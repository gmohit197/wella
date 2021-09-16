//
//  InSalonLineTableViewCell.swift
//  Wella.2
//
//  Created by Acxiom Consulting on 09/03/21.
//  Copyright © 2021 Acxiom. All rights reserved.
//

import UIKit

class InSalonLineTableViewCell: UITableViewCell {
    @IBOutlet weak var stylistCode: UILabel!
    @IBOutlet weak var stylistName: UILabel!
    @IBOutlet weak var salonName: UILabel!
    @IBOutlet weak var salonCode: UILabel!


    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

//    @IBAction func deleteBtn(_ sender: Any) {
//        print("Delete Btn Clicked")
//    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
