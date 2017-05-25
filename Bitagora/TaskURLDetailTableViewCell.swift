//
//  TaskURLDetailTableViewCell.swift
//  Bitagora
//
//  Created by Lazaro Garcia Cruz on 23/5/17.
//  Copyright © 2017 Lazaro Garcia Cruz. All rights reserved.
//

import UIKit
import SafariServices

class TaskURLDetailTableViewCell: UITableViewCell {

    @IBOutlet weak var youtubePlayerView: YouTubePlayerView!
    @IBOutlet weak var urlView: UIView!
    @IBOutlet weak var urlText: UILabel!
    
    var textoURL: String = ""
    var isVideo = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = .clear
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func inicializarComponentes() {
        
        if textoURL == "" {
            
            youtubePlayerView.isHidden = true
            urlView.isHidden = false
            urlText.text = textoURL
            
        } else {
            
            if isVideo {
                
                cargarVideoYouTube()
                youtubePlayerView.isHidden = false
                urlView.isHidden = true
                
            } else {
                
                youtubePlayerView.isHidden = true
                urlView.isHidden = false
                
                urlText.text = textoURL
                urlText.addTapGesture(tapNumber: 1, action: { (sender) in
                    
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
                        if let viewController = self.parentViewController as? GameTaskDetailViewController {
                            viewController.present(safariViewController, animated: true, completion: nil)
                        }
                    }
                    
                })
                
            }
            
        }
        
    }
    
    func cargarVideoYouTube() {
        
        let videoURL = NSURL(string: self.textoURL)
        youtubePlayerView.loadVideoURL(videoURL! as URL)
        
        if youtubePlayerView.ready {
            if youtubePlayerView.playerState != YouTubePlayerState.Playing {
                youtubePlayerView.play()
            }
        }
        
    }
    
}
