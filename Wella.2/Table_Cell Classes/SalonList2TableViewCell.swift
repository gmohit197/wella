//
//  SalonList2TableViewCell.swift
//  Wella.2
//
//  Created by Acxiom Consulting on 04/03/21.
//  Copyright © 2021 Acxiom. All rights reserved.
//

import UIKit

class SalonList2TableViewCell: UITableViewCell {
    @IBOutlet weak var catname: UILabel!
    @IBOutlet weak var l2msales: UILabel!
    @IBOutlet weak var mtdly: UILabel!
    @IBOutlet weak var mtdty: UILabel!
    @IBOutlet weak var ytdly: UILabel!
    @IBOutlet weak var ytdty: UILabel!


    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
