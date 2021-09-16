//
//  InSalonHeaderTableView.swift
//  Wella.2
//
//  Created by Acxiom Consulting on 09/03/21.
//  Copyright © 2021 Acxiom. All rights reserved.
//

import UIKit

class InSalonHeaderTableView: UITableViewCell  {
    @IBOutlet weak var plusBtnLabel: UIButton!
    @IBOutlet weak var salonCode: UILabel!
    @IBOutlet weak var salonName: UILabel!
    @IBOutlet weak var subject: UILabel!
    @IBOutlet weak var nop: UILabel!
    var tapPlusButton: (() -> Void)? = nil

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBAction func plusBtn(_ sender: Any) {
     //   tapPlusButton?()
        plusButton(salonCode: self.salonCode.text!,salonName: self.salonName.text!)
    }
    
    public func plusButton(salonCode : String?, salonName : String?){
        print("Plus Btn Clicked")
        print("SalonName=======================================")
        print(salonName!)
        print("SalonCode=======================================")
        print(salonCode!)
    }
    

    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
