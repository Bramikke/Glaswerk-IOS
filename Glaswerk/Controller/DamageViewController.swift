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
    
    var items : [Item] = [
        Item(itemid: 1, lokaal_id: 1, naam: "test", aantal: 1, min_aantal: 1, max_aantal: 1, bestel_hoeveelheid: 1)
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
    }


}

extension DamageViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = items[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: K.damage.cellIdentifier, for: indexPath)
        cell.textLabel?.text = item.naam
        return cell
    }
    
    
}

