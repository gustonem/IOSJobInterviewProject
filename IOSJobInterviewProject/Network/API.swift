//
//  API.swift
//  IOSJobInterviewProject
//
//  Created by Augustin Nemec on 16/04/2019.
//  Copyright © 2019 Augustin Nemec. All rights reserved.
//

import Foundation
import Alamofire

class API {
    
    static var apiKey = "f00b506655eee67a4d78a7b9c60bfb40"
    
    static func getPopularMovies(completion: @escaping (Result<movieResults, Error>) -> Void) {
        let jsonDecoder = JSONDecoder()
        AF.request("https://api.themoviedb.org/3/movie/popular?api_key=" + apiKey )
            .responseDecodable (decoder: jsonDecoder){ (response: DataResponse<movieResults>) in
                completion(response.result)
        }
    }
    
    static func getDetailedMovie(id: Int, completion: @escaping (Result<Movie, Error>) -> Void) {
        let jsonDecoder = JSONDecoder()
        AF.request("https://api.themoviedb.org/3/movie/" + String(id) + "?api_key=" + apiKey )
            .responseDecodable (decoder: jsonDecoder){ (response: DataResponse<Movie>) in
                completion(response.result)
        }
    }
    
    static func getVideosForMovie(id: Int, completion: @escaping (Result<videoResults, Error>) -> Void) {
        let jsonDecoder = JSONDecoder()
        AF.request("https://api.themoviedb.org/3/movie/" + String(id) + "/videos?api_key=" + apiKey )
            .responseDecodable (decoder: jsonDecoder){ (response: DataResponse<videoResults>) in
                completion(response.result)
        }
    }
    
    
    static func getImage(urlString: String, completion: @escaping (Result<Data, Error>) -> Void) {
        AF.download(urlString).responseData { response in
            completion(response.result)
        }
    }
}
