//
//  IOSJobInterviewProjectTests.swift
//  IOSJobInterviewProjectTests
//
//  Created by Augustin Nemec on 16/04/2019.
//  Copyright © 2019 Augustin Nemec. All rights reserved.
//

import XCTest
@testable import IOSJobInterviewProject

class IOSJobInterviewProjectTests: XCTestCase {
    
    var moviesController: MoviesViewController!
    
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        moviesController = (storyboard.instantiateViewController(withIdentifier: "moviesController") as! MoviesViewController)
        
        _ = moviesController.view
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testCanBeInstantiated() {
        
        XCTAssertNotNil(moviesController)
    }
    
    func testHasSearchBar() {
        
        XCTAssertNotNil(moviesController.searchBar)
    }
    
    func testCanFilterMoviesAfterSearchTextChanges() {
        
        // sample of searchable items (instead of fetching asynchronously from network)
        
        let movie1 = Movie(id: 1, title: "Avengers 1", poster_path: "", backdrop_path: "", genres: nil, release_date: nil, overview: nil)
        let movie2 = Movie(id: 2, title: "Avengers 2", poster_path: "", backdrop_path: "", genres: nil, release_date: nil, overview: nil)
        let movie3 = Movie(id: 3, title: "Captain Marvel", poster_path: "", backdrop_path: "", genres: nil, release_date: nil, overview: nil)
        let movie4 = Movie(id: 4, title: "Dumbo", poster_path: "", backdrop_path: "", genres: nil, release_date: nil, overview: nil)
        
        moviesController.movies = [movie1, movie2, movie3, movie4]
        
        XCTAssertEqual(moviesController.movies.count, 4)
        XCTAssertEqual(moviesController.filteredMovies.count, 0)
        
        moviesController.searchBar.text = "a"
        moviesController.searchBar(moviesController.searchBar, textDidChange: "a")
        XCTAssertEqual(moviesController.filteredMovies.count, 3)
        
        moviesController.searchBar.text = "avengers"
        moviesController.searchBar(moviesController.searchBar, textDidChange: "avengers")
        
        XCTAssertEqual(moviesController.filteredMovies.count, 2)
        XCTAssertEqual(moviesController.filteredMovies[0], movie1)
        XCTAssertEqual(moviesController.filteredMovies[1], movie2)
    }
}
