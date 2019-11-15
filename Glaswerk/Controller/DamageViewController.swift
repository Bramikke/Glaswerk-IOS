//
//  FirstViewController.swift
//  Glaswerk
//
//  Created by Bram Goedvriend on 10/11/2019.
//  Copyright © 2019 Bram Goedvriend. All rights reserved.
//

import UIKit

class DamageViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lokaalButton: UIButton!
    @IBOutlet weak var klasButton: UIButton!

    let defaults = UserDefaults.standard
    
    var items : [Item] = []
    var lokalen: [Lokaal] = []
    var klassen: [Klas] = []
    var indexPath: IndexPath?
    
    let lokaalRepository = LokaalRepository()
    let klasRepository = KlasRepository()
    let itemRepository = ItemRepository()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        lokaalRepository.getLokalen()
        klasRepository.getKlassen()
        updateItems()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        defaults.register(defaults: [K.defaultKeys.klasid : 1, K.defaultKeys.lokaalid : 1])
        lokaalRepository.delegate = self
        klasRepository.delegate = self
        itemRepository.delegate = self
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: K.damage.cellNibName, bundle: nil), forCellReuseIdentifier: K.damage.cellIdentifier)
    }
    
    func updateLokaal() {
        let lokaalid = self.defaults.integer(forKey: K.defaultKeys.lokaalid)
        DispatchQueue.main.async {
            if let lokaal = self.lokalen.first(where: { $0.lokaalid == lokaalid }) {
                self.lokaalButton.setTitle(K.lokaal + lokaal.naam , for: .normal)
                self.lokaalButton.sizeToFit()
            }
        }
    }
    
    func updateKlas() {
        let klasid = self.defaults.integer(forKey: K.defaultKeys.klasid)
        DispatchQueue.main.async {
            if let klas = self.klassen.first(where: {$0.klasid == klasid}) {
                self.klasButton.setTitle(K.klas + klas.naam, for: .normal)
                self.klasButton.sizeToFit()
            }
        }
    }
    
    func updateItems() {
        let lokaalid = defaults.integer(forKey: K.defaultKeys.lokaalid)
        itemRepository.getItems(roomId: lokaalid)
    }
    
    @IBAction func lokaalClick(_ sender: UIButton) {
        let alert = UIAlertController(title: "Selecteer lokaal", message: nil, preferredStyle: .actionSheet)
        for lokaal in lokalen {
            alert.addAction(UIAlertAction(title: lokaal.naam, style: .default, handler: { _ in
                self.defaults.set(lokaal.lokaalid, forKey: K.defaultKeys.lokaalid)
                self.updateLokaal()
                self.updateItems()
            }))
        }
        alert.addAction(UIAlertAction(title: "Annuleer", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func klasClick(_ sender: UIButton) {
        let alert = UIAlertController(title: "Selecteer klas", message: nil, preferredStyle: .actionSheet)
        for klas in klassen {
            alert.addAction(UIAlertAction(title: klas.naam, style: .default, handler: { _ in
                self.defaults.set(klas.klasid, forKey: K.defaultKeys.klasid)
                self.updateKlas()
            }))
        }
        alert.addAction(UIAlertAction(title: "Annuleer", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! DamageLeerlingViewController
        vc.item = items[indexPath!.row]
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let indexPathSave = indexPath {
            self.tableView.deselectRow(at: indexPathSave, animated: true)
        }
    }
}

//MARK: -
extension DamageViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = items[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: K.damage.cellIdentifier, for: indexPath) as! ItemCell
        cell.layer.cornerRadius = 8
        cell.layer.masksToBounds = true
        cell.titleLabel.text = item.naam
        cell.amountLabel.text = String(item.aantal)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.indexPath = indexPath
        self.performSegue(withIdentifier: K.damage.cellToLeerling, sender: self)
    }
}

//MARK: -
extension DamageViewController: ItemRepositoryDelegate, LokaalRepositoryDelegate, KlasRepositoryDelegate {
    func didUpdate(_ lokaalRepository: LokaalRepository, lokalen: [Lokaal]) {
        self.lokalen = lokalen
        self.updateLokaal()
    }
    
    func didUpdate(_ klasRepository: KlasRepository, klassen: [Klas]) {
        self.klassen = klassen
        self.updateKlas()
    }
    
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
