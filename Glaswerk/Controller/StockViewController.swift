//
//  StockViewController.swift
//  Glaswerk
//
//  Created by Bram Goedvriend on 10/11/2019.
//  Copyright © 2019 Bram Goedvriend. All rights reserved.
//

import UIKit
import JJFloatingActionButton

class StockViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lokaalButton: UIButton!
    
    let defaults = UserDefaults.standard
    var items : [Item] = []
    var lokalen: [Lokaal] = []
    var indexPath: IndexPath?
    
    let lokaalRepository = LokaalRepository()
    let itemRepository = ItemRepository()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        lokaalRepository.getLokalen()
        updateItems()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addFAB()
        lokaalRepository.delegate = self
        itemRepository.delegate = self
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: K.cellNibName, bundle: nil), forCellReuseIdentifier: K.cellIdentifier)
        
    }
    
    func addFAB() {
        let actionButton = JJFloatingActionButton()
        actionButton.addItem(title: K.stock.addItem, image: UIImage(systemName: "plus")?.withRenderingMode(.alwaysTemplate)) { item in
            self.indexPath = nil
            self.performSegue(withIdentifier: K.stock.cellToDetail, sender: self)
        }
        
        actionButton.addItem(title: K.stock.addLokaal, image: UIImage(systemName: "square.and.arrow.down.fill")?.withRenderingMode(.alwaysTemplate)) { item in
            let alertController = UIAlertController(title: K.stock.addLokaal, message: nil, preferredStyle: .alert)
            let confirmAction = UIAlertAction(title: K.add, style: .default) { _ in
                if let txtField = alertController.textFields?.first, let text = txtField.text {
                    if text != "" {
                        self.lokaalRepository.addLokaal(lokaal: Lokaal(lokaalid: nil, naam: text))
                    } else {
                        self.view.makeToast(K.error.name)
                    }
                }
            }
            let cancelAction = UIAlertAction(title: K.cancel, style: .cancel) { _ in }
            alertController.addTextField { (textField) in
                textField.placeholder = K.stock.lokaalName
            }
            alertController.addAction(confirmAction)
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true, completion: nil)
        }
        
        actionButton.addItem(title: K.stock.removeLokaal, image: UIImage(systemName: "trash.fill")?.withRenderingMode(.alwaysTemplate)) { item in
            //message new lines to better show UIPickerView
            let alert = UIAlertController(title: K.stock.removeLokaal, message: "\n\n\n\n\n\n\n\n\n", preferredStyle: .alert)
            let pickerView = UIPickerView(frame: CGRect(x: 0, y: 50, width: 260, height: 162))
            pickerView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.2)
            pickerView.dataSource = self
            pickerView.delegate = self
            alert.view.addSubview(pickerView)
            let confirmAction = UIAlertAction(title: K.remove, style: .destructive) { _ in
                self.lokaalRepository.removeLokaal(lokaal: self.lokalen[pickerView.selectedRow(inComponent: 0)])
            }
            let cancelAction = UIAlertAction(title: K.cancel, style: .cancel) { _ in }
            alert.addAction(confirmAction)
            alert.addAction(cancelAction)
            self.present(alert, animated: true) {
                pickerView.frame.size.width = alert.view.frame.size.width
            }
        }
        view.addSubview(actionButton)
        actionButton.translatesAutoresizingMaskIntoConstraints = false
        actionButton.buttonDiameter = 45
        
        actionButton.buttonColor = UIColor(named: K.blueTint)!
        // anchors to place button in right bottom corner
        actionButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16).isActive = true
        actionButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16).isActive = true
    }
    
    func updateLokaal() {
        let lokaalid = self.defaults.integer(forKey: K.defaultKeys.lokaalid)
        DispatchQueue.main.async {
            if let lokaal = self.lokalen.first(where: {$0.lokaalid == lokaalid}) {
                self.lokaalButton.setTitle(K.lokaal + lokaal.naam, for: .normal)
                self.lokaalButton.sizeToFit()
            }
        }
    }
    
    func updateItems() {
        let lokaalid = defaults.integer(forKey: K.defaultKeys.lokaalid)
        itemRepository.getItems(roomId: lokaalid)
    }
    
    @IBAction func lokaalClick(_ sender: UIButton) {
        let alert = UIAlertController(title: K.selectLokaal, message: nil, preferredStyle: .actionSheet)
        for lokaal in lokalen {
            alert.addAction(UIAlertAction(title: lokaal.naam, style: .default, handler: { _ in
                self.defaults.set(lokaal.lokaalid, forKey: K.defaultKeys.lokaalid)
                self.updateLokaal()
                self.updateItems()
            }))
        }
        alert.addAction(UIAlertAction(title: K.cancel, style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! StockDetailViewController
        if let ip = indexPath {
            vc.item = items[ip.row]
        }
        vc.lokalen = lokalen
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let indexPathSave = indexPath {
            self.tableView.deselectRow(at: indexPathSave, animated: true)
        }
    }
}

//MARK: - TableView
extension StockViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = items[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier, for: indexPath) as! ItemCell
        cell.titleLabel.text = item.naam
        cell.amountLabel.text = String(item.aantal)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.indexPath = indexPath
        self.performSegue(withIdentifier: K.stock.cellToDetail, sender: self)
    }
}

//MARK: - Repositories
extension StockViewController: ItemRepositoryDelegate, LokaalRepositoryDelegate {
    func didUpdate(_ itemRepository: ItemRepository, items: [Item]?) {
        DispatchQueue.main.async {
            self.items = items!
            self.tableView.reloadData()
        }
    }
    
    func didUpdate(_ lokaalRepository: LokaalRepository, lokalen: [Lokaal]?) {
        if let lokalenSave = lokalen {
            self.lokalen = lokalenSave
            self.updateLokaal()
        } else {
            lokaalRepository.getLokalen()
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
}

//MARK: - PickerView
extension StockViewController: UIPickerViewDataSource ,UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return lokalen.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return lokalen[row].naam
    }
}
