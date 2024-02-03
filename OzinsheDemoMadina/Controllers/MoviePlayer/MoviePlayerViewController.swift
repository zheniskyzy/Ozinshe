//
//  MoviePlayerViewController.swift
//  OzinsheDemoMadina
//
//  Created by Madina Olzhabek on 02.02.2024.
//

import UIKit
import YouTubePlayer

class MoviePlayerViewController: UIViewController {

    @IBOutlet weak var player: YouTubePlayerView!
    

     var video_link = ""

    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        
        player.loadVideoID(video_link)
    
    }

}
