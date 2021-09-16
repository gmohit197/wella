//
//  InSalonWorkshopHeaderAdapter.swift
//  Wella.2
//
//  Created by Acxiom Consulting on 09/03/21.
//  Copyright © 2021 Acxiom. All rights reserved.
//

class InSalonWorkshopHeaderAdapter{
    var trnappid: String?
    var saloncode: String?
    var salonname: String?
    var subject: String?
    var nop: String?
    var colorcode: String?

    
    init(trnappid: String?,saloncode: String?,salonname: String?,subject: String?,nop: String? , colorcode : String?){
        self.saloncode = saloncode
        self.salonname = salonname
        self.subject = subject
        self.nop = nop
        self.trnappid = trnappid
        self.colorcode = colorcode

    }
}

