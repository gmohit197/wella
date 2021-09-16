
//  HomeViewController.swift
//  Wella.2
//
//  Created by Acxiom Consulting on 01/03/21.
//  Copyright © 2021 Acxiom. All rights reserved.
//

import UIKit
import Charts
import JTAppleCalendar
import Alamofire
import SQLite3
import PieCharts
import SwiftEventBus

class HomeViewController: ExecuteApi , UITableViewDelegate , UITableViewDataSource , ChartViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return(tableView == prodTableView) ? prodListAdapter.count : unprodListAdapter.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == prodTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "prodcell") as! ProductiveTableViewCell
            let list: ProdListAdapter
            list = prodListAdapter[indexPath.row]
            cell.customercode.text = list.customercode
            return cell
        }
        
        if tableView == unprodTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "unprodcell") as! UnProductiveTableViewCell
            let list: UnProdListadapter
            list = unprodListAdapter[indexPath.row]
            cell.customercode.text = list.customercode
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == prodTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "prodcell") as! ProductiveTableViewCell
            let list: ProdListAdapter
            list = prodListAdapter[indexPath.row]
            AppDelegate.salonCodeSalonTracking = list.customercode
            print("DIDSELECTCALLED====================================")
            DispatchQueue.main.async{
            self.pushnext(identifier: "SalonTrackingVC", controller: self)
            }
        }
    }


@IBOutlet weak var uniqueDoorsLabel: UILabel!
@IBOutlet weak var topDoorsLabel: UILabel!
@IBOutlet weak var stylistsLabel: UILabel!
@IBOutlet weak var trainingLabel: UILabel!
@IBOutlet weak var trainingLineChart: LineChartView!
@IBOutlet weak var stylistsLineChart: LineChartView!
@IBOutlet weak var pieChartView: PieChartView!
@IBOutlet weak var trainingCardView: CardView!
@IBOutlet weak var stylistsCardView: CardView!
@IBOutlet weak var uniqueDoorsCardView: CardView!
@IBOutlet weak var topDoorsCardView: CardView!
@IBOutlet weak var productivityCardView: CardView!

@IBOutlet weak var date: UILabel!
@IBOutlet weak var dialogHeaderLabel: UILabel!
@IBOutlet weak var dialogTargetLabel: UILabel!
@IBOutlet weak var dialogAchmtLabel: UILabel!
@IBOutlet weak var dialogInSalonLabel: UILabel!
@IBOutlet weak var dialogVirtualLabel: UILabel!
@IBOutlet weak var dialogWorkshopLabel: UILabel!
@IBOutlet weak var trainingStackView: UIStackView!
@IBOutlet weak var detailsView: UIView!
@IBOutlet weak var productivityView: UIView!

@IBOutlet weak var prodDoors: UILabel!
@IBOutlet weak var prodTotDoors: UILabel!
@IBOutlet weak var prodDoorLastMnth: UILabel!
@IBOutlet weak var prodDoorsYTD: UILabel!
@IBOutlet weak var productivityCount: UILabel!

@IBOutlet weak var unprodTableView: UITableView!
@IBOutlet weak var prodTableView: UITableView!

var prodListAdapter = [ProdListAdapter]()
var unprodListAdapter = [UnProdListadapter]()
var salonCode : String!
var salonName : String!
var salonCodearray : [String]! = []
var salonNamearray : [String]! = []

var trainingLabelarray : [String]! = []


var months: [String]! = []
var ptarget: [Double]! = []
var pachmt: [Double]! = []

var salondata = [PieChartDataEntry]()
var colors: [UIColor]! = []
var menuvc : menuViewController!
var trainingTarget : String!
var stylistTarget : String!
var uniqueDoorTarget : String!
var topDoorTarget : String!
var trainingAch : String!
var stylistAch : String!
var uniqueDoorAch : String!
var topDoorAch : String!
var insalon : String!
var virtualTraining : String!
var workshop : String!

