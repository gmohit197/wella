//
//  PlannedListAdapter.swift
//  Wella.2
//
//  Created by Acxiom Consulting on 28/03/21.
//  Copyright © 2021 Acxiom. All rights reserved.
//

import Foundation
class PlannedListAdapter{
    var saloncode: String?
    var salonname: String?
    var subject: String?
    var subjectname: String?
    var trainingtype:String?
    
    init(saloncode: String?, salonname: String?, subject: String?,subjectname: String?, trainingtype : String?) {
        self.saloncode = saloncode
        self.salonname = salonname
        self.subject = subject
        self.subjectname = subjectname
        self.trainingtype = trainingtype
    }
}
