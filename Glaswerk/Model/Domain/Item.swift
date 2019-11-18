//
//  Item.swift
//  Glaswerk
//
//  Created by Bram Goedvriend on 13/11/2019.
//  Copyright © 2019 Bram Goedvriend. All rights reserved.
//

import Foundation

struct ItemData: Codable {
    let items: [Item]
}

struct Item: Codable {
    let itemid: Int?
    let lokaal_id: Int
    let naam: String
    let aantal: Int
    let min_aantal: Int
    let max_aantal: Int
    let bestel_hoeveelheid: Int
    let lokaalid: Int?
    let lokaal_naam: String?
}
