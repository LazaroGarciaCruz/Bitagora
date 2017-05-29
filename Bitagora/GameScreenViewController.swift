//
//  GameScreenViewController.swift
//  Bitagora
//
//  Created by Lazaro Garcia Cruz on 10/5/17.
//  Copyright © 2017 Lazaro Garcia Cruz. All rights reserved.
//

import UIKit
import Gifu

class GameScreenViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, GameTaskTableViewCellDelegate {
    
    enum OrdenacionLista : Int {
        
        case fechaAscendente
        case fechaDescendente
        case dificultadAscendente
        case dificultadDescendente
        case prioridadAscendente
        case prioridadDescendente
        
    }
    
    let colores: Array<CGColor> = [UIColor(red: 144/255, green: 42/255, blue: 135/255, alpha: 1).cgColor,
                                   UIColor(red: 252/255, green: 2/255, blue: 84/255, alpha: 1).cgColor]
    let coloresPantalla: Array<CGColor> = [UIColor(red: 0/255, green: 128/255, blue: 64/255, alpha: 1).cgColor,
                                   UIColor(red: 0/255, green: 128/255, blue: 0/255, alpha: 1).cgColor,
                                   UIColor(red: 64/255, green: 128/255, blue: 0/255, alpha: 1).cgColor]
    let gifHardware: Array<String> = ["monitor_hardware2.gif", "monitor_hardware3.gif"]
    let opcionesFiltrado: Array<UIImage> = [#imageLiteral(resourceName: "ordenacion_fecha_ascendente"), #imageLiteral(resourceName: "ordenacion_fecha_descendente"),
                                            #imageLiteral(resourceName: "ordenacion_dificultad_ascendente"), #imageLiteral(resourceName: "ordenacion_dificultad_descendente"),
                                            #imageLiteral(resourceName: "ordenacion_prioridad_ascendente"), #imageLiteral(resourceName: "ordenacion_prioridad_descendente")]
    
    //Esta variable contiene la informacion del juego seleccionado
    var juegoSeleccionado: Game!
    var listaTask: Array<GameTask> = []
    
    //Variables para la gestion de datos
    var dataManager = DataMaganer.sharedInstance

    //Variables para la gestion de la tabla de tareas
    @IBOutlet weak var tableView: UITableView!
    
    //Variables para la barra de titulo
    @IBOutlet weak var viewTitulo: ScrollingBackgroundView!
    @IBOutlet weak var botonAtras: GlowLabelSimple!
    @IBOutlet weak var fondoGIF: GIFImageView!
    @IBOutlet weak var botonFiltro: UIButton!
    @IBOutlet weak var botonNuevo: UIButton!
    
    @IBOutlet weak var character1: GIFImageView!
    @IBOutlet weak var character1heigth: NSLayoutConstraint!
    @IBOutlet weak var character1width: NSLayoutConstraint!
    @IBOutlet weak var character1izquierda: NSLayoutConstraint!
    
    @IBOutlet weak var character2: GIFImageView!
    @IBOutlet weak var character2width: NSLayoutConstraint!
    @IBOutlet weak var character2heigth: NSLayoutConstraint!
    @IBOutlet weak var character2izquierda: NSLayoutConstraint!
    
    @IBOutlet weak var character3: GIFImageView!
    @IBOutlet weak var character3width: NSLayoutConstraint!
    @IBOutlet weak var character3heigth: NSLayoutConstraint!
    @IBOutlet weak var character3izquierda: NSLayoutConstraint!
    
    @IBOutlet weak var character4: GIFImageView!
    @IBOutlet weak var character4width: NSLayoutConstraint!
    @IBOutlet weak var character4heigth: NSLayoutConstraint!
    @IBOutlet weak var character4izquerda: NSLayoutConstraint!
    
    //Variables para la gestion del filtrado de los datos
    var tipView: EasyTipView?
    var isShowingTip = false
    
    //Variables para los elementos aleatorios
    var coloresActuales = [CGColor]()
    var hardwareActual = [String]()
    
    //Variables para las transiciones entre vistas
    let transicion = PopTransitionAnimator()
    
    private var isIphone = false
    private var ventanaIniciada = false
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        if UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.pad {
            isIphone = false
        } else {
            isIphone = true
        }
        
        listaTask = juegoSeleccionado.taskLista
        inicializarViewControler()
        prepararTabla()
        
    }
    
