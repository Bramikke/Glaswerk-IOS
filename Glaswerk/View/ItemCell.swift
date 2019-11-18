//
//  ItemCell.swift
//  Glaswerk
//
//  Created by Bram Goedvriend on 15/11/2019.
//  Copyright © 2019 Bram Goedvriend. All rights reserved.
//

import UIKit

class ItemCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var backgroundCell: UIView!
    @IBOutlet weak var personImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundCell.layer.cornerRadius = 10
        backgroundCell.layer.masksToBounds = false
        backgroundCell.layer.shadowColor = UIColor.black.withAlphaComponent(0.2).cgColor
        backgroundCell.layer.shadowOffset = CGSize(width: 0, height: 0)
        backgroundCell.layer.shadowOpacity = 0.8
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        if(selected) {
            backgroundCell.backgroundColor = UIColor.opaqueSeparator
        } else {
            backgroundCell.backgroundColor = UIColor.systemBackground
        }
    }
}
