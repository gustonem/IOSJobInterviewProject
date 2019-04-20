//
//  landscapeViewController.swift
//  IOSJobInterviewProject
//
//  Created by Augustin Nemec on 17/04/2019.
//  Copyright © 2019 Augustin Nemec. All rights reserved.
//

import UIKit

class MovieDetailedViewController: UIViewController {

    
    @IBOutlet var portraitConstraints: [NSLayoutConstraint]!
    
    @IBOutlet var landscapeConstraints: [NSLayoutConstraint]!
    
    @IBOutlet weak var emptySpace: UIView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var genresLabel: UILabel!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var overviewLabel: UILabel!
    
    @IBOutlet weak var posterImage: UIImageView!
    
    var id: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setConstrains()
        titleLabel.text = String(id)
        
        API.getDetailedMovie(id: id) { result in
            switch result {
            case .success(let movie):
                
                var genres: [String] = []
                for genre in movie.genres! {
                    genres.append(genre.name)
                }
                
                self.genresLabel.text? = genres.joined(separator: ", ")
                
                
                self.titleLabel.text = movie.title
                self.posterImage.imageFromURL(urlString: "https://image.tmdb.org/t/p/w500" + movie.backdrop_path)
                
                self.dateLabel.text = self.convertDateFormatter(date: movie.release_date!)
                self.overviewLabel.text = movie.overview
                
            case .failure(let error):
                print(error.localizedDescription)
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
}
