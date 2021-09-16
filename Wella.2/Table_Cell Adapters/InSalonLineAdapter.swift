//
//  InSalonLineAdapter.swift
//  Wella.2
//
//  Created by Acxiom Consulting on 09/03/21.
//  Copyright © 2021 Acxiom. All rights reserved.
//

class InSalonLineAdapter{
    var stylistcode: String?
    var stylistname: String?
    var salonname: String?
    var saloncode: String?
    var trnapppid: String?
    var colorcode: String?

    
    init(stylistcode: String?,stylistname: String?,salonname: String?,saloncode: String?,trnapppid: String?,colorcode: String?){
        self.stylistcode = stylistcode
        self.stylistname = stylistname
        self.salonname = salonname
        self.saloncode = saloncode
        self.trnapppid = trnapppid
        self.colorcode = colorcode

    }
}

