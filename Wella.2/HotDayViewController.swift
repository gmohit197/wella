//
//  HotDayViewController.swift
//  Wella.2
//
//  Created by Acxiom Consulting on 03/02/21.
//  Copyright © 2021 Acxiom. All rights reserved.
//

//MARK:- IMPORTS
import UIKit
import Dropdowns
import SQLite3
import Alamofire
import SystemConfiguration
import SwiftEventBus
import CoreLocation


//MARK:- BEGIN
class HotDayViewController: ExecuteApi , CLLocationManagerDelegate ,  UITableViewDelegate, UITableViewDataSource , UITextViewDelegate {
    
    //MARK:- TABLE VIEW METHODS
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return hotdaylistdata.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HotDayCell", for:  indexPath) as! HotDayCell
        
        let list: HotDayListAdapter
        list = hotdaylistdata[indexPath.row]
        cell.salonCode.text = list.saloncode
        cell.salonName.text = list.salonname
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if(editingStyle == .delete){
            presentDeletionFailsafe(indexPath: indexPath)
            
        }
    }
    func presentDeletionFailsafe(indexPath: IndexPath) {
        let alert = UIAlertController(title: nil, message: "Are you sure you'd like to delete this Line", preferredStyle: .alert)
                // yes action
        let yesAction = UIAlertAction(title: "Yes", style: .default) { _ in
                // replace data variable with your own data array
        let element = self.salonCodeSelectedarray[indexPath.row]
        self.delethotdaymarketvisitPostTableData(saloncode: element)
            self.setList(trainingtypeStr: "Hot Day")

                    }
        
        alert.addAction(yesAction)
        // cancel action
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    //MARK:- OUTLETS
    @IBOutlet weak var datetextField : UITextField!
    @IBOutlet weak var salonNameDropDown : DropDown!
    @IBOutlet weak var salonCodeDropDown : DropDown!
    @IBOutlet weak var salonAddressLabel : UILabel!
    @IBOutlet weak var addSalonBtn : UIButton!
    @IBOutlet weak var saveBtn : UIButton!
    @IBOutlet weak var hotdayTable: UITableView!
    @IBOutlet weak var remarkView: UIView!
    @IBOutlet weak var remarkText : UITextView!


    var hotdaylistdata = [HotDayListAdapter]()
    var salonCodeStr1 : String! = ""
    var salonNameStr1 : String! = ""
    
    @IBAction func saveBtnClick(_ sender: UIButton) {
        if(hotdaylistdata.count>0){
            saveBtnClick()
        }
        else {
            self.showtoast(controller: self, message: "Please Add Salon First", seconds: 1.0)
        }
    }
    @IBAction func addSalonBtnClick(_ sender: UIButton) {
        addSalonBtnClickFunc()
    }
    
    //MARK:- VARIABLE DECLARTION
    var menuvc: menuViewController!
    var salonCode : String! = ""
    var salonName : String! = ""
    var salonAddress : String! = ""
    var salonPsrCode : String! = ""
    var salonSiteCode : String! = ""
    var locationManager:CLLocationManager!
    var lat: String! = ""
    var longi: String! = ""
    let datetime: String? = nil
    var datePicker: UIDatePicker?
    var datePicker2 : UIDatePicker?
    var date = Date()
    let formatter = DateFormatter()
    
    var salonCodeSelectedarray : [String]! = []
    var salonCodearray : [String]! = []
    var salonNamearray : [String]! = []
    var salonAddressarray : [String]! = []
    var salonSiteCodearray : [String]! = []
    var salonPsrCodearray : [String]! = []
    var TRNAPPID : String! = ""
    
    //MARK:- VIEW DID LOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        let value = UIInterfaceOrientation.portrait.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
        self.view.addSubview(remarkView)
        setUpSideBar()
        determineMyCurrentLocation()
        self.setList(trainingtypeStr: "Hot Day")
        fillDropDownData()
        setupOnClicksalonCode()
        setupOnClickSalonName()
        setUpDate()
        self.TRNAPPID = UserDefaults.standard.string(forKey: "userid")! + getTodayStringNew()
    }
    //MARK:- SETUPDATE
    fileprivate func setUpDate(){
        formatter.dateFormat = "dd-MMM-yyyy"
        let result = formatter.string(from: date)
        datetextField.text = result
    }
    
    //MARK:- SETUPDATA
    fileprivate func setupPreFilledData(){
        // let PostHotDayMarketVisit = "CREATE TABLE IF NOT EXISTS hotdaymarketvisit(trnappid text,trainercode text,trainingtype text,salonname text, saloncode text , location text , lat text , long text , trainingdate text , salonaddress text , post text,sitecode text,sellercode text,isedit text)"
        var stmt:OpaquePointer?
        let queryString = "SELECT trainingdate,salonname,saloncode,salonaddress FROM hotdaymarketvisit"
        if sqlite3_prepare_v2(DatabaseConnection.dbs, queryString, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(DatabaseConnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return
        }
        while(sqlite3_step(stmt) == SQLITE_ROW){
            let datetextFieldStr = String(cString: sqlite3_column_text(stmt, 0))
            let salonNameDropDownStr = String(cString: sqlite3_column_text(stmt, 1))
            let salonCodeDropDownStr = String(cString: sqlite3_column_text(stmt, 2))
            let salonAddressLabelStr = String(cString: sqlite3_column_text(stmt, 3))
            
            datetextField.text! = datetextFieldStr
            salonNameDropDown.text! = salonNameDropDownStr
            salonCodeDropDown.text! = salonCodeDropDownStr
            salonAddressLabel.text! = salonAddressLabelStr
        }
        self.setList(trainingtypeStr: "Hot Day")
    }
    
    // public func deletePostSuccess(){}
    //   public func deletePostFailure(){}
   //    public func deletePostError(){}
    

    //MARK:- OVERRIDE
    override func deletePostSuccess(){
        if(self.validateNetwork()){
            self.postHotDayData(trainingtype: "Hot Day")
        }
    }
//    override func deletePostFailure(){
//        self.showtoast(controller: self, message: "Data Not Submitted", seconds: 1.0)
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
//                   self.push(vcId: "dashnc", vc: self)
//               }
//    }
//    override func deletePostError(){
//        self.showtoast(controller: self, message: "Network Connection Failed , Please Try Again Later! ", seconds: 1.0)
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
//                   self.push(vcId: "dashnc", vc: self)
//               }
//    }

    
    //MARK:- OVERRIDE
    override func hotDayPostSuccess(){
        self.showtoast(controller: self, message: "Data Submitted Successfully", seconds: 1.0)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.push(vcId: "dashnc", vc: self)
        }
    }
    override func hotDayPostFailure(){
        self.showtoast(controller: self, message: "Network Connection Failed , Please Try Again Later! ", seconds: 1.0)
    }
    override func hotDayPostError(){
        self.showtoast(controller: self, message: "Data Not Submitted", seconds: 1.0)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.push(vcId: "dashnc", vc: self)
        }
    }
    
    //MARK:- SAVE BTNCLICK
    func saveBtnClick(){
        self.remarkText.text = "Enter Remark........"
        self.remarkText.textColor = UIColor.lightGray
        self.remarkView.isHidden = false
    }
    //MARK:- ADD SALON BTN CLICK
    func addSalonBtnClickFunc(){
        if(validation() && checkList(saloncodeStr: self.salonCode!) && validateNetwork()){
            do{
                self.insertHotDayPost(trainercode: UserDefaults.standard.string(forKey: "userid")!, saloncode: self.salonCode!, salonaddress: self.salonAddress!, trnappid: self.TRNAPPID!, salonname: self.salonName!, lat: lat, long: longi, trainingdate: datetextField.text!, sitecode: self.salonSiteCode!, sellercode: self.salonPsrCode!, trainingtype: "Hot Day", post: "0")
                self.setList(trainingtypeStr: "Hot Day")
                self.salonNameDropDown.text! = ""
                self.salonCodeDropDown.text! = ""
                self.salonAddressLabel.text! = "Salon Address"
            }
        }
    }
    //MARK:- INTERNET CHECK
    fileprivate func validateNetwork() -> Bool{
        self.checknet()
        if(AppDelegate.ntwrk>0){
            return true
        }
        self.showtoast(controller: self, message: "Please Check Your Internet Connection", seconds: 1.0)
        return false
    }
    
    //MARK:- VALIDATION
    fileprivate func validation() -> Bool {
//        var salonkanaame : String! = ""
//        if(salonNameDropDown.text!.contains("'")){
//          salonkanaame = salonNameDropDown.text!.replacingOccurrences(of: "'", with: "")
//
//        }
//        else {
//            salonkanaame = String(salonNameDropDown.text!.prefix(5))
//
//        }
        salonNameStr1 =  self.getSalonName(saloncode: salonCodeDropDown.text!)
        salonCodeStr1 =  self.getSalonCode(salonName:salonNameDropDown.text!)
        do{
            if(datetextField.text!.isEmpty || datetextField.text! == ""){
                self.showtoast(controller: self, message: "Please Enter Date", seconds: 1.0)
                return false
            }
            else  if(salonNameDropDown.text == nil || self.salonName == nil ||     salonNameDropDown.text!.isEmpty || salonNameDropDown.text! == "" || salonNameDropDown.text! == "Select Salon" || self.salonName.isEmpty || self.salonName! == ""){
                self.showtoast(controller: self, message: "Please Select Salon Name", seconds: 1.0)
                return false
            }
            else  if(salonCodeDropDown.text == nil || self.salonCode == nil ||     salonCodeDropDown.text!.isEmpty || salonCodeDropDown.text! == "" || salonCodeDropDown.text! == "Select Salon Code" || self.salonCode.isEmpty || self.salonCode! == ""){
                self.showtoast(controller: self, message: "Please Select Salon Code", seconds: 1.0)
                return false
            }
            else  if(salonAddressLabel.text!.isEmpty || salonAddressLabel.text! == "" || salonAddressLabel.text! == "Salon Address"){
                self.showtoast(controller: self, message: "Please Enter Salon Address", seconds: 1.0)
                return false
            }
            else if(self.salonNameStr1.isEmpty || self.salonNameStr1! == "" ){
                           self.showtoast(controller: self, message: "Please Select Salon Code", seconds: 1.0)
                           return false
                       }
                       else if(self.salonCodeStr1.isEmpty || self.salonCodeStr1! == "" ){
                           self.showtoast(controller: self, message: "Please Select Salon Name", seconds: 1.0)
                           return false
                       }
        }
        return true
    }
    
    //MARK:- FILL DROP DOWN
    func fillDropDownData () {
        fillSalonNameData()
    }
    
    //MARK:- SALON DROP
    fileprivate func fillSalonNameData(){
        salonNamearray.removeAll()
        salonCodearray.removeAll()
        salonAddressarray.removeAll()
        salonPsrCodearray.removeAll()
        salonSiteCodearray.removeAll()
        
        salonNameDropDown.optionArray.removeAll()
        salonCodeDropDown.optionArray.removeAll()
        
        var stmt:OpaquePointer?
        let queryString = "SELECT * FROM salon"
        if sqlite3_prepare_v2(DatabaseConnection.dbs, queryString, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(DatabaseConnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return
        }
        while(sqlite3_step(stmt) == SQLITE_ROW){
            let salonCodeStr = String(cString: sqlite3_column_text(stmt, 0))
            let salonNameStr = String(cString: sqlite3_column_text(stmt, 1))
            let salonAddressStr = String(cString: sqlite3_column_text(stmt, 2))
            let salonSiteCodeStr = String(cString: sqlite3_column_text(stmt, 3))
            let salonPsrCodeStr = String(cString: sqlite3_column_text(stmt, 4))
            
            
            salonNameDropDown.optionArray.append(salonNameStr)
            salonCodeDropDown.optionArray.append(salonCodeStr)
            
            salonCodearray.append(salonCodeStr)
            salonNamearray.append(salonNameStr)
            salonAddressarray.append(salonAddressStr)
            salonPsrCodearray.append(salonPsrCodeStr)
            salonSiteCodearray.append(salonSiteCodeStr)
        }
    }
    //MARK:- SALON CODE CLICK
    fileprivate func setupOnClicksalonCode(){
        salonCodeDropDown.didSelect{(selectedText , index ,id) in
            print("Selected String: \(selectedText) \n index: \(index)")
            self.salonCode = self.salonCodearray[index]
            self.salonName = self.salonNamearray[index]
            self.salonAddress = self.salonAddressarray[index]
            self.salonSiteCode = self.salonSiteCodearray[index]
            self.salonPsrCode = self.salonPsrCodearray[index]
            
            self.salonCodeDropDown.text! = self.salonCode!
            self.salonNameDropDown.text! = self.salonName!
            self.salonAddressLabel.text! = self.salonAddress!
        }
    }
    //MARK:- SALON NAME CLICK
    fileprivate func setupOnClickSalonName(){
        salonNameDropDown.didSelect{(selectedText , index ,id) in
            print("Selected String: \(selectedText) \n index: \(index)")
            self.salonCode = self.salonCodearray[index]
            self.salonName = self.salonNamearray[index]
            self.salonAddress = self.salonAddressarray[index]
            self.salonSiteCode = self.salonSiteCodearray[index]
            self.salonPsrCode = self.salonPsrCodearray[index]
            
            self.salonCodeDropDown.text! = self.salonCode!
            self.salonNameDropDown.text! = self.salonName!
            self.salonAddressLabel.text! = self.salonAddress!
        }
    }
    //MARK:- SIDE BAR
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
    
    //MARK:- SETLIST
     func setList(trainingtypeStr : String?)
       {
           self.salonCodeSelectedarray.removeAll()
           self.hotdaylistdata.removeAll()
           self.hotdayTable.isHidden = false
           var stmt4:OpaquePointer?
           let queryString = "SELECT saloncode, salonname FROM hotdaymarketvisit where  trainingtype = '" + trainingtypeStr! + "'"
        print("setList"+queryString)
        if sqlite3_prepare_v2(DatabaseConnection.dbs, queryString, -1, &stmt4, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(DatabaseConnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return
        }
        while(sqlite3_step(stmt4) == SQLITE_ROW){
            let saloncodeStr = String(cString: sqlite3_column_text(stmt4, 0))
            let salonnameStr = String(cString: sqlite3_column_text(stmt4, 1))
            self.hotdaylistdata.append(HotDayListAdapter(saloncode: saloncodeStr, salonname: salonnameStr))
            salonCodeSelectedarray.append(saloncodeStr)
            print("Set List Array ===========================================")
            print( salonCodeSelectedarray!)
        }
        self.hotdayTable.reloadData()
    }
    //MARK:- CHECK LIST
    func checkList(saloncodeStr : String?) -> Bool
    {
        self.hotdaylistdata.removeAll()
        self.hotdayTable.isHidden = false
        var stmt4:OpaquePointer?
        let queryString = "SELECT saloncode, salonname FROM hotdaymarketvisit where  saloncode = '" + saloncodeStr! + "' and trainingtype = 'Hot Day'  "
        print("setList"+queryString)
        if sqlite3_prepare_v2(DatabaseConnection.dbs, queryString, -1, &stmt4, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(DatabaseConnection.dbs)!)
            print("error preparing get: \(errmsg)")
        }
        while(sqlite3_step(stmt4) == SQLITE_ROW){
            self.salonNameDropDown.text! = ""
            self.salonCodeDropDown.text! = ""
            self.salonAddressLabel.text! = "Salon Address"
            
            self.showtoast(controller: self, message: "Please Select Different Salon", seconds: 1.0)
            return false;
        }
        return true
    }
    
    
    
    //MARK:- LOCATION
    func determineMyCurrentLocation() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
            //locationManager.startUpdatingHeading()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation:CLLocation = locations[0] as CLLocation
        
        // Call stopUpdatingLocation() to stop listening for location updates,
        // other wise this function will be called every time when user location changes.
        
        // manager.stopUpdatingLocation()
        
        print("user latitude = \(userLocation.coordinate.latitude)")
        print("user longitude = \(userLocation.coordinate.longitude)")
        lat = String(userLocation.coordinate.latitude)
        longi = String(userLocation.coordinate.longitude)
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    {
        print("Error \(error)")
    }
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        let value = UIInterfaceOrientation.portrait.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
    }
    
    //MARK:- TEXTVIEW NIL
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    //MARK:- OK BTN CLICK
    @IBAction func CancelBtnclick(_ sender : UIButton){
        self.remarkView.isHidden = true
    }

    
    //MARK:- OK BTN CLICK
    @IBAction func OKBtnclick(_ sender : UIButton){
        if !(remarkText.text! == "" || remarkText.text! == "Enter Remark........" ){
            if(self.validateNetwork()){
                self.updatehotdaymarketvisitremark(remark: remarkText.text!,trainingType: "Hot Day")
                self.remarkView.isHidden = true
                saveBtn.isEnabled = false
                self.postDeleteData(ActivityType: "Hot Day")
            }
        }
        else{
            self.showtoast(controller: self, message: "Please Enter Remark", seconds: 1.0)
        }
    }

}
