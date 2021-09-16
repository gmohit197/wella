//
//  dashboardlistdata.swift
//  Wella.2
//
//  Created by Acxiom on 12/09/18.
//  Copyright © 2018 Acxiom. All rights reserved.
//

class dashboardlistview{
    var product: String?
    var distri_mtd: String?
    var distri_ytd: String?
    var volume_mtd: String?
    var volume_ytd: String?
    
    init(product: String?,distri_mtd: String?,distri_ytd: String?,volume_mtd: String?,volume_ytd: String?){
        self.product = product
        self.distri_mtd = distri_mtd
        self.distri_ytd = distri_ytd
        self.volume_mtd = volume_mtd
        self.volume_ytd = volume_ytd
    }
}


