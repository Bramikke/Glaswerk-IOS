//
//  StudentDetailViewController.swift
//  Glaswerk
//
//  Created by Bram Goedvriend on 16/11/2019.
//  Copyright © 2019 Bram Goedvriend. All rights reserved.
//

import UIKit
import DropDown
import IQKeyboardManagerSwift
import Toast_Swift

class StudentDetailViewController: UIViewController {
    
    @IBOutlet weak var voornaamInput: UITextField!
    @IBOutlet weak var achternaamInput: UITextField!
    @IBOutlet weak var klasInput: UITextField!
    @IBOutlet weak var verwijderButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    
    let leerlingRepository = LeerlingRepository()
    var leerling : Leerling?
    var klassen : [Klas]?
    var klasid : Int?
    let dropDown = DropDown()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        verwijderButton.layer.borderColor = UIColor.systemRed.cgColor
        klasInput.inputView = UIView.init(frame: CGRect.zero)
        klasInput.inputAccessoryView = UIView.init(frame: CGRect.zero)
        if let l = leerling {
            self.title = "\(String(l.voornaam)) \(l.achternaam)"
            voornaamInput.text = l.voornaam
            achternaamInput.text = l.achternaam
            klasInput.text = klassen!.first(where: { $0.klasid == l.klasid })?.naam
            klasid = klassen!.first(where: { $0.klasid == l.klasid })?.klasid
        } else {
            verwijderButton.isHidden = true
            saveButton.setTitle(K.add, for: .normal)
        }
        dropDown.anchorView = klasInput
        dropDown.dataSource = klassen!.map({ $0.naam })
        dropDown.selectionAction = { (index: Int, item: String) in
            self.klasInput.text = self.klassen![index].naam
            self.klasid = self.klassen![index].klasid
        }
    }
    
    @IBAction func klasInputClick(_ sender: UITextField) {
        sender.endEditing(true)
        dropDown.show()
    }
    
    @IBAction func removeButtonClick(_ sender: UIButton) {
        let alert = UIAlertController(title: K.detailView.remove, message: "\(K.detailView.areUSureThat)\(leerling!.voornaam) \(leerling!.achternaam)\(K.detailView.wantToRemove)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: K.cancel, style: .default, handler: { _ in }))
        alert.addAction(UIAlertAction(title: K.remove, style: .destructive, handler: { _ in
            self.leerlingRepository.removeLeerling(leerling: self.leerling!)
            self.navigationController?.popViewController(animated: true)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func saveButtonClick(_ sender: UIButton) {
        if klasid != nil, voornaamInput.text != "", achternaamInput.text != "" {
            if let l = leerling {
                leerlingRepository.editLeerling(leerling: Leerling(leerlingid: l.leerlingid,
                                                                   klasid: klasid!,
                                                                   voornaam: voornaamInput.text!,
                                                                   achternaam: achternaamInput.text!,
                                                                   aantalGebroken: nil))
            } else {
                leerlingRepository.addLeerling(leerling: Leerling(leerlingid: nil,
                                                                  klasid: klasid!,
                                                                  voornaam: voornaamInput.text!,
                                                                  achternaam: achternaamInput.text!,
                                                                  aantalGebroken: nil))
            }
            navigationController?.popViewController(animated: true)
        } else {
            view.makeToast(K.error.fields)
        }
    }
}
