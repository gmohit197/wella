//
//  dashboardViewController.swift
//  Wella.2
//
//  Created by Acxiom on 22/08/18.
//  Copyright © 2018 Acxiom. All rights reserved.
//

import UIKit
import Charts
import JTAppleCalendar
import Alamofire
import SQLite3

class dashboardViewController: ExecuteApi, UITableViewDelegate,UITableViewDataSource {
    
    var db: OpaquePointer?
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listdata.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! DashboardTableViewCell
        let list: dashboardlistview
        list = listdata[indexPath.row]
        
        cell.brandlabel.text = list.product
        cell.distribution_mtd.text = list.distri_mtd
        cell.distribution_ytd.text = list.distri_ytd
        cell.volume_mtd.text = list.volume_mtd
        cell.volume_ytd.text = list.volume_ytd
        return cell
    }
    var listdata = [dashboardlistview]()
    var menuvc : menuViewController!
    @IBOutlet weak var listview: UITableView!
    @IBOutlet weak var applecalendar: JTAppleCalendarView!
    @IBOutlet weak var year: UILabel!
    @IBOutlet weak var month: UILabel!
    @IBOutlet weak var piechart: PieChartView!
    @IBOutlet weak var doors: UILabel!
    @IBOutlet weak var stylisttrained: UILabel!
    @IBOutlet weak var uniquedoor: UILabel!
    @IBOutlet weak var gold: UILabel!
    @IBOutlet weak var silver: UILabel!
    @IBOutlet weak var key: UILabel!
    @IBOutlet weak var others: UILabel!
    @IBOutlet weak var scrollview: UIScrollView!
    @IBOutlet var dashboardview: UIView!
    
    @IBAction func salontracking(_ sender: UIButton) {
        let salontraking: salontracking = self.storyboard?.instantiateViewController(withIdentifier: "salontracking") as! salontracking
        self.navigationController?.pushViewController(salontraking, animated: true)
    }
  
    let formatter = DateFormatter()
    let outsidemonthcolor = UIColor.lightGray
    let monthcolor = UIColor.black
    let selectedmonthcolor = UIColor.white
    let currentdatecolor = UIColor.green
    
    var goldDataEntry = PieChartDataEntry(value: 1.85)
    var kaelDataEntry = PieChartDataEntry(value: 0.16)
    var kaptDataEntry = PieChartDataEntry(value: 0.03)
    var silverDataEntry = PieChartDataEntry(value: 0.06)
    
    var salondata = [PieChartDataEntry]()
    
    
    var database: DatabaseConnection?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
        activityIndicator.center = CGPoint(x: view.bounds.size.width/2, y: view.bounds.size.height/2)
        activityIndicator.color = UIColor.black
        view.addSubview(activityIndicator)
        
        view.isUserInteractionEnabled = false
        activityIndicator.startAnimating()
        print("loader activated")
        AppDelegate.menubool = true
        menuvc = self.storyboard?.instantiateViewController(withIdentifier: "menuViewController") as! menuViewController
        let swiperyt = UISwipeGestureRecognizer(target: self, action: #selector(self.gesturerecognise))
        swiperyt.direction = UISwipeGestureRecognizerDirection.right
        
        let swipelft = UISwipeGestureRecognizer(target: self, action: #selector(self.gesturerecognise))
        swipelft.direction = UISwipeGestureRecognizerDirection.left
        
        self.view.addGestureRecognizer(swiperyt)
        self.view.addGestureRecognizer(swipelft)
        
        
        self.setUpLabels()
        self.setupcalendarview()
        self.setchart()
        self.setlist()
        self.setDashboarddata()
        
        activityIndicator.stopAnimating()
        self.view.isUserInteractionEnabled = true
        
        print("loader deactivated")
    }
    
    func setUpLabels(){
        goldDataEntry.label = "Gold"
        kaelDataEntry.label = "KA-EL"
        kaptDataEntry.label = "KA-PT"
        silverDataEntry.label = "Silver"
    }
    
    
    func setDashboarddata(){
        self.doors.text = UserDefaults.standard.string(forKey: "doorstrained")
        self.stylisttrained.text = UserDefaults.standard.string(forKey: "stylisttrained")
        self.uniquedoor.text = UserDefaults.standard.string(forKey: "uniquedoorstrained")
        
        self.gold.text = UserDefaults.standard.string(forKey:  "gold")
        self.silver.text = UserDefaults.standard.string(forKey: "silver")
        self.key.text = UserDefaults.standard.string(forKey: "key")
        self.others.text = UserDefaults.standard.string(forKey: "others")

    }
    
    func setlist()
    {
        
        self.listdata.removeAll()
        var stmt1:OpaquePointer?
        let queryString = "SELECT * FROM Brand"
       
        if sqlite3_prepare_v2(DatabaseConnection.dbs, queryString, -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(DatabaseConnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return
        }
        
        while(sqlite3_step(stmt1) == SQLITE_ROW){
            //String(cString: sqlite3_column_text(stmt, 1))
            let product1 = String(cString: sqlite3_column_text(stmt1, 0))
            let distriytd1 = String(cString: sqlite3_column_text(stmt1, 1))
            let volumeytd1 = String(cString: sqlite3_column_text(stmt1, 2))
            let distrimtd1 = String(cString: sqlite3_column_text(stmt1, 3))
            let volumemtd1 = String(cString: sqlite3_column_text(stmt1, 4))
//            let queryResultCol1 = sqlite3_column_text(stmt1, 0)
//            let product = String(cString: queryResultCol1!)
//
            print("\n")
            //print("get============product: \(String(describing: product1))")
            print("get============product: \(String(describing: product1))")
            print("get============distrimtd:\(String(describing: distrimtd1))")
            print("get============distriytd:\(String(describing: distriytd1))")
            print("get============volumemtd:\(String(describing: volumemtd1))")
            print("get============volumeytd:\(String(describing: volumeytd1))")
            
            self.listdata.append(dashboardlistview(product: product1, distri_mtd: distrimtd1, distri_ytd: distriytd1, volume_mtd: volumemtd1, volume_ytd: volumeytd1))
            
        }
        self.listview.reloadData()
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
        
        self.formatter.dateFormat = "yyyy"
        //self.year.text = formatter.string(from: date)
        self.year.text = "2019"
        
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
    
    
    func setchart()
    {
        goldDataEntry.value = UserDefaults.standard.double(forKey: "goldvalue")
        kaelDataEntry.value = UserDefaults.standard.double(forKey: "kaelvalue")
        kaptDataEntry.value = UserDefaults.standard.double(forKey: "kaptvalue")
        silverDataEntry.value = UserDefaults.standard.double(forKey: "silvervalue")
        
        salondata = [goldDataEntry,kaelDataEntry,kaptDataEntry,silverDataEntry]
        
        let pieChartDataSet = PieChartDataSet(values: salondata, label: "")
        pieChartDataSet.colors = [UIColor.blue,UIColor.brown,UIColor.cyan,UIColor.green]
        let pieChartData = PieChartData(dataSet: pieChartDataSet)
        piechart.data = pieChartData
        piechart.centerText = ""
        piechart.chartDescription?.text = ""
        piechart.usePercentValuesEnabled = false
        piechart.legend.horizontalAlignment = .center
    }
    
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
    
    @IBAction func sidebtn(_ sender: UIBarButtonItem) {
        
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
    
    @IBAction func bell(_ sender: UIBarButtonItem) {
          self.push(vcId: "notificationc", vc: self)
      //  self.performSegue(withIdentifier: "notification", sender: (Any).self)
        
    }
}



extension dashboardViewController:JTAppleCalendarViewDataSource {
    
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
        
        
        let startDate = formatter.date(from: "2018 01 01")!
        let endDate  = formatter.date(from: "2018 12 31")!
        
        
        
        let parameters = ConfigurationParameters(startDate: startDate, endDate: endDate)
        return parameters
    }
    
    
}
extension dashboardViewController: JTAppleCalendarViewDelegate {
    
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
