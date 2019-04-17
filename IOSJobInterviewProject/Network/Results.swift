//
//  Result.swift
//  IOSJobInterviewProject
//
//  Created by Augustin Nemec on 17/04/2019.
//  Copyright © 2019 Augustin Nemec. All rights reserved.
//

import Foundation

struct Results: Decodable {
    let page: Int
    let results: [Movie]
}
