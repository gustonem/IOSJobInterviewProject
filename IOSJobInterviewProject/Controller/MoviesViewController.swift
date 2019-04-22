//
//  ViewController.swift
//  IOSJobInterviewProject
//
//  Created by Augustin Nemec on 21/04/2019.
//  Copyright © 2019 Augustin Nemec. All rights reserved.
//

import UIKit

class MoviesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

    var movies: [Movie] = []
    
    var filteredMovies: [Movie] = []
    
    var searching = false

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
        
        API.getPopularMovies{ result in
            switch result {
            case .success(let movies):
                self.movies = movies.results
                self.tableView.reloadData()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if searching {
            return filteredMovies.count
        } else {
            return movies.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "movieCell", for: indexPath) as? MovieViewCell  else {
            fatalError("The dequeued cell is not an instance of MealTableViewCell.")
        }
        
        if searching {
            cell.posterImage.imageFromURL(urlString: "https://image.tmdb.org/t/p/w500" + filteredMovies[indexPath.row].backdrop_path)
            cell.title.text = filteredMovies[indexPath.row].title
        } else {
            cell.posterImage.imageFromURL(urlString: "https://image.tmdb.org/t/p/w500" + movies[indexPath.row].backdrop_path)
            cell.title.text = movies[indexPath.row].title
        }
        
        return cell
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
                
            var frame = self.searchBar.frame
            frame.origin.y -= keyboardHeight
                self.searchBar.frame = frame
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        searchBar.frame.origin.y = self.view.frame.height - searchBar.frame.height
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        searchBar.endEditing(true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let detailedMovieController = segue.destination as! MovieDetailedViewController
        searchBar.endEditing(true)
        if searching {
            detailedMovieController.id = filteredMovies[(tableView.indexPathForSelectedRow?.row)!].id
        } else {
            detailedMovieController.id = movies[(tableView.indexPathForSelectedRow?.row)!].id
        }
    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searching = true
        
        if let searchText = searchBar.text, !searchText.isEmpty {
            filteredMovies = movies.filter { movie in
                return movie.title.lowercased().contains(searchText.lowercased())
            }
        } else {
                filteredMovies = movies
        }
        tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
        tableView.reloadData()
    }
    
}

extension UIImageView {
    public func imageFromURL(urlString: String) {
        
        let activityIndicator = UIActivityIndicatorView(style: .gray)
        activityIndicator.frame = CGRect.init(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height)
        activityIndicator.startAnimating()
        if self.image == nil{
            self.addSubview(activityIndicator)
        }
        
        URLSession.shared.dataTask(with: NSURL(string: urlString)! as URL, completionHandler: { (data, response, error) -> Void in
            
            if error != nil {
                print(error ?? "No Error")
                return
            }
            DispatchQueue.main.async(execute: { () -> Void in
                let image = UIImage(data: data!)
                activityIndicator.removeFromSuperview()
                self.image = image
            })
            
        }).resume()
    }
}
