//
//  ListTableViewCell.swift
//  HowToCoreData
//
//  Created by Guadalupe on 03/12/2018.
//  Copyright © 2018 Guadalupe Vlček. All rights reserved.
//

import UIKit

class ListTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var itemsAmountLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setupCell(name:String, itemsAmount: String){
        nameLabel.text = name
        itemsAmountLabel.text = itemsAmount
    }
}
