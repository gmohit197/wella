//
//  CalendarPlannedViewController.swift
//  Wella.2
//
//  Created by Acxiom Consulting on 15/03/21.
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

class CalendarPlannedViewController: ExecuteApi , CLLocationManagerDelegate
{
    var calendardate : Date!
    var eventName : String!
    @IBOutlet weak var trainingTypeLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var salonCodeLabelPlanned: UILabel!
    @IBOutlet weak var salonNameLabelPlanned: UILabel!
    @IBOutlet weak var subjectNameLabelPlanned: UILabel!
    @IBOutlet weak var plannedDataStackView: UIStackView!
    @IBOutlet weak var plannnedHeaderStackView: UIStackView!
    @IBOutlet weak var plannnedFirstRowStackView: UIStackView!
    @IBOutlet weak var plannnedSeecondRowStackView: UIStackView!
    @IBOutlet weak var plannnedThirdStackView: UIStackView!
    @IBOutlet weak var plannedFirstSalonCodeLabel: UILabel!
    @IBOutlet weak var plannedFirstSalonNameLabel: UILabel!
    @IBOutlet weak var plannedFirstSubjectHeaderLabel: UILabel!
    @IBOutlet weak var plannedFirstSubjectNameLabel: UILabel!
    @IBOutlet weak var plannedSecondSalonCodeLabel: UILabel!
    @IBOutlet weak var plannedSecondSalonNameLabel: UILabel!
    @IBOutlet weak var plannedSecondSubjectHeaderLabel: UILabel!
    @IBOutlet weak var plannedSecondSubjectNameLabel: UILabel!
    @IBOutlet weak var plannedThirdSubjectHeaderLabel: UILabel!
    @IBOutlet weak var plannedThirdSubjectNameLabel: UILabel!
    @IBOutlet weak var approvedTrainingTypeLabel: UILabel!
    @IBOutlet weak var salonCodeLabelApproved: UILabel!
    @IBOutlet weak var salonNameLabelApproved: UILabel!
    @IBOutlet weak var subjectNameLabelApproved: UILabel!
    @IBOutlet weak var approvedDataStackView: UIStackView!
    @IBOutlet weak var approvedHeaderStackView: UIStackView!
    @IBOutlet weak var approvedFirstSalonCodeLabel: UILabel!
    @IBOutlet weak var approvedFirstSalonNameLabel: UILabel!
    @IBOutlet weak var approvedFirstSubjectHeaderLabel: UILabel!
    @IBOutlet weak var approvedFirstSubjectNameLabel: UILabel!
    @IBOutlet weak var approvedSecondSalonCodeLabel: UILabel!
    @IBOutlet weak var approvedSecondSalonNameLabel: UILabel!
    @IBOutlet weak var approvedSecondSubjectHeaderLabel: UILabel!
    @IBOutlet weak var approvedSecondSubjectNameLabel: UILabel!
    @IBOutlet weak var approvedThirdSubjectHeaderLabel: UILabel!
    @IBOutlet weak var approvedThirdSubjectNameLabel: UILabel!
    @IBOutlet weak var awaitingTrainingTypeLabel: UILabel!
    @IBOutlet weak var awaitingDataStackView: UIStackView!
    @IBOutlet weak var awaitingHeaderStackView: UIStackView!
    @IBOutlet weak var awaitingFirstSalonCodeLabel: UILabel!
    @IBOutlet weak var awaitingFirstSalonNameLabel: UILabel!
    @IBOutlet weak var awaitingFirstSubjectHeaderLabel: UILabel!
    @IBOutlet weak var awaitingFirstSubjectNameLabel: UILabel!
    @IBOutlet weak var awaitingSecondSalonCodeLabel: UILabel!
    @IBOutlet weak var awaitingSecondSalonNameLabel: UILabel!
    @IBOutlet weak var awaitingSecondSubjectHeaderLabel: UILabel!
    @IBOutlet weak var awaitingSecondSubjectNameLabel: UILabel!
    @IBOutlet weak var awaitingThirdSubjectHeaderLabel: UILabel!
    @IBOutlet weak var awaitingThirdSubjectNameLabel: UILabel!
    @IBOutlet weak var activitySubjectStackView: UIStackView!
    @IBOutlet weak var activitySubjectDropDown: DropDown!
    
