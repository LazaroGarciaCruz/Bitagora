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

class TaskURLTableViewCell: UITableViewCell {

    @IBOutlet weak var playerView: YouTubePlayerView!
    
    @IBOutlet weak var validateLinkView: UIView!
    @IBOutlet weak var validateText: UITextField!
    @IBOutlet weak var validateButton: UIButton!
    
    @IBOutlet weak var simpleLinkView: UIView!
    @IBOutlet weak var simpleLinkText: UILabel!
    
    var delegate: TaskURLTableViewCellDelegate?
    
    var indexPath: IndexPath?
    
    var textoURL: String = ""
    
    var isVideo = false
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        
        playerView.addBorder(width: 1, color: .black)
        
        let panel = UIView(frame: self.frame)
        panel.w = panel.w * 2
        panel.h = panel.h * 2
        panel.x = panel.x + 10
        panel.y = panel.y + 20
        panel.backgroundColor = .black
        
        self.addSubview(panel)
        self.sendSubview(toBack: panel)
        
        self.backgroundColor = .clear
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func inicializarComponentes() {
        
        if textoURL == "" {
            
            self.validateLinkView.isHidden = false
            self.simpleLinkView.isHidden = true
            self.playerView.isHidden = true
            validateText.text = ""
            
        } else {
            
            if isVideo {
                
                cargarVideoYouTube()
                self.validateLinkView.isHidden = true
                self.simpleLinkView.isHidden = true
                self.playerView.isHidden = false
                
            } else {
                
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
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    }
                    
                })
                
                self.validateLinkView.isHidden = true
                self.simpleLinkView.isHidden = false
                self.playerView.isHidden = true
                
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
        
        //validateText.isEnabled = false
        //validateButton.isEnabled = false
        
        textoURL = validateText.text!
        
        let testURL = NSURL(string: textoURL)!
        Youtube.h264videosWithYoutubeURL(youtubeURL: testURL) { (videoInfo, error) -> Void in
            
            if let _ = videoInfo {
                
                //El enlace es un video de YouTube y cargamos el visor de videos
                
                self.isVideo = true
                self.delegate?.actualizarURL(url: self.textoURL, isVideo: self.isVideo, index: (self.indexPath?.row)!)
                
            } else {
                
                //El enlace es otra cosa diferente y mostramos simplmente el enlace
                
                guard let url = URL(string: self.textoURL) else {
                    return
                }
                
                if ["http", "https"].contains(url.scheme?.lowercased() ?? "") {
                    self.isVideo = false
                    self.delegate?.actualizarURL(url: self.textoURL, isVideo: self.isVideo, index: (self.indexPath?.row)!)
                } else {
                    // Scheme is not supported or no scheme is given, use openURL
                    //UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    let alertVC = UIAlertController(title: "URL mal formada", message: "La URL debe comenzar por 'http://' o 'https://'", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                    alertVC.addAction(okAction)
                    if let viewController = self.parentViewController as? GameTaskViewController {
                        viewController.present(alertVC, animated: true, completion: nil)
                    }
                    //self.validateText.isEnabled = true
                    //self.validateButton.isEnabled = true
                }
                
            }
            
        }
        
    }
    
    @IBAction func borrarCelda(_ sender: Any) {
        delegate?.borrarElemento(index: (indexPath?.row)!)
    }

}
