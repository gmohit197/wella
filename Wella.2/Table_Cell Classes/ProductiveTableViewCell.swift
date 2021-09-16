//
//  ProductiveTableViewCell.swift
//  Wella.2
//
//  Created by Acxiom Consulting on 18/03/21.
//  Copyright © 2021 Acxiom. All rights reserved.
//

import UIKit

class ProductiveTableViewCell: UITableViewCell {

    @IBOutlet weak var customercode: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
