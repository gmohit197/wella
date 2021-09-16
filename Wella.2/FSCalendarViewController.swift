//
//  FSCalendarViewController.swift
//  Wella.2
//
//  Created by Acxiom Consulting on 17/03/21.
//  Copyright © 2021 Acxiom. All rights reserved.

//MARK:- IMPORTS
import UIKit
import Dropdowns
import SQLite3
import Alamofire
import SystemConfiguration
import SwiftEventBus
import CoreLocation
import FSCalendar

class FSCalendarViewController: ExecuteApi , FSCalendarDataSource, FSCalendarDelegate , FSCalendarDelegateAppearance   {
    var menuvc : menuViewController!
    
    @IBOutlet weak var calendar: FSCalendar!
    
    fileprivate let gregorian = Calendar(identifier: .gregorian)
    fileprivate let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    override var shouldAutorotate: Bool {
        return false
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask{
        return .landscapeRight
    }

    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation{
        return .landscapeRight
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        let value = UIInterfaceOrientation.landscapeRight.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
    }
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
       // menuGestures()
        let value = UIInterfaceOrientation.landscapeRight.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
        self.setup()
        self.calendarApperreanceSetup()
    }
    
//    override func viewWillDisappear(_ animated: Bool) {
//        DispatchQueue.main.async {
//            (UIApplication.shared.delegate as! AppDelegate).restrictRotation = .portrait
//        }
//    }
     
