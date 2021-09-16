//
//  MyStylistCelldata.swift
//  Wella.2
//
//  Created by Acxiom Consulting on 29/09/18.
//  Copyright © 2018 Acxiom. All rights reserved.
//

import Foundation

class MyStylistlistview {
    var seller: String?
    var contact: String?
    var salon: String?
    var stylist: String?
    var count: String?
    
    init(seller: String?, contact: String?, salon: String?, Stylist: String?, count: String?) {
        self.seller = seller
        self.contact = contact
        self.stylist = Stylist
        self.salon = salon
        self.count = count
    }
}
