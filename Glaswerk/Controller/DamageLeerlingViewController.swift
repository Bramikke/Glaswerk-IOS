//
//  DamageLeerlingViewController.swift
//  Glaswerk
//
//  Created by Bram Goedvriend on 15/11/2019.
//  Copyright © 2019 Bram Goedvriend. All rights reserved.
//

import UIKit

class DamageLeerlingViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var klasButton: UIButton!
    
    let defaults = UserDefaults.standard
    let klasRepository = KlasRepository()
    let leerlingRepository = LeerlingRepository()
    let leerlingItemRepository = LeerlingItemRepository()
    let itemRepository = ItemRepository()
    var item: Item?
    var klassen: [Klas] = []
    var leerlingen: [Leerling] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        defaults.register(defaults: [K.defaultKeys.klasid : 1, K.defaultKeys.lokaalid : 1])
        klasRepository.delegate = self
        leerlingRepository.delegate = self
        leerlingItemRepository.delegate = self
        itemRepository.delegate = self
        klasRepository.getKlassen()
        updateLeerlingen()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: K.damage.cellNibName, bundle: nil), forCellReuseIdentifier: K.damage.cellIdentifier)
    }
    
    func updateKlas() {
        let klasid = self.defaults.integer(forKey: K.defaultKeys.klasid)
        DispatchQueue.main.async {
            if let klas = self.klassen.first(where: {$0.klasid == klasid}) {
                //self.klasButton.title = K.klas + klas.naam
                self.klasButton.setTitle(K.klas + klas.naam, for: .normal)
                self.klasButton.sizeToFit()
            }
        }
    }
    
    func updateLeerlingen() {
        let klasid = defaults.integer(forKey: K.defaultKeys.klasid)
        leerlingRepository.getLeerlingen(classId: klasid, itemId: item!.itemid!)
    }

    @IBAction func klasClick(_ sender: UIButton) {
        let alert = UIAlertController(title: "Selecteer klas", message: nil, preferredStyle: .actionSheet)
        for klas in klassen {
            alert.addAction(UIAlertAction(title: klas.naam, style: .default, handler: { _ in
                self.defaults.set(klas.klasid, forKey: K.defaultKeys.klasid)
                self.updateKlas()
                self.updateLeerlingen()
            }))
        }
        alert.addAction(UIAlertAction(title: "Annuleer", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

//MARK: -
extension DamageLeerlingViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return leerlingen.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let leerling = leerlingen[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: K.damage.cellIdentifier, for: indexPath) as! ItemCell
        cell.personImage.isHidden = false
        cell.titleLabel.text = "\(leerling.voornaam) \(leerling.achternaam)"
        cell.amountLabel.text = String(leerling.aantalGebroken!)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let alert = UIAlertController(title: "Reden", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Opzettelijk", style: .default, handler: { (_) in
            self.alertDone(leerling: self.leerlingen[indexPath.row], opzettelijk: true)
        }))
        alert.addAction(UIAlertAction(title: "Niet-opzettelijk", style: .default, handler: { (_) in
            self.alertDone(leerling: self.leerlingen[indexPath.row], opzettelijk: false)
        }))
        alert.addAction(UIAlertAction(title: "Annuleer", style: .cancel, handler: { _ in }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func alertDone(leerling: Leerling, opzettelijk: Bool) {
        let leerlingItem = LeerlingItem(leerlingid: leerling.leerlingid!, itemid: item!.itemid!, opzettelijk: (opzettelijk) ? 1 : 0)
        leerlingItemRepository.addLeerlingItem(leerlingItem: leerlingItem)
        itemRepository.reduceItem(itemid: item!.itemid!)
        navigationController?.popToRootViewController(animated: true)
    }
}

//MARK: -
extension DamageLeerlingViewController: LeerlingRepositoryDelegate, KlasRepositoryDelegate, LeerlingItemRepositoryDelegate, ItemRepositoryDelegate {
    func didUpdate(_ itemRepository: ItemRepository, items: [Item]?) {
        print("updated item")
    }
    
    func didUpdate(_ klasRepository: KlasRepository, klassen: [Klas]?) {
        self.klassen = klassen!
        self.updateKlas()
    }
    
    func didUpdate(_ leerlingRepository: LeerlingRepository, leerlingen: [Leerling]) {
        DispatchQueue.main.async {
            self.leerlingen = leerlingen
            self.tableView.reloadData()
        }
    }
    
    func didUpdate(_ leerlingItemRepository: LeerlingItemRepository) {
        print("updated leerlingItem")
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
}