    fileprivate func GetData(){
        self.checknet()
        if(AppDelegate.ntwrk > 0){
            self.showSyncloader(title: "Loading....Please Wait")
            self.executeURL_GetCalende1()
            self.executeURL_GetCalenderPending1()
        }
        else {
            self.showNetworkAlert()
        }
    }
    
    
    @IBAction func backBtnCllick(_ sender: UIBarButtonItem) {
           self.pushHome(vcId: "dashnc", vc: self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
           self.GetData()
           self.hideSyncloader()
       }
       
    override func viewWillAppear(_ animated: Bool) {
        SwiftEventBus.onMainThread(self, name: "setcalendar") { (result) in
            DispatchQueue.main.asyncAfter(deadline: .now()+0.5) {
                   let value = UIInterfaceOrientation.landscapeRight.rawValue
                   UIDevice.current.setValue(value, forKey: "orientation")
                self.setup()
                self.calendarApperreanceSetup()
            }
        }
    }
    
    
    fileprivate func calendarApperreanceSetup(){
        self.calendar.calendarWeekdayView.weekdayLabels[0].textColor  = UIColor.black
        self.calendar.calendarWeekdayView.weekdayLabels[1].textColor  = UIColor.black
        self.calendar.calendarWeekdayView.weekdayLabels[2].textColor  = UIColor.black
        self.calendar.calendarWeekdayView.weekdayLabels[3].textColor  = UIColor.black
        self.calendar.calendarWeekdayView.weekdayLabels[4].textColor  = UIColor.black
        self.calendar.calendarWeekdayView.weekdayLabels[5].textColor  = UIColor.black
        self.calendar.calendarWeekdayView.weekdayLabels[6].textColor  = UIColor.black
        self.calendar.appearance.weekdayTextColor = UIColor.black
        self.calendar.appearance.headerTitleColor = UIColor.black
        self.calendar.appearance.headerTitleFont = UIFont(name: "Bold", size: 20.0)
        self.calendar.appearance.weekdayFont = UIFont(name: "Bold", size: 20.0)
        self.calendar.appearance.caseOptions = .weekdayUsesUpperCase
        //        self.calendar.appearance.titleFont = UIFont(name: "Bold", size: 12.0)
        self.calendar.appearance.subtitleFont = UIFont(name: "Regular", size: 5.0)
        //        self.calendar.appearance.borderDefaultColor = UIColor.systemPink
        self.calendar.calendarWeekdayView.backgroundColor =  hexStringToUIColor(hex : "#8da64b")
        self.calendar.today = nil // Hide the today circle
        self.calendar.placeholderType = .none
        self.calendar.appearance.headerMinimumDissolvedAlpha = 0
        self.calendar.scrollEnabled = false
        self.calendar.pagingEnabled = false
    }
    
    fileprivate func subtitleForDate(date : Date) -> String? {
        var  subtitle : String! = ""
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "dd MMM"
        let currentdate =  dateformatter.string(from: date)
        subtitle = self.getShortDescription(date: String(currentdate))
        return subtitle
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {
        UIColor.black
    }
    
    func calendar(_ calendar: FSCalendar, subtitleFor date: Date) -> String? {
        self.subtitleForDate(date: date)
    }
    
    fileprivate func setup(){
        let view = UIView(frame: UIScreen.main.bounds)
        view.backgroundColor = UIColor.groupTableViewBackground
        self.view = view
        
        let screenBounds = UIScreen.main.bounds
        let screen_width = screenBounds.width
        let screen_height = screenBounds.height
        
        let height: CGFloat = UIDevice.current.model.hasPrefix("iPad") ? 400 : 300
        let calendar = FSCalendar(frame: CGRect(x: 0, y: self.navigationController!.navigationBar.frame.maxY, width:650, height: height))
        
     //   let calendar = FSCalendar(frame: CGRect(x: 0, y: self.navigationController!.navigationBar.frame.maxY, width:screen_width - 17 , height: height))


        calendar.dataSource = self
        calendar.delegate = self
        calendar.allowsMultipleSelection = false
        view.addSubview(calendar)
        self.calendar = calendar
        
        
        calendar.appearance.eventOffset = CGPoint(x: 0, y: -7)
        calendar.today = nil // Hide the today circle
        calendar.register(DIYCalendarCell.self, forCellReuseIdentifier: "cell")
    //    calendar.clipsToBounds = false // Remove top/bottom line
        calendar.appearance.eventSelectionColor = UIColor.green
    }
    //    func calendar(_ calendar: FSCalendar, willDisplay cell: FSCalendarCell, for date: Date, at monthPosition: FSCalendarMonthPosition) {
    //            let labelMy2 = UILabel(frame: CGRect(x: 10, y: 20, width: cell.bounds.width, height: 10))
    //            labelMy2.font = UIFont(name: "Regular", size: 10)
    //            labelMy2.text = "INSLN"
    //
    //            labelMy2.textAlignment = .center
    //            labelMy2.layer.cornerRadius = cell.bounds.width
    //            labelMy2.textColor = UIColor.init(named: "#32C77F")
    //            cell.addSubview(labelMy2)
    //    }
    
    // MARK:- FSCalendarDataSource
    func calendar(_ calendar: FSCalendar, cellFor date: Date, at position: FSCalendarMonthPosition) -> FSCalendarCell {
        let cell = calendar.dequeueReusableCell(withIdentifier: "cell", for: date, at: position)
        return cell
    }
    
    func calendar(_ calendar: FSCalendar, willDisplay cell: FSCalendarCell, for date: Date, at position: FSCalendarMonthPosition) {
        self.configure(cell: cell, for: date, at: position)
    }
    
    func calendar(_ calendar: FSCalendar, titleFor date: Date) -> String? {
        return nil
    }
    
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        return 0
    }
    
    // MARK:- FSCalendarDelegate
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
      //  self.calendar.frame.size.height = bounds.height
            //  self.eventLabel.frame.origin.y = calendar.frame.maxY + 10
    }
    
    func calendar(_ calendar: FSCalendar, shouldSelect date: Date, at monthPosition: FSCalendarMonthPosition)   -> Bool {
        return monthPosition == .current
    }
    
    func calendar(_ calendar: FSCalendar, shouldDeselect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
        return monthPosition == .current
    }
    
    //    private func configureVisibleCellsDidSelet() {
    //           calendar.visibleCells().forEach { (cell) in
    //               let date = calendar.date(for: cell)
    //               let position = calendar.monthPosition(for: cell)
    //               self.configureDidSelect(cell: cell, for: date!, at: position)
    //           }
    //          }
    
