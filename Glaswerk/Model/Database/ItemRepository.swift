//
//  ItemRepository.swift
//  Glaswerk
//
//  Created by Bram Goedvriend on 15/11/2019.
//  Copyright © 2019 Bram Goedvriend. All rights reserved.
//

import Foundation
import RestEssentials

protocol ItemRepositoryDelegate {
    func didUpdate(_ itemRepository: ItemRepository, items: [Item]?)
    func didFailWithError(error: Error)
}

class ItemRepository: GlaswerkManager {
    var delegate: ItemRepositoryDelegate?
    
    func getItems(roomId: Int) {
        let url = "\(URL)item?roomid=\(roomId)"
        guard let rest = RestController.make(urlString: url) else {
            self.delegate?.didFailWithError(error: BadURLError.runtimeError("Bad URL"))
            return
        }
        rest.get(ItemData.self) { result, httpResponse in
            do {
                let response = try result.value()
                self.delegate?.didUpdate(self, items: response.items)
            } catch {
                self.delegate?.didFailWithError(error: error)
            }
        }
    }
    
    func getItemOrders() {
        let url = "\(URL)itemOrders"
        guard let rest = RestController.make(urlString: url) else {
            self.delegate?.didFailWithError(error: BadURLError.runtimeError("Bad URL"))
            return
        }
        rest.get(ItemData.self) { result, httpResponse in
            do {
                let response = try result.value()
                self.delegate?.didUpdate(self, items: response.items)
            } catch {
                self.delegate?.didFailWithError(error: error)
            }
        }
    }
    
    func reduceItem(itemid: Int) {
        let url = "\(URL)"
        guard let rest = RestController.make(urlString: url) else {
            self.delegate?.didFailWithError(error: BadURLError.runtimeError("Bad URL"))
            return
        }
        let postData: JSON = ["itemid": itemid]
        rest.post(postData, at: "reduceItem"){ result, httpResponse in }
    }
    
    func addOrder(itemid: Int, aantal: Int) {
        let url = "\(URL)"
        guard let rest = RestController.make(urlString: url) else {
            self.delegate?.didFailWithError(error: BadURLError.runtimeError("Bad URL"))
            return
        }
        let postData: JSON = ["itemid": itemid, "aantal": aantal]
        rest.post(postData, at: "orderItem"){ result, httpResponse in
            self.getItemOrders()
        }
        
    }
}
