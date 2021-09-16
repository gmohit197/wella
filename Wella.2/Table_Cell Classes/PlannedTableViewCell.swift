//
//  PlannedTableViewCell.swift
//  Wella.2
//
//  Created by Acxiom Consulting on 28/03/21.
//  Copyright © 2021 Acxiom. All rights reserved.
//

import UIKit

class PlannedTableViewCell: UITableViewCell {

    @IBOutlet weak var subjectName: UILabel!
    @IBOutlet weak var subjectHeader: UILabel!
    @IBOutlet weak var salonName: UILabel!
    @IBOutlet weak var saloncode: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
