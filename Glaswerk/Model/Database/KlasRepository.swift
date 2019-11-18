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
    func didUpdate(_ klasRepository: KlasRepository, klassen: [Klas]?)
    func didFailWithError(error: Error)
}

class KlasRepository: GlaswerkManager {
    var delegate: KlasRepositoryDelegate?
    
    func restRequestGet(_ url: String) {
        guard let rest = RestController.make(urlString: url) else {
            self.delegate?.didFailWithError(error: BadURLError.runtimeError("Bad URL"))
            return
        }
        rest.get(KlasData.self) { result, httpResponse in
            do {
                let response = try result.value()
                self.delegate?.didUpdate(self, klassen: response.classes.sorted(by: {$0.naam < $1.naam}))
            } catch {
                self.delegate?.didFailWithError(error: error)
            }
        }
    }
    
    func restRequestPost(_ url: String, klas: Klas) {
        guard let rest = RestController.make(urlString: url) else {
            self.delegate?.didFailWithError(error: BadURLError.runtimeError("Bad URL"))
            return
        }
        rest.post(klas, at: "", responseType: HttpResponse.self){ result, httpResponse in
            self.delegate?.didUpdate(self, klassen: nil)
        }
    }
    
    func getKlassen() {
        let url = "\(URL)klas"
        restRequestGet(url)
    }
    
    func addKlas(klas: Klas) {
        let url = "\(URL)addKlas"
        restRequestPost(url, klas: klas)
    }
    
    func removeKlas(klas: Klas) {
        let url = "\(URL)deleteKlas"
        restRequestPost(url, klas: klas)
    }
}