    var TRNAPPID : String! = ""
    var oldSubjectCode : String! = ""
    var impactDate : String! = ""
    override func viewDidLoad() {
        super.viewDidLoad()
         self.TRNAPPID! = UserDefaults.standard.string(forKey: "userid")! + getTodayStringNew()
        
        let value = UIInterfaceOrientation.portrait.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
        self.calendardate = AppDelegate.calendardate
        self.eventName = AppDelegate.calendarevent
        
        
        let eventdate = NSDate()
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "dd MMM"
        let currentdate =  dateformatter.string(from: eventdate as Date)
        let calendardateResult =  dateformatter.string(from: calendardate as Date)
        AppDelegate.palnnedcalendardate = calendardateResult
        
        if(calendardateResult >= currentdate){
            activitySubjectStackView.isHidden = false
        }
        else{
            activitySubjectStackView.isHidden = true
        }
        setDateApplied()
        setData()
        BindSpinnerData()
        setupOnClickSubjectDropDown()
    }
    
    fileprivate func setDateApplied (){
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "yyyy-MM-dd"
        
        let calendardateResult1 =  dateformatter.string(from: calendardate as Date)
        self.impactDate = calendardateResult1
        AppDelegate.impactDateCalendar = calendardateResult1
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//           DispatchQueue.main.async {
//               (UIApplication.shared.delegate as! AppDelegate).restrictRotation = .portrait
//           }
//    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
           super.viewWillTransition(to: size, with: coordinator)
           let value = UIInterfaceOrientation.portrait.rawValue
           UIDevice.current.setValue(value, forKey: "orientation")
       }
    
    
    fileprivate func BindSpinnerData(){
        activitySubjectDropDown.optionArray.append("Select Activity Subject")
        activitySubjectDropDown.optionArray.append("Market Visit")
        activitySubjectDropDown.optionArray.append("Hot Day")
        activitySubjectDropDown.optionArray.append("InSalon")
        activitySubjectDropDown.optionArray.append("Workshop")
        activitySubjectDropDown.optionArray.append("Internal Training")
        activitySubjectDropDown.optionArray.append("Other")
        activitySubjectDropDown.optionArray.append("Virtual Training")
        activitySubjectDropDown.optionArray.append("Leave")
    }
    
    fileprivate func setupOnClickSubjectDropDown(){
        activitySubjectDropDown.didSelect{(selectedText , index ,id) in
            print("Selected String: \(selectedText) \n index: \(index)")
            AppDelegate.selectedText = selectedText
            var message : String! = ""
            if(self.eventName == selectedText){
                message = "Changes in Same Activity Can't be Permissible"
            }
            else{
                message = String("Are you sure want to change activity " + selectedText + " from " + self.eventName)
            }
            
            if(selectedText == "Hot Day" || selectedText == "Market Visit" || selectedText == "Other" || selectedText == "Leave" || selectedText == "Internal Training"){
            self.showAlert(selectedText: selectedText, eventName: self.eventName, message: message)
            }
            else if (selectedText == "Workshop" || selectedText == "Virtual Training" ){
               self.pushnext(identifier: "PlannedForWorkshopViewController", controller: self)
            }
            else if (selectedText == "InSalon"){
                self.pushnext(identifier: "PlannnedInSalonViewController", controller: self)
            }
        }
    }
//    //MARK:- SET DATE
//    func setDate(){
//        let dateNew = Date()
//        let formatter = DateFormatter()
//        formatter.dateFormat = "dd-MMM-yyyy"
//        let result = formatter.string(from: dateNew)
//        datetextField.text = result
//    }
    
    
    fileprivate func insertData(selectedText: String! , eventName : String!){
        self.deletePostCalender()
        self.insertPostCalender(TRNAPPID: TRNAPPID, ENTRY_TYPE: "1", TRAINER_CODE: UserDefaults.standard.string(forKey: "userid")!, IMPACT_DATE:   self.impactDate!, PLANNED_ACTIVITY: eventName, CHANGE_REQUESTED: selectedText, DATE_APPLIED: getTodayDateStringYMD(), STATUS: "0", CREATEDDATETIME: getTodayDateStringYMD(), CREATEDBY: UserDefaults.standard.string(forKey: "userid")!, DATAAREAID: "7200", Post: "0", INSALON_1_CODE: "", NEW_INSALON_1_CODE: "", INSALON_1_SUBJECT: "", NEW_INSALON_1_SUBJECT: "", INSALON_2_CODE: "", NEW_INSALON_2_CODE: "", INSALON_2_SUBJECT: "", NEW_INSALON_2_SUBJECT: "", ACTIVITY_SUBJECT: "", NEW_ACTIVITY_SUBJECT: "")
        
        if(validateNetwork()){
            AppDelegate.isIntentDone = "0"
            self.postCalendar()
        }
    }
    
