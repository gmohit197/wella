//
//  workshopcell.swift
//  Wella.2
//
//  Created by Acxiom Consulting on 01/10/18.
//  Copyright © 2018 Acxiom. All rights reserved.
//

import UIKit

class workshopcell: UITableViewCell {

    @IBOutlet weak var sno: UILabel!
    @IBOutlet weak var salon: UILabel!
    @IBOutlet weak var stylistno: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
