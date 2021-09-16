//
//  CalendarNewViewController.swift
//  Wella.2
//
//  Created by Acxiom Consulting on 09/03/21.
//  Copyright © 2021 Acxiom. All rights reserved.


//MARK:- IMPORTS
import UIKit
import Dropdowns
import SQLite3
import Alamofire
import SystemConfiguration
import SwiftEventBus
import CoreLocation
import JTAppleCalendar

class CalendarNewViewController: UIViewController {
    @IBOutlet weak var applecalendar: JTAppleCalendarView!
    @IBOutlet weak var year: UILabel!
    @IBOutlet weak var month: UILabel!
    
    let formatter = DateFormatter()
    let outsidemonthcolor = UIColor.lightGray
    let monthcolor = UIColor.black
    let selectedmonthcolor = UIColor.white
    let currentdatecolor = UIColor.green
    var menuvc: menuViewController!
    var Datearray : [String]! = []
    var Labelarray : [String]! = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpSideBar()
        setupcalendarview()
        // Do any additional setup after loading the view.
    }
    
    //MARK:- SUBJECT
    fileprivate func fillCalendarCellData(){
 //Cursor res = sq.rawQuery("select distinct(substr(date,1,13)),shorT_DESC,status,substr(date,1,13) as date from Calender", null);
        Datearray.removeAll()
        Labelarray.removeAll()
//
//        activitySubjectDropDown.optionArray.removeAll()
        
        var stmt:OpaquePointer?
        let queryString = "select distinct(substr(date,1,13)),shorT_DESC,status,substr(date,1,13) as date from Calender"
        if sqlite3_prepare_v2(DatabaseConnection.dbs, queryString, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(DatabaseConnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return
        }
        while(sqlite3_step(stmt) == SQLITE_ROW){
            let DateStr = String(cString: sqlite3_column_text(stmt, 0))
            let LabelStr = String(cString: sqlite3_column_text(stmt, 1))
            
            
            Datearray.append(DateStr)
            Labelarray.append(LabelStr)
        }
    }
    
    //MARK:- CellColor
    fileprivate func getCellColor(date : String) -> String{
        var status : String! = ""
        var stmt:OpaquePointer?
        let queryString = "select distinct substr(date,6,8) as dateSubStr,status  from Calender where dateSubStr = '" + date + "' "
        
        if sqlite3_prepare_v2(DatabaseConnection.dbs, queryString, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(DatabaseConnection.dbs)!)
            print("error preparing get: \(errmsg)")
        }
        while(sqlite3_step(stmt) == SQLITE_ROW){
            status = String(cString: sqlite3_column_text(stmt, 1))
        }
        return status
    }
    
    //MARK:- ShortDescription
    fileprivate func getShortDescription(date : String) -> String{
        var shortdesc : String! = ""
        var stmt:OpaquePointer?
        let queryString = "select distinct substr(date,6,8) as dateSubStr,shorT_DESC  from Calender where dateSubStr = '" + date + "' "
        
        if sqlite3_prepare_v2(DatabaseConnection.dbs, queryString, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(DatabaseConnection.dbs)!)
            print("error preparing get: \(errmsg)")
        }
        while(sqlite3_step(stmt) == SQLITE_ROW){
            shortdesc = String(cString: sqlite3_column_text(stmt, 1))
        }
        return shortdesc
    }


    
    fileprivate func setUpSideBar(){
        AppDelegate.menubool = true
        menuvc = (self.storyboard?.instantiateViewController(withIdentifier: "menuViewController") as! menuViewController)
        let swiperyt = UISwipeGestureRecognizer(target: self, action: #selector(self.gesturerecognise))
        swiperyt.direction = UISwipeGestureRecognizerDirection.right
        let swipelft = UISwipeGestureRecognizer(target: self, action: #selector(self.gesturerecognise))
        swipelft.direction = UISwipeGestureRecognizerDirection.left
        self.view.addGestureRecognizer(swiperyt)
        self.view.addGestureRecognizer(swipelft)
    }
    
//    override func shouldAutorotate() -> Bool {
//        print("shouldAutorotate")
//        return false
//    }
//
//    override func supportedInterfaceOrientations() -> Int {
//        print("supportedInterfaceOrientations")
//        return Int(UIInterfaceOrientationMask.landscapeLeft.rawValue)
//    }
//
//    override func preferredInterfaceOrientationForPresentation() -> UIInterfaceOrientation {
//        return UIInterfaceOrientation.landscapeLeft
//    }

    @objc func gesturerecognise (gesture : UISwipeGestureRecognizer)
    {
        switch gesture.direction {
        case UISwipeGestureRecognizerDirection.left :
            hidemenu()
            break
            
        case UISwipeGestureRecognizerDirection.right :
            showmenu()
            break
            
        default:
            break
        }
    }
    
    @IBAction func sidebarbtn(_ sender: UIBarButtonItem) {
        if AppDelegate.menubool{
            showmenu()
        }
        else {
            hidemenu()
        }
    }
    
    func showmenu()
    {
        UIView.animate(withDuration: 0.4){ ()->Void in
            self.menuvc.view.frame = CGRect(x: 0, y: 60, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            self.menuvc.view.backgroundColor = UIColor.black.withAlphaComponent(0.0)
            self.addChildViewController(self.menuvc)
            self.view.addSubview(self.menuvc.view)
            AppDelegate.menubool = false
        }
    }
    func hidemenu ()
    {
        UIView.animate(withDuration: 0.3, animations: { ()->Void in
            self.menuvc.view.frame = CGRect(x: -UIScreen.main.bounds.width, y: 60, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        }) { (finished) in
            self.menuvc.view.removeFromSuperview()
        }
        AppDelegate.menubool = true
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
            validcell.selectedcell.isHidden = false
        }
        else
        {
            validcell.selectedcell.isHidden = true
        }
    }
    
    func setupviewsofcalendar(from visibleDates: DateSegmentInfo)
    {
        let date = visibleDates.monthDates.first!.date
        self.formatter.dateFormat = "MMM-yyyy"
        self.year.text = formatter.string(from: date)
      //  self.year.text = "2021"
        self.formatter.dateFormat = "MMM"
        self.month.text = formatter.string(from: date)
    }
    
    func handlecelltextcolor(view: JTAppleCell?, cellState: CellState){
        var status : String! = ""
        guard let validcell = view as? customCollectionViewCell else {return}
        self.formatter.dateFormat = "DD"
        let currentdate = formatter.string(from: Date())
        let cellstatedate = formatter.string(from: cellState.date)
        if currentdate == cellstatedate
        {
            validcell.currentdate.isHidden = false
            status =  self.getCellColor(date: currentdate)
           
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
extension CalendarNewViewController:JTAppleCalendarViewDataSource {
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
        formatter.dateFormat = "yyy MM dd"
        formatter.timeZone = Calendar.current.timeZone
        formatter.locale = Calendar.current.locale

        var dateComponent = DateComponents()
        dateComponent.year = 1
        let startDate = Date()
        let endDate = Calendar.current.date(byAdding: dateComponent, to: startDate)
        let parameters = ConfigurationParameters(startDate: startDate, endDate: endDate!, numberOfRows: 6, calendar: Calendar.current, generateInDates: .forFirstMonthOnly, generateOutDates: .off, firstDayOfWeek: .sunday, hasStrictBoundaries: true)
        return parameters
    }
}

extension CalendarNewViewController: JTAppleCalendarViewDelegate {
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
