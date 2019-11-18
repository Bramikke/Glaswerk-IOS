//
//  Constants.swift
//  Glaswerk
//
//  Created by Bram Goedvriend on 13/11/2019.
//  Copyright © 2019 Bram Goedvriend. All rights reserved.
//

import Foundation

struct K {
    
    static let lokaal = "Lokaal: "
    static let klas = "Klas: "
    
    struct defaultKeys {
        static let klasid = "klasid"
        static let lokaalid = "lokaalid"
    }
    
    struct damage {
        static let cellIdentifier = "itemCell"
        static let cellNibName = "ItemCell"
        static let cellToLeerling = "CellToLeerling"
    }
    
    struct order {
        static let cellIdentifier = "orderCell"
        static let cellNibName = "OrderCell"
    }
    
    struct stock {
        static let cellToDetail = "ItemToDetail"
    }
    
    struct leerling {
        static let cellToDetail = "StudentToDetail"
    }
}
