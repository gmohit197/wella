//
//  VirtualLineAdapter.swift
//  Wella.2
//
//  Created by Acxiom Consulting on 13/03/21.
//  Copyright © 2021 Acxiom. All rights reserved.
//

class VirtualLineAdapter{
    var stylistcode: String?
    var stylistname: String?
    var saloncode: String?
    var trnapppid: String?
    var colorcode: String?
    var subject: String?
    
    init(stylistcode: String?,stylistname: String?,saloncode: String?,trnapppid: String?,colorcode: String?,subject: String?){
        self.stylistcode = stylistcode
        self.stylistname = stylistname
        self.saloncode = saloncode
        self.trnapppid = trnapppid
        self.colorcode = colorcode
        self.subject = subject
    }
}

