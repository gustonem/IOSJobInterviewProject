//
//  MoviesViewController.swift
//  IOSJobInterviewProject
//
//  Created by Augustin Nemec on 17/04/2019.
//  Copyright © 2019 Augustin Nemec. All rights reserved.
//

import UIKit

class MoviesViewController: UITableViewController {

    var movies: [Movie] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        
        API.getPopularMovies{ result in
            switch result {
            case .success(let movies):
                self.movies = movies.results
                self.tableView.reloadData()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 0
//    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "movieCell", for: indexPath) as? MovieViewCell  else {
            fatalError("The dequeued cell is not an instance of MealTableViewCell.")
        }
        
//        let url = URL(string: "https://image.tmdb.org/t/p/w500" + movies[indexPath.row].backdrop_path)
        
//        DispatchQueue.global().async {
//            URLSession.shared.dataTask(with: url!) { data, response, error in
//                guard let data = data else { return }
//                DispatchQueue.main.async {
//                    cell.posterImage.image = UIImage(data: data)
//                }
//                }.resume()
//
//        }
        
        cell.posterImage.imageFromURL(urlString: "https://image.tmdb.org/t/p/w500" + movies[indexPath.row].backdrop_path)
        
        cell.title.text = movies[indexPath.row].title
        return cell
    }
    
//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let storyBoard = UIStoryboard(name: <#T##String#>, bundle: <#T##Bundle?#>)
//    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let detailedMovieController = segue.destination as! MovieDetailedViewController
        detailedMovieController.id = movies[(tableView.indexPathForSelectedRow?.row)!].id
        
    }
    
//    func getImageForMovie(imagePath: String) -> UIImage {
//
//        var image: UIImage
//        let url = URL(string: "https://image.tmdb.org/t/p/w500" + imagePath)
//        DispatchQueue.global().async {
//            URLSession.shared.dataTask(with: url!) { data, response, error in
//                guard let data = data else { return }
//                DispatchQueue.main.async {
//                    image = UIImage(data: data)!
//                }
//                }.resume()
//        }
//        return image
//    }


    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

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
