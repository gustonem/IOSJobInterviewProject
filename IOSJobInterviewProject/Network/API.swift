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
    
    static func getPopularMovies(completion: @escaping (Result<Results, Error>) -> Void) {
        let jsonDecoder = JSONDecoder()
        AF.request("https://api.themoviedb.org/3/movie/popular?api_key=" + apiKey )
            .responseDecodable (decoder: jsonDecoder){ (response: DataResponse<Results>) in
                completion(response.result)
        }
    }
}
