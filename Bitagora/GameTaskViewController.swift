//
//  GameTaskViewController.swift
//  Bitagora
//
//  Created by Lazaro Garcia Cruz on 12/5/17.
//  Copyright © 2017 Lazaro Garcia Cruz. All rights reserved.
//

import UIKit
import ImageSlideshow
import Gifu

class GameTaskViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate,
                                TaskTextoTableViewCellDelegate, TaskImagenesTableViewCellDelegate,
                                TaskURLTableViewCellDelegate, TaskCounterTableViewCellDelegate {
    
    //Variable que representa al juego
    var juegoSeleccionado: Game!
    var nuevoTask: GameTask?
    
    //Variables generales de la clase
    
    @IBOutlet weak var tableView: UITableView!

    @IBOutlet weak var scanlineView: PassThroughView!
    
    var listaComponentesTask: Array<TaskComponent> = []
    
    var activeField: UITextView?
    
    //Variables para la gestion de la ventana de guardado
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var backView2: UIView!
    @IBOutlet weak var textoTituloTarea: UITextField!
    @IBOutlet weak var viewGuardarTarea: UIView!
    @IBOutlet weak var botonCerrarViewGuardarTarea: UIButton!
    @IBOutlet weak var botonDificultadFacil: GIFImageView!
    @IBOutlet weak var botonDificultadNormal: GIFImageView!
    @IBOutlet weak var botonDificultadDificil: GIFImageView!
    @IBOutlet weak var botonPrioridadBaja: GIFImageView!
    @IBOutlet weak var botonPrioridadMedia: GIFImageView!
    @IBOutlet weak var botonPrioridadAlta: GIFImageView!
    @IBOutlet weak var botonGuardarTask: UIButton!
    
    var tituloTask: String = ""
    var dificultad: TaskDifficulty = TaskDifficulty.easy
    var prioridad: TaskPriority = TaskPriority.low
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        //Estas notificaciones son las que permiten a la vista
        //saber cuando se va a mostrar el teclado y cuando se oculta
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasShown), name: NSNotification.Name.UIKeyboardDidShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillBeHidden), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        inicializarVentanaGuardarTarea()
        generarScanlines()
        prepararTabla()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
     Este metodo se llama cuando la vista se ha cargado
     */
    override func viewDidAppear(_ animated: Bool) {
        //tableView.reloadData()
    }
    
    /*
     Con este metodo estamos diciendo a la vista que se pueden usar varios gestos simultaneamente
     Para ello es necesario que implemente UIGestureRecognizerDelegate
     */
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    func inicializarVentanaGuardarTarea() {
        
        textoTituloTarea.delegate = self
        botonGuardarTask.isEnabled = false
        
        //Se establecen las propiedades de la seccion 
        //para establecer el titulo de la tarea
        
        textoTituloTarea.addBorder(width: 1, color: UIColor(red: 0/255, green: 0/255, blue: 173/255, alpha: 255/255))
        backView.addBorder(width: 2, color: .white)
        backView2.addBorder(width: 2, color: .white)
        
        //Se establecen las propiedades de los selectores
        //de dificultad y prioridad
        
        botonDificultadFacil.animate(withGIFNamed: "dificultad_facil.gif")
        botonPrioridadBaja.animate(withGIFNamed: "prioridad_baja_star.gif")
        
        botonDificultadFacil.addTapGesture(tapNumber: 1) { (gesture) in
            self.botonDificultadFacil.animate(withGIFNamed: "dificultad_facil.gif")
            self.botonDificultadNormal.stopAnimatingGIF()
            self.botonDificultadNormal.image = #imageLiteral(resourceName: "dificultad_normal_desactivado")
            self.botonDificultadDificil.stopAnimatingGIF()
            self.botonDificultadDificil.image = #imageLiteral(resourceName: "dificultad_dificil_desactivado")
            self.dificultad = TaskDifficulty.easy
        }
        
        botonDificultadNormal.addTapGesture(tapNumber: 1) { (gesture) in
            self.botonDificultadFacil.stopAnimatingGIF()
            self.botonDificultadFacil.image = #imageLiteral(resourceName: "dificultad_facil_desactivado")
            self.botonDificultadNormal.animate(withGIFNamed: "dificultad_normal.gif")
            self.botonDificultadDificil.stopAnimatingGIF()
            self.botonDificultadDificil.image = #imageLiteral(resourceName: "dificultad_dificil_desactivado")
            self.dificultad = TaskDifficulty.normal
        }
        
        botonDificultadDificil.addTapGesture(tapNumber: 1) { (gesture) in
            self.botonDificultadFacil.stopAnimatingGIF()
            self.botonDificultadFacil.image = #imageLiteral(resourceName: "dificultad_facil_desactivado")
            self.botonDificultadNormal.stopAnimatingGIF()
            self.botonDificultadNormal.image = #imageLiteral(resourceName: "dificultad_normal_desactivado")
            self.botonDificultadDificil.animate(withGIFNamed: "dificultad_dificil.gif")
            self.dificultad = TaskDifficulty.hard
        }
        
        botonPrioridadBaja.addTapGesture(tapNumber: 1) { (gesture) in
            self.botonPrioridadBaja.animate(withGIFNamed: "prioridad_baja_star.gif")
            self.botonPrioridadMedia.stopAnimatingGIF()
            self.botonPrioridadMedia.image = #imageLiteral(resourceName: "prioridad_media_star_desactivado")
            self.botonPrioridadAlta.stopAnimatingGIF()
            self.botonPrioridadAlta.image = #imageLiteral(resourceName: "prioridad_alta_star_desactivado")
            self.prioridad = TaskPriority.low
        }
        
        botonPrioridadMedia.addTapGesture(tapNumber: 1) { (gesture) in
            self.botonPrioridadBaja.stopAnimatingGIF()
            self.botonPrioridadBaja.image = #imageLiteral(resourceName: "prioridad_baja_star_desactivado")
            self.botonPrioridadMedia.animate(withGIFNamed: "prioridad_media_star.gif")
            self.botonPrioridadAlta.stopAnimatingGIF()
            self.botonPrioridadAlta.image = #imageLiteral(resourceName: "prioridad_alta_star_desactivado")
            self.prioridad = TaskPriority.medium
        }
        
        botonPrioridadAlta.addTapGesture(tapNumber: 1) { (gesture) in
            self.botonPrioridadBaja.stopAnimatingGIF()
            self.botonPrioridadBaja.image = #imageLiteral(resourceName: "prioridad_baja_star_desactivado")
            self.botonPrioridadMedia.stopAnimatingGIF()
            self.botonPrioridadMedia.image = #imageLiteral(resourceName: "prioridad_media_star_desactivado")
            self.botonPrioridadAlta.animate(withGIFNamed: "prioridad_alta_star.gif")
            self.prioridad = TaskPriority.high
        }
        
    }
    
    func generarScanlines() {
        
        for subview in scanlineView.subviews {
            subview.removeFromSuperview()
        }
        
        let totalImagenes = 500
        //let heigth: CGFloat = scanlinesView.h / CGFloat(totalImagenes)
        let heigth: CGFloat = UIScreen.main.bounds.height / CGFloat(totalImagenes)
        
        var index = 0
        
        for _ in 0...totalImagenes {
            /*let imageView = UIImageView(frame: CGRect(x: 0, y: heigth * CGFloat(index), width: scanlinesView.w, height: heigth), image: UIImage(named: "scanlines_iphone.png")!)*/
            let imageView = UIImageView(frame: CGRect(x: 0, y: heigth * CGFloat(index), width: UIScreen.main.bounds.width, height: heigth), image: UIImage(named: "scanlines_iphone.png")!)
            imageView.setRotationX(x: 180)
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            imageView.alpha = 0.25
            scanlineView.addSubview(imageView)
            index += 1
        }
        
    }
    
    func ajustarTexto() {
        
        let currentOffset = tableView.contentOffset
        UIView.setAnimationsEnabled(false)
        tableView.beginUpdates()
        tableView.endUpdates()
        UIView.setAnimationsEnabled(true)
        tableView.setContentOffset(currentOffset, animated: false)
        
        tableView.scrollToRow(at: IndexPath(row: (activeField?.tag)!, section: 0), at: .bottom, animated: false)
        
    }
    
    func actualizarTexto(texto: String, index: Int) {
        if index <= listaComponentesTask.count && listaComponentesTask.count > 0 {
            if listaComponentesTask[index] is TaskComponentText {
                (listaComponentesTask[index] as! TaskComponentText).texto = texto
            }
        }
    }
    
    func actualizarImagenes(imagenes: Array<UIImage>, index: Int) {
        if listaComponentesTask[index] is TaskComponentImages {
            (listaComponentesTask[index] as! TaskComponentImages).listaImagenes = imagenes
        }
    }
    
    func actualizarURL(url: String, isVideo: Bool, index: Int) {
        if listaComponentesTask[index] is TaskComponentURL {
            (listaComponentesTask[index] as! TaskComponentURL).url = url
            (listaComponentesTask[index] as! TaskComponentURL).isVideo = isVideo
            tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .top)
        }
    }
    
    func actualizarContador(maxElements: Int, index: Int) {
        if listaComponentesTask[index] is TaskComponentCounter {
            (listaComponentesTask[index] as! TaskComponentCounter).maxElements = maxElements
        }
    }
    
    func actualizarDescripcion(descripcion: String, index: Int) {
        if listaComponentesTask[index] is TaskComponentCounter {
            (listaComponentesTask[index] as! TaskComponentCounter).descripcion = descripcion
        }
    }
    
    func borrarElemento(index: Int) {
        listaComponentesTask.remove(at: index)
        tableView.deleteRows(at: [IndexPath(row: index, section: 0)], with: .middle)
        tableView.reloadData()
    }
    
    @IBAction func insertarCeldaTexto(_ sender: Any) {
        listaComponentesTask.append(TaskComponentText())
        scrollToBottom()
    }
    
    @IBAction func insertarCeldaImagenes(_ sender: Any) {
        listaComponentesTask.append(TaskComponentImages())
        scrollToBottom()
    }
    
    @IBAction func insertarCeldaEnlace(_ sender: Any) {
        listaComponentesTask.append(TaskComponentURL())
        scrollToBottom()
    }
    
    @IBAction func insertarCeldaContador(_ sender: Any) {
        listaComponentesTask.append(TaskComponentCounter())
        scrollToBottom()
    }
    
    func scrollToBottom() {
        let indexPath = IndexPath(row: self.listaComponentesTask.count-1, section: 0)
        tableView.insertRows(at: [indexPath], with: .none)
        tableView.scrollToRow(at: indexPath, at: .bottom, animated: false)
    }
    
    @IBAction func limpiarTabla(_ sender: Any) {
        listaComponentesTask.removeAll()
        tableView.reloadData()
    }
    
    @IBAction func botonCancelarPulsado(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    //------------------------------------------------------------------
    //------------------------------------------------------------------
    //--------------------  METODOS DEL KEYBOARD -----------------------
    //------------------------------------------------------------------
    //------------------------------------------------------------------
    
    func establecerTextoActivo(index: Int) {
        if listaComponentesTask[index] is TaskComponentText {
            activeField = (tableView.dequeueReusableCell(withIdentifier: "cellTexto", for: IndexPath(row: index, section: 0)) as! TaskTextoTableViewCell).textView
            activeField?.tag = index
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func keyboardWasShown(aNotification: NSNotification) {
        
        let info = aNotification.userInfo as! [String: Any],
        kbSize = (info[UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue.size,
        contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: kbSize.height, right: 0)
        
        tableView.contentInset = contentInsets
        tableView.scrollIndicatorInsets = contentInsets
        
        // If active text field is hidden by keyboard, scroll it so it's visible
        // Your app might not need or want this behavior.
        var aRect = self.view.frame
        aRect.size.height -= kbSize.height
        
        if let activeTF = activeField {
            if !aRect.contains(activeTF.frame.origin) {
                tableView.scrollRectToVisible(activeTF.frame, animated: true)
            }
        }
        
    }
    
    func keyboardWillBeHidden(aNotification: Notification) {
        
        let contentInsets = UIEdgeInsets.zero
        tableView.contentInset = contentInsets
        tableView.scrollIndicatorInsets = contentInsets
        
        if let actField = activeField {
            tableView.scrollToRow(at: IndexPath(row: actField.tag, section: 0), at: .bottom, animated: false)
        }
        
    }
    
    //------------------------------------------------------------------
    //------------------------------------------------------------------
    //------------------  METODOS DEL TABLE VIEW -----------------------
    //------------------------------------------------------------------
    //------------------------------------------------------------------
    
    //Este metodo se encarga de establecer las propiedades de la tabla
    func prepararTabla() {
        
        //En esta tabla no estara permitido seleccionar celdas
        tableView.allowsSelection = false
        
        //Eliminamos el footer para que no se vean lineas de mas
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        
        //Establecemos la imagen de fondo de la tabla
        tableView.backgroundColor = .clear
        
        //Propiedades del alto de las celdas
        tableView.estimatedRowHeight = 150.0
        tableView.rowHeight = UITableViewAutomaticDimension
        
        //El scroll sera del tipo lento para facilitar la vision de los elementos
        tableView.decelerationRate = UIScrollViewDecelerationRateFast
        
        //Le añadimos la accion que permite cerrar el teclado en caso de que
        //se encuentre activo en la edicion de texto de las celdas
        tableView.addTapGesture(tapNumber: 1) { (gesture) in
            self.view.endEditing(true)
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listaComponentesTask.count
    }
    
    //Este metodo configura la representacion visual de cada una de las filas de la tabla
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch (listaComponentesTask[indexPath.row] as TaskComponent).type {
            case TaskComponentType.text:
                return procesarTaskTextoCell(indexPath: indexPath)
            case TaskComponentType.images:
                return procesarTaskImagenesCell(indexPath: indexPath)
            case TaskComponentType.url:
                return procesarTaskURLCell(indexPath: indexPath)
            case TaskComponentType.counter:
                return procesarTaskCounterCell(indexPath: indexPath)
            default:
                return UITableViewCell()
        }
        
    }
    
    func procesarTaskTextoCell(indexPath: IndexPath) -> TaskTextoTableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellTexto", for: indexPath) as! TaskTextoTableViewCell
        cell.texto = (listaComponentesTask[indexPath.row] as! TaskComponentText).texto
        cell.indexPath = indexPath
        cell.delegate = self
        cell.inicializarComponentes()
        
        return cell
        
    }
    
    func procesarTaskImagenesCell(indexPath: IndexPath) -> TaskImagenesTableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellImagenes", for: indexPath) as! TaskImagenesTableViewCell
        cell.listaImagenes = (listaComponentesTask[indexPath.row] as! TaskComponentImages).listaImagenes
        cell.indexPath = indexPath
        cell.inicializarImageSlideshow()
        cell.delegate = self
        
        return cell
        
    }
    
    func procesarTaskURLCell(indexPath: IndexPath) -> TaskURLTableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellURL", for: indexPath) as! TaskURLTableViewCell
        cell.textoURL = (listaComponentesTask[indexPath.row] as! TaskComponentURL).url
        cell.isVideo = (listaComponentesTask[indexPath.row] as! TaskComponentURL).isVideo
        cell.indexPath = indexPath
        cell.delegate = self
        cell.inicializarComponentes()
        
        return cell
        
    }
    
    func procesarTaskCounterCell(indexPath: IndexPath) -> TaskCounterTableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellContador", for: indexPath) as! TaskCounterTableViewCell
        cell.descripcion = (listaComponentesTask[indexPath.row] as! TaskComponentCounter).descripcion
        cell.maxElements = (listaComponentesTask[indexPath.row] as! TaskComponentCounter).maxElements
        cell.indexPath = indexPath
        cell.delegate = self
        
        return cell
        
    }
    
    //Este metodo determina la altura de cada una de las filas de la tabla
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch (listaComponentesTask[indexPath.row] as TaskComponent).type {
            case TaskComponentType.text:
                return UITableViewAutomaticDimension
                //return 175
            case TaskComponentType.images:
                return 250
            case TaskComponentType.url:
                if (listaComponentesTask[indexPath.row] as! TaskComponentURL).isVideo {
                    return 250
                }
                return 90
            case TaskComponentType.counter:
                return 90
            default:
                return 150
        }
        
    }
    
    //------------------------------------------------------------------
    //------------------------------------------------------------------
    //--------------------  METODOS DEL KEYBOARD -----------------------
    //------------------------------------------------------------------
    //------------------------------------------------------------------
    
    /*
     Con este metodo se especifica que se debe hacer cuando
     un textfield esta activo pierde el foco
     */
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextFieldDidEndEditingReason) {
        
        self.view.endEditing(true)
        tituloTask = textoTituloTarea.text!
        
        botonGuardarTask.isEnabled = false
        botonGuardarTask.backgroundColor = UIColor(red: 168/255, green: 168/255, blue: 168/255, alpha: 255/255)
        botonGuardarTask.setTitleColor(.darkGray, for: .normal)
        if tituloTask != "" {
            botonGuardarTask.isEnabled = true
            botonGuardarTask.backgroundColor = .clear
            botonGuardarTask.setTitleColor(.black, for: .normal)
        }
        
    }
    
    /*
     Con este metodo se especifica que se debe hacer cuando
     se pulsa return cuando un textfield esta activo
     */
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        self.view.endEditing(true)
        tituloTask = textoTituloTarea.text!
        
        botonGuardarTask.isEnabled = false
        botonGuardarTask.backgroundColor = UIColor(red: 168/255, green: 168/255, blue: 168/255, alpha: 255/255)
        botonGuardarTask.setTitleColor(.darkGray, for: .normal)
        if tituloTask != "" {
            botonGuardarTask.isEnabled = true
            botonGuardarTask.backgroundColor = .clear
            botonGuardarTask.setTitleColor(.black, for: .normal)
        }
        
        return false
        
    }

    //------------------------------------------------------------------
    //------------------------------------------------------------------
    //------------------  METODOS PARA LA CREACION ---------------------
    //--------------------  DE UNA NUEVA TAREA -------------------------
    //------------------------------------------------------------------
    //------------------------------------------------------------------
    
    @IBAction func botonAceptarPulsado(_ sender: Any) {
        
        textoTituloTarea.text = ""
        tituloTask = ""
        botonGuardarTask.isEnabled = false
        botonGuardarTask.backgroundColor = UIColor(red: 168/255, green: 168/255, blue: 168/255, alpha: 255/255)
        botonGuardarTask.setTitleColor(.darkGray, for: .normal)
        
        botonDificultadFacil.animate(withGIFNamed: "dificultad_facil.gif")
        botonDificultadNormal.stopAnimatingGIF()
        botonDificultadNormal.image = #imageLiteral(resourceName: "dificultad_normal_desactivado")
        botonDificultadDificil.stopAnimatingGIF()
        botonDificultadDificil.image = #imageLiteral(resourceName: "dificultad_dificil_desactivado")
        dificultad = TaskDifficulty.easy
        botonPrioridadBaja.animate(withGIFNamed: "prioridad_baja_star.gif")
        botonPrioridadMedia.stopAnimatingGIF()
        botonPrioridadMedia.image = #imageLiteral(resourceName: "prioridad_media_star_desactivado")
        botonPrioridadAlta.stopAnimatingGIF()
        botonPrioridadAlta.image = #imageLiteral(resourceName: "prioridad_alta_star_desactivado")
        prioridad = TaskPriority.low
        
        //Preparamos y lanzamos la animcacion que muestra la vista
        
        let panelFondo = UIView(frame: self.view.frame)
        panelFondo.backgroundColor = .black
        panelFondo.alpha = 0
        panelFondo.tag = 100
        
        self.view.addSubview(panelFondo)
        self.view.bringSubview(toFront: panelFondo)
        self.view.bringSubview(toFront: viewGuardarTarea)
        
        viewGuardarTarea.isHidden = false
        viewGuardarTarea.alpha = 0
        viewGuardarTarea.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        
        UIView.animate(withDuration: 0.25) {
            panelFondo.alpha = 0.6
            self.viewGuardarTarea.transform = CGAffineTransform.identity
            self.viewGuardarTarea.alpha = 1
        }
        
    }
  
    @IBAction func cerrarVentanaGuardarTarea(_ sender: Any) {
        
        for subview in self.view.subviews {
            if subview.tag == 100 {
                UIView.animate(withDuration: 0.25, animations: {
                    subview.alpha = 0
                    self.viewGuardarTarea.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
                    self.viewGuardarTarea.alpha = 0
                }, completion: { (exito) in
                    subview.removeFromSuperview()
                })
            }
        }

    }
    
    @IBAction func botonGuardarPulsado(_ sender: Any) {
        
        nuevoTask = DataMaganer.sharedInstance.almacenarTask(idJuego: juegoSeleccionado.id, titulo: tituloTask, dificultad: dificultad, prioridad: prioridad, listaComponentes: listaComponentesTask)
        cerrarVentanaGuardarTarea(sender)
        self.performSegue(withIdentifier: "volverPantallaJuegoNuevoJuegoTransicion", sender: self)
        //dismiss(animated: true, completion: nil)
        
    }
    
}