    /*
     Este metodo se llama cuando la vista se ha cargado
    */
    override func viewDidAppear(_ animated: Bool) {
        
        if !ventanaIniciada {
        
            //Cargamos y animamos la barra de titulo
            animarBarraTitulo()
            
            //Cargamos la animacion de la tabla por primera vez
            tableView.isHidden = false
            tableView.reloadData()
            tableView.layoutIfNeeded()
            
            var index = 0
            
            for i in tableView.visibleCells {
                
                let cell: GameTaskTableViewCell = i as! GameTaskTableViewCell
                
                cell.setRotationX(x: -90)
                
                UIView.animate(withDuration: 0.2, animations: {
                    cell.setRotationX(x: 0)
                }, completion: {(exito) in
                    
                    let task = self.listaTask[index]
                    self.configurarCelda(cell: cell, task: task, indexPath: IndexPath(row: index, section: 0))
                    index += 1
                    
                    if (index == self.tableView.visibleCells.count) {
                        self.ventanaIniciada = true
                        self.tableView.isUserInteractionEnabled = true
                    }
                    
                })
                
            }
            
        } else {
            tableView.reloadData()
            tableView.layoutIfNeeded()
        }
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        
        for i in tableView.visibleCells {
            let cell: GameTaskTableViewCell = i as! GameTaskTableViewCell
            cell.animacionCeldaApagarMonitor()
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
     Establece la barra de estado de color blanco
    */
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    /**
     Este metodo se encarga de llevar a cabo las tareas necesarias para
     iniciar las propiedades y elementos generales del view controller
     */
    func inicializarViewControler() {
        
        //Propiedades del status bar
        let statusBarView = UIView(frame: UIApplication.shared.statusBarFrame)
        statusBarView.createGradientWithColors(colors: colores, direction: .horizontal)
        view.addSubview(statusBarView)
        
        //Inicializamos la barra de titulo
        Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(animarTextoAtras), userInfo: nil, repeats: true)
        
        botonAtras.addTapGesture(tapNumber: 1) { (gesture) in
            
            if let tip = self.tipView {
                tip.dismiss()
            }
                        
            self.performSegue(withIdentifier: "volverPantallaPrincipalTransicion", sender: self)
            
        }
        
        //Inicializamos los elementos aleatorios
        for _ in juegoSeleccionado.taskLista {
            var randomNum: UInt32 = arc4random_uniform(3)
            coloresActuales.append(coloresPantalla[Int(randomNum)])
            randomNum = arc4random_uniform(2)
            hardwareActual.append(gifHardware[Int(randomNum)])
        }
        
        //Se le añade el control para borrar de elementos
        
        tableView.addLongPressGesture { (sender) in
            
            if sender.state != UIGestureRecognizerState.ended {
                return
            }
            
            let p = sender.location(in: self.tableView)
            let indexPath = self.tableView.indexPathForRow(at: p)
            
            if let index = indexPath {
                (self.tableView.cellForRow(at: index) as! GameTaskTableViewCell).animacionBorrado()
            }
            
        }
        
    }
    
    /*
     Este metodo se llama cada vez que se va a
     animar el texto del boton para volver
     */
    func animarTextoAtras() {
        botonAtras.text = "ATRAS"
        botonAtras.animateText(timeInterval: 0.1)
    }
    
    /*
     En este metodo se llevan a cabo todas las tareas
     para inicializar y animar los elementos de la
     barra de titulo del view controller
     */
    func animarBarraTitulo() {
        
        animarTextoAtras()
        
        fondoGIF.animate(withGIFNamed: "pixel_city_rain.gif")
        fondoGIF.clipsToBounds = true
        fondoGIF.contentMode = isIphone ? .center : .left
        
        character1.animate(withGIFNamed: "steampunk_character1.gif")
        character2.animate(withGIFNamed: "steampunk_character2.gif")
        character3.animate(withGIFNamed: "steampunk_character3.gif")
        character4.animate(withGIFNamed: "steampunk_character4.gif")
        
        if isIphone {
            character1width.constant = 64
            character1heigth.constant = 64
            character1izquierda.constant = 80
            character2width.constant = 64
            character2heigth.constant = 64
            character2izquierda.constant = 0
            character3width.constant = 64
            character3heigth.constant = 64
            character3izquierda.constant = 180
            character4width.constant = 64
            character4heigth.constant = 64
            character4izquerda.constant = -5
        } else {
            character1width.constant = 72
            character1heigth.constant = 72
            character1izquierda.constant = 130
            character2width.constant = 72
            character2heigth.constant = 72
            character2izquierda.constant = 0
            character3width.constant = 72
            character3heigth.constant = 72
            character3izquierda.constant = 400
            character4width.constant = 72
            character4heigth.constant = 72
            character4izquerda.constant = 0
        }
        
    }
    
    /*
     En este metodo se llevan a cabo las tareas para
     mostrar las distintas opciones de filtrado de la
     lista cuando se pulsa el boton correspondiente
     */
    @IBAction func mostrarOpcionesFiltrado(_ sender: Any) {
        
        if !isShowingTip {
        
            let width: CGFloat = 32.0
            let offset: CGFloat = 10.0
            let panelOpcionesFiltrado = UIView(x: 0, y: 0, w: (CGFloat(opcionesFiltrado.count) * width) + (CGFloat(opcionesFiltrado.count) * offset) + offset, h: (width + offset * 2))
            panelOpcionesFiltrado.backgroundColor = .clear
            var posX = -width + offset
            
            var listaFiltros = [OrdenacionLista.fechaAscendente, OrdenacionLista.fechaDescendente, OrdenacionLista.dificultadAscendente,
                                OrdenacionLista.dificultadDescendente, OrdenacionLista.prioridadAscendente, OrdenacionLista.prioridadDescendente]
            var index = 0
            
            for image in opcionesFiltrado {
                posX += width
                let imageView = UIImageView(frame: CGRect(x: posX, y: offset, width: width, height: width), image: image)
                imageView.tag = index
                imageView.addTapGesture(tapNumber: 1, action: { (sender) in
                    self.tipView?.dismiss()
                    self.isShowingTip = false
                    self.reordenarLista(ordenacion: listaFiltros[(sender.view as! UIImageView).tag])
                })
                panelOpcionesFiltrado.addSubview(imageView)
                posX += offset
                index += 1
            }
            
            let panelContenido = GradientView(frame: CGRect(x: 0, y: 0, width: panelOpcionesFiltrado.w, height: panelOpcionesFiltrado.h))
            panelContenido.addSubview(panelOpcionesFiltrado)
            panelContenido.colores = [colores.last!, colores.first!]
            panelContenido.direccion = UIView.UIViewLinearGradientDirection.vertical
            
            var preferences = EasyTipView.Preferences()
            preferences.drawing.backgroundColor = UIColor(cgColor: colores[1])
            preferences.drawing.arrowPosition = .top
            preferences.positioning.bubbleHInset = -50
            preferences.animating.dismissTransform = CGAffineTransform(translationX: 0, y: 100)
            preferences.animating.showInitialTransform = CGAffineTransform(translationX: 0, y: 20)
            preferences.animating.showInitialAlpha = 0
            preferences.animating.showDuration = 0.5
            preferences.animating.dismissDuration = 1
            preferences.animating.dismissOnTap = false
            
            tipView = EasyTipView(contenido: panelContenido, preferences: preferences)
            tipView?.show(forView: botonFiltro, withinSuperview: self.navigationController?.view!)
            
            isShowingTip = true
            
        } else {
            tipView?.dismiss()
            isShowingTip = false
        }
        
    }
    
    /*
     En este metodo se llevan a cabo las tareas para
     reordenar la lista de datos en funcion de la
     opcion seleccionada por el usuario
     */
    func reordenarLista(ordenacion: OrdenacionLista) {
        
        switch ordenacion {
            
            case .fechaAscendente:
                
                listaTask.sort(by: { $0.creationDate?.compare($1.creationDate!) == .orderedAscending})
            
            case .fechaDescendente:
                
                listaTask.sort(by: { $0.creationDate?.compare($1.creationDate!) == .orderedDescending})
            
            case .dificultadAscendente:
                
                var listaAux1: Array<GameTask> = []
                for task in listaTask {
                    if task.difficulty == .hard {
                        listaAux1.append(task)
                    }
                }
                listaAux1.sort(by: { $0.creationDate?.compare($1.creationDate!) == .orderedAscending})
                var listaAux2: Array<GameTask> = []
                for task in listaTask {
                    if task.difficulty == .normal {
                        listaAux2.append(task)
                    }
                }
                listaAux2.sort(by: { $0.creationDate?.compare($1.creationDate!) == .orderedAscending})
                var listaAux3: Array<GameTask> = []
                for task in listaTask {
                    if task.difficulty == .easy {
                        listaAux3.append(task)
                    }
                }
                listaAux3.sort(by: { $0.creationDate?.compare($1.creationDate!) == .orderedAscending})
                listaTask = []
                listaTask.append(contentsOf: listaAux1)
                listaTask.append(contentsOf: listaAux2)
                listaTask.append(contentsOf: listaAux3)
            
            case .dificultadDescendente:
                
                var listaAux1: Array<GameTask> = []
                for task in listaTask {
                    if task.difficulty == .easy {
                        listaAux1.append(task)
                    }
                }
                listaAux1.sort(by: { $0.creationDate?.compare($1.creationDate!) == .orderedAscending})
                var listaAux2: Array<GameTask> = []
                for task in listaTask {
                    if task.difficulty == .normal {
                        listaAux2.append(task)
                    }
                }
                listaAux2.sort(by: { $0.creationDate?.compare($1.creationDate!) == .orderedAscending})
                var listaAux3: Array<GameTask> = []
                for task in listaTask {
                    if task.difficulty == .hard {
                        listaAux3.append(task)
                    }
                }
                listaAux3.sort(by: { $0.creationDate?.compare($1.creationDate!) == .orderedAscending})
                listaTask = []
                listaTask.append(contentsOf: listaAux1)
                listaTask.append(contentsOf: listaAux2)
                listaTask.append(contentsOf: listaAux3)
            
            case .prioridadAscendente:
                
                var listaAux1: Array<GameTask> = []
                for task in listaTask {
                    if task.priority == .high {
                        listaAux1.append(task)
                    }
                }
                listaAux1.sort(by: { $0.creationDate?.compare($1.creationDate!) == .orderedAscending})
                var listaAux2: Array<GameTask> = []
                for task in listaTask {
                    if task.priority == .medium {
                        listaAux2.append(task)
                    }
                }
                listaAux2.sort(by: { $0.creationDate?.compare($1.creationDate!) == .orderedAscending})
                var listaAux3: Array<GameTask> = []
                for task in listaTask {
                    if task.priority == .low {
                        listaAux3.append(task)
                    }
                }
                listaAux3.sort(by: { $0.creationDate?.compare($1.creationDate!) == .orderedAscending})
                listaTask = []
                listaTask.append(contentsOf: listaAux1)
                listaTask.append(contentsOf: listaAux2)
                listaTask.append(contentsOf: listaAux3)
            
            case .prioridadDescendente:
                
                var listaAux1: Array<GameTask> = []
                for task in listaTask {
                    if task.priority == .low {
                        listaAux1.append(task)
                    }
                }
                listaAux1.sort(by: { $0.creationDate?.compare($1.creationDate!) == .orderedAscending})
                var listaAux2: Array<GameTask> = []
                for task in listaTask {
                    if task.priority == .medium {
                        listaAux2.append(task)
                    }
                }
                listaAux2.sort(by: { $0.creationDate?.compare($1.creationDate!) == .orderedAscending})
                var listaAux3: Array<GameTask> = []
                for task in listaTask {
                    if task.priority == .high {
                        listaAux3.append(task)
                    }
                }
                listaAux3.sort(by: { $0.creationDate?.compare($1.creationDate!) == .orderedAscending})
                listaTask = []
                listaTask.append(contentsOf: listaAux1)
                listaTask.append(contentsOf: listaAux2)
                listaTask.append(contentsOf: listaAux3)
            
        }
        
        tableView.reloadData()
        tableView.layoutIfNeeded()
        
    }
    
    //------------------------------------------------------------------
    //------------------------------------------------------------------
    //------------------  METODOS DEL TABLE VIEW -----------------------
    //------------------------------------------------------------------
    //------------------------------------------------------------------
    
    /*
     Este metodo se encarga de establecer las propiedades de la tabla
    */
    func prepararTabla() {
        
        tableView.allowsSelection = true
        
        //Eliminamos el footer para que no se vean lineas de mas
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        
        //Establecemos la imagen de fondo de la tabla
        tableView.backgroundColor = .clear
        
        tableView.isHidden = true
        tableView.isUserInteractionEnabled = false
        tableView.decelerationRate = UIScrollViewDecelerationRateFast
        
    }
    
    /*
     Devuelve el numero de elementos de la lista
     */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return juegoSeleccionado.taskLista.count
    }
    