    private func configureVisibleCells() {
        calendar.visibleCells().forEach { (cell) in
            let date = calendar.date(for: cell)
            let position = calendar.monthPosition(for: cell)
            self.configure(cell: cell, for: date!, at: position)
        }
    }
    fileprivate func pushDate(date : Date , eventName : String){
        AppDelegate.calendardate = date
        AppDelegate.calendarevent = eventName
        self.pushnext(identifier: "CalendarPlannedViewController", controller: self)
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        print("did select date \(self.formatter.string(from: date))")
        var shortdescStr : String! = ""
        var  color : UIColor = .white
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "dd MMM"
        let currentdate =  dateformatter.string(from: date)
        let status = self.getCellColor(date: String(currentdate))
        let activityname = self.getActivityName(date: String(currentdate))
        shortdescStr = self.getShortDescription(date: String(currentdate))
        let reasonName = self.getReasonName(date: String(currentdate))

        if(shortdescStr.count > 0){
        if(status == "0" ){
            color = .systemYellow
            self.pushDate(date: date, eventName: activityname)
        }
        else if(status == "1"){
            color = .systemGreen
            self.pushDate(date: date, eventName: activityname)
        }
        else if(status == "2"){
            color = .systemRed
            self.pushDate(date: date, eventName: activityname)
        }
        else if(status == "3"){
            color = .systemRed
            self.pushDate(date: date, eventName: activityname)
        }
            
        else if(status == "4"){
            self.showblockAlert(message: reasonName)
            color = .systemBlue
            }
        }
        self.calendar.appearance.titleSelectionColor =  UIColor.systemGreen
        self.calendar.appearance.subtitleSelectionColor = UIColor.black
        //           self.configureVisibleCells()
    }
    
    //MARK:-  ALERT
    func showNetworkAlert(){
        let alert = UIAlertController(title: "", message: "Please Check Your Internet Connection", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
            self.push(vcId: "dashnc", vc: self)
        }))
        self.present(alert, animated: true)
    }

    
    
    //MARK:- BLOCK ALERT
    func showblockAlert(message : String?){
        let alert = UIAlertController(title: "Block Day Reason", message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true)
    }
    
    func calendar(_ calendar: FSCalendar, didDeselect date: Date) {
        print("did deselect date \(self.formatter.string(from: date))")
    }
    
    //       func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, eventDefaultColorsFor date: Date) -> [UIColor]? {
    //           if self.gregorian.isDateInToday(date) {
    //               return [UIColor.orange]
    //           }
    //           return [appearance.eventDefaultColor]
    //       }
    
    private func configureDidSelect(cell: FSCalendarCell, for date: Date, at position: FSCalendarMonthPosition) {
        let diyCell = (cell as! DIYCalendarCell)
        // Custom today circle
        print("CURRENT CELL===================================")
        print(date)
        print(position)
        
        diyCell.circleImageView.isHidden = !self.gregorian.isDateInToday(date)
        diyCell.circleImageView.isHidden = true
        diyCell.backgroundView?.backgroundColor = UIColor.systemGreen
    }
    
    private func configure(cell: FSCalendarCell, for date: Date, at position: FSCalendarMonthPosition) {
        let diyCell = (cell as! DIYCalendarCell)
        // Custom today circle
        print("CURRENT CELL===================================")
        print(date)
        print(position)
        
        diyCell.circleImageView.isHidden = !self.gregorian.isDateInToday(date)
        diyCell.circleImageView.isHidden = true
        diyCell.backgroundView?.backgroundColor = self.colorForDate(date: date)
    }
    
    fileprivate func colorForDate(date : Date)-> UIColor {
        var  color : UIColor = .white
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "dd MMM"
        let currentdate =  dateformatter.string(from: date)
        let status = self.getCellColor(date: String(currentdate))
        if(status == "0" ){
            color = .systemYellow
        }
        else if(status == "1"){
            color = .systemGreen
        }
        else if(status == "2"){
            color = .systemRed
        }
        else if(status == "4"){
            color = .systemBlue
        }
        return color
    }
    
    
    //MARK:- CellColor
    fileprivate func getCellColor(date : String) -> String{
        var status : String! = ""
        var stmt:OpaquePointer?
        let queryString = "select distinct substr(date,6,8) as dateSubStr,status from Calender where dateSubStr like '%" + date + "%' "
        print("Cell Color Query===========================================================")
        print(queryString)
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
    fileprivate func getActivityName(date : String) -> String {
        var activityName : String! = ""
        var stmt:OpaquePointer?
        let queryString = "select distinct substr(date,6,8) as dateSubStr,activitY_NAME  from Calender where dateSubStr like '%" + date + "%' "
        print("SHORTDESCRIPTIONQUERY=======================================================")
        print(queryString)
        if sqlite3_prepare_v2(DatabaseConnection.dbs, queryString, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(DatabaseConnection.dbs)!)
            print("error preparing get: \(errmsg)")
        }
        while(sqlite3_step(stmt) == SQLITE_ROW){
            activityName = String(cString: sqlite3_column_text(stmt, 1))
        }
        return activityName
    }
    
    //MARK:- BlockDayReason
    fileprivate func getReasonName(date : String) -> String {
        var reasonName : String! = ""
        var stmt:OpaquePointer?
        let queryString = "select distinct substr(date,6,8) as dateSubStr,blocK_REASON  from Calender where dateSubStr like '%" + date + "%' "
        print("SHORTDESCRIPTIONQUERY=======================================================")
        print(queryString)
        if sqlite3_prepare_v2(DatabaseConnection.dbs, queryString, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(DatabaseConnection.dbs)!)
            print("error preparing get: \(errmsg)")
        }
        while(sqlite3_step(stmt) == SQLITE_ROW){
            reasonName = String(cString: sqlite3_column_text(stmt, 1))
        }
        return reasonName
    }
    
    //MARK:- ShortDescription
    fileprivate func getShortDescription(date : String) -> String {
        var shortdesc : String! = ""
        var stmt:OpaquePointer?
        let queryString = "select distinct substr(date,6,8) as dateSubStr,shorT_DESC  from Calender where dateSubStr like '%" + date + "%' "
        print("SHORTDESCRIPTIONQUERY=======================================================")
        print(queryString)
        if sqlite3_prepare_v2(DatabaseConnection.dbs, queryString, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(DatabaseConnection.dbs)!)
            print("error preparing get: \(errmsg)")
        }
        while(sqlite3_step(stmt) == SQLITE_ROW){
            shortdesc = String(cString: sqlite3_column_text(stmt, 1))
        }
        return shortdesc
    }
    
    //MARK:- SIDE BAR
