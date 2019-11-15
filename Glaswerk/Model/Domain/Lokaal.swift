//
//  Lokaal.swift
//  Glaswerk
//
//  Created by Bram Goedvriend on 15/11/2019.
//  Copyright © 2019 Bram Goedvriend. All rights reserved.
//

import Foundation

struct LokaalData: Codable {
    let rooms: [Lokaal]
}

struct Lokaal: Codable {
    let lokaalid: Int
    let naam: String
}
