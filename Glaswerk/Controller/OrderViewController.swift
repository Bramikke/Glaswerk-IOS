//
//  SecondViewController.swift
//  Glaswerk
//
//  Created by Bram Goedvriend on 10/11/2019.
//  Copyright © 2019 Bram Goedvriend. All rights reserved.
//

import UIKit

class OrderViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var items : [Item] = []
    
    let itemRepository = ItemRepository()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateItems()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        itemRepository.delegate = self
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: K.order.cellNibName, bundle: nil), forCellReuseIdentifier: K.order.cellIdentifier)
    }

    func updateItems() {
        itemRepository.getItemOrders()
    }

}

extension OrderViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = items[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: K.order.cellIdentifier, for: indexPath) as! OrderCell
        cell.titleLabel.text = item.naam
        cell.aantalLabel.text = String(item.aantal)
        cell.maxLabel.text = String(item.max_aantal)
        cell.minLabel.text = String(item.min_aantal)
        let aantalBestellen = (item.max_aantal - item.aantal) / item.bestel_hoeveelheid
        cell.bestelLabel.text = String("\(aantalBestellen) x \(item.bestel_hoeveelheid)")
        cell.lokaalLabel.text = item.lokaal_naam
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = items[indexPath.row]
        let alertController = UIAlertController(title: "Aantal besteld", message: nil, preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "Toevoegen", style: .default) { (_) in
            if let txtField = alertController.textFields?.first, let text = txtField.text {
                self.itemRepository.addOrder(itemid: item.itemid, aantal: Int(text)!)
                tableView.deselectRow(at: indexPath, animated: true)
            }
        }
        let cancelAction = UIAlertAction(title: "Annuleer", style: .cancel) { (_) in
            tableView.deselectRow(at: indexPath, animated: true)
        }
        alertController.addTextField { (textField) in
            textField.keyboardType = .numberPad
            textField.placeholder = "Aantal"
            textField.text = String((item.max_aantal - item.aantal) / item.bestel_hoeveelheid * item.bestel_hoeveelheid)
        }
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
        
    }
}

//MARK: -
extension OrderViewController: ItemRepositoryDelegate {
    func didUpdate(_ itemRepository: ItemRepository, items: [Item]?) {
        DispatchQueue.main.async {
            self.items = items!
            self.tableView.reloadData()
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
}

extension UIAlertController {
    func addNumberField() {
        
    }
}
