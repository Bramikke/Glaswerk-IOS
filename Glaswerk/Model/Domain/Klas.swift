//
//  Klas.swift
//  Glaswerk
//
//  Created by Bram Goedvriend on 15/11/2019.
//  Copyright © 2019 Bram Goedvriend. All rights reserved.
//

import Foundation

struct KlasData: Codable {
    let classes: [Klas]
}

struct Klas: Codable {
    let klasid: Int
    let naam: String
}
