//
//  DashboardTableViewCell.swift
//  Wella.2
//
//  Created by Acxiom on 12/09/18.
//  Copyright © 2018 Acxiom. All rights reserved.
//

import UIKit

class DashboardTableViewCell: UITableViewCell {

    @IBOutlet weak var distribution_mtd: UILabel!
    @IBOutlet weak var distribution_ytd: UILabel!
    @IBOutlet weak var volume_ytd: UILabel!
    @IBOutlet weak var volume_mtd: UILabel!
    @IBOutlet weak var brandlabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
