//
//  WorkshopTableViewCell.swift
//  Wella.2
//
//  Created by Acxiom Consulting on 16/03/21.
//  Copyright © 2021 Acxiom. All rights reserved.
//

import UIKit

class WorkshopTableViewCell: UITableViewCell {
    
    @IBOutlet weak var stylistcode: UILabel!
    @IBOutlet weak var stylistname: UILabel!
    @IBOutlet weak var saloncode: UILabel!
    @IBOutlet weak var salonname: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
