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

    @IBOutlet weak var backTitleView: UIView!
    @IBOutlet weak var titleView: GradientView!
    @IBOutlet weak var backgroundView: PassThroughView!
    @IBOutlet weak var scanlineView: PassThroughView!
    
    var listaComponentesTask: Array<TaskComponent> = []
    
    var activeField: UITextView?
    
    //Variables para la gestion de la ventana de guardado
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
    @IBOutlet weak var fondoPanel: UIImageView!
    @IBOutlet weak var fondoBotonGuardar: UIImageView!
    @IBOutlet weak var textoTip: UILabel!
    
    var tituloTask: String = ""
    var dificultad: TaskDifficulty = TaskDifficulty.easy
    var prioridad: TaskPriority = TaskPriority.low
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        //Propiedades del status bar
        
        var colores: Array<CGColor> = [UIColor(red: 144/255, green: 42/255, blue: 135/255, alpha: 1).cgColor,
                                       UIColor(red: 252/255, green: 2/255, blue: 84/255, alpha: 1).cgColor]
        
        let statusBarView = UIView(frame: UIApplication.shared.statusBarFrame)
        statusBarView.createGradientWithColors(colors: colores, direction: .horizontal)
        view.addSubview(statusBarView)
        
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
     Establece la barra de estado de color blanco
     */
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
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
        
        //Se establecen las propiedades de los selectores
        //de dificultad y prioridad
        
        botonDificultadFacil.image = #imageLiteral(resourceName: "dificultad_facil_color")
        botonPrioridadBaja.image = #imageLiteral(resourceName: "prioridad_baja_star_color")
        
        botonDificultadFacil.addTapGesture(tapNumber: 1) { (gesture) in
            //self.botonDificultadFacil.animate(withGIFNamed: "dificultad_facil.gif")
            self.botonDificultadFacil.image = #imageLiteral(resourceName: "dificultad_facil_color")
            self.botonDificultadNormal.stopAnimatingGIF()
            self.botonDificultadNormal.image = #imageLiteral(resourceName: "dificultad_normal_desactivado")
            self.botonDificultadDificil.stopAnimatingGIF()
            self.botonDificultadDificil.image = #imageLiteral(resourceName: "dificultad_dificil_desactivado")
            self.dificultad = TaskDifficulty.easy
        }
        
        botonDificultadNormal.addTapGesture(tapNumber: 1) { (gesture) in
            self.botonDificultadFacil.stopAnimatingGIF()
            self.botonDificultadFacil.image = #imageLiteral(resourceName: "dificultad_facil_desactivado")
            self.botonDificultadNormal.image = #imageLiteral(resourceName: "dificultad_normal_color")
            self.botonDificultadDificil.stopAnimatingGIF()
            self.botonDificultadDificil.image = #imageLiteral(resourceName: "dificultad_dificil_desactivado")
            self.dificultad = TaskDifficulty.normal
        }
        
        botonDificultadDificil.addTapGesture(tapNumber: 1) { (gesture) in
            self.botonDificultadFacil.stopAnimatingGIF()
            self.botonDificultadFacil.image = #imageLiteral(resourceName: "dificultad_facil_desactivado")
            self.botonDificultadNormal.stopAnimatingGIF()
            self.botonDificultadNormal.image = #imageLiteral(resourceName: "dificultad_normal_desactivado")
            self.botonDificultadDificil.image = #imageLiteral(resourceName: "dificultad_dificl_color")
            self.dificultad = TaskDifficulty.hard
        }
        
        botonPrioridadBaja.addTapGesture(tapNumber: 1) { (gesture) in
            self.botonPrioridadBaja.image = #imageLiteral(resourceName: "prioridad_baja_star_color")
            self.botonPrioridadMedia.stopAnimatingGIF()
            self.botonPrioridadMedia.image = #imageLiteral(resourceName: "prioridad_media_star_desactivado")
            self.botonPrioridadAlta.stopAnimatingGIF()
            self.botonPrioridadAlta.image = #imageLiteral(resourceName: "prioridad_alta_star_desactivado")
            self.prioridad = TaskPriority.low
        }
        
        botonPrioridadMedia.addTapGesture(tapNumber: 1) { (gesture) in
            self.botonPrioridadBaja.stopAnimatingGIF()
            self.botonPrioridadBaja.image = #imageLiteral(resourceName: "prioridad_baja_star_desactivado")
            self.botonPrioridadMedia.image = #imageLiteral(resourceName: "prioridad_media_star_color")
            self.botonPrioridadAlta.stopAnimatingGIF()
            self.botonPrioridadAlta.image = #imageLiteral(resourceName: "prioridad_alta_star_desactivado")
            self.prioridad = TaskPriority.medium
        }
        
        botonPrioridadAlta.addTapGesture(tapNumber: 1) { (gesture) in
            self.botonPrioridadBaja.stopAnimatingGIF()
            self.botonPrioridadBaja.image = #imageLiteral(resourceName: "prioridad_baja_star_desactivado")
            self.botonPrioridadMedia.stopAnimatingGIF()
            self.botonPrioridadMedia.image = #imageLiteral(resourceName: "prioridad_media_star_desactivado")
            self.botonPrioridadAlta.image = #imageLiteral(resourceName: "prioridad_alta_star_color")
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
            imageView.alpha = 0.20
            scanlineView.addSubview(imageView)
            index += 1
        }
        
        for subview in backgroundView.subviews {
            subview.removeFromSuperview()
        }
        
        /*var imagenesHorizontal = 12
        var imagenesVertical = 1
        var widthGif: CGFloat = backTitleView.w / CGFloat(imagenesHorizontal)
        var heigthGif: CGFloat = backTitleView.h
        
        backTitleView.addBorder(width: 5, color: .clear)
        
        for indexW in 0...imagenesHorizontal {
            let gif = GIFImageView(frame: CGRect(x: CGFloat(indexW) * widthGif, y: 0, width: widthGif, height: heigthGif))
            gif.animate(withGIFNamed: "stars_grey_background.gif")
            gif.addBorder(width: 3, color: .clear)
            backTitleView.addSubview(gif)
            backTitleView.sendSubview(toBack: gif)
        }*/
        
        let imagenesHorizontal = 2
        let imagenesVertical = 1
        let widthGif = UIScreen.main.bounds.height / CGFloat(imagenesHorizontal)
        let heigthGif = UIScreen.main.bounds.height / CGFloat(imagenesVertical)
        
        for indexH in 0...imagenesVertical {
            for indexW in 0...imagenesHorizontal {
                let gif = GIFImageView(frame: CGRect(x: CGFloat(indexW) * widthGif, y: CGFloat(indexH) * heigthGif, width: widthGif, height: heigthGif))
                gif.animate(withGIFNamed: "stars_purple_background.gif")
                backgroundView.addSubview(gif)
            }
        }
        
        /*let imagenesHorizontal = 1
        let imagenesVertical = 2
        let widthGif: CGFloat = UIScreen.main.bounds.height / CGFloat(imagenesHorizontal)
        let heigthGif: CGFloat = UIScreen.main.bounds.height / CGFloat(imagenesVertical)
        
        for indexH in 0...imagenesVertical {
            for indexW in 0...imagenesHorizontal {
                let gif = GIFImageView(frame: CGRect(x: CGFloat(indexW) * widthGif, y: CGFloat(indexH) * heigthGif, width: widthGif, height: heigthGif))
                gif.animate(withGIFNamed: "stars_scroll_background.gif")
                backgroundView.addSubview(gif)
            }
        }*/
        
        //Inicializamos el title view
        
        /*colores = [UIColor(red: 144/255, green: 42/255, blue: 135/255, alpha: 1).cgColor,
                   UIColor(red: 252/255, green: 2/255, blue: 84/255, alpha: 1).cgColor]
        titleView.colores = colores
        titleView.direccion = UIView.UIViewLinearGradientDirection.diagonalFromRightToLeftAndTopToDown*/
        
    }
    
    func ajustarTexto() {
        
        /*let currentOffset = tableView.contentOffset
        UIView.setAnimationsEnabled(false)
        tableView.beginUpdates()
        tableView.endUpdates()
        UIView.setAnimationsEnabled(true)
        tableView.setContentOffset(currentOffset, animated: false)*/
        
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
                //return UITableViewAutomaticDimension
                return 250
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
     un textfield que esta inactivo gana el foco
     */
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textoTip.isHidden = true
    }
    
    /*
     Con este metodo se especifica que se debe hacer cuando
     un textfield esta activo pierde el foco
     */
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextFieldDidEndEditingReason) {
        
        self.view.endEditing(true)
        tituloTask = textoTituloTarea.text!
        
        botonGuardarTask.isEnabled = false
        fondoBotonGuardar.image = #imageLiteral(resourceName: "window_button_desactivado")
        //botonGuardarTask.backgroundColor = UIColor(red: 168/255, green: 168/255, blue: 168/255, alpha: 255/255)
        botonGuardarTask.setTitleColor(.darkGray, for: .normal)
        if tituloTask != "" {
            botonGuardarTask.isEnabled = true
            botonGuardarTask.backgroundColor = .clear
            fondoBotonGuardar.image = #imageLiteral(resourceName: "window_button")
            botonGuardarTask.setTitleColor(.black, for: .normal)
        } else {
            textoTip.isHidden = false
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
        //botonGuardarTask.backgroundColor = UIColor(red: 168/255, green: 168/255, blue: 168/255, alpha: 255/255)
        fondoBotonGuardar.image = #imageLiteral(resourceName: "window_button_desactivado")
        botonGuardarTask.setTitleColor(.darkGray, for: .normal)
        if tituloTask != "" {
            botonGuardarTask.isEnabled = true
            botonGuardarTask.backgroundColor = .clear
            fondoBotonGuardar.image = #imageLiteral(resourceName: "window_button")
            botonGuardarTask.setTitleColor(.black, for: .normal)
        } else {
            textoTip.isHidden = false
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
        
        if verificarComponentes() {
        
            textoTituloTarea.text = ""
            tituloTask = ""
            botonGuardarTask.isEnabled = false
            fondoBotonGuardar.image = #imageLiteral(resourceName: "window_button_desactivado")
            //botonGuardarTask.backgroundColor = UIColor(red: 168/255, green: 168/255, blue: 168/255, alpha: 255/255)
            botonGuardarTask.setTitleColor(.darkGray, for: .normal)
            
            botonDificultadFacil.image = #imageLiteral(resourceName: "dificultad_facil_color")
            //botonDificultadFacil.animate(withGIFNamed: "dificultad_facil.gif")
            botonDificultadNormal.stopAnimatingGIF()
            botonDificultadNormal.image = #imageLiteral(resourceName: "dificultad_normal_desactivado")
            botonDificultadDificil.stopAnimatingGIF()
            botonDificultadDificil.image = #imageLiteral(resourceName: "dificultad_dificil_desactivado")
            dificultad = TaskDifficulty.easy
            botonPrioridadBaja.image = #imageLiteral(resourceName: "prioridad_baja_star_color")
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
    
    func verificarComponentes() -> Bool {
        
        if listaComponentesTask.count == 0 {
            let alertVC = UIAlertController(title: "Atencion", message: "Debe haber al menos un componente en la tarea a crear", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertVC.addAction(okAction)
            self.present(alertVC, animated: true, completion: nil)
            return false
        }
        
        var componentesCorrectos = true
        for componente in listaComponentesTask {
            switch componente.type {
            case .text:
                if (componente as! TaskComponentText).texto == "" {
                    componentesCorrectos = false
                }
            case .images:
                if (componente as! TaskComponentImages).listaImagenes.count == 0 {
                    componentesCorrectos = false
                }
            case .url:
                if (componente as! TaskComponentURL).url == "" {
                    componentesCorrectos = false
                }
            case .counter:
                if (componente as! TaskComponentCounter).descripcion == "" || (componente as! TaskComponentCounter).maxElements == 0 {
                    componentesCorrectos = false
                }
            default:
                return false
            }
        }
        
        if !componentesCorrectos {
            let alertVC = UIAlertController(title: "Atencion", message: "En alguno de los componentes insertados no se han establecido sus propiedades correctamente. Si es texto verifique que se ha introducido algun texto, si son imagenes que se ha seleccionado alguna imagen, si son enlaces que se ha verificado realmente algun enlace y si es un contador que posee descripcion y un numero de elementos mayor a 0", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertVC.addAction(okAction)
            self.present(alertVC, animated: true, completion: nil)
            return false
        }
        
        return true
        
    }
    
}
