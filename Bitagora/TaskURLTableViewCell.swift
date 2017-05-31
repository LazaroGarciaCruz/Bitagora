//
//  TaskURLTableViewCell.swift
//  Bitagora
//
//  Created by Lazaro Garcia Cruz on 12/5/17.
//  Copyright © 2017 Lazaro Garcia Cruz. All rights reserved.
//

import UIKit
import SafariServices

protocol TaskURLTableViewCellDelegate: class {
    func actualizarURL(url: String, isVideo: Bool, index: Int)
    func borrarElemento(index: Int)
}

class TaskURLTableViewCell: UITableViewCell, UITextFieldDelegate {

    @IBOutlet weak var playerView: YouTubePlayerView!
    @IBOutlet weak var playerViewContainer: UIView!
    @IBOutlet weak var validateLinkView: UIView!
    @IBOutlet weak var validateText: UITextField!
    @IBOutlet weak var validateButton: UIButton!
    @IBOutlet weak var textoTip: UILabel!
    @IBOutlet weak var simpleLinkView: UIView!
    @IBOutlet weak var simpleLinkText: UILabel!
    
    var delegate: TaskURLTableViewCellDelegate?
    
    var indexPath: IndexPath?
    
    var textoURL: String = ""
    
    var isVideo = false
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        
        validateText.delegate = self
        self.backgroundColor = .clear
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textoTip.isHidden = true
        validateButton.isEnabled = true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if validateText.text == "" {
            textoTip.isHidden = false
            validateButton.isEnabled = false
        }
    }
    
    func inicializarComponentes() {
        
        if textoURL == "" {
            
            self.validateLinkView.isHidden = false
            self.textoTip.isHidden = false
            self.simpleLinkView.isHidden = true
            self.playerViewContainer.isHidden = true
            validateText.text = ""
            validateButton.isEnabled = false
            
        } else {
            
            if isVideo {
                
                cargarVideoYouTube()
                self.validateLinkView.isHidden = true
                self.simpleLinkView.isHidden = true
                self.playerViewContainer.isHidden = false
                
            } else {
                
                self.validateLinkView.isHidden = true
                self.simpleLinkView.isHidden = false
                self.playerViewContainer.isHidden = true
                
                simpleLinkText.text = textoURL
                simpleLinkText.addTapGesture(tapNumber: 1, action: { (sender) in
                    
                    guard let url = URL(string: self.textoURL) else {
                        // not a valid URL
                        return
                    }
                    
                    if ["http", "https"].contains(url.scheme?.lowercased() ?? "") {
                        // Can open with SFSafariViewController
                        let safariViewController = SFSafariViewController(url: url)
                        if let viewController = self.parentViewController as? GameTaskViewController {
                            viewController.present(safariViewController, animated: true, completion: nil)
                        }
                    } else {
                        // Scheme is not supported or no scheme is given, use openURL
                        var modifiedURLString = String(format:"http://%@", url.absoluteString)
                        let safariViewController = SFSafariViewController(url: URL(string: modifiedURLString)!)
                        if let viewController = self.parentViewController as? GameTaskViewController {
                            viewController.present(safariViewController, animated: true, completion: nil)
                        }
                        /*if #available(iOS 10.0, *) {
                            UIApplication.shared.open(url, options: [:], completionHandler: nil)
                        } else {
                            UIApplication.shared.openURL(url)
                        }*/
                    }
                    
                })
                
            }
            
        }
        
    }
    
    func cargarVideoYouTube() {
        
        let videoURL = NSURL(string: self.textoURL)
        self.playerView.loadVideoURL(videoURL! as URL)
        
        if self.playerView.ready {
            if self.playerView.playerState != YouTubePlayerState.Playing {
                self.playerView.play()
            }
        }
        
    }
    
    @IBAction func validarURL(_ sender: Any) {
        
        textoURL = validateText.text!
        
        if let testURL = NSURL(string: textoURL) {
            
            //let testURL = NSURL(string: textoURL)!
            Youtube.h264videosWithYoutubeURL(youtubeURL: testURL) { (videoInfo, error) -> Void in
                
                if let _ = videoInfo {
                    
                    //El enlace es un video de YouTube y cargamos el visor de videos
                    
                    self.isVideo = true
                    self.delegate?.actualizarURL(url: self.textoURL, isVideo: self.isVideo, index: (self.indexPath?.row)!)
                    
                } else {
                    
                    //El enlace es otra cosa diferente y mostramos simplmente el enlace
                    
                    guard URL(string: self.textoURL) != nil else {
                        self.validateText.text = ""
                        let alertVC = UIAlertController(title: "URL no valida", message: "La URL introducida esta en un formato incorrecto", preferredStyle: .alert)
                        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                        alertVC.addAction(okAction)
                        if let viewController = self.parentViewController as? GameTaskViewController {
                            viewController.present(alertVC, animated: true, completion: nil)
                        }
                        return
                    }
                    
                    self.isVideo = false
                    self.delegate?.actualizarURL(url: self.textoURL, isVideo: self.isVideo, index: (self.indexPath?.row)!)

                }
                
            }
            
        } else {
            
            validateText.text = ""
            textoTip.isHidden = false
            let alertVC = UIAlertController(title: "URL no valida", message: "La URL introducida esta en un formato incorrecto", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertVC.addAction(okAction)
            if let viewController = self.parentViewController as? GameTaskViewController {
                viewController.present(alertVC, animated: true, completion: nil)
            }
            
        }
        
    }
    
    @IBAction func borrarCelda(_ sender: Any) {
        
        if self.playerView.ready {
            if self.playerView.playerState == YouTubePlayerState.Playing {
                self.playerView.stop()
            }
        }
        
        delegate?.borrarElemento(index: (indexPath?.row)!)
        
    }

}
