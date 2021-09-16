//  MyWorkshopViewController.swift
//  Wella.2
//  Created by Acxiom Consulting on 13/03/21.
//  Copyright © 2021 Acxiom. All rights reserved.

//MARK:- IMPORTS

import UIKit
import Dropdowns
import SQLite3
import Alamofire
import SystemConfiguration
import SwiftEventBus
import CoreLocation

//MARK:- BEGIN
class MyWorkshopViewController: ExecuteApi , CLLocationManagerDelegate ,  UITableViewDelegate, UITableViewDataSource  , UITextViewDelegate {

    //MARK:- TABLE VIEW METHODS
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return workshopListAdapter.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "workshopcell", for:  indexPath) as! WorkshopTableViewCell
        let list: WorkshopListAdapter
        list = workshopListAdapter[indexPath.row]
        cell.stylistcode.text = list.stylistcode
        cell.stylistname.text = list.stylistname
        cell.saloncode.text = list.saloncode
        cell.salonname.text = list.salonname
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if(editingStyle == .delete){
            presentDeletionFailsafe(indexPath: indexPath)
        }
    }
    
    func presentDeletionFailsafe(indexPath: IndexPath) {
        let alert = UIAlertController(title: nil, message: "Are you sure you'd like to delete this Line", preferredStyle: .alert)
        let yesAction = UIAlertAction(title: "Yes", style: .default) { _ in
            let element = self.stylistCodeSelectedarray[indexPath.row]
            self.deletInsertWorkshopPostTableData(stylistcode: element)
            self.setList()
        }
        alert.addAction(yesAction)
        // cancel action
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    @IBOutlet weak var datetextField: UITextField!
    @IBOutlet weak var salonNameHeader: UILabel!
    @IBOutlet weak var salonCodeHeader: UILabel!
    @IBOutlet weak var stylistNameHeader: UILabel!
    @IBOutlet weak var stylistCodeHeader: UILabel!
    @IBOutlet weak var workshopTableView: UITableView!
    @IBOutlet weak var salonNameLabel: UILabel!
    @IBOutlet weak var stylistContactDropDown: DropDown!
    @IBOutlet weak var stylistCodeDropDown: DropDown!
    @IBOutlet weak var stylistNameDropDown: DropDown!
    @IBOutlet weak var activitySubjectDropDown: DropDown!
    @IBOutlet weak var trainingLoctextView: UITextView!
    @IBOutlet weak var day3WorkshopTextField: UITextField!
    @IBOutlet weak var day2WorkshopTextField: UITextField!
    @IBOutlet weak var Day3WorkshopStackView: UIStackView!
    @IBOutlet weak var Day2WorkshopStackView: UIStackView!
    @IBOutlet weak var multiDayWorkshopDropDown: DropDown!
    
    @IBAction func addParticipantBtnClick(_ sender: UIButton) {
        ADDPARTICIPANT()
    }
    @IBAction func saveBtnClick(_ sender: UIButton) {
        ADDSWORKSHOPHEADERINSERT()
    }
    //MARK:- VARIABLE DECALRATION
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
    
    var workshopListAdapter = [WorkshopListAdapter]()
    var salonCodeSelectedarray : [String]! = []
    var salonCodearray : [String]! = []
    var salonNamearray : [String]! = []
    var salonAddressarray : [String]! = []
    var salonSiteCodearray : [String]! = []
    var salonPsrCodearray : [String]! = []
    var subjectNamearray : [String]! = []
    var subjectCodearray : [String]! = []
    var stylistNamearray : [String]! = []
    var stylistCodearray : [String]! = []
    var stylistNumberarray : [String]! = []
    var stylistsalonCodearray : [String]! = []
    var stylistsalonnamearray : [String]! = []
    var TRNAPPID : String! = ""
    var stylistCodeSelectedarray : [String]! = []
    var trnappidSelectedarray : [String]! = []
    var trnappidLineSelectedarray : [String]! = []

    var colorcodeLine : String! = ""
    var subjectName : String! = ""
    var subjectCode : String! = ""
    var stylistName : String! = ""
    var stylistCode : String! = ""
    var stylistNumber : String! = ""
    var stylistSalonName : String! = ""
    var stylistSalonCode : String! = ""
    var headerExists : Bool = false
    
    //MARK:-VIEW DID LOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let value = UIInterfaceOrientation.portrait.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
        self.TRNAPPID! = UserDefaults.standard.string(forKey: "userid")! + getTodayStringNew()
        self.setupLabels()
        self.setUpSideBar()
        self.fillStylistData()
        self.fillStylistSubjectData()
        self.addMultiDayWorkshopDropDown()
        self.setupDidSelect()
        self.setupDatePicker()
        self.setDate()
        self.determineMyCurrentLocation()
        self.setList()
        self.setupOnClickmultiDayWorkshopDropDown()
        self.Day2WorkshopStackView.isHidden = true
        self.Day3WorkshopStackView.isHidden = true
        self.salonNameLabel.text! = "Salon Name"
        
        if(checkisMultiDay()){
            showMultiAlert()
        }
        else {
            fetchTodayData()
        }
    }
