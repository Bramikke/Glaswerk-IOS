//
//  KlasRepository.swift
//  Glaswerk
//
//  Created by Bram Goedvriend on 15/11/2019.
//  Copyright © 2019 Bram Goedvriend. All rights reserved.
//

import Foundation
import RestEssentials

protocol KlasRepositoryDelegate {
    func didUpdate(_ klasRepository: KlasRepository, klassen: [Klas])
    func didFailWithError(error: Error)
}

class KlasRepository: GlaswerkManager {
    var delegate: KlasRepositoryDelegate?
    
    func getKlassen() {
        let url = "\(URL)klas"
        guard let rest = RestController.make(urlString: url) else {
            self.delegate?.didFailWithError(error: BadURLError.runtimeError("Bad URL"))
            return
        }
        rest.get(KlasData.self) { result, httpResponse in
            do {
                let response = try result.value()
                self.delegate?.didUpdate(self, klassen: response.classes)
            } catch {
                self.delegate?.didFailWithError(error: error)
            }
        }
    }
}
