//
//  LokaalRepository.swift
//  Glaswerk
//
//  Created by Bram Goedvriend on 15/11/2019.
//  Copyright © 2019 Bram Goedvriend. All rights reserved.
//

import Foundation
import RestEssentials

protocol LokaalRepositoryDelegate {
    func didUpdate(_ lokaalRepository: LokaalRepository, lokalen: [Lokaal])
    func didFailWithError(error: Error)
}

class LokaalRepository: GlaswerkManager {
    var delegate: LokaalRepositoryDelegate?
    
    func getLokalen() {
        let url = "\(URL)lokaal"
        guard let rest = RestController.make(urlString: url) else {
            self.delegate?.didFailWithError(error: BadURLError.runtimeError("Bad URL"))
            return
        }
        rest.get(LokaalData.self) { result, httpResponse in
            do {
                let response = try result.value()
                self.delegate?.didUpdate(self, lokalen: response.rooms)
            } catch {
                self.delegate?.didFailWithError(error: error)
            }
        }
    }
}
