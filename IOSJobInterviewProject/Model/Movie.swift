//
//  File.swift
//  IOSJobInterviewProject
//
//  Created by Augustin Nemec on 16/04/2019.
//  Copyright © 2019 Augustin Nemec. All rights reserved.
//

import Foundation

struct Movie: Decodable, Hashable {
    
    let id: Int!
    let title: String
    let poster_path: String
    let backdrop_path: String
    let genres: [Genre]?
    let release_date: String?
    let overview: String?
    
    static func == (lhs: Movie, rhs: Movie) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
