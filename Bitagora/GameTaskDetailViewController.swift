//
//  GameTaskDetailViewController.swift
//  Bitagora
//
//  Created by Lazaro Garcia Cruz on 23/5/17.
//  Copyright © 2017 Lazaro Garcia Cruz. All rights reserved.
//

import UIKit
import Gifu

class GameTaskDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, TaskCounterDetailTableViewCellDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var scanlinesView: UIView!
    @IBOutlet weak var botonAtras: UIButton!
    
    var taskSeleccionada: GameTask!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        generarScanlines()
        prepararTabla()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func generarScanlines() {
        
        for subview in scanlinesView.subviews {
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
            scanlinesView.addSubview(imageView)
            index += 1
        }
        
    }
    
    func actualizarContador(actualElements: Int, index: Int) {
        if taskSeleccionada.listaComponentesTask[index] is TaskComponentCounter {
            (taskSeleccionada.listaComponentesTask[index] as! TaskComponentCounter).currentElementCount = actualElements
            DataMaganer.sharedInstance.actualizarContadorTask(
                id: taskSeleccionada.id, taskComponente: taskSeleccionada.listaComponentesTask[index] as! TaskComponentCounter)
        }
    }
    
    @IBAction func volverPantallaJuego(_ sender: Any) {
        self.performSegue(withIdentifier: "volverPantallaJuegoTransicion", sender: self)
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
        /*let backgroundImage = UIImage(named: "buttonSquare_green")
        let imageView = UIImageView(image: backgroundImage)
        imageView.contentMode = .scaleToFill
        imageView.clipsToBounds = true
        tableView.backgroundView = imageView*/
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
        return taskSeleccionada.listaComponentesTask.count
    }
    
    //Este metodo configura la representacion visual de cada una de las filas de la tabla
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch (taskSeleccionada.listaComponentesTask[indexPath.row] as TaskComponent).type {
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
    
    func procesarTaskTextoCell(indexPath: IndexPath) -> TaskTextoDetailTableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellTexto", for: indexPath) as! TaskTextoDetailTableViewCell
        cell.texto = (taskSeleccionada.listaComponentesTask[indexPath.row] as! TaskComponentText).texto
        
        return cell
        
    }
    
    func procesarTaskImagenesCell(indexPath: IndexPath) -> TaskImagenesDetailTableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellImagenes", for: indexPath) as! TaskImagenesDetailTableViewCell
        cell.listaImagenes = (taskSeleccionada.listaComponentesTask[indexPath.row] as! TaskComponentImages).listaImagenes
        cell.inicializarImageSlideshow()
        
        return cell
        
    }
    
    func procesarTaskURLCell(indexPath: IndexPath) -> TaskURLDetailTableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellURL", for: indexPath) as! TaskURLDetailTableViewCell
        cell.textoURL = (taskSeleccionada.listaComponentesTask[indexPath.row] as! TaskComponentURL).url
        cell.isVideo = (taskSeleccionada.listaComponentesTask[indexPath.row] as! TaskComponentURL).isVideo
        cell.inicializarComponentes()
        
        return cell
        
    }
    
    func procesarTaskCounterCell(indexPath: IndexPath) -> TaskCounterTDetailableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellContador", for: indexPath) as! TaskCounterTDetailableViewCell
        cell.textoDescripcion.text = (taskSeleccionada.listaComponentesTask[indexPath.row] as! TaskComponentCounter).descripcion
        cell.cantidadTotal = (taskSeleccionada.listaComponentesTask[indexPath.row] as! TaskComponentCounter).maxElements
        cell.cantidadActual = (taskSeleccionada.listaComponentesTask[indexPath.row] as! TaskComponentCounter).currentElementCount
        cell.indexPath = indexPath
        cell.delegate = self
        
        return cell
        
    }
    
    //Este metodo determina la altura de cada una de las filas de la tabla
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch (taskSeleccionada.listaComponentesTask[indexPath.row] as TaskComponent).type {
        case TaskComponentType.text:
            return UITableViewAutomaticDimension
        //return 175
        case TaskComponentType.images:
            return 250
        case TaskComponentType.url:
            if (taskSeleccionada.listaComponentesTask[indexPath.row] as! TaskComponentURL).isVideo {
                return 250
            }
            return 20
        case TaskComponentType.counter:
            return 40
        default:
            return 150
        }
        
    }

}
