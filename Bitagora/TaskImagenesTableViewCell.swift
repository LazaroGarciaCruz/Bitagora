//
//  TaskImagenesTableViewCell.swift
//  Bitagora
//
//  Created by Lazaro Garcia Cruz on 12/5/17.
//  Copyright © 2017 Lazaro Garcia Cruz. All rights reserved.
//

import UIKit
import ImageSlideshow

protocol TaskImagenesTableViewCellDelegate: class {
    func actualizarImagenes(imagenes: Array<ImageSource>, index: Int)
    func borrarElemento(index: Int)
}

class TaskImagenesTableViewCell: UITableViewCell, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imageSlideshow: ImageSlideshow!
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var galleryButton: UIButton!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var backView2: UIView!
    
    weak var delegate: TaskImagenesTableViewCellDelegate?
    
    var indexPath: IndexPath?
    
    var localSource: Array<ImageSource> = []
    
    let imagePicker = UIImagePickerController()
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        
        let panel = UIView(frame: self.frame)
        panel.w = panel.w * 5
        panel.h = panel.h * 5
        panel.x = panel.x + 10
        panel.y = panel.y + 20
        panel.backgroundColor = .black
        
        self.addSubview(panel)
        self.sendSubview(toBack: panel)
        
        self.backgroundColor = .clear
        
        /*textView.addBorder(width: 1, color: UIColor(red: 0/255, green: 0/255, blue: 173/255, alpha: 255/255))*/
        backView.addBorder(width: 2, color: .white)
        backView2.addBorder(width: 2, color: .white)
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func inicializarImageSlideshow() {
        
        imagePicker.delegate = self
        
        //imageSlideshow.addBorder(width: 1, color: .black)
        imageSlideshow.backgroundColor = UIColor(red: 0/255, green: 0/255, blue: 173/255, alpha: 255/255)
        imageSlideshow.slideshowInterval = 0
        imageSlideshow.pageControlPosition = PageControlPosition.insideScrollView
        imageSlideshow.pageControl.currentPageIndicatorTintColor = .white/*UIColor(red: 252/255, green: 2/255, blue: 84/255, alpha: 1)*/
        imageSlideshow.pageControl.pageIndicatorTintColor = .lightGray/*UIColor(red: 144/255, green: 42/255, blue: 135/255, alpha: 1)*/
        imageSlideshow.contentScaleMode = UIViewContentMode.scaleAspectFill
        imageSlideshow.activityIndicator = DefaultActivityIndicator()
        
        imageSlideshow.setImageInputs(localSource)
        
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(mostrarFullScreenController))
        imageSlideshow.addGestureRecognizer(recognizer)
        
    }
    
    func mostrarFullScreenController() {
        
        if let viewController = parentViewController as? GameTaskViewController {
            let fullScreenController = imageSlideshow.presentFullScreenController(from: viewController)
            // set the activity indicator for full screen controller; skip the line if no activity indicator should be shown
            fullScreenController.slideshow.activityIndicator = DefaultActivityIndicator(style: .white, color: nil)
        }
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        localSource.append(ImageSource(image: chosenImage))
        imageSlideshow.setImageInputs(localSource)
        delegate?.actualizarImagenes(imagenes: localSource, index: (indexPath?.row)!)
        
        if let viewController = parentViewController as? GameTaskViewController {
            viewController.dismiss(animated:true, completion: nil)
        }
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        if let viewController = parentViewController as? GameTaskViewController {
            viewController.dismiss(animated: true, completion: nil)
        }
        
    }
    
    @IBAction func showImagePicker(_ sender: Any) {
        
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        imagePicker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        
        if let viewController = parentViewController as? GameTaskViewController {
            viewController.present(imagePicker, animated: true, completion: nil)
        }
        
    }
    
    @IBAction func showCamera(_ sender: Any) {
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
        
            imagePicker.allowsEditing = false
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera
            imagePicker.cameraCaptureMode = .photo
            imagePicker.modalPresentationStyle = .fullScreen
            
            if let viewController = parentViewController as? GameTaskViewController {
                viewController.present(imagePicker, animated: true, completion: nil)
            }
            
        } else {
            
            let alertVC = UIAlertController(title: "Camara no encontrada",
                message: "Este dispositivo no dispone de camara",
                preferredStyle: .alert)
            let okAction = UIAlertAction(
                title: "OK",
                style:.default,
                handler: nil)
            alertVC.addAction(okAction)
            
            if let viewController = parentViewController as? GameTaskViewController {
                viewController.present(alertVC, animated: true, completion: nil)
            }
            
        }
        
    }
    
    @IBAction func borrarCelda(_ sender: Any) {
        delegate?.borrarElemento(index: (indexPath?.row)!)
    }
        
}
