//
//  WorkshopListAdapter.swift
//  Wella.2
//
//  Created by Acxiom Consulting on 16/03/21.
//  Copyright © 2021 Acxiom. All rights reserved.
//


import Foundation
class WorkshopListAdapter{
    var stylistcode: String?
    var stylistname: String?
    var saloncode: String?
    var salonname: String?
    
    init(stylistcode: String?, stylistname: String? ,saloncode: String?, salonname: String?) {
        self.stylistcode = stylistcode
        self.stylistname = stylistname
        self.saloncode = saloncode
        self.salonname = salonname
       
    }
}