    /*
     Este metodo configura la representacion visual de cada una de las filas de la tabla
    */
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Task", for: indexPath) as! GameTaskTableViewCell
        
        if ventanaIniciada {
            let task = listaTask[indexPath.row]
            configurarCelda(cell: cell, task: task, indexPath: indexPath)
        }
        
        return cell
        
    }
    
    /*
     En este metodo se establece la configuracion visual
     de la celda en funcion de la informacion de la tarea
     que va a representar
     */
    func configurarCelda(cell: GameTaskTableViewCell, task: GameTask, indexPath: IndexPath) {
        
        cell.cadenaTitulo = task.title.uppercased()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy hh:mm:ss"
        cell.cadenaFecha = dateFormatter.string(from: task.creationDate!).uppercased()
        
        cell.pantalla.backgroundColor = UIColor(cgColor: coloresActuales[indexPath.row])
        cell.imagenHardware.animate(withGIFNamed: hardwareActual[indexPath.row])
        cell.indexPath = indexPath
        cell.delegate = self
        
        switch task.priority {
            case .low:
                cell.imagenPrioridad.animate(withGIFNamed: "prioridad_baja_star.gif")
            case .medium:
                cell.imagenPrioridad.animate(withGIFNamed: "prioridad_media_star.gif")
            case .high:
                cell.imagenPrioridad.animate(withGIFNamed: "prioridad_alta_star.gif")
        }
        
        switch task.difficulty {
            case .easy:
                cell.imagenDificultad.animate(withGIFNamed: "dificultad_facil.gif")
            case .normal:
                cell.imagenDificultad.animate(withGIFNamed: "dificultad_normal.gif")
            case .hard:
                cell.imagenDificultad.animate(withGIFNamed: "dificultad_dificil.gif")
        }
        
        cell.animacionCeldaEncenderMonitor()
        
    }
    
    /*
     Este metodo determina la altura de cada una de las filas de la tabla
    */
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let totalFilas: CGFloat = 7
        return UIScreen.main.bounds.height / totalFilas
        
    }
    
    /*
     Este metodo lleva a cabo las tareas necesarias para
     el borrado de una celda del table view
     */
    func borrarCelda(index: Int) {
        
        if (DataMaganer.sharedInstance.borrarTask(task: juegoSeleccionado.taskLista[index])) {
            
            if let cell = self.tableView.cellForRow(at: IndexPath(row: index, section: 0)) {
                (cell as! GameTaskTableViewCell).cancelarBorrado()
            }
            
            juegoSeleccionado.taskLista.remove(at: index)
            listaTask.remove(at: index)
            tableView.reloadData()
            
        }
        
    }
    
    //------------------------------------------------------------------
    //------------------------------------------------------------------
    //-----------------------  NAVEGACION ------------------------------
    //------------------------------------------------------------------
    //------------------------------------------------------------------
    
    /*
     Este metodo se ejecuta cada vez que se hace un transicion y nos permite
     determinar a quien se hace y que informacion se le envia
     */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "showTaskDetail" {
            
            let toViewController = segue.destination as! GameTaskDetailViewController
            
            if let indexPath = tableView.indexPathForSelectedRow {
                toViewController.taskSeleccionada = listaTask[indexPath.row]
            }
            
            toViewController.transitioningDelegate = transicion
            
        } else if segue.identifier == "showNewTask" {
            
            let toViewController = segue.destination as! GameTaskViewController
            toViewController.juegoSeleccionado = juegoSeleccionado
            
        }
        
    }
    
    /*
     Este metodo se ejecuta cuando se vuelve a esta pantalla desde otra transicion
     */
    @IBAction func volverPantallaJuego(segue: UIStoryboardSegue) {
        
        if segue.identifier == "volverPantallaJuegoNuevoJuegoTransicion" {
            
            let fromViewController = segue.source as! GameTaskViewController
            
            juegoSeleccionado.taskLista.append(fromViewController.nuevoTask!)
            listaTask.append(fromViewController.nuevoTask!)
            
            coloresActuales = []
            for _ in juegoSeleccionado.taskLista {
                var randomNum: UInt32 = arc4random_uniform(3)
                coloresActuales.append(coloresPantalla[Int(randomNum)])
                randomNum = arc4random_uniform(2)
                hardwareActual.append(gifHardware[Int(randomNum)])
            }
            
            tableView.reloadData()
            
        }
        
    }

}
