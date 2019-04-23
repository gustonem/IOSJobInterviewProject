//
//  Results.swift
//  IOSJobInterviewProject
//
//  Created by Augustin Nemec on 17/04/2019.
//  Copyright © 2019 Augustin Nemec. All rights reserved.
//

import Foundation

struct movieResults: Decodable {
    let results: [Movie]
}

struct videoResults: Decodable {
    let results: [Video]
}
