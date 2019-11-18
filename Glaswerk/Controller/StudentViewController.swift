//
//  StudentViewController.swift
//  Glaswerk
//
//  Created by Bram Goedvriend on 10/11/2019.
//  Copyright © 2019 Bram Goedvriend. All rights reserved.
//

import UIKit
import JJFloatingActionButton
import Toast_Swift

class StudentViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var klasButton: UIButton!
    
    let defaults = UserDefaults.standard
    var leerlingen : [Leerling] = []
    var klassen: [Klas] = []
    var indexPath: IndexPath?
    
    let klasRepository = KlasRepository()
    let leerlingRepository = LeerlingRepository()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        klasRepository.getKlassen()
        updateLeerlingen()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addFAB()
        klasRepository.delegate = self
        leerlingRepository.delegate = self
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: K.cellNibName, bundle: nil), forCellReuseIdentifier: K.cellIdentifier)
    }
    
    func addFAB() {
        let actionButton = JJFloatingActionButton()
        actionButton.addItem(title: K.leerling.addLeerling, image: UIImage(systemName: "person.fill")?.withRenderingMode(.alwaysTemplate)) { item in
            self.indexPath = nil
            self.performSegue(withIdentifier: K.leerling.cellToDetail, sender: self)
        }
        
        actionButton.addItem(title: K.leerling.addKlas, image: UIImage(systemName: "person.3.fill")?.withRenderingMode(.alwaysTemplate)) { item in
            let alertController = UIAlertController(title: K.leerling.addKlas, message: nil, preferredStyle: .alert)
            let confirmAction = UIAlertAction(title: K.add, style: .default) { _ in
                if let txtField = alertController.textFields?.first, let text = txtField.text {
                    if text != "" {
                        self.klasRepository.addKlas(klas: Klas(klasid: nil, naam: text))
                    } else {
                        self.view.makeToast(K.error.name)
                    }
                }
            }
            let cancelAction = UIAlertAction(title: K.cancel, style: .cancel) { _ in }
            alertController.addTextField { (textField) in
                textField.placeholder = K.leerling.klasName
            }
            alertController.addAction(confirmAction)
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true, completion: nil)
        }
        
        actionButton.addItem(title: K.leerling.removeKlas, image: UIImage(systemName: "trash.fill")?.withRenderingMode(.alwaysTemplate)) { item in
            let alert = UIAlertController(title: K.leerling.removeKlas, message: "\n\n\n\n\n\n\n\n\n", preferredStyle: .alert)
            let pickerView = UIPickerView(frame: CGRect(x: 0, y: 50, width: 260, height: 162))
            pickerView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.2)
            pickerView.dataSource = self
            pickerView.delegate = self
            alert.view.addSubview(pickerView)
            let confirmAction = UIAlertAction(title: K.remove, style: .destructive) { _ in
                self.klasRepository.removeKlas(klas: self.klassen[pickerView.selectedRow(inComponent: 0)])
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
        actionButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16).isActive = true
        actionButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16).isActive = true
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
    
    func updateLeerlingen() {
        let klasid = defaults.integer(forKey: K.defaultKeys.klasid)
        leerlingRepository.getLeerlingen(classId: klasid)
    }
    
    @IBAction func klasClick(_ sender: UIButton) {
        let alert = UIAlertController(title: K.selectKlas, message: nil, preferredStyle: .actionSheet)
        for klas in klassen {
            alert.addAction(UIAlertAction(title: klas.naam, style: .default, handler: { _ in
                self.defaults.set(klas.klasid, forKey: K.defaultKeys.klasid)
                self.updateKlas()
                self.updateLeerlingen()
            }))
        }
        alert.addAction(UIAlertAction(title: K.cancel, style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! StudentDetailViewController
        if let ip = indexPath {
            vc.leerling = leerlingen[ip.row]
        }
        vc.klassen = klassen
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let indexPathSave = indexPath {
            self.tableView.deselectRow(at: indexPathSave, animated: true)
        }
    }
}

//MARK: - TableView
extension StudentViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return leerlingen.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let leerling = leerlingen[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier, for: indexPath) as! ItemCell
        cell.personImage.isHidden = false
        cell.titleLabel.text = "\(leerling.voornaam) \(leerling.achternaam)"
        cell.amountLabel.text = String(leerling.aantalGebroken!)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.indexPath = indexPath
        self.performSegue(withIdentifier: K.leerling.cellToDetail, sender: self)
    }
}

//MARK: - Repositories
extension StudentViewController: LeerlingRepositoryDelegate, KlasRepositoryDelegate {
    func didUpdate(_ leerlingRepository: LeerlingRepository, leerlingen: [Leerling]) {
        DispatchQueue.main.async {
            self.leerlingen = leerlingen
            self.tableView.reloadData()
        }
    }
    
    func didUpdate(_ klasRepository: KlasRepository, klassen: [Klas]?) {
        if let klassenSave = klassen {
            self.klassen = klassenSave
            self.updateKlas()
        } else {
            klasRepository.getKlassen()
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
}

//MARK: - Pickerview
extension StudentViewController: UIPickerViewDataSource ,UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return klassen.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return klassen[row].naam
    }
}
