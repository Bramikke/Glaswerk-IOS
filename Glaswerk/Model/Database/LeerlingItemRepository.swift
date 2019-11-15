//
//  LeerlingItemRepository.swift
//  Glaswerk
//
//  Created by Bram Goedvriend on 15/11/2019.
//  Copyright © 2019 Bram Goedvriend. All rights reserved.
//

import Foundation
import RestEssentials

protocol LeerlingItemRepositoryDelegate {
    func didUpdate(_ leerlingItemRepository: LeerlingItemRepository)
    func didFailWithError(error: Error)
}

struct HttpResponse: Codable {
    let fieldCount: Int
    let affectedRows: Int
    let insertId: Int
    let info: String
    let serverStatus: Int
    let warningStatus: Int
}

class LeerlingItemRepository: GlaswerkManager {
    var delegate: LeerlingItemRepositoryDelegate?
    
    func addLeerlingItem(leerlingItem: LeerlingItem) {
        let url = "\(URL)"
        guard let rest = RestController.make(urlString: url) else {
            self.delegate?.didFailWithError(error: BadURLError.runtimeError("Bad URL"))
            return
        }
        rest.post(leerlingItem, at: "studentItemBroken", responseType: HttpResponse.self){ result, httpResponse in }
    }
}
