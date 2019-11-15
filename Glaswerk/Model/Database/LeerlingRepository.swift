//
//  LeerlingRepository.swift
//  Glaswerk
//
//  Created by Bram Goedvriend on 15/11/2019.
//  Copyright © 2019 Bram Goedvriend. All rights reserved.
//

import Foundation
import RestEssentials

protocol LeerlingRepositoryDelegate {
    func didUpdate(_ leerlingRepository: LeerlingRepository, leerlingen: [Leerling])
    func didFailWithError(error: Error)
}

class LeerlingRepository: GlaswerkManager {
    var delegate: LeerlingRepositoryDelegate?
    
    func getLeerlingen(classId: Int, itemId: Int) {
        let url = "\(URL)studentByClassByItem?itemid=\(itemId)&klasid=\(classId)"
        guard let rest = RestController.make(urlString: url) else {
            self.delegate?.didFailWithError(error: BadURLError.runtimeError("Bad URL"))
            return
        }
        rest.get(LeerlingData.self) { result, httpResponse in
            do {
                let response = try result.value()
                self.delegate?.didUpdate(self, leerlingen: response.students)
            } catch {
                self.delegate?.didFailWithError(error: error)
            }
        }
    }
}