    //MARK:- OVERRIDE
    override func postCalendarPostSuccess(){
        if(AppDelegate.isIntentDone == "0"){
        self.showtoast(controller: self, message: "Change Request Submitted to Manager For Approval", seconds: 1.0)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.push(vcId: "calendarnc", vc: self)

            }
            AppDelegate.isIntentDone = "1"

        }
    }
    
    //MARK:- OVERRIDE
    override func postCalendnrPostFailure(){
        if(AppDelegate.isIntentDone == "0"){
        self.showtoast(controller: self, message: "Data Not Submitted", seconds: 1.0)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.push(vcId: "calendarnc", vc: self)
            }
            AppDelegate.isIntentDone = "1"

        }
    }
    //MARK:- OVERRIDE
    override func postCalendarPostError(){
        if(AppDelegate.isIntentDone == "0"){
        self.showtoast(controller: self, message: "Data Not Submitted", seconds: 1.0)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.push(vcId: "FSCalendarViewController", vc: self)
            }
            AppDelegate.isIntentDone = "1"

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
    
        //MARK:- BLOCK ALERT
    func showAlert(selectedText : String,eventName : String ,message : String){
        let alert = UIAlertController(title: "", message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
            self.insertData(selectedText : selectedText,eventName : eventName)
        }))
        self.present(alert, animated: true)
    }
    
    fileprivate func hideLabel (label : UILabel!){
        label.isHidden = true
    }
    
    fileprivate func showLabel (label : UILabel!){
        label.isHidden = false
    }
    
    @IBAction func backBtnClick(_ sender: UIBarButtonItem) {
        BACKTOSCREEN()
    }
    
    fileprivate func BACKTOSCREEN(){
        self.navigationController?.popViewController(animated: true)
    }
    
