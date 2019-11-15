//
//  Leerling.swift
//  Glaswerk
//
//  Created by Bram Goedvriend on 15/11/2019.
//  Copyright © 2019 Bram Goedvriend. All rights reserved.
//

import Foundation

struct LeerlingData: Codable {
    let students: [Leerling]
}

struct Leerling: Codable {
    let leerlingid: Int
    let klasid: Int
    let voornaam: String
    let achternaam: String
    let aantalGebroken: Int?
}
