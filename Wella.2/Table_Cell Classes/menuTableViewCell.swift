//
//  menuTableViewCell.swift
//  Wella.2
//
//  Created by Acxiom on 22/08/18.
//  Copyright © 2018 Acxiom. All rights reserved.
//

import UIKit

class menuTableViewCell: UITableViewCell {

    @IBOutlet weak var menuicons: UIImageView!
    @IBOutlet weak var lableview: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
