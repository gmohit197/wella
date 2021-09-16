//
//  SalonList1Adapter.swift
//  Wella.2
//
//  Created by Acxiom Consulting on 04/03/21.
//  Copyright © 2021 Acxiom. All rights reserved.
//

import Foundation
class SalonList1Adapter{
    var entity: String?
    var l2msales: String?
    var mtdly: String?
    var mtdty: String?
    var ytdly: String?
    var ytdty: String?
    
    
    init(entity: String?, l2msales: String?, mtdly: String?,mtdty: String?, ytdly: String?, ytdty: String?) {
        self.entity = entity
        self.l2msales = l2msales
        self.mtdly = mtdly
        self.mtdty = mtdty
        self.ytdly = ytdly
        self.ytdty = ytdty
       
    }
}
