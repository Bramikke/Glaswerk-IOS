//
//  StockDetailViewController.swift
//  Glaswerk
//
//  Created by Bram Goedvriend on 17/11/2019.
//  Copyright © 2019 Bram Goedvriend. All rights reserved.
//

import UIKit
import DropDown
import IQKeyboardManagerSwift

class StockDetailViewController: UIViewController {
    @IBOutlet weak var naamInput: UITextField!
    @IBOutlet weak var aantalInput: UITextField!
    @IBOutlet weak var minAantalInput: UITextField!
    @IBOutlet weak var maxAantalInput: UITextField!
    @IBOutlet weak var bestelHoeveelheidInput: UITextField!
    @IBOutlet weak var lokaalInput: UITextField!
    @IBOutlet weak var verwijderButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    
    let itemRepository = ItemRepository()
    var item : Item?
    var lokalen : [Lokaal]?
    var lokaalid : Int?
    let dropDown = DropDown()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        verwijderButton.layer.borderColor = UIColor.systemRed.cgColor
        lokaalInput.inputView = UIView.init(frame: CGRect.zero)
        lokaalInput.inputAccessoryView = UIView.init(frame: CGRect.zero)
        if let i = item {
            self.title = i.naam
            naamInput.text = i.naam
            aantalInput.text = String(i.aantal)
            minAantalInput.text = String(i.min_aantal)
            maxAantalInput.text = String(i.max_aantal)
            bestelHoeveelheidInput.text = String(i.bestel_hoeveelheid)
            lokaalInput.text = lokalen!.first(where: {$0.lokaalid == i.lokaal_id})?.naam
            lokaalid = lokalen!.first(where: {$0.lokaalid == i.lokaal_id})?.lokaalid
        } else {
            verwijderButton.isHidden = true
            saveButton.setTitle(K.add, for: .normal)
        }
        dropDown.anchorView = lokaalInput
        dropDown.dataSource = lokalen!.map({ $0.naam })
        dropDown.selectionAction = { (index: Int, item: String) in
            self.lokaalInput.text = self.lokalen![index].naam
            self.lokaalid = self.lokalen![index].lokaalid
        }
    }
    
    @IBAction func lokaalInputClick(_ sender: UITextField) {
        sender.endEditing(true)
        dropDown.show()
    }
    
    @IBAction func verwijderButtonClick(_ sender: UIButton) {
        let alert = UIAlertController(title: K.detailView.remove, message: K.detailView.areUSureThat+item!.naam+K.detailView.wantToRemove, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: K.cancel, style: .default, handler: { _ in }))
        alert.addAction(UIAlertAction(title: K.remove, style: .destructive, handler: { _ in
            self.itemRepository.removeItem(item: self.item!)
            self.navigationController?.popViewController(animated: true)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func saveButtonClick(_ sender: UIButton) {
        if lokaalid != nil, naamInput.text != "", aantalInput.text != "", minAantalInput.text != "", maxAantalInput.text != "", bestelHoeveelheidInput.text != "" {
            if let i = item {
                itemRepository.editItem(
                    item: Item(itemid: i.itemid,
                               lokaal_id: lokaalid!,
                               naam: naamInput.text!,
                               aantal: Int(aantalInput.text!)!,
                               min_aantal: Int(minAantalInput.text!)!,
                               max_aantal: Int(maxAantalInput.text!)!,
                               bestel_hoeveelheid: Int(bestelHoeveelheidInput.text!)!,
                               lokaalid: nil, lokaal_naam: nil))
            } else {
                itemRepository.addItem(
                    item: Item(itemid: nil,
                               lokaal_id: lokaalid!,
                               naam: naamInput.text!,
                               aantal: Int(aantalInput.text!)!,
                               min_aantal: Int(minAantalInput.text!)!,
                               max_aantal: Int(maxAantalInput.text!)!,
                               bestel_hoeveelheid: Int(bestelHoeveelheidInput.text!)!,
                               lokaalid: nil, lokaal_naam: nil))
            }
            navigationController?.popViewController(animated: true)
        } else {
            view.makeToast(K.error.fields)
        }
    }
}