//    func menuGestures(){
//        menuvc = (self.storyboard?.instantiateViewController(withIdentifier: "menuViewController") as! menuViewController)
//        let swiperyt = UISwipeGestureRecognizer(target: self, action: #selector(self.gesturerecognise))
//        swiperyt.direction = UISwipeGestureRecognizerDirection.right
//        let swipelft = UISwipeGestureRecognizer(target: self, action: #selector(self.gesturerecognise))
//        swipelft.direction = UISwipeGestureRecognizerDirection.left
//        self.view.addGestureRecognizer(swiperyt)
//        self.view.addGestureRecognizer(swipelft)
//    }
    
//    @IBAction func sidebarbtn(_ sender: UIBarButtonItem) {
//        if AppDelegate.menubool{
//            showmenu()
//        }
//        else {
//            hidemenu()
//        }
//    }
//    func showmenu()
//    {
//        UIView.animate(withDuration: 0.4){ ()->Void in
//            self.menuvc.view.frame = CGRect(x: 0, y: 60, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
//            self.menuvc.view.backgroundColor = UIColor.black.withAlphaComponent(0.0)
//            self.addChildViewController(self.menuvc)
//            self.view.addSubview(self.menuvc.view)
//            AppDelegate.menubool = false
//        }
//    }
//    func hidemenu ()
//    {
//        UIView.animate(withDuration: 0.3, animations: { ()->Void in
//            self.menuvc.view.frame = CGRect(x: -UIScreen.main.bounds.width, y: 60, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
//        }) { (finished) in
//            self.menuvc.view.removeFromSuperview()
//        }
//        AppDelegate.menubool = true
//    }
//    @objc
//    func gesturerecognise (gesture : UISwipeGestureRecognizer)
//    {
//        switch gesture.direction {
//        case UISwipeGestureRecognizerDirection.left :
//            hidemenu()
//            break
//        case UISwipeGestureRecognizerDirection.right :
//            showmenu()
//            break
//        default:
//            break
//        }
//    }
    
    func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        var rgbValue:UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(0.44)
        )
    }
}
//extension UINavigationController {
//
//override open var shouldAutorotate: Bool {
//    get {
//        if let visibleVC = visibleViewController {
//            return visibleVC.shouldAutorotate
//        }
//        return super.shouldAutorotate
//    }
//}
//
//override open var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation{
//    get {
//        if let visibleVC = visibleViewController {
//            return visibleVC.preferredInterfaceOrientationForPresentation
//        }
//        return super.preferredInterfaceOrientationForPresentation
//    }
//}
//
//override open var supportedInterfaceOrientations: UIInterfaceOrientationMask{
//    get {
//        if let visibleVC = visibleViewController {
//            return visibleVC.supportedInterfaceOrientations
//        }
//        return super.supportedInterfaceOrientations
//    }
//}
//
//}