var prodDoorFTM : String! = ""
var totalDoorTrainedFTM : String! = ""
var prodDoorLastMonthFTM : String! = ""
var prodDoorsYTDStr : String! = ""
var productivityCountStr : String! = ""


    override func viewDidLoad() {
        super.viewDidLoad()
        let value = UIInterfaceOrientation.portrait.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
        viewDidLoadsetup()
        let date = Date()
        let monthString = date.currentMonth
        self.date.text! = monthString
        let tapDismissView = UITapGestureRecognizer(target: self, action:#selector(dismissDetailsView))
        view.addGestureRecognizer(tapDismissView)
        view.addSubview(detailsView)
        trainingLineChart.isUserInteractionEnabled = false
        stylistsLineChart.isUserInteractionEnabled = false
        setDashboardTile()
        setupOnClickOfLabels()
        setupTrainingLineChart()
        setupStylistLineChart()
        setupPieChart()
        setupProductivity()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        SwiftEventBus.onMainThread(self, name: "dashboardupdate") { (result) in
            DispatchQueue.main.asyncAfter(deadline: .now()+0.5) {
                self.setDashboardTile()
                self.setupOnClickOfLabels()
                self.setupTrainingLineChart()
                self.setupStylistLineChart()
                self.setupPieChart()
                self.setupProductivity()
                self.hidemenu()
            }
            self.hideSyncloader()
        }
    }
    
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        let value = UIInterfaceOrientation.portrait.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
    }
    

fileprivate func setupProductivity(){
    setupProdLabels()
    setUpProdList()
    setupUnProdList()
}

fileprivate func setupProdLabels(){
    var stmt1:OpaquePointer?
    let queryString = "SELECT * FROM HomeProd"
    
    if sqlite3_prepare_v2(DatabaseConnection.dbs, queryString, -1, &stmt1, nil) != SQLITE_OK{
        let errmsg = String(cString: sqlite3_errmsg(DatabaseConnection.dbs)!)
        print("error preparing get: \(errmsg)")
        return
    }
    
    while(sqlite3_step(stmt1) == SQLITE_ROW){
        prodDoorFTM = String(cString: sqlite3_column_text(stmt1, 0))
        totalDoorTrainedFTM = String(cString: sqlite3_column_text(stmt1, 1))
        prodDoorLastMonthFTM = String(cString: sqlite3_column_text(stmt1, 2))
        prodDoorsYTDStr = String(cString: sqlite3_column_text(stmt1, 3))
        productivityCountStr = String(cString: sqlite3_column_text(stmt1, 4))
        
        self.prodDoors.text! = prodDoorFTM
        self.prodTotDoors.text! = totalDoorTrainedFTM
        self.prodDoorLastMnth.text! = prodDoorLastMonthFTM
        self.prodDoorsYTD.text! = prodDoorsYTDStr
        self.productivityCount.text! = productivityCountStr + "%"
        
    }
}
fileprivate func setUpProdList(){
    
    // HomeProd_UnProd (typecustomer,customeR_CODE)
    self.prodListAdapter.removeAll()
    self.prodTableView.isHidden = false
    var stmt4:OpaquePointer?
    let typStr : String! = "PRODUCTIVE"
    let queryString = "SELECT customeR_CODE FROM HomeProd_UnProd  WHERE typecustomer = '" + typStr! + "'"
    //     let queryString = "SELECT * FROM salontrackingdata"
    
    print("SetList1"+queryString)
    if sqlite3_prepare_v2(DatabaseConnection.dbs, queryString, -1, &stmt4, nil) != SQLITE_OK{
        let errmsg = String(cString: sqlite3_errmsg(DatabaseConnection.dbs)!)
        print("error preparing get: \(errmsg)")
        return
    }
    
    while(sqlite3_step(stmt4) == SQLITE_ROW){
        
        let customercode = String(cString: sqlite3_column_text(stmt4, 0))
        
        self.prodListAdapter.append(ProdListAdapter(customercode: customercode))
        
        
    }
    self.prodTableView.reloadData()
    
}
fileprivate func setupUnProdList(){
    self.unprodListAdapter.removeAll()
    self.unprodTableView.isHidden = false
    var stmt4:OpaquePointer?
    let typStr : String! = "UNPRODUCTIVE"
    let queryString = "SELECT customeR_CODE FROM HomeProd_UnProd  WHERE typecustomer = '" + typStr! + "'"
    print("SetList1"+queryString)

    if sqlite3_prepare_v2(DatabaseConnection.dbs, queryString, -1, &stmt4, nil) != SQLITE_OK{
        let errmsg = String(cString: sqlite3_errmsg(DatabaseConnection.dbs)!)
        print("error preparing get: \(errmsg)")
        return
    }
    while(sqlite3_step(stmt4) == SQLITE_ROW){
        
        let customercode = String(cString: sqlite3_column_text(stmt4, 0))
        
        self.unprodListAdapter.append(UnProdListadapter(customercode: customercode))
    }
    self.unprodTableView.reloadData()
}

