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
    func didUpdate(_ lokaalRepository: LokaalRepository, lokalen: [Lokaal]?)
    func didFailWithError(error: Error)
}

class LokaalRepository: GlaswerkManager {
    var delegate: LokaalRepositoryDelegate?
    
    func restRequestGet(_ url: String) {
        guard let rest = RestController.make(urlString: url) else {
            self.delegate?.didFailWithError(error: BadURLError.runtimeError("Bad URL"))
            return
        }
        rest.get(LokaalData.self) { result, httpResponse in
            do {
                let response = try result.value()
                self.delegate?.didUpdate(self, lokalen: response.rooms.sorted(by: {$0.naam < $1.naam}))
            } catch {
                self.delegate?.didFailWithError(error: error)
            }
        }
    }
    
    func restRequestPost(_ url: String, lokaal: Lokaal) {
        guard let rest = RestController.make(urlString: url) else {
            self.delegate?.didFailWithError(error: BadURLError.runtimeError("Bad URL"))
            return
        }
        rest.post(lokaal, at: "", responseType: HttpResponse.self){ result, httpResponse in
            self.delegate?.didUpdate(self, lokalen: nil)
        }
    }
    
    func getLokalen() {
        let url = "\(URL)lokaal"
        restRequestGet(url)
    }
    
    func addLokaal(lokaal: Lokaal) {
        let url = "\(URL)addLokaal"
        restRequestPost(url, lokaal: lokaal)
    }
    
    func removeLokaal(lokaal: Lokaal) {
        let url = "\(URL)deleteLokaal"
        restRequestPost(url, lokaal: lokaal)
    }
}
