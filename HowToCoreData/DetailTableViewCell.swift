//
//  DetailTableViewCell.swift
//  HowToCoreData
//
//  Created by Guadalupe on 03/12/2018.
//  Copyright © 2018 Guadalupe Vlček. All rights reserved.
//

import UIKit

class DetailTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func setupCell(name: String){
        nameLabel.text = name
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
