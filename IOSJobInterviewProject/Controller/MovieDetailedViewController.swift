//
//  landscapeViewController.swift
//  IOSJobInterviewProject
//
//  Created by Augustin Nemec on 17/04/2019.
//  Copyright © 2019 Augustin Nemec. All rights reserved.
//

import UIKit
import XCDYouTubeKit
import AVKit

class MovieDetailedViewController: UIViewController {
    
    @IBOutlet var portraitConstraints: [NSLayoutConstraint]!
    
    @IBOutlet var landscapeConstraints: [NSLayoutConstraint]!
    
    @IBOutlet weak var emptySpace: UIView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var genresLabel: UILabel!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var overviewLabel: UILabel!
    
    @IBOutlet var posterImage: UIImageView!
    
    var id: Int = 0
    var image: UIImage = UIImage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setConstrains()
        
        self.posterImage.image = image
        
        API.getDetailedMovie(id: id) { response in
            
            
            switch response {
            case .success(let movie):
                var genres: [String] = []
                for genre in movie.genres! {
                    genres.append(genre.name)
                }
                
                self.genresLabel.text? = genres.joined(separator: ", ")
                
                self.titleLabel.text = movie.title
                self.dateLabel.text = self.convertDateFormatter(date: movie.release_date!)
                self.overviewLabel.text = movie.overview
                
            case .failure(let error):
                
                let alert = UIAlertController(title: "API error", message: error.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                    self.viewDidLoad()
                }))
                self.present(alert, animated: true)
            }
        }
    }
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        self.setConstrains()
    }
    
    func setConstrains() {
        if UIDevice.current.orientation.isLandscape {
            emptySpace.isHidden = false
            for c in portraitConstraints {
                c.isActive = false
            }
            
            for c in landscapeConstraints {
                c.isActive = true
            }
            
        } else {
            emptySpace.isHidden = true
            for c in landscapeConstraints {
                c.isActive = false
            }
            
            for c in portraitConstraints {
                c.isActive = true
            }
        }
    }
    
    func convertDateFormatter(date: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let convertedDate = dateFormatter.date(from: date)
        
        dateFormatter.dateFormat = "dd.MM.yyyy"
        let timeStamp = dateFormatter.string(from: convertedDate!)
        
        return timeStamp
    }
    
    @IBAction func watchTrailer(_ sender: UIButton) {
        
        API.getVideosForMovie(id: self.id) { response in
            
            
            switch response {
            case .success(let videos):
                let playerViewController = AVPlayerViewController()
                self.present(playerViewController, animated: true, completion: nil)
                
                XCDYouTubeClient.default().getVideoWithIdentifier(videos.results[0].key) { (video, error) in
                    guard video != nil else {
                        // Handle error
                        return
                    }
                    
                    if let streamURLs = video?.streamURLs {
                        let streamURL = (streamURLs[XCDYouTubeVideoQuality.HD720.rawValue] ?? streamURLs[XCDYouTubeVideoQuality.medium360.rawValue] ?? streamURLs[XCDYouTubeVideoQuality.small240.rawValue])
                        playerViewController.player = AVPlayer(url: streamURL!)
                        playerViewController.player?.play()
                        
                        NotificationCenter.default.addObserver(self, selector: #selector(self.playerDidFinishPlaying), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: playerViewController.player?.currentItem)
                        
                        // Only IOS 11+
                        // playerViewController.exitsFullScreenWhenPlaybackEnds = true
                    } else {
                        self.dismiss(animated: true, completion: nil)
                    }
                }
            case .failure(let error):
                let alert = UIAlertController(title: "API error", message: error.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true)
            }
        }
    }
    
    @objc func playerDidFinishPlaying(note: NSNotification) {
        self.dismiss(animated: true, completion: nil)
    }  
}