fileprivate func setupOnClickOfLabels(){
    let tapTraining = UITapGestureRecognizer(target: self, action:#selector(trainingCardViewClick))
    self.trainingCardView.addGestureRecognizer(tapTraining)
    let tapStylist = UITapGestureRecognizer(target: self, action:#selector(stylistCardViewClick))
    self.stylistsCardView.addGestureRecognizer(tapStylist)
    let tapTopDoor = UITapGestureRecognizer(target: self, action:#selector(topDoorCardViewClick))
    self.topDoorsCardView.addGestureRecognizer(tapTopDoor)
    let tapProductivity = UITapGestureRecognizer(target: self, action:#selector(productivityCardViewClick))
    self.productivityCardView.addGestureRecognizer(tapProductivity)
    
}
@objc
func dismissDetailsView() {
    detailsView.isHidden = true
}

@objc func productivityCardViewClick()
{
    view.backgroundColor = UIColor.gray
    view.addSubview(productivityView)
    productivityView.isHidden = false
    trainingStackView.isHidden = false
    dialogHeaderLabel.text! = "Training Conducted FTM"
    dialogTargetLabel.text! = trainingTarget
    dialogAchmtLabel.text! = trainingAch
    dialogInSalonLabel.text! = insalon
    dialogVirtualLabel.text! = virtualTraining
    dialogWorkshopLabel.text! = workshop
}


@objc func trainingCardViewClick()
{
    view.backgroundColor = UIColor.gray
   
    detailsView.isHidden = false
    trainingStackView.isHidden = false
    dialogHeaderLabel.text! = "Training Conducted FTM"
    dialogTargetLabel.text! = trainingTarget
    dialogAchmtLabel.text! = trainingAch
    dialogInSalonLabel.text! = insalon
    dialogVirtualLabel.text! = virtualTraining
    dialogWorkshopLabel.text! = workshop
}

@objc func stylistCardViewClick()
{
    detailsView.isHidden = false
    trainingStackView.isHidden = true
    dialogHeaderLabel.text! = "Stylist Trained FTM"
    dialogTargetLabel.text! = stylistTarget
    dialogAchmtLabel.text! = stylistAch
    
}

@objc func topDoorCardViewClick()
{
    detailsView.isHidden = false
    
    trainingStackView.isHidden = true
    dialogHeaderLabel.text! = "Top Doors Trained FTM"
    dialogTargetLabel.text! = topDoorTarget
    dialogAchmtLabel.text! = topDoorAch
    
}

fileprivate func setupTrainingLineChart(){
    setupTrainingLineChartData()
    initTrainingLineChart()
    setTrainingLineChartData(values: ptarget, dates: months)
}
fileprivate func setupStylistLineChart(){
    setupStylistLineChartData()
    initStylistLineChart()
    setStylistLineChartData(values: pachmt, dates: months)
}
fileprivate func setupPieChart(){
    setPiechart()
}
func initTrainingLineChart(){
    trainingLineChart.noDataText = "Chart Data not available!"
    
    trainingLineChart.chartDescription!.font = UIFont.boldSystemFont(ofSize: (trainingLineChart.chartDescription?.font.pointSize)!)
    //legend
    let legend = trainingLineChart.legend
    legend.enabled = true
    legend.horizontalAlignment = .left
    legend.verticalAlignment = .bottom
    legend.orientation = .horizontal
    legend.drawInside = false
    legend.yOffset = 10.0;
    legend.xOffset = 10.0;
    legend.yEntrySpace = 0.0;
    
    let description = trainingLineChart.chartDescription
    description?.xOffset = 10.0
    description?.yOffset = 310.0
    
    let xaxis = trainingLineChart.xAxis
    
    xaxis.drawGridLinesEnabled = true
    xaxis.labelPosition = .bottom
    xaxis.centerAxisLabelsEnabled = true
    xaxis.valueFormatter = IndexAxisValueFormatter(values:self.months)
    xaxis.granularity = 1
    xaxis.wordWrapEnabled = true
    xaxis.enabled = true
    xaxis.axisMinimum = 0.0
    xaxis.setLabelCount(6, force: true)
    
    self.trainingLineChart.xAxis.labelPosition = .bottom
    
    let leftAxisFormatter = NumberFormatter()
    leftAxisFormatter.maximumFractionDigits = 1
    
    let yaxis = trainingLineChart.leftAxis
    yaxis.spaceTop = 0.35
    yaxis.axisMinimum = 0.0
    yaxis.drawGridLinesEnabled = true
    
    trainingLineChart.rightAxis.enabled = false
    trainingLineChart.leftAxis.spaceBottom = 0.0
    
}

fileprivate func setTrainingLineChartData(values: [Double], dates: [String]) {
    var yValues : [ChartDataEntry] = [ChartDataEntry]()
    for i in 0 ..< dates.count {
        yValues.append(ChartDataEntry(x: Double(i), y: values[i]))
    }
    let data = LineChartData()
    let ds = LineChartDataSet(values: yValues, label: "ACHMT")
    ds.drawCirclesEnabled = true
    ds.lineWidth = 1
    ds.drawValuesEnabled = false
    ds.setColor(hexStringToUIColor(hex : "#7500ca"))
    ds.drawCircleHoleEnabled = false
    ds.setCircleColor(hexStringToUIColor(hex: "#7500ca"))
    ds.axisDependency = .right
    data.addDataSet(ds)
    self.trainingLineChart.data = data
}
func initStylistLineChart(){
    stylistsLineChart.noDataText = "Chart Data not available!"
    
    //legend
    let legend = stylistsLineChart.legend
    legend.enabled = true
    legend.horizontalAlignment = .left
    legend.verticalAlignment = .bottom
    legend.orientation = .horizontal
    legend.drawInside = false
    legend.yOffset = 10.0;
    legend.xOffset = 10.0;
    legend.yEntrySpace = 0.0;
    
    let description = stylistsLineChart.chartDescription
    description?.xOffset = 10.0
    description?.yOffset = 310.0
    
    let xaxis = stylistsLineChart.xAxis
    
    xaxis.drawGridLinesEnabled = true
    xaxis.labelPosition = .bottom
    xaxis.centerAxisLabelsEnabled = true
    xaxis.valueFormatter = IndexAxisValueFormatter(values:self.months)
    xaxis.granularity = 1
    xaxis.wordWrapEnabled = true
    xaxis.enabled = true
    
    self.stylistsLineChart.xAxis.labelPosition = .bottom
    
    let leftAxisFormatter = NumberFormatter()
    leftAxisFormatter.maximumFractionDigits = 1
    
    let yaxis = stylistsLineChart.leftAxis
    yaxis.spaceTop = 0.35
    yaxis.axisMinimum = 0.0
    yaxis.drawGridLinesEnabled = true
    stylistsLineChart.rightAxis.enabled = false
}

fileprivate func setStylistLineChartData(values: [Double], dates: [String]) {
    var yValues : [ChartDataEntry] = [ChartDataEntry]()
    for i in 0 ..< dates.count {
        yValues.append(ChartDataEntry(x: Double(i), y: values[i]))
    }
    let data = LineChartData()
    let ds = LineChartDataSet(values: yValues, label: "ACHMT")
    ds.drawCirclesEnabled = true
    ds.lineWidth = 1
    ds.drawValuesEnabled = false
    ds.setColor(hexStringToUIColor(hex : "#7500ca"))
    ds.drawCircleHoleEnabled = false
    ds.setCircleColor(hexStringToUIColor(hex: "#7500ca"))
    data.addDataSet(ds)
    self.stylistsLineChart.data = data
}
func setPiechart()
{
    self.pieChartView.delegate = self
    setupPieChartData()
    let color1 =     hexStringToUIColor(hex: "#fed8b1")
    let color2 =     hexStringToUIColor(hex: "#FEAE65")
    let color3 =     hexStringToUIColor(hex: "#E6F69D")
    let color4 =     hexStringToUIColor(hex: "#AADEA7")
    let color5 =     hexStringToUIColor(hex: "#64C2A6")
    let color6 =     hexStringToUIColor(hex: "#2D87BB")
    colors = [color1,color2,color3,color4,color5,color6]
    
    let pieChartDataSet = PieChartDataSet(values: salondata, label: "")
    pieChartDataSet.valueFormatter = DefaultValueFormatter()
    pieChartDataSet.colors = colors
    pieChartDataSet.selectionShift = 0
    let pieChartData = PieChartData(dataSet: pieChartDataSet)
    pieChartData.setValueTextColor(NSUIColor.black)
    
    pieChartView.data = pieChartData
    pieChartView.usePercentValuesEnabled = false
    pieChartView.drawHoleEnabled = false
    pieChartView.holeRadiusPercent = 0.0
    pieChartView.rotationEnabled = false
    pieChartView.drawEntryLabelsEnabled = false
    pieChartView.legend.enabled = false
    pieChartView.chartDescription?.enabled = false
    pieChartView.isUserInteractionEnabled = true
    pieChartView.highlightPerTapEnabled = true
    
}
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
        alpha: CGFloat(1.0)
    )
}
fileprivate func viewDidLoadsetup(){
    //        let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
    //        activityIndicator.center = CGPoint(x: view.bounds.size.width/2, y: view.bounds.size.height/2)
    //        activityIndicator.color = UIColor.black
    //        view.addSubview(activityIndicator)
    //
    //        view.isUserInteractionEnabled = false
    //        activityIndicator.startAnimating()
    //        print("loader activated")
    AppDelegate.menubool = true
    menuvc = self.storyboard?.instantiateViewController(withIdentifier: "menuViewController") as! menuViewController
    let swiperyt = UISwipeGestureRecognizer(target: self, action: #selector(self.gesturerecognise))
    swiperyt.direction = UISwipeGestureRecognizerDirection.right
    
    let swipelft = UISwipeGestureRecognizer(target: self, action: #selector(self.gesturerecognise))
    swipelft.direction = UISwipeGestureRecognizerDirection.left
    
    self.view.addGestureRecognizer(swiperyt)
    self.view.addGestureRecognizer(swipelft)
    
    
    //        self.setUpLabels()
    //        self.setupcalendarview()
    //        self.setchart()
    //        self.setlist()
    //        self.setDashboarddata()
    //
    //        activityIndicator.stopAnimating()
    //        self.view.isUserInteractionEnabled = true
    //
    //        print("loader deactivated")
    
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
// MARK:- DASHBOARD DATASETUP

func setDashboardTile()
{
    
    var stmt1:OpaquePointer?
    let queryString = "SELECT * FROM dsu"
    
    if sqlite3_prepare_v2(DatabaseConnection.dbs, queryString, -1, &stmt1, nil) != SQLITE_OK{
        let errmsg = String(cString: sqlite3_errmsg(DatabaseConnection.dbs)!)
        print("error preparing get: \(errmsg)")
        return
    }
    
    while(sqlite3_step(stmt1) == SQLITE_ROW){
        trainingTarget = String(cString: sqlite3_column_text(stmt1, 0))
        stylistTarget = String(cString: sqlite3_column_text(stmt1, 1))
        uniqueDoorTarget = String(cString: sqlite3_column_text(stmt1, 2))
        topDoorTarget = String(cString: sqlite3_column_text(stmt1, 3))
        trainingAch = String(cString: sqlite3_column_text(stmt1, 4))
        stylistAch = String(cString: sqlite3_column_text(stmt1, 5))
        uniqueDoorAch = String(cString: sqlite3_column_text(stmt1, 6))
        topDoorAch = String(cString: sqlite3_column_text(stmt1, 7))
        insalon = String(cString: sqlite3_column_text(stmt1, 8))
        virtualTraining = String(cString: sqlite3_column_text(stmt1, 9))
        workshop = String(cString: sqlite3_column_text(stmt1, 10))
        
        self.trainingLabel.text! = "FTM - " + trainingAch
        self.stylistsLabel.text! = "FTM - " + stylistAch
        self.uniqueDoorsLabel.text! = "FTM - " + uniqueDoorTarget
        self.topDoorsLabel.text! = "FTM - " + topDoorAch
        
    }
}
// MARK:- TRAINING CHART DATASETUP

fileprivate func setupTrainingLineChartData(){
    var stmt:OpaquePointer?
    months = []
    ptarget = []
    let queryString = "SELECT * FROM traininglinechart"
    
    if sqlite3_prepare_v2(DatabaseConnection.dbs, queryString, -1, &stmt, nil) != SQLITE_OK{
        let errmsg = String(cString: sqlite3_errmsg(DatabaseConnection.dbs)!)
        print("error preparing get: \(errmsg)")
        return
    }
    
    while(sqlite3_step(stmt) == SQLITE_ROW){
        
        let monthsStr = String(cString: sqlite3_column_text(stmt, 0))
        let pTargetStr = Double(String(cString: sqlite3_column_text(stmt, 1)))
        
        months.append(monthsStr)
        ptarget.append(pTargetStr!)
        
    }
}
// MARK:- STYLIST CHART DATASETUP
fileprivate func setupStylistLineChartData(){
    var stmt:OpaquePointer?
    months = []
    pachmt = []
    let queryString = "SELECT * FROM stylistlinechart"
    
    if sqlite3_prepare_v2(DatabaseConnection.dbs, queryString, -1, &stmt, nil) != SQLITE_OK{
        let errmsg = String(cString: sqlite3_errmsg(DatabaseConnection.dbs)!)
        print("error preparing get: \(errmsg)")
        return
    }
    
    while(sqlite3_step(stmt) == SQLITE_ROW){
        
        let monthsStr = String(cString: sqlite3_column_text(stmt, 0))
        let pAchStr = Double(String(cString: sqlite3_column_text(stmt, 1)))
        
        months.append(monthsStr)
        pachmt.append(pAchStr!)
        
    }
}
// MARK:- PIECHARTDATASETUP
fileprivate func setupPieChartData(){
    var stmt:OpaquePointer?
    salondata = []
    trainingLabelarray.removeAll()
    
    let queryString = "SELECT * FROM piechartdata"
    
    if sqlite3_prepare_v2(DatabaseConnection.dbs, queryString, -1, &stmt, nil) != SQLITE_OK{
        let errmsg = String(cString: sqlite3_errmsg(DatabaseConnection.dbs)!)
        print("error preparing get: \(errmsg)")
        return
    }
    
    while(sqlite3_step(stmt) == SQLITE_ROW){
        
        let pieChartLabels = String(cString: sqlite3_column_text(stmt, 0))
        let pieChartValues = Double(String(cString: sqlite3_column_text(stmt, 1)))
        
        salondata.append(PieChartDataEntry(value: pieChartValues!))
        trainingLabelarray.append(pieChartLabels)
        //  pachmt.append(pAchStr!)
        
    }
}
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        var description : String! = ""
        var index : Int! = 0
        index = Int(highlight.x)
//        description = getPieChartDescription(Value: String(highlight.y))
        description = trainingLabelarray[index]
        self.showtoast(controller: self, message: description, seconds: 1.0)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch: UITouch? = touches.first!
        //location is relative to the current view
        // do something with the touched point
        if touch?.view != productivityView {
            productivityView.isHidden = true
        }
        if touch?.view != detailsView {
            detailsView.isHidden = true
        }
    }
    
    // MARK:- PIECHARTDATASETUP
    fileprivate func getPieChartDescription(Value : String) -> String{
        var desc : String! = ""
        var stmt:OpaquePointer?
        let queryString = "SELECT trainingname FROM piechartdata   where cast(counttrainingcode as float) = '" + Value + "'"
        
        if sqlite3_prepare_v2(DatabaseConnection.dbs, queryString, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(DatabaseConnection.dbs)!)
            print("error preparing get: \(errmsg)")
        }
        
        while(sqlite3_step(stmt) == SQLITE_ROW){
            desc  = String(cString: sqlite3_column_text(stmt, 0))
        }
        return desc
    }
    
    
}

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
}
extension Date {
    var currentMonth: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM-yy"
        return dateFormatter.string(from: self)
    }
}

