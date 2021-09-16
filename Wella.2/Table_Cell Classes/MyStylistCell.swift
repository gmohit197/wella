//
//  MyStylistCell.swift
//  Wella.2
//
//  Created by Acxiom Consulting on 29/09/18.
//  Copyright © 2018 Acxiom. All rights reserved.
//

import UIKit

class MyStylistCell: UITableViewCell {

    @IBOutlet weak var seller: UILabel!
    @IBOutlet weak var contact: UILabel!
    @IBOutlet weak var stylist: UILabel!
    @IBOutlet weak var salon: UILabel!
    
    @IBOutlet weak var count: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
