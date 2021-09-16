//
//  calendarViewController.swift
//  Wella.2
//
//  Created by Acxiom on 01/09/18.
//  Copyright © 2018 Acxiom. All rights reserved.
//

import UIKit
import JTAppleCalendar

class calendarViewController: UIViewController {
    
    let formatter = DateFormatter()
    @IBOutlet weak var applecalendar: JTAppleCalendarView!
    @IBOutlet weak var year: UILabel!
    @IBOutlet weak var month: UILabel!
    
    let outsidemonthcolor = UIColor.lightGray
    let monthcolor = UIColor.black
    let selectedmonthcolor = UIColor.white
    let currentdatecolor = UIColor.green
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupcalendarview()
    }
    func setupcalendarview()
    {
        //seting up labels layout
        applecalendar.minimumLineSpacing = 0
        applecalendar.minimumInteritemSpacing = 0
        //setup labels
        applecalendar.visibleDates{ (visibleDates) in
            self.setupviewsofcalendar(from: visibleDates)
        }
    }

    func handlecellselected(view: JTAppleCell?, cellState: CellState){
        guard let validcell = view as? customCollectionViewCell else {return}
        if cellState.isSelected && cellState.dateBelongsTo == .thisMonth {
            validcell.selectedcell.isHidden=false
        }
        else
        {
            validcell.selectedcell.isHidden = true
        }
    }
    func setupviewsofcalendar(from visibleDates: DateSegmentInfo)
    {
        let date = visibleDates.monthDates.first!.date
        
        self.formatter.dateFormat = "yyyy"
        self.year.text = formatter.string(from: date)
        
        self.formatter.dateFormat = "MMMM"
        self.month.text = formatter.string(from: date)
    }
    
    func handlecelltextcolor(view: JTAppleCell?, cellState: CellState){
        guard let validcell = view as? customCollectionViewCell else {return}
        
        self.formatter.dateFormat = "DD"
        
        let currentdate = formatter.string(from: Date())
        let cellstatedate = formatter.string(from: cellState.date)
        
        if currentdate == cellstatedate
        {
            validcell.currentdate.isHidden = false
            validcell.datelabel.textColor = selectedmonthcolor
        }
        else
        {
            validcell.currentdate.isHidden = true
            
        }
        //cell selection check
        
        if cellState.dateBelongsTo == .thisMonth
        {
            validcell.datelabel.textColor = monthcolor //black
            validcell.isUserInteractionEnabled = true
            if cellState.isSelected
            {
                validcell.datelabel.textColor=selectedmonthcolor  //white
            }
            else
            {
                if cellState.dateBelongsTo == .thisMonth{
                    validcell.datelabel.textColor = monthcolor //black
                    
                }
                else
                {
                    validcell.datelabel.textColor = outsidemonthcolor    //light grey
                    
                }
            }
        }
        else
        {
            validcell.datelabel.textColor = outsidemonthcolor    //light grey
            validcell.isUserInteractionEnabled = false
            if cellState.isSelected
            {
                validcell.selectedcell.isHidden =  true
            }
        }
        
        if validcell.currentdate.isHidden == false      //if current date is set
        {
            validcell.datelabel.textColor=selectedmonthcolor  //white
        }
    }
    
}
extension calendarViewController:JTAppleCalendarViewDataSource {
    func calendar(_ calendar: JTAppleCalendarView, willDisplay cell: JTAppleCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
    }
    func calendar(_ calendar: JTAppleCalendarView, shouldSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) -> Bool {
        //making cells unselectable
        if cellState.dateBelongsTo == .thisMonth
        {
            return true
        }
        else
        {
            return false
        }
    }
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        formatter.dateFormat = "yyyy MM dd"
        formatter.timeZone = Calendar.current.timeZone
        formatter.locale = Calendar.current.locale
        let startDate = formatter.date(from: "2019 01 01")!
        let endDate  = formatter.date(from: "2019 12 31")!
        let parameters = ConfigurationParameters(startDate: startDate, endDate: endDate)
        return parameters
    }
}
extension calendarViewController: JTAppleCalendarViewDelegate {
    //display cell
    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "calendarcell", for: indexPath) as! customCollectionViewCell
        cell.datelabel.text = cellState.text
        handlecelltextcolor(view: cell, cellState: cellState)
        handlecellselected(view: cell, cellState: cellState)
        return cell
    }
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        handlecellselected(view: cell, cellState: cellState)
        handlecelltextcolor(view: cell, cellState: cellState)
    }
    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        handlecelltextcolor(view: cell, cellState: cellState)
        handlecellselected(view: cell, cellState: cellState)
    }
    func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        setupviewsofcalendar(from: visibleDates)
        
    }
}