//
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        let value = UIInterfaceOrientation.portrait.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
    }
    
    //MARK:- FETCHDATA FROM QUERY
    fileprivate func fetchData(isEdit:String){
          var stmt:OpaquePointer?
          let queryString = "select ismultidayworkshop, trainingcode,location,workshopdaY2DATE,workshopdaY3DATE from WorkshopHeaderUpdated where isedit = '" + isEdit + "'"
          if sqlite3_prepare_v2(DatabaseConnection.dbs, queryString, -1, &stmt, nil) != SQLITE_OK{
              let errmsg = String(cString: sqlite3_errmsg(DatabaseConnection.dbs)!)
              print("error preparing get: \(errmsg)")
              return
          }
          while(sqlite3_step(stmt) == SQLITE_ROW){
            headerExists = true
            let ismultidayworkshopStr = String(cString: sqlite3_column_text(stmt, 0))
            let trainingcodeStr = String(cString: sqlite3_column_text(stmt, 1))
            let locationStr = String(cString: sqlite3_column_text(stmt, 2))
            let workshopDay2Str = String(cString: sqlite3_column_text(stmt, 3))
            let workshopDay3Str = String(cString: sqlite3_column_text(stmt, 4))
            let subject = self.getSubjectName(trainingcode : trainingcodeStr)
           
            if(isEdit == "2"){
            self.multiDayWorkshopDropDown.text! = "Yes"
            self.Day2WorkshopStackView.isHidden = false
            self.Day3WorkshopStackView.isHidden = false
            self.day2WorkshopTextField.text! = workshopDay2Str
            self.day3WorkshopTextField.text! = workshopDay3Str
            self.trainingLoctextView.text! = locationStr
            self.activitySubjectDropDown.text! = subject
            self.subjectCode = trainingcodeStr
            self.subjectName = subject
            
            self.multiDayWorkshopDropDown.isUserInteractionEnabled = false
            self.Day2WorkshopStackView.isUserInteractionEnabled = false
            self.Day3WorkshopStackView.isUserInteractionEnabled = false
            self.activitySubjectDropDown.isUserInteractionEnabled = false
            self.trainingLoctextView.isUserInteractionEnabled = true
            }
            else {
                self.multiDayWorkshopDropDown.text! = "No"
                self.Day2WorkshopStackView.isHidden = true
                self.Day2WorkshopStackView.isHidden = true
                self.day2WorkshopTextField.text! = workshopDay2Str
                self.day3WorkshopTextField.text! = workshopDay3Str
                self.trainingLoctextView.text! = locationStr
                self.activitySubjectDropDown.text! = subject
                self.subjectCode = trainingcodeStr
                self.subjectName = subject
                
                self.multiDayWorkshopDropDown.isUserInteractionEnabled = false
                self.Day2WorkshopStackView.isUserInteractionEnabled = false
                self.Day2WorkshopStackView.isUserInteractionEnabled = false
                self.activitySubjectDropDown.isUserInteractionEnabled = false
                self.trainingLoctextView.isUserInteractionEnabled = false
            }
            
            
            
//            switch ismultidayworkshopStr {
//            case "0":
//                self.multiDayWorkshopDropDown.text! = "Yes"
//                self.Day2WorkshopStackView.isHidden = false
//                self.Day3WorkshopStackView.isHidden = false
//                self.day2WorkshopTextField.text! = workshopDay2Str
//                self.day3WorkshopTextField.text! = workshopDay3Str
//
//            case "1":
//                self.multiDayWorkshopDropDown.text! = "No"
//                self.Day2WorkshopStackView.isHidden = true
//                self.Day3WorkshopStackView.isHidden = true
//                self.day2WorkshopTextField.text! = ""
//                self.day3WorkshopTextField.text! = ""
//
//            default:
//                break
//            }
          }
      }
    
        //MARK:- FETCHDATA FROM QUERY
        fileprivate func fetchTodayData(){
              var stmt:OpaquePointer?
              let queryString = "select ismultidayworkshop, trainingcode,location,workshopdaY2DATE,workshopdaY3DATE,TRNAPPID from WorkshopHeaderUpdated"
              if sqlite3_prepare_v2(DatabaseConnection.dbs, queryString, -1, &stmt, nil) != SQLITE_OK{
                  let errmsg = String(cString: sqlite3_errmsg(DatabaseConnection.dbs)!)
                  print("error preparing get: \(errmsg)")
                  return
              }
              while(sqlite3_step(stmt) == SQLITE_ROW){
                headerExists = true
                let ismultidayworkshopStr = String(cString: sqlite3_column_text(stmt, 0))
                let trainingcodeStr = String(cString: sqlite3_column_text(stmt, 1))
                let locationStr = String(cString: sqlite3_column_text(stmt, 2))
                let workshopDay2Str = String(cString: sqlite3_column_text(stmt, 3))
                let workshopDay3Str = String(cString: sqlite3_column_text(stmt, 4))
                let trnappidStr = String(cString: sqlite3_column_text(stmt, 5))
                self.TRNAPPID = trnappidStr
                let subject = self.getSubjectName(trainingcode : trainingcodeStr)
               
                if(ismultidayworkshopStr == "1"){
                self.multiDayWorkshopDropDown.text! = "Yes"
                self.Day2WorkshopStackView.isHidden = false
                self.Day3WorkshopStackView.isHidden = false
                self.day2WorkshopTextField.text! = workshopDay2Str
                self.day3WorkshopTextField.text! = workshopDay3Str
                self.trainingLoctextView.text! = locationStr
                self.activitySubjectDropDown.text! = subject
                self.subjectCode = trainingcodeStr
                self.subjectName = subject
                
                self.multiDayWorkshopDropDown.isUserInteractionEnabled = false
                self.Day2WorkshopStackView.isUserInteractionEnabled = false
                self.Day3WorkshopStackView.isUserInteractionEnabled = false
                self.activitySubjectDropDown.isUserInteractionEnabled = false
                self.trainingLoctextView.isUserInteractionEnabled = true

                }
                else {
                    self.multiDayWorkshopDropDown.text! = "No"
                    self.Day2WorkshopStackView.isHidden = true
                    self.Day2WorkshopStackView.isHidden = true
                    self.day2WorkshopTextField.text! = ""
                    self.day3WorkshopTextField.text! = ""
                    self.trainingLoctextView.text! = locationStr
                    self.activitySubjectDropDown.text! = subject
                    self.subjectCode = trainingcodeStr
                    self.subjectName = subject
                    
                    self.multiDayWorkshopDropDown.isUserInteractionEnabled = false
                    self.Day2WorkshopStackView.isUserInteractionEnabled = false
                    self.Day2WorkshopStackView.isUserInteractionEnabled = false
                    self.activitySubjectDropDown.isUserInteractionEnabled = false
                    self.trainingLoctextView.isUserInteractionEnabled = false
                }
              }
          }
    
    
    
    
    //MARK:- FETCHDATA FROM QUERY
    fileprivate func checkisMultiDay() -> Bool {
        var stmt:OpaquePointer?
        let queryString = "select ismultidayworkshop from WorkshopHeaderUpdated where isedit = '2' "
        if sqlite3_prepare_v2(DatabaseConnection.dbs, queryString, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(DatabaseConnection.dbs)!)
            print("error preparing get: \(errmsg)")
        }
        while(sqlite3_step(stmt) == SQLITE_ROW){
            return true
        }
        return false
    }
    
    //MARK:- MultiDayWorkshop
    fileprivate func addMultiDayWorkshopDropDown(){
        multiDayWorkshopDropDown.optionArray.append("Yes")
        multiDayWorkshopDropDown.optionArray.append("No")
    }
    
    fileprivate func setupOnClickmultiDayWorkshopDropDown(){
        multiDayWorkshopDropDown.didSelect{(selectedText , index ,id) in
            print("Selected String: \(selectedText) \n index: \(index)")
            if(selectedText == "Yes"){
                self.Day2WorkshopStackView.isHidden = false
                self.Day3WorkshopStackView.isHidden = false
                self.day2WorkshopTextField.text! = ""
                self.day3WorkshopTextField.text! = ""
            }
            else {
                self.Day2WorkshopStackView.isHidden = true
                self.Day3WorkshopStackView.isHidden = true
                self.day2WorkshopTextField.text! = ""
                self.day3WorkshopTextField.text! = ""
            }
            
        }
    }
    fileprivate func fetchDataUser_Profile(){
        var stmt:OpaquePointer?
        let queryString = "SELECT sitecode FROM User_Profile"
        if sqlite3_prepare_v2(DatabaseConnection.dbs, queryString, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(DatabaseConnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return
        }
        while(sqlite3_step(stmt) == SQLITE_ROW){
           self.salonSiteCode = String(cString: sqlite3_column_text(stmt, 0))
        }
        
    }
    
    //MARK:- CHECK LIST
    func checkList(saloncodeStr : String?) -> Bool
    {
        var stmt4:OpaquePointer?
        let queryString = "SELECT *  FROM InsertWorkshop where  saloncodes = '" + saloncodeStr! + "'"
        print("setList"+queryString)
        if sqlite3_prepare_v2(DatabaseConnection.dbs, queryString, -1, &stmt4, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(DatabaseConnection.dbs)!)
            print("error preparing get: \(errmsg)")
        }
        while(sqlite3_step(stmt4) == SQLITE_ROW){
            self.showtoast(controller: self, message: "Data already Exists Please Enter Different Stylist Details", seconds: 1.0)
            self.stylistCodeDropDown.text! = ""
            self.stylistNameDropDown.text! = ""
            self.stylistContactDropDown.text! = ""
            self.salonNameLabel.text! = ""
            return false;
        }
        return true
    }

       
    
    //MARK:- SET DATE
    func setDate(){
           let dateNew = Date()
           let formatter = DateFormatter()
           formatter.dateFormat = "dd-MMM-yyyy"
           let result = formatter.string(from: dateNew)
           datetextField.text = result
       }
    
    fileprivate func fieldeUnEditabe(){
        self.multiDayWorkshopDropDown.isUserInteractionEnabled = false
        self.Day2WorkshopStackView.isUserInteractionEnabled = false
        self.Day2WorkshopStackView.isUserInteractionEnabled = false
        self.activitySubjectDropDown.isUserInteractionEnabled = false
        self.trainingLoctextView.isUserInteractionEnabled = false
    }
    
    fileprivate func fieldeEditabe(){
        if(!checkisMultiDay()){
        self.multiDayWorkshopDropDown.isUserInteractionEnabled = true
        self.Day2WorkshopStackView.isUserInteractionEnabled = true
        self.Day2WorkshopStackView.isUserInteractionEnabled = true
        self.activitySubjectDropDown.isUserInteractionEnabled = true
        self.trainingLoctextView.isUserInteractionEnabled = true
        }
    }
    
    
    //MARK:-PARTICIPANT CLICK
    fileprivate func ADDPARTICIPANT(){
        if(validation() && checkListStylistCode(stylistcodeStr: self.stylistCode!) && validateNetwork() ){
            do{
                self.fieldeUnEditabe()
                self.insertLineInsertWorkshop(trnappid: TRNAPPID, trainingdate: datetextField.text!, stylistcode: self.stylistCode!, stylistname: self.SetStylistName(stylistNameString : self.stylistName!), stylistnumber: self.stylistNumber!, saloncode: self.stylistSalonCode!, salonname: self.stylistSalonName!, salonremark: "", isedit: "0", post: "1")
                
                setList()
                self.stylistNameDropDown.text! = ""
                self.stylistCodeDropDown.text! = ""
                self.stylistContactDropDown.text! = ""
                self.salonNameLabel.text! = ""
                self.stylistName! = ""
                self.stylistCode! = ""
                self.stylistNumber! = ""
                self.stylistSalonName! = ""
                
            }
        }
    }
    
    
    //MARK:- SETUPLABELS
    fileprivate func setupLabels(){
        salonNameHeader.text!  =  "Salon" + "\n" + "Name"
        salonCodeHeader.text!  =  "Salon" + "\n" + "Code"
        stylistNameHeader.text!  =  "Stylist" + "\n" + "Name"
        stylistCodeHeader.text!  =  "Stylist" + "\n" + "Code"
    }
    
    //MARK:- DATE PICKER
    fileprivate func setupDatePicker(){
        datePicker = UIDatePicker()
        datePicker?.datePickerMode = .date
        datePicker2 = UIDatePicker()
        datePicker2?.datePickerMode = .date
        datePicker?.minimumDate = self.date
        datePicker2?.minimumDate = self.date
        
        datePicker?.addTarget(self, action: #selector(MyWorkshopViewController.dateChanged(datePicker:)), for: .valueChanged)
        datePicker2?.addTarget(self, action: #selector(MyWorkshopViewController.dateChanged(datePicker2:)), for: .valueChanged)
        day2WorkshopTextField.inputView = datePicker
        day3WorkshopTextField.inputView = datePicker2
    }
    
    //MARK:- DATE CHANGED
    @objc func dateChanged(datePicker: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MMM-YYYY"
        if(curentDateCheck(todate: dateFormatter.string(from: datePicker.date), fromdate: datetextField.text!)){
            day2WorkshopTextField.text = dateFormatter.string(from: datePicker.date)
        }
    }
    
    @objc func dateChanged(datePicker2: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MMM-YYYY"
        if(curentDateCheck(todate: dateFormatter.string(from: datePicker2.date), fromdate: datetextField.text!) && Day3Workshopcheck(todate: dateFormatter.string(from: datePicker2.date), fromdate: day2WorkshopTextField.text!)){
            day3WorkshopTextField.text = dateFormatter.string(from: datePicker2.date)
        }
    }
    
    func Day3Workshopcheck(todate: String, fromdate: String)-> Bool{
        if fromdate == "" {
            self.showtoast(controller: self, message: "Please Enter Workshop Day 2 Date", seconds: 1.5)
            return false
        }
        if todate == fromdate  {
            self.showtoast(controller: self, message: "Please Select Different Date from Day2 Date", seconds: 1.5)
            return false
        }
        return true
    }
    
    func curentDateCheck(todate: String, fromdate: String)-> Bool{
        
        if todate == fromdate  {
            self.showtoast(controller: self, message: "Sorry ! You Can't Select Current Date", seconds: 1.5)
            return false
        }
        return true
    }
    
    //MARK:- TEXTVIEW NIL
    func textViewDidBeginEditing(_ textView: UITextView) {
        self.trainingLoctextView.text! = ""
    }

    
    //MARK:- OVERRIDE
    override func WorkshopPostSuccess(){
        if(AppDelegate.isIntentDone == "0"){
        self.showtoast(controller: self, message: "Data Submitted Successfully", seconds: 1.0)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.push(vcId: "dashnc", vc: self)
            }
            AppDelegate.isIntentDone = "1"

        }
    }
    
    //MARK:- OVERRIDE
    override func WorkshopPostFailure(){
        if(AppDelegate.isIntentDone == "0"){
        self.showtoast(controller: self, message: "Data Not Submitted", seconds: 1.0)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.push(vcId: "dashnc", vc: self)
            }
            AppDelegate.isIntentDone = "1"

        }
    }
    
    //MARK:- OVERRIDE
    override func WorkshopPostError(){
        if(AppDelegate.isIntentDone == "0"){
        self.showtoast(controller: self, message: "Data Not Submitted", seconds: 1.0)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.push(vcId: "dashnc", vc: self)
            }
            AppDelegate.isIntentDone = "1"

        }
    }
    
    @IBOutlet weak var saveBtn: UIButton!
    //MARK:- ADD HEADER BTN CLICK
    fileprivate func ADDSWORKSHOPHEADERINSERT(){
        if(validationHeader() && validateNetwork()){
            do{
                self.saveBtn.isEnabled = false
                if(!headerExists){
                    self.fetchDataUser_Profile()
                    self.GetSiteCodeandPsrCodeForHeader(salonSiteCode: self.salonSiteCode!)
                    self.isMultiText()
                    self.insertWorkshopHeaderUpdated(trnappid: TRNAPPID, trainingtype: "WorkShop", trainingcode: self.subjectCode!, trainercode: UserDefaults.standard.string(forKey: "userid")!, sitecode: self.salonSiteCode!, sellercode: self.salonPsrCode!, Lat:lat!, Long: longi!, trainingdate: datetextField.text!, remark: "", post: "1", workshopday2date:day2WorkshopTextField.text!, workshopday3date: day3WorkshopTextField.text!, ismultidayworkshop: multiDayWorkshopDropDown.text!, isEdit: "0", location: trainingLoctextView.text!)
                }
                self.updateWorkshopHeaderUpdatedLocation(trnappid: TRNAPPID, location: trainingLoctextView.text!)
                self.postDeleteData(ActivityType: "WorkShop")
                
            }
        }
    }
    
    fileprivate func isMultiText(){
        var ismultiDay : String! = ""
        ismultiDay = multiDayWorkshopDropDown.text!
        switch ismultiDay {
        case "No":
             multiDayWorkshopDropDown.text! = "0"
        case "Yes":
            multiDayWorkshopDropDown.text! = "1"
        default :
            break
        }
    }
    
    
    
    //MARK:- MULTI ALERT
    func showMultiAlert(){
        let alert = UIAlertController(title: "", message: "Your workshop is already registered. Click on YES to continue with this workshop or NO to schedule a new workshop", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.default, handler: { (action) in
            self.deleteWorkshopHeaderUpdated()   // done
            self.deleteInsertWorkshopdata()
            self.setList()
            alert.dismiss(animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.cancel, handler: { (action) in
            self.fetchData(isEdit: "2")
            alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true)
    }

    
    fileprivate func isEditableCheck(){
        if(workshopListAdapter.count == 0 && (multiDayWorkshopDropDown.text! == "No")){
            self.trainingLoctextView.isUserInteractionEnabled = true
            self.datetextField.isUserInteractionEnabled = true
            self.activitySubjectDropDown.isUserInteractionEnabled = true
        }
        else if(workshopListAdapter.count == 0 && (multiDayWorkshopDropDown.text! == "Yes")) {
            self.trainingLoctextView.isUserInteractionEnabled = false
            self.datetextField.isUserInteractionEnabled = false
            self.activitySubjectDropDown.isUserInteractionEnabled = false
        }
    }
    
    override func deletePostSuccess() {
         AppDelegate.isIntentDone = "0"
        self.POSTWORKSHOPHEADERLINE()
    }
    
    
    fileprivate func GetSiteCodeandPsrCodeForHeader(salonSiteCode : String?){
        var stmt:OpaquePointer?
        let queryString = "SELECT  psrcode  FROM salon where  sitecode = '" + salonSiteCode! + "' LIMIT 1 "
        if sqlite3_prepare_v2(DatabaseConnection.dbs, queryString, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(DatabaseConnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return
        }
        
        print("SELERCODE=============================")
        print(queryString)
        while(sqlite3_step(stmt) == SQLITE_ROW){
            let psrcodeStr = String(cString: sqlite3_column_text(stmt, 0))
            self.salonPsrCode! = psrcodeStr
        }
    }

    //MARK:- HEADER VALIDATION
    fileprivate func validationHeader() -> Bool {
        if(workshopListAdapter.count > 0){
            return true
        }
        else {
            self.showtoast(controller: self, message: "Please Add Stylist First", seconds: 1.0)
        }
        return false
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
        do{
            if(datetextField.text!.isEmpty || datetextField.text! == ""){
                self.showtoast(controller: self, message: "Please Enter Date", seconds: 1.0)
                return false
            }
                
            else  if(multiDayWorkshopDropDown.text == nil  || multiDayWorkshopDropDown.text!.isEmpty  || multiDayWorkshopDropDown.text! == "Is this MultiDay Workshop ?" ){
                self.showtoast(controller: self, message: "Please Select Either Workshop Is MultiDay", seconds: 1.0)
                return false
            }
            else  if(Day2WorkshopStackView.isHidden == false && (day2WorkshopTextField.text!.isEmpty || day2WorkshopTextField.text! == "" || day2WorkshopTextField.text! == "Select Workshop Day 2 Date")){
                self.showtoast(controller: self, message: "Please Select Workshop Day 2 Date", seconds: 1.0)
                return false
            }
//            else  if(Day3WorkshopStackView.isHidden == false && (day3WorkshopTextField.text!.isEmpty || day3WorkshopTextField.text! == "" || day3WorkshopTextField.text! == "Select Workshop Day 3 Date")){
//                self.showtoast(controller: self, message: "Please Select Workshop Day 3 Date", seconds: 1.0)
//                return false
//            }
            else  if(activitySubjectDropDown.text == nil || self.subjectCode == nil ||     activitySubjectDropDown.text!.isEmpty || activitySubjectDropDown.text! == "" || activitySubjectDropDown.text! == "Select Training" || self.subjectCode.isEmpty || self.subjectCode! == ""){
                self.showtoast(controller: self, message: "Please Select Training", seconds: 1.0)
                return false
            }
            else  if(trainingLoctextView.text == nil  || trainingLoctextView.text!.isEmpty || trainingLoctextView.text! == "" || trainingLoctextView.text! == "Training Location" ){
                self.showtoast(controller: self, message: "Please Enter Training Location", seconds: 1.0)
                return false
            }
            else  if(stylistNameDropDown.text == nil || self.salonName == nil ||     stylistNameDropDown.text!.isEmpty || stylistNameDropDown.text! == "" || stylistNameDropDown.text! == "Stylist Name" || self.stylistName.isEmpty || self.stylistName! == ""){
                self.showtoast(controller: self, message: "Please Select Stylist Name", seconds: 1.0)
                return false
            }
            else  if(stylistCodeDropDown.text == nil || self.stylistCode == nil ||     stylistCodeDropDown.text!.isEmpty || stylistCodeDropDown.text! == "" || stylistCodeDropDown.text! == "Stylist Code" || self.stylistCode.isEmpty || self.stylistCode! == ""){
                self.showtoast(controller: self, message: "Please Select Stylist Code", seconds: 1.0)
                return false
            }
            else  if(stylistContactDropDown.text == nil || self.stylistNumber == nil ||     stylistContactDropDown.text!.isEmpty || stylistContactDropDown.text! == "" || stylistContactDropDown.text! == "Stylist Phone Number" || self.stylistNumber.isEmpty || self.stylistNumber! == ""){
                self.showtoast(controller: self, message: "Please Select Stylist Mobile Number", seconds: 1.0)
                return false
            }
                
            else  if(salonNameLabel.text!.isEmpty || salonNameLabel.text! == "" || salonNameLabel.text! == "Salon Name"){
                self.showtoast(controller: self, message: "Salon Name Cannot Be Empty", seconds: 1.0)
                return false
            }
        }
        return true
    }
    
    //MARK:- STYLIST DATA
    fileprivate func fillStylistData(){
        
        stylistNamearray.removeAll()
        stylistCodearray.removeAll()
        stylistNumberarray.removeAll()
        
        stylistNameDropDown.optionArray.removeAll()
        stylistCodeDropDown.optionArray.removeAll()
        stylistContactDropDown.optionArray.removeAll()
        
        var stmt:OpaquePointer?
        let queryString = "SELECT stylistname,stylistcode,contact,saloncode,salonname FROM stylist"
        if sqlite3_prepare_v2(DatabaseConnection.dbs, queryString, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(DatabaseConnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return
        }
        while(sqlite3_step(stmt) == SQLITE_ROW){
            let stylistNameStr = String(cString: sqlite3_column_text(stmt, 0))
            let stylistCodeStr = String(cString: sqlite3_column_text(stmt, 1))
            let stylistContactStr = String(cString: sqlite3_column_text(stmt, 2))
            let stylistSalonCodeStr = String(cString: sqlite3_column_text(stmt, 3))
            let stylistSalonNameStr = String(cString: sqlite3_column_text(stmt, 4))
            
            
            stylistNameDropDown.optionArray.append(stylistNameStr)
            stylistCodeDropDown.optionArray.append(stylistCodeStr)
            stylistContactDropDown.optionArray.append(stylistContactStr)
            
            stylistNamearray.append(stylistNameStr)
            stylistCodearray.append(stylistCodeStr)
            stylistNumberarray.append(stylistContactStr)
            stylistsalonCodearray.append(stylistSalonCodeStr)
            stylistsalonnamearray.append(stylistSalonNameStr)
            
        }
    }
    
    //MARK:- SUBJECT
    fileprivate func fillStylistSubjectData(){
        subjectNamearray.removeAll()
        subjectCodearray.removeAll()
        
        activitySubjectDropDown.optionArray.removeAll()
        
        var stmt:OpaquePointer?
        let queryString = "SELECT * FROM TrainingMaster"
        if sqlite3_prepare_v2(DatabaseConnection.dbs, queryString, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(DatabaseConnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return
        }
        while(sqlite3_step(stmt) == SQLITE_ROW){
            let trainingCodeStr = String(cString: sqlite3_column_text(stmt, 0))
            let trainingNameStr = String(cString: sqlite3_column_text(stmt, 1))
            
            activitySubjectDropDown.optionArray.append(trainingNameStr)
            
            subjectNamearray.append(trainingNameStr)
            subjectCodearray.append(trainingCodeStr)
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
    fileprivate func setList()
    {
        self.stylistCodeSelectedarray.removeAll()
        self.workshopListAdapter.removeAll()
        var stmt4:OpaquePointer?
        let queryString = "SELECT stylistcode,stylistname,saloncodes,salonname FROM InsertWorkshop"
        print("setList"+queryString)
        if sqlite3_prepare_v2(DatabaseConnection.dbs, queryString, -1, &stmt4, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(DatabaseConnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return
        }
        self.fieldeEditabe()
        while(sqlite3_step(stmt4) == SQLITE_ROW){
            let stylistcodeStr = String(cString: sqlite3_column_text(stmt4, 0))
            let stylistnameStr = String(cString: sqlite3_column_text(stmt4, 1))
            let saloncodeStr = String(cString: sqlite3_column_text(stmt4, 2))
            let salonnameStr = String(cString: sqlite3_column_text(stmt4, 3))
            
            self.stylistCodeSelectedarray.append(stylistcodeStr)
            self.workshopListAdapter.append(WorkshopListAdapter(stylistcode: stylistcodeStr, stylistname: stylistnameStr, saloncode: saloncodeStr, salonname: salonnameStr))
            self.fieldeUnEditabe()
        }
        self.workshopTableView.reloadData()
    }
    //MARK:- CHECK LIST
    func checkList(stylistcodeStr : String?) -> Bool
    {
        var stmt4:OpaquePointer?
        let queryString = "SELECT stylistcode FROM InsertWorkshop where  stylistcode = '" + stylistcodeStr! + "'"
        print("setList"+queryString)
        if sqlite3_prepare_v2(DatabaseConnection.dbs, queryString, -1, &stmt4, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(DatabaseConnection.dbs)!)
            print("error preparing get: \(errmsg)")
        }
        while(sqlite3_step(stmt4) == SQLITE_ROW){
            self.showtoast(controller: self, message: "Please Select Different Stylist", seconds: 1.0)
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
        if(AppDelegate.isDebug){
            print("user latitude = \(userLocation.coordinate.latitude)")
            print("user longitude = \(userLocation.coordinate.longitude)")
        }
        lat = String(userLocation.coordinate.latitude)
        longi = String(userLocation.coordinate.longitude)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    {
        print("Error \(error)")
    }
    
    //MARK:- SETUP DID SELECT
    fileprivate  func setupDidSelect () {
        setupOnClickActivitySubject()
        setupOnClickStylistCode()
        setupOnClickStylistName()
        setupOnClickStylistMobileNumber()
    }
    
    fileprivate func setupOnClickActivitySubject(){
        activitySubjectDropDown.didSelect{(selectedText , index ,id) in
            print("Selected String: \(selectedText) \n index: \(index)")
            self.subjectName = self.subjectNamearray[index]
            self.subjectCode = self.subjectCodearray[index]
            
            self.activitySubjectDropDown.text! = self.subjectName!
        }
    }
    
    fileprivate func setupOnClickStylistCode(){
        stylistCodeDropDown.didSelect{(selectedText , index ,id) in
            print("Selected String: \(selectedText) \n index: \(index)")
            self.stylistCode = self.stylistCodearray[index]
            self.stylistName = self.stylistNamearray[index]
            self.stylistNumber = self.stylistNumberarray[index]
            self.stylistSalonName = self.stylistsalonnamearray[index]
            self.stylistSalonCode = self.stylistsalonCodearray[index]
            
            self.stylistNameDropDown.text! = self.stylistName!
            self.stylistCodeDropDown.text! = self.stylistCode!
            self.stylistContactDropDown.text! = self.stylistNumber!
            self.salonNameLabel.text! = self.stylistSalonName!
        }
    }
    
    fileprivate func setupOnClickStylistName(){
        stylistNameDropDown.didSelect{(selectedText , index ,id) in
            print("Selected String: \(selectedText) \n index: \(index)")
            self.stylistCode = self.stylistCodearray[index]
            self.stylistName = self.stylistNamearray[index]
            self.stylistNumber = self.stylistNumberarray[index]
            self.stylistSalonName = self.stylistsalonnamearray[index]
            self.stylistSalonCode = self.stylistsalonCodearray[index]
            
            self.stylistNameDropDown.text! = self.stylistName!
            self.stylistCodeDropDown.text! = self.stylistCode!
            self.stylistContactDropDown.text! = self.stylistNumber!
            self.salonNameLabel.text! = self.stylistSalonName!
        }
    }
    
    fileprivate func setupOnClickStylistMobileNumber(){
        stylistContactDropDown.didSelect{(selectedText , index ,id) in
            print("Selected String: \(selectedText) \n index: \(index)")
            self.stylistCode = self.stylistCodearray[index]
            self.stylistName = self.stylistNamearray[index]
            self.stylistNumber = self.stylistNumberarray[index]
            self.stylistSalonName = self.stylistsalonnamearray[index]
            self.stylistSalonCode = self.stylistsalonCodearray[index]
            
            self.stylistNameDropDown.text! = self.stylistName!
            self.stylistCodeDropDown.text! = self.stylistCode!
            self.stylistContactDropDown.text! = self.stylistNumber!
            self.salonNameLabel.text! = self.stylistSalonName!
        }
    }
    //MARK:- CHECK LIST
    func checkListStylistCode(stylistcodeStr : String?) -> Bool
    {
        var stmt4:OpaquePointer?
        let queryString = "SELECT stylistcode FROM InsertWorkshop where  stylistcode = '" + stylistcodeStr! + "'"
        print("setList"+queryString)
        if sqlite3_prepare_v2(DatabaseConnection.dbs, queryString, -1, &stmt4, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(DatabaseConnection.dbs)!)
            print("error preparing get: \(errmsg)")
        }
        while(sqlite3_step(stmt4) == SQLITE_ROW){
            self.showtoast(controller: self, message: "Data already Exists Please Enter Different Stylist Details", seconds: 1.0)
            self.stylistCodeDropDown.text! = ""
            self.stylistNameDropDown.text! = ""
            self.stylistContactDropDown.text! = ""
            self.salonNameLabel.text! = ""
            return false;
        }
        return true
    }

}







