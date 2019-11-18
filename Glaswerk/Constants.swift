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
    static let cellIdentifier = "itemCell"
    static let cellNibName = "ItemCell"
    static let blueTint = "BlueTint"
    static let selectLokaal = "Selecteer lokaal"
    static let selectKlas = "Selecteer klas"
    static let add = "Toevoegen"
    static let cancel = "Annuleer"
    static let remove = "Verwijder"
    
    struct defaultKeys {
        static let klasid = "klasid"
        static let lokaalid = "lokaalid"
    }
    
    struct damage {
        static let cellToLeerling = "CellToLeerling"
        static let reason = "Reden"
        static let onPurpose = "Opzettelijk"
        static let notOnPurpose = "Niet-opzettelijk"
    }
    
    struct order {
        static let cellIdentifier = "orderCell"
        static let cellNibName = "OrderCell"
        static let amount = "Aantal"
        static let orderAmount = "Aantal besteld"
    }
    
    struct stock {
        static let cellToDetail = "ItemToDetail"
        static let addItem = "Voeg item toe"
        static let addLokaal = "Voeg lokaal toe"
        static let lokaalName = "Lokaal naam"
        static let removeLokaal = "\(K.remove) lokaal"
    }
    
    struct leerling {
        static let cellToDetail = "StudentToDetail"
        static let addLeerling = "Voeg leerling toe"
        static let addKlas = "Voeg klas toe"
        static let klasName = "Klas naam"
        static let removeKlas = "\(K.remove) klas"
    }
    
    struct detailView {
        static let remove = "\(K.remove) ?"
        static let areUSureThat = "Weet je zeker dat je "
        static let wantToRemove = " wilt verwijderen?"
    }
    
    struct error {
        static let name = "Gelieve een naam in te geven"
        static let fields = "Gelieve alle velden in te vullen"
    }
}
