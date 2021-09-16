//
//  dtrlistdata.swift
//  Wella.2
//
//  Created by Acxiom Consulting on 28/09/18.
//  Copyright © 2018 Acxiom. All rights reserved.
//

class Dtrlistview {
    var date: String?
    var stylist: String?
    var salon: String?
    var type: String?
    var training: String?
    var trainingdoc: String?
    
    init(date: String?,stylist: String?,salon: String?,type: String?,training: String?,trainingdoc: String?){
        self.date = date
        self.stylist = stylist
        self.salon = salon
        self.type = type
        self.training = training
        self.trainingdoc = trainingdoc
    }
}