//    override var shouldAutorotate: Bool {
//        return false
//    }
//    
//    override var supportedInterfaceOrientations: UIInterfaceOrientationMask{
//        return .portrait
//    }
//    
//    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation{
//        return .portrait
//    }
//    
    
    fileprivate func setData(){
        
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "dd MMM"
        let currentdate =  dateformatter.string(from: calendardate)
        self.dateLabel.text! = currentdate
        
        SetPlannedList(activityname: eventName, eventDate: currentdate)
        SetApprovedList(activityname: eventName, eventDate: currentdate)
        SetAwaitingList(activityname: eventName, eventDate: currentdate)
    }
    
    fileprivate func SetPlannedList(activityname : String, eventDate : String){
        var stmt4:OpaquePointer?
        let queryString = "select distinct substr(date,6,8) as dateSubStr,insaloN_1_CODE,insaloN_2_CODE,insaloN_1_SUBJECT,insaloN_2_SUBJECT,activitY_SUBJECT,activitY_NAME  from Calender where dateSubStr like '%" + eventDate + "%' "
        print("SetPlannedList"+queryString)
        if sqlite3_prepare_v2(DatabaseConnection.dbs, queryString, -1, &stmt4, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(DatabaseConnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return
        }
        self.approvedTrainingTypeLabel.text! = ""
        if(sqlite3_step(stmt4) == SQLITE_ROW){
            let entity = String(cString: sqlite3_column_text(stmt4, 0))
            let insalon1code = String(cString: sqlite3_column_text(stmt4, 1))
            let insalon2code = String(cString: sqlite3_column_text(stmt4, 2))
            let insalon1subject = String(cString: sqlite3_column_text(stmt4, 3))
            let insalon2subject = String(cString: sqlite3_column_text(stmt4, 4))
            let activitysubject = String(cString: sqlite3_column_text(stmt4, 5))
            let activitynameStr = String(cString: sqlite3_column_text(stmt4, 6))
            
            self.trainingTypeLabel.text! = activitynameStr
            
            if(activitynameStr == "InSalon"){
                self.plannedFirstSalonCodeLabel.text! = insalon1code
                self.plannedSecondSalonCodeLabel.text! = insalon2code

                self.plannnedHeaderStackView.isHidden = false
                self.plannedFirstSubjectHeaderLabel.isHidden = true
                self.plannedSecondSubjectHeaderLabel.isHidden = true
                self.plannedThirdSubjectHeaderLabel.isHidden = true
                self.plannedThirdSubjectNameLabel.isHidden  =  true
                
                self.plannedFirstSalonNameLabel.isHidden = false
                self.plannedSecondSalonNameLabel.isHidden = false
                
                self.plannedFirstSalonCodeLabel.isHidden = false
                self.plannedSecondSalonCodeLabel.isHidden = false
                
                self.plannedFirstSalonNameLabel.text! = self.getSalonName(saloncode: insalon1code)
                self.plannedSecondSalonNameLabel.text! = self.getSalonName(saloncode: insalon2code)
                self.plannedFirstSubjectNameLabel.text! = self.getSubjectName(trainingcode: insalon1subject)
                self.plannedSecondSubjectNameLabel.text! = self.getSubjectName(trainingcode: insalon2subject)
            }
            
            else if (activitynameStr == "Workshop"){
                self.plannnedHeaderStackView.isHidden = true
                self.plannedFirstSubjectHeaderLabel.isHidden = false
                self.plannedSecondSubjectHeaderLabel.isHidden = true
                self.plannedThirdSubjectHeaderLabel.isHidden = true
                
                self.plannedFirstSubjectNameLabel.isHidden  =  false
                self.plannedSecondSubjectNameLabel.isHidden  =  true
                self.plannedThirdSubjectNameLabel.isHidden  =  true
                
                self.plannedFirstSalonNameLabel.isHidden = true
                self.plannedSecondSalonNameLabel.isHidden = true
                
                self.plannedFirstSalonCodeLabel.isHidden = true
                self.plannedSecondSalonCodeLabel.isHidden = true
                
                self.plannedFirstSubjectNameLabel.text! = self.getSubjectName(trainingcode: activitysubject)
                if(self.plannedFirstSubjectNameLabel.text! == ""){
                   self.plannedFirstSubjectNameLabel.text! = "Subject"
                }
                self.plannedFirstSubjectHeaderLabel.text! = "Subject1"
            }
                
                
                
            else if(activitynameStr == "Virtual Training") {
                self.plannnedHeaderStackView.isHidden = true
                
                self.plannedFirstSubjectHeaderLabel.isHidden = false
                self.plannedSecondSubjectHeaderLabel.isHidden = false
                self.plannedThirdSubjectHeaderLabel.isHidden = false
                
                self.plannedThirdSubjectNameLabel.isHidden = false

                self.plannedFirstSalonNameLabel.isHidden = true
                self.plannedSecondSalonNameLabel.isHidden = true
                
                self.plannedFirstSalonCodeLabel.isHidden = true
                self.plannedSecondSalonCodeLabel.isHidden = true
                
                self.plannedFirstSubjectNameLabel.text! = ""
                self.plannedSecondSubjectNameLabel.text! = ""
                self.plannedThirdSubjectNameLabel.text! = ""
                
                self.plannedFirstSubjectNameLabel.text! = self.getSubjectName(trainingcode: insalon1subject)
                self.plannedSecondSubjectNameLabel.text! = self.getSubjectName(trainingcode: insalon2subject)
                self.plannedThirdSubjectNameLabel.text! = self.getSubjectName(trainingcode: activitysubject)
                
                print("SUBJECTVALUES=========================")
                print(self.plannedFirstSubjectNameLabel.text!)
                print(self.plannedSecondSubjectNameLabel.text!)
                print(self.plannedThirdSubjectNameLabel.text!)

                
                if(self.plannedFirstSubjectNameLabel.text! == ""){
                    self.plannedFirstSubjectHeaderLabel.isHidden = true
                    self.plannedFirstSubjectNameLabel.isHidden = true
                }
                if(self.plannedSecondSubjectNameLabel.text! == ""){
                    self.plannedSecondSubjectHeaderLabel.isHidden = true
                    self.plannedSecondSubjectNameLabel.isHidden = true
                }
                if(self.plannedThirdSubjectNameLabel.text! == ""){
                    self.plannedThirdSubjectHeaderLabel.isHidden = true
                    self.plannedThirdSubjectNameLabel.isHidden = true
                }
                if(self.plannedFirstSubjectNameLabel.text! == ""){
                    self.plannedSecondSubjectHeaderLabel.text! = "Subject1"
                }
                if(self.plannedSecondSubjectNameLabel.text! == ""){
                    self.plannedThirdSubjectHeaderLabel.text! = "Subject2"
                }
                if(self.plannedSecondSubjectNameLabel.text! == "" && self.plannedFirstSubjectNameLabel.text! == "" ){
                    self.plannedThirdSubjectHeaderLabel.text! = "Subject1"
                }
            }
            else {
                self.plannedDataStackView.isHidden = true
                self.plannnedHeaderStackView.isHidden = true
            }
        }
        else {
            self.plannedDataStackView.isHidden = true
            self.plannnedHeaderStackView.isHidden = true
        }

    }
    
    fileprivate func SetApprovedList(activityname : String, eventDate : String){
        var stmt4:OpaquePointer?
        let queryString = "select distinct substr(date,6,8) as dateSubStr,approveD_INSALON_1_CODE,approveD_INSALON_2_CODE,approveD_INSALON_1_SUBJECT,approveD_INSALON_2_SUBJECT,approveD_ACTIVITY_SUBJECT,approveD_ACTIVITY_NAME  from Calender where dateSubStr like '%" + eventDate + "%' "
        print("SetPlannedList"+queryString)
        if sqlite3_prepare_v2(DatabaseConnection.dbs, queryString, -1, &stmt4, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(DatabaseConnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return
        }
        self.approvedTrainingTypeLabel.text! = ""
        if(sqlite3_step(stmt4) == SQLITE_ROW){
            let entity = String(cString: sqlite3_column_text(stmt4, 0))
            let insalon1code = String(cString: sqlite3_column_text(stmt4, 1))
            let insalon2code = String(cString: sqlite3_column_text(stmt4, 2))
            let insalon1subject = String(cString: sqlite3_column_text(stmt4, 3))
            let insalon2subject = String(cString: sqlite3_column_text(stmt4, 4))
            let activitysubject = String(cString: sqlite3_column_text(stmt4, 5))
            let activitynameStr = String(cString: sqlite3_column_text(stmt4, 6))
            
            self.approvedTrainingTypeLabel.text! = activitynameStr
            
            if(activitynameStr == "InSalon"){
                self.approvedFirstSalonCodeLabel.text! = insalon1code
                self.approvedSecondSalonCodeLabel.text! = insalon2code

                self.approvedHeaderStackView.isHidden = false
                self.approvedFirstSubjectHeaderLabel.isHidden = true
                self.approvedSecondSubjectHeaderLabel.isHidden = true
                self.approvedThirdSubjectHeaderLabel.isHidden = true
                self.approvedThirdSubjectNameLabel.isHidden  =  true
                
                self.approvedFirstSalonNameLabel.isHidden = false
                self.approvedSecondSalonNameLabel.isHidden = false
                
                self.approvedFirstSalonCodeLabel.isHidden = false
                self.approvedSecondSalonCodeLabel.isHidden = false
                
                self.approvedFirstSalonNameLabel.text! = self.getSalonName(saloncode: insalon1code)
                self.approvedSecondSalonNameLabel.text! = self.getSalonName(saloncode: insalon2code)
                self.approvedFirstSubjectNameLabel.text! = self.getSubjectName(trainingcode: insalon1subject)
                self.approvedSecondSubjectNameLabel.text! = self.getSubjectName(trainingcode: insalon2subject)
            }
            
            else if (activitynameStr == "Workshop"){
                self.approvedHeaderStackView.isHidden = true
                self.approvedFirstSubjectHeaderLabel.isHidden = false
                self.approvedSecondSubjectHeaderLabel.isHidden = true
                self.approvedThirdSubjectHeaderLabel.isHidden = true
                
                self.approvedFirstSubjectNameLabel.isHidden  =  false
                self.approvedSecondSubjectNameLabel.isHidden  =  true
                self.approvedThirdSubjectNameLabel.isHidden  =  true
                
                self.approvedFirstSalonNameLabel.isHidden = true
                self.approvedSecondSalonNameLabel.isHidden = true
                
                self.approvedFirstSalonCodeLabel.isHidden = true
                self.approvedSecondSalonCodeLabel.isHidden = true
                
                self.approvedFirstSubjectNameLabel.text! = self.getSubjectName(trainingcode: activitysubject)
                if(self.approvedFirstSubjectNameLabel.text! == ""){
                   self.approvedFirstSubjectNameLabel.text! = "Subject"
                }
                self.approvedFirstSubjectHeaderLabel.text! = "Subject1"
            }
                
                
                
            else if(activitynameStr == "Virtual Training") {
                self.approvedHeaderStackView.isHidden = true
                
                self.approvedFirstSubjectHeaderLabel.isHidden = false
                self.approvedSecondSubjectHeaderLabel.isHidden = false
                self.approvedThirdSubjectHeaderLabel.isHidden = false
                
                self.approvedThirdSubjectNameLabel.isHidden = false

                self.approvedFirstSalonNameLabel.isHidden = true
                self.approvedSecondSalonNameLabel.isHidden = true
                
                self.approvedFirstSalonCodeLabel.isHidden = true
                self.approvedSecondSalonCodeLabel.isHidden = true
                
                self.approvedFirstSubjectNameLabel.text! = ""
                self.approvedSecondSubjectNameLabel.text! = ""
                self.approvedThirdSubjectNameLabel.text! = ""
                
                self.approvedFirstSubjectNameLabel.text! = self.getSubjectName(trainingcode: insalon1subject)
                self.approvedSecondSubjectNameLabel.text! = self.getSubjectName(trainingcode: insalon2subject)
                self.approvedThirdSubjectNameLabel.text! = self.getSubjectName(trainingcode: activitysubject)
                
                print("SUBJECTVALUES=========================")
                print(self.approvedFirstSubjectNameLabel.text!)
                print(self.approvedSecondSubjectNameLabel.text!)
                print(self.approvedThirdSubjectNameLabel.text!)

                
                if(self.approvedFirstSubjectNameLabel.text! == ""){
                    self.approvedFirstSubjectHeaderLabel.isHidden = true
                    self.approvedFirstSubjectNameLabel.isHidden = true
                }
                if(self.approvedSecondSubjectNameLabel.text! == ""){
                    self.approvedSecondSubjectHeaderLabel.isHidden = true
                    self.approvedSecondSubjectNameLabel.isHidden = true
                }
                if(self.approvedThirdSubjectNameLabel.text! == ""){
                    self.approvedThirdSubjectHeaderLabel.isHidden = true
                    self.approvedThirdSubjectNameLabel.isHidden = true
                }
                if(self.approvedFirstSubjectNameLabel.text! == ""){
                    self.approvedSecondSubjectHeaderLabel.text! = "Subject1"
                }
                if(self.approvedSecondSubjectNameLabel.text! == ""){
                    self.approvedThirdSubjectHeaderLabel.text! = "Subject2"
                }
                if(self.approvedSecondSubjectNameLabel.text! == "" && self.approvedFirstSubjectNameLabel.text! == "" ){
                    self.approvedThirdSubjectHeaderLabel.text! = "Subject1"
                }
            }
            else {
                self.approvedDataStackView.isHidden = true
                self.approvedHeaderStackView.isHidden = true
            }
        }
        else {
            self.approvedDataStackView.isHidden = true
            self.approvedHeaderStackView.isHidden = true
        }
    }
    
    fileprivate func SetAwaitingList(activityname : String, eventDate : String){
        var stmt4:OpaquePointer?
        let queryString = "select distinct substr(date,6,8) as dateSubStr, case when neW_SALONCODE1 ISNULL then '' else neW_SALONCODE1 end as neW_SALONCODE1 ,neW_SALONCODE2,neW_INSALON_1_SUBJECT,case when neW_INSALON_2_SUBJECT ISNULL then '' else neW_INSALON_2_SUBJECT end as neW_INSALON_2_SUBJECT,neW_ACTIVITY_SUBJECT,changE_REQUESTED  from GetCalenderPending where dateSubStr like '%" + eventDate + "%' "
        print("SetAwaitingList"+queryString)

        if sqlite3_prepare_v2(DatabaseConnection.dbs, queryString, -1, &stmt4, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(DatabaseConnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return
        }
        self.awaitingTrainingTypeLabel.text! = ""
        
        if(sqlite3_step(stmt4) == SQLITE_ROW){
            let entity = String(cString: sqlite3_column_text(stmt4, 0))
            let insalon1code = String(cString: sqlite3_column_text(stmt4, 1))
            let insalon2code = String(cString: sqlite3_column_text(stmt4, 2))
            let insalon1subject = String(cString: sqlite3_column_text(stmt4, 3))
            let insalon2subject = String(cString: sqlite3_column_text(stmt4, 4))
            let activitysubject = String(cString: sqlite3_column_text(stmt4, 5))
            let activitynameStr = String(cString: sqlite3_column_text(stmt4, 6))
            
            self.awaitingTrainingTypeLabel.text! = activitynameStr
            
            if(activitynameStr == "InSalon"){
                self.awaitingFirstSalonCodeLabel.text! = insalon1code
                self.awaitingSecondSalonCodeLabel.text! = insalon2code

                self.awaitingHeaderStackView.isHidden = false
                self.awaitingFirstSubjectHeaderLabel.isHidden = true
                self.awaitingSecondSubjectHeaderLabel.isHidden = true
                self.awaitingThirdSubjectHeaderLabel.isHidden = true
                self.awaitingThirdSubjectNameLabel.isHidden  =  true
                
                self.awaitingFirstSalonNameLabel.isHidden = false
                self.awaitingSecondSalonNameLabel.isHidden = false
                
                self.awaitingFirstSalonCodeLabel.isHidden = false
                self.awaitingSecondSalonCodeLabel.isHidden = false
                
                self.awaitingFirstSalonNameLabel.text! = self.getSalonName(saloncode: insalon1code)
                self.awaitingSecondSalonNameLabel.text! = self.getSalonName(saloncode: insalon2code)
                self.awaitingFirstSubjectNameLabel.text! = self.getSubjectName(trainingcode: insalon1subject)
                self.awaitingSecondSubjectNameLabel.text! = self.getSubjectName(trainingcode: insalon2subject)
            }
            else if (activitynameStr == "Workshop"){
                self.awaitingHeaderStackView.isHidden = true
                self.awaitingFirstSubjectHeaderLabel.isHidden = false
                self.awaitingSecondSubjectHeaderLabel.isHidden = true
                self.awaitingThirdSubjectHeaderLabel.isHidden = true
                
                self.awaitingFirstSubjectNameLabel.isHidden  =  false
                self.awaitingSecondSubjectNameLabel.isHidden  =  true
                self.awaitingThirdSubjectNameLabel.isHidden  =  true
                
                self.awaitingFirstSalonNameLabel.isHidden = true
                self.awaitingSecondSalonNameLabel.isHidden = true
                
                self.awaitingFirstSalonCodeLabel.isHidden = true
                self.awaitingSecondSalonCodeLabel.isHidden = true
                
                self.awaitingFirstSubjectNameLabel.text! = self.getSubjectName(trainingcode: activitysubject)
                if(self.awaitingFirstSubjectNameLabel.text! == ""){
                   self.awaitingFirstSubjectNameLabel.text! = "Subject"
                }
                self.awaitingFirstSubjectHeaderLabel.text! = "Subject1"
            }
                
            else if(activitynameStr == "Virtual Training") {
                self.awaitingHeaderStackView.isHidden = true
                
                self.awaitingFirstSubjectHeaderLabel.isHidden = false
                self.awaitingSecondSubjectHeaderLabel.isHidden = false
                self.awaitingThirdSubjectHeaderLabel.isHidden = false
                
                self.awaitingThirdSubjectNameLabel.isHidden = false

                self.awaitingFirstSalonNameLabel.isHidden = true
                self.awaitingSecondSalonNameLabel.isHidden = true
                
                self.awaitingFirstSalonCodeLabel.isHidden = true
                self.awaitingSecondSalonCodeLabel.isHidden = true
                
                self.awaitingFirstSubjectNameLabel.text! = ""
                self.awaitingSecondSubjectNameLabel.text! = ""
                self.awaitingThirdSubjectNameLabel.text! = ""
                
                self.awaitingFirstSubjectNameLabel.text! = self.getSubjectName(trainingcode: insalon1subject)
                self.awaitingSecondSubjectNameLabel.text! = self.getSubjectName(trainingcode: insalon2subject)
                self.awaitingThirdSubjectNameLabel.text! = self.getSubjectName(trainingcode: activitysubject)
                
                print("SUBJECTVALUES=========================")
                print(self.awaitingFirstSubjectNameLabel.text!)
                print(self.awaitingSecondSubjectNameLabel.text!)
                print(self.awaitingThirdSubjectNameLabel.text!)
                
                if(self.awaitingFirstSubjectNameLabel.text! == ""){
                    self.awaitingFirstSubjectHeaderLabel.isHidden = true
                    self.awaitingFirstSubjectNameLabel.isHidden = true
                }
                if(self.awaitingSecondSubjectNameLabel.text! == ""){
                    self.awaitingSecondSubjectHeaderLabel.isHidden = true
                    self.awaitingSecondSubjectNameLabel.isHidden = true
                }
                if(self.awaitingThirdSubjectNameLabel.text! == ""){
                    self.awaitingThirdSubjectHeaderLabel.isHidden = true
                    self.awaitingThirdSubjectNameLabel.isHidden = true
                }
                if(self.awaitingFirstSubjectNameLabel.text! == ""){
                    self.awaitingSecondSubjectHeaderLabel.text! = "Subject1"
                }
                if(self.awaitingSecondSubjectNameLabel.text! == ""){
                    self.awaitingThirdSubjectHeaderLabel.text! = "Subject2"
                }
                if(self.awaitingSecondSubjectNameLabel.text! == "" && self.awaitingFirstSubjectNameLabel.text! == "" ){
                    self.awaitingThirdSubjectHeaderLabel.text! = "Subject1"
                }
            }
            else {
                self.awaitingHeaderStackView.isHidden = true
                self.awaitingDataStackView.isHidden = true
            }
        }
        else {
            self.awaitingHeaderStackView.isHidden = true
            self.awaitingDataStackView.isHidden = true
        }
    }
}
