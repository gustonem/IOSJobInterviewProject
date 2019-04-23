//
//  MoviesViewController.swift
//  IOSJobInterviewProject
//
//  Created by Augustin Nemec on 21/04/2019.
//  Copyright © 2019 Augustin Nemec. All rights reserved.
//

import UIKit

class MoviesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    var movies = [Movie]()
    
    var movieWithImage = [Movie:UIImage]()
    
    var filteredMovies = [Movie]()
    
    var searching = false
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Observer to find out when keyboard will show to abjust
        // searchBar position with keyboardWillShow function
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        
        // Observer to find out when keyboard will hide to abjust
        // searchBar position with keyboardWillHide function
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
        
        populateTable()
    }
    
    /**
     Function to pupulate tableView with popular movies
     
     Contains API call to get all movies and also call to get poster image for each movie.
     In case of API error, alert is showed with `OK` button to repeat function
     */
    func populateTable() {
        API.getPopularMovies{ response in
            
            switch response {
            case .success(let movies):
                for movie in movies.results {
                    API.getImage(urlString: "https://image.tmdb.org/t/p/w500" + movie.backdrop_path) { response in
                        
                        
                        switch response {
                        case .success(let data):
                            self.movieWithImage[movie] = UIImage(data: data)
                        case .failure(let error):
                            let alert = UIAlertController(title: "API error", message: error.localizedDescription, preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                                self.populateTable()
                            }))
                            self.present(alert, animated: true)
                        }
                        
                        self.tableView.reloadData()
                    }
                }
                
                self.movies = movies.results
            case .failure(let error):
                let alert = UIAlertController(title: "API error", message: error.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                    self.populateTable()
                }))
                self.present(alert, animated: true)
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
            cell.posterImage.image = movieWithImage[filteredMovies[indexPath.row]]
            cell.title.text = filteredMovies[indexPath.row].title
        } else {
            cell.posterImage.image = movieWithImage[movies[indexPath.row]]
            cell.title.text = movies[indexPath.row].title
        }
        
        return cell
    }
    
    /**
     Function to abjuct searchBar position to be just over the keyboard
     */
    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            var bottomPadding: CGFloat = 0
            
            if #available(iOS 11.0, *) {
                let window = UIApplication.shared.keyWindow
                bottomPadding = (window?.safeAreaInsets.bottom)!
            }
            var frame = self.searchBar.frame
            frame.origin.y -= keyboardHeight - bottomPadding
            
            self.searchBar.frame = frame
        }
    }
    
    /**
     Function to abjuct searchBar position to be on bottom of the view
     */
    @objc func keyboardWillHide(_ notification: Notification) {
        searchBar.frame.origin.y = self.view.frame.height - searchBar.frame.height
        var bottomPadding: CGFloat = 0
        
        if #available(iOS 11.0, *) {
            let window = UIApplication.shared.keyWindow
            bottomPadding = (window?.safeAreaInsets.bottom)!
        }
        searchBar.frame.origin.y = self.view.frame.height - searchBar.frame.height - bottomPadding
    }
    
    /**
     Function to hide keyboard after scrolling
     */
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        searchBar.endEditing(true)
    }
    
    
    /**
     Function to prepare next view for segue
     It sets id and image of selected movie to destination controller
     */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "toDetail") {
            let detailedMovieController = segue.destination as! MovieDetailedViewController
            searchBar.endEditing(true)
            if searching {
                detailedMovieController.id = filteredMovies[(tableView.indexPathForSelectedRow?.row)!].id
                detailedMovieController.image = movieWithImage[filteredMovies[(tableView.indexPathForSelectedRow?.row)!]] ?? UIImage()
            } else {
                detailedMovieController.id = movies[(tableView.indexPathForSelectedRow?.row)!].id
                detailedMovieController.image = movieWithImage[movies[(tableView.indexPathForSelectedRow?.row)!]] ?? UIImage()
            }
        }
    }
    
    /**
     Function to filter movies after text change in search bar
     If searchbar is empty all movies are showed
     */
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
    
    /**
     Function to hide keyboard after clicking to search button
     */
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
}
