//
//  TaskImagenesDetailTableViewCell.swift
//  Bitagora
//
//  Created by Lazaro Garcia Cruz on 23/5/17.
//  Copyright © 2017 Lazaro Garcia Cruz. All rights reserved.
//

import UIKit
import ImageSlideshow

class TaskImagenesDetailTableViewCell: UITableViewCell {

    @IBOutlet weak var imageSlideshow: ImageSlideshow!
    
    var listaImagenes: Array<UIImage> = []
    var localSource: Array<ImageSource> = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = .clear
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func inicializarImageSlideshow() {
        
        imageSlideshow.backgroundColor = UIColor(red: 175/255, green: 184/255, blue: 123/255, alpha: 255/255)
        imageSlideshow.slideshowInterval = 0
        imageSlideshow.pageControlPosition = PageControlPosition.insideScrollView
        imageSlideshow.pageControl.currentPageIndicatorTintColor = .white
        imageSlideshow.pageControl.pageIndicatorTintColor = .lightGray
        imageSlideshow.contentScaleMode = UIViewContentMode.scaleAspectFill
        imageSlideshow.activityIndicator = DefaultActivityIndicator()
        
        localSource = []
        for imagen in listaImagenes {
            localSource.append(ImageSource(image: imagen))
        }
        imageSlideshow.setImageInputs(localSource)
        
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(mostrarFullScreenController))
        imageSlideshow.addGestureRecognizer(recognizer)
        
    }
    
    func mostrarFullScreenController() {
        
        if let viewController = parentViewController as? GameTaskDetailViewController {
            let fullScreenController = imageSlideshow.presentFullScreenController(from: viewController)
            fullScreenController.slideshow.activityIndicator = DefaultActivityIndicator(style: .white, color: nil)
        }
        
    }

}
