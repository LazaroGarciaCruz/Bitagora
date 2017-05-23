//
//  GameTaskViewController.swift
//  Bitagora
//
//  Created by Lazaro Garcia Cruz on 12/5/17.
//  Copyright © 2017 Lazaro Garcia Cruz. All rights reserved.
//

import UIKit
import ImageSlideshow

class GameTaskViewController: UIViewController, UITableViewDataSource, UITableViewDelegate,
                                TaskTextoTableViewCellDelegate, TaskImagenesTableViewCellDelegate,
                                TaskURLTableViewCellDelegate, TaskCounterTableViewCellDelegate {
    
    @IBOutlet weak var tableView: UITableView!

    @IBOutlet weak var scanlineView: PassThroughView!
    
    var listaComponentesTask: Array<TaskComponent> = []
    
    var activeField: UITextView?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        //Estas notificaciones son las que permiten a la vista
        //saber cuando se va a mostrar el teclado y cuando se oculta
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasShown), name: NSNotification.Name.UIKeyboardDidShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillBeHidden), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
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
    
    func generarScanlines() {
        
        for subview in scanlineView.subviews {
            subview.removeFromSuperview()
        }
        
        let totalImagenes = 500
        let heigth: CGFloat = scanlineView.h / CGFloat(totalImagenes)
        
        var index = 0
        
        for _ in 0...totalImagenes {
            let imageView = UIImageView(frame: CGRect(x: 0, y: heigth * CGFloat(index), width: scanlineView.w, height: heigth), image: UIImage(named: "scanlines_iphone.png")!)
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
        if (index <= listaComponentesTask.count) {
            if listaComponentesTask[index] is TaskComponentText {
                (listaComponentesTask[index] as! TaskComponentText).texto = texto
            }
        }
    }
    
    func actualizarImagenes(imagenes: Array<ImageSource>, index: Int) {
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
    
    @IBAction func botonAceptarPulsado(_ sender: Any) {
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
        cell.localSource = (listaComponentesTask[indexPath.row] as! TaskComponentImages).listaImagenes
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
                return 80
            case TaskComponentType.counter:
                return 80
            default:
                return 150
        }
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
