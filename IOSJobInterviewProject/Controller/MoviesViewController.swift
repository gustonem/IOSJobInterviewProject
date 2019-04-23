//
//  ViewController.swift
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
        
        populateTable()
    }
    
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
    
    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            
            var frame = self.searchBar.frame
            frame.origin.y -= keyboardHeight
            
            print(frame.origin.y)
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
