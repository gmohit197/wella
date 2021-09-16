//
//  tempViewController.swift
//  Wella.2
//
//  Created by Acxiom on 01/09/18.
//  Copyright © 2018 Acxiom. All rights reserved.
//

import UIKit
import JTAppleCalendar

class tempViewController: UIViewController {

    let formatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
    }
}

extension tempViewController: JTAppleCalendarViewDelegate, JTAppleCalendarViewDataSource {
    func calendar(_ calendar: JTAppleCalendarView, willDisplay cell: JTAppleCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
        return
    }
    
        func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
            formatter.dateFormat = "yyyy MM dd"
            formatter.timeZone = Calendar.current.timeZone
            formatter.locale = Calendar.current.locale
            
            let startdate = formatter.date(from: "2017 01 01")!
            let enddaet = formatter.date(from: "2017 12 01")!
            
            let parameters = ConfigurationParameters(startDate: startdate, endDate: enddaet)
        
        return parameters
        }
        func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
            let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "calendarcell", for: indexPath) as! customCollectionViewCell
            cell.datelabel.text = cellState.text
            return cell
        }
        
    }

