//
//  salontrackingcellTableViewCell.swift
//  Wella.2
//
//  Created by Acxiom Consulting on 06/10/18.
//  Copyright © 2018 Acxiom. All rights reserved.
//

import UIKit

class salontrackingcellTableViewCell: UITableViewCell {
    
    @IBOutlet weak var brand: UILabel!
    @IBOutlet weak var ytd: UILabel!
    @IBOutlet weak var mtd: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
