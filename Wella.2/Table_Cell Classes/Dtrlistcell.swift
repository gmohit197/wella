//
//  Dtrlistcell.swift
//  Wella.2
//
//  Created by Acxiom Consulting on 28/09/18.
//  Copyright © 2018 Acxiom. All rights reserved.
//

import UIKit
import SwiftEventBus
import SQLite3

class Dtrlistcell: UITableViewCell{
    
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var stylist: UILabel!
    @IBOutlet weak var salon: UILabel!
    @IBOutlet weak var type: UILabel!
    @IBOutlet weak var training: UILabel!
   
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}

//extension Dtrlistcell
//{
//    func setTableviewDataSourceDelegate
//        <D:UITableViewDelegate & UITableViewDataSource>
//        (_ dataSourceDelegate: D, forRow row: Int)
//    {
//        insidedtrcell.delegate = dataSourceDelegate
//        insidedtrcell.dataSource = dataSourceDelegate
//
//        insidedtrcell.reloadData()
//    }
//}
