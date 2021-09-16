//
//  VirtualLineTableViewCell.swift
//  Wella.2
//
//  Created by Acxiom Consulting on 13/03/21.
//  Copyright © 2021 Acxiom. All rights reserved.
//
import UIKit

class VirtualLineTableViewCell: UITableViewCell {
    @IBOutlet weak var subject: UILabel!
    @IBOutlet weak var stylistname: UILabel!
    @IBOutlet weak var saloncode: UILabel!
    @IBOutlet weak var stylistcode: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
