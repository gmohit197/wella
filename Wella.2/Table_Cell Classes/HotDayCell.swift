//
//  HotDayCell.swift
//  Wella.2
//
//  Created by Acxiom Consulting on 04/02/21.
//  Copyright © 2021 Acxiom. All rights reserved.


import UIKit
import Foundation

class HotDayCell: UITableViewCell {

    @IBOutlet weak var salonCode : UILabel!
    @IBOutlet weak var salonName : UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
