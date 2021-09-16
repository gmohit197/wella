//
//  PlannnedInSalonViewController.swift
//  Wella.2
//
//  Created by Acxiom Consulting on 29/03/21.
//  Copyright © 2021 Acxiom. All rights reserved.
//


import UIKit
import Dropdowns
import SQLite3
import Alamofire
import SystemConfiguration
import SwiftEventBus
import CoreLocation

class PlannnedInSalonViewController: ExecuteApi {
    @IBOutlet weak var secondEditBackGround: UIButton!
    @IBOutlet weak var firstEditBackGround: UIButton!
    @IBOutlet weak var headerLabel: UILabel!
     @IBAction func secondEditBtn(_ sender: UIButton) {
        secondEditBackGround.backgroundColor = UIColor.lightGray
        secondEditIconClick()
    }
    @IBAction func firstEditBtn(_ sender: UIButton) {
        firstEditBackGround.backgroundColor = UIColor.lightGray
        firstEditIconClick()
    }
    @IBOutlet weak var FirstSalonNameDropDown: DropDown!
    @IBOutlet weak var FirstSalonCodeDropDown: DropDown!
    @IBOutlet weak var SecondSalonNameDropDown: DropDown!
    @IBOutlet weak var SecondSalonCodeDropDown: DropDown!
    @IBOutlet weak var FirstTrainingDropDown: DropDown!
    @IBOutlet weak var SecondTrainingDropDown: DropDown!
    @IBAction func cancelBtnClick(_ sender: UIButton) {
        BACKTOSCREEN()
    }
    @IBAction func submitBtnClick(_ sender: UIButton) {
        INSERTDATA()
    }
    @IBOutlet weak var dateLabel: UILabel!
    var subjectNamearray1 : [String]! = []
    var subjectCodearray1 : [String]! = []
    var subjectNamearray2 : [String]! = []
    var subjectCodearray2 : [String]! = []

    var subjectName1 : String! = ""
    var subjectCode1 : String! = ""
    var subjectName2 : String! = ""
    var subjectCode2 : String! = ""
    
    var salonCode1 : String! = ""
    var salonName1 : String! = ""
    var salonCode2 : String! = ""
    var salonName2 : String! = ""
    
    var salonCodearray1 : [String]! = []
    var salonNamearray1 : [String]! = []
    var salonCodearray2 : [String]! = []
    var salonNamearray2 : [String]! = []

    var selectedText : String! = ""
    var eventName : String! = ""
    var TRNAPPID : String! = ""
    
     var subjectCode3 : String! = ""
     var oldsubjectCode1 : String! = ""
     var oldsubjectCode2 : String! = ""
    
    var oldsalonCode1 : String! = ""
    var oldsalonCode2 : String! = ""

    var oldsalonName1 : String! = ""
    var oldsalonName2 : String! = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let value = UIInterfaceOrientation.portrait.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
        
        self.selectedText = AppDelegate.selectedText
        self.eventName = AppDelegate.calendarevent
        self.dateLabel.text! = AppDelegate.palnnedcalendardate
        self.headerLabel.text! = "Change Activity Name : " + selectedText!
        self.TRNAPPID! = UserDefaults.standard.string(forKey: "userid")! + getTodayStringNew()
        disableDataIntially()
        fillSubjectData()
        fillDropDownData()
        setupOnClickSubject()
        setupOnClicksalon()
        self.getOldCodes(eventDate: AppDelegate.palnnedcalendardate)
        setupprefilleddata()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
            super.viewWillTransition(to: size, with: coordinator)
            let value = UIInterfaceOrientation.portrait.rawValue
            UIDevice.current.setValue(value, forKey: "orientation")
        }
    
    fileprivate func disableDataIntially(){
        self.FirstSalonCodeDropDown.isUserInteractionEnabled = false
        self.FirstSalonNameDropDown.isUserInteractionEnabled = false
        
        self.SecondSalonNameDropDown.isUserInteractionEnabled = false
        self.SecondSalonCodeDropDown.isUserInteractionEnabled = false
        
        self.FirstTrainingDropDown.isUserInteractionEnabled = false
        self.SecondTrainingDropDown.isUserInteractionEnabled = false
    }
    
    fileprivate func firstEditIconClick(){
        self.FirstSalonCodeDropDown.text!  = ""
        self.FirstSalonNameDropDown.text!  = ""
        self.FirstTrainingDropDown.text!  = ""
        self.salonCode1 = ""
        self.salonName1 = ""
        self.subjectName1 = ""
        self.subjectCode1 = ""

        self.FirstSalonCodeDropDown.isUserInteractionEnabled = true
        self.FirstSalonNameDropDown.isUserInteractionEnabled = true
        self.FirstTrainingDropDown.isUserInteractionEnabled = true
    }
    
    fileprivate func secondEditIconClick(){
        self.salonCode2 = ""
        self.salonName2 = ""
        self.subjectName2 = ""
        self.subjectCode2 = ""

        self.SecondSalonNameDropDown.text!  = ""
        self.SecondSalonCodeDropDown.text!  = ""
        self.SecondTrainingDropDown.text!  = ""

        self.SecondSalonNameDropDown.isUserInteractionEnabled = true
        self.SecondSalonCodeDropDown.isUserInteractionEnabled = true
        self.SecondTrainingDropDown.isUserInteractionEnabled = true
    }

    
    
    fileprivate func BACKTOSCREEN(){
         self.navigationController?.popViewController(animated: true)
    }

    
    fileprivate func INSERTDATA(){
         self.insertData(selectedText: selectedText, eventName: eventName)
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
    fileprivate func getOldCodes(eventDate : String){
              var stmt4:OpaquePointer?
              let queryString = "select distinct substr(date,6,8) as dateSubStr,insaloN_1_CODE,insaloN_2_CODE,insaloN_1_SUBJECT,insaloN_2_SUBJECT,activitY_SUBJECT,activitY_NAME  from Calender where dateSubStr like '%" + eventDate + "%' "
              print("SetPlannedList"+queryString)
              if sqlite3_prepare_v2(DatabaseConnection.dbs, queryString, -1, &stmt4, nil) != SQLITE_OK{
                  let errmsg = String(cString: sqlite3_errmsg(DatabaseConnection.dbs)!)
                  print("error preparing get: \(errmsg)")
                  return
              }
              if(sqlite3_step(stmt4) == SQLITE_ROW){
                let entity = String(cString: sqlite3_column_text(stmt4, 0))
                let insalon1code = String(cString: sqlite3_column_text(stmt4, 1))
                let insalon2code = String(cString: sqlite3_column_text(stmt4, 2))
                let insalon1subject = String(cString: sqlite3_column_text(stmt4, 3))
                let insalon2subject = String(cString: sqlite3_column_text(stmt4, 4))
                let activitysubject = String(cString: sqlite3_column_text(stmt4, 5))
                let activitynameStr = String(cString: sqlite3_column_text(stmt4, 6))
             
                self.oldsalonCode1 =  insalon1code
                self.oldsalonCode2 = insalon2code
                self.oldsubjectCode1 = insalon1subject
                self.oldsubjectCode2 = insalon2subject
                
           }
       }
    
    fileprivate func  setupprefilleddata(){
        self.FirstSalonNameDropDown.text! = self.getSalonName(saloncode: oldsalonCode1)
        self.SecondSalonNameDropDown.text! = self.getSalonName(saloncode: oldsalonCode2)
        self.salonName1 = self.getSalonName(saloncode: oldsalonCode1)
        self.salonName2 = self.getSalonName(saloncode: oldsalonCode2)
        
        self.FirstSalonCodeDropDown.text! = oldsalonCode1
        self.SecondSalonCodeDropDown.text! = oldsalonCode2
        self.salonCode1 = oldsalonCode1
        self.salonCode2 = oldsalonCode2
        
        self.FirstTrainingDropDown.text! = self.getSubjectName(trainingcode: oldsubjectCode1)
        self.SecondTrainingDropDown.text! = self.getSubjectName(trainingcode: oldsubjectCode2)
        self.subjectName1 = self.getSubjectName(trainingcode: oldsubjectCode1)
        self.subjectName2 = self.getSubjectName(trainingcode: oldsubjectCode2)
        self.subjectCode1 = oldsubjectCode1
        self.subjectCode2 = oldsubjectCode2
    }
    
    fileprivate func validation () -> Bool {
        var salonCode1Str : String! = ""
        var salonName1Str : String! = ""
        var subjectName1Str : String! = ""
        var salonCode2Str : String! = ""
        var salonName2Str : String! = ""
        var subjectName2Str : String! = ""
        
        salonCode1Str = self.getSalonCode(salonName: FirstSalonNameDropDown.text!)
        salonName1Str = self.getSalonName(saloncode: FirstSalonCodeDropDown.text!)
        subjectName1Str = self.getSubjectCode(trainingname: FirstTrainingDropDown.text!)

        salonCode2Str = self.getSalonCode(salonName: SecondSalonNameDropDown.text!)
        salonName2Str = self.getSalonName(saloncode: SecondSalonCodeDropDown.text!)
        subjectName2Str = self.getSubjectCode(trainingname: SecondTrainingDropDown.text!)

        if(FirstSalonCodeDropDown.text == nil || self.salonCode1 == nil || FirstSalonCodeDropDown.text!.isEmpty || FirstSalonCodeDropDown.text! == "" || FirstSalonCodeDropDown.text! == "Salon Code" || self.salonCode1.isEmpty || self.salonCode1! == ""){
            self.showtoast(controller: self, message: "Please Select First Salon Code", seconds: 1.0)
            return false
        }
        
      else if(FirstSalonNameDropDown.text == nil || self.salonName1 == nil || FirstSalonNameDropDown.text!.isEmpty || FirstSalonNameDropDown.text! == "" || FirstSalonNameDropDown.text! == "Salon Name" || self.salonName1.isEmpty || self.salonCode1! == ""){
            self.showtoast(controller: self, message: "Please Select First Salon Name", seconds: 1.0)
            return false
        }
        
        else if(FirstTrainingDropDown.text == nil || self.subjectName1 == nil ||  FirstTrainingDropDown.text!.isEmpty || FirstTrainingDropDown.text! == "" || FirstTrainingDropDown.text! == "Training Salon 1" || self.subjectName1.isEmpty || self.subjectName1! == ""){
              self.showtoast(controller: self, message: "Please Select Training Salon 1", seconds: 1.0)
              return false
          }
        else if((self.salonCode2.count > 0) && (SecondSalonCodeDropDown.text!.count > 0 )  &&  (SecondSalonCodeDropDown.text == nil || self.salonCode2 == nil || SecondSalonCodeDropDown.text!.isEmpty || SecondSalonCodeDropDown.text! == "" || SecondSalonCodeDropDown.text! == "Salon Code" || self.salonCode2.isEmpty || self.salonCode2! == "")){
            self.salonCode2 = ""
            self.SecondSalonCodeDropDown.text! = ""
            self.showtoast(controller: self, message: "Please Select  Second Salon Code", seconds: 1.0)
            return false
        }
        else if((self.salonName2.count > 0) && (SecondSalonNameDropDown.text!.count > 0 ) &&    (SecondSalonNameDropDown.text == nil || self.salonName2 == nil || SecondSalonNameDropDown.text!.isEmpty || SecondSalonNameDropDown.text! == "" || SecondSalonNameDropDown.text! == "Salon Name" || self.salonName2.isEmpty || self.salonName2! == "")){
            self.salonName2 = ""
            self.SecondSalonNameDropDown.text! = ""
            self.showtoast(controller: self, message: "Please Select Second Salon Name", seconds: 1.0)
            return false
        }
        else if((self.subjectName2.count > 0) && (SecondTrainingDropDown.text!.count > 0 ) &&  (SecondTrainingDropDown.text == nil || self.subjectName2 == nil || SecondTrainingDropDown.text!.isEmpty || SecondTrainingDropDown.text! == "" || SecondTrainingDropDown.text! == "Training Salon 2" || self.subjectName2.isEmpty || self.subjectName2! == "")){
            self.subjectName2 = ""
            self.SecondTrainingDropDown.text! = ""
            self.showtoast(controller: self, message: "Please Select Training Salon 2", seconds: 1.0)
            return false
        }
        else if (FirstSalonCodeDropDown.text!.count > 0  && ( salonName1Str == "" || salonName1Str == nil || salonName1Str.isEmpty)){
            self.FirstSalonCodeDropDown.text! = ""
            self.showtoast(controller: self, message: "Please Select First Salon Code", seconds: 1.0)
            return false
        }
        else if (FirstSalonNameDropDown.text!.count > 0  && ( salonCode1Str == "" || salonCode1Str == nil || salonCode1Str.isEmpty)){
            self.FirstSalonNameDropDown.text! = ""
            self.showtoast(controller: self, message: "Please Select First Salon Name", seconds: 1.0)
            return false
        }
        else if (FirstTrainingDropDown.text!.count > 0  && ( subjectName1Str == "" || subjectName1Str == nil || subjectName1Str.isEmpty)){
            self.FirstTrainingDropDown.text! = ""
             self.showtoast(controller: self, message: "Please Select Training Salon 1", seconds: 1.0)
            return false
        }
        else if (SecondSalonCodeDropDown.text!.count > 0  && ( salonName2Str == "" || salonName2Str == nil || salonName2Str.isEmpty)){
            self.SecondSalonCodeDropDown.text! = ""
            self.showtoast(controller: self, message: "Please Select Second Salon Code", seconds: 1.0)
            return false
        }
        else if (SecondSalonNameDropDown.text!.count > 0  && ( salonCode2Str == "" || salonCode2Str == nil || salonCode2Str.isEmpty)){
            self.SecondSalonNameDropDown.text! = ""
            self.showtoast(controller: self, message: "Please Select Second Salon Name", seconds: 1.0)
            return false
        }
        else if (SecondTrainingDropDown.text!.count > 0  && ( subjectName2Str == "" || subjectName2Str == nil || subjectName2Str.isEmpty)){
            self.SecondTrainingDropDown.text! = ""
             self.showtoast(controller: self, message: "Please Select Training Salon 2", seconds: 1.0)
            return false
        }
        else if((FirstSalonCodeDropDown.text!.count > 0 && FirstSalonNameDropDown.text!.count > 0 && FirstTrainingDropDown.text!.count > 0 && SecondSalonCodeDropDown.text!.count > 0 && SecondSalonNameDropDown.text!.count > 0 && SecondTrainingDropDown.text!.count > 0 )&&((salonCode1Str == salonCode2Str) && (salonName1Str == salonName2Str)&&(subjectName1Str == subjectName2Str))){
             self.showtoast(controller: self, message: "Please Select Different Salon", seconds: 1.0)
            return false
        }
        
        return true
    }
    
    fileprivate func EmptyData(){
        var salonCode1Str : String! = ""
        var salonName1Str : String! = ""
        var subjectName1Str : String! = ""
        var salonCode2Str : String! = ""
        var salonName2Str : String! = ""
        var subjectName2Str : String! = ""
        
        salonCode1Str = self.getSalonCode(salonName: FirstSalonNameDropDown.text!)
        salonName1Str = self.getSalonName(saloncode: FirstSalonCodeDropDown.text!)
        subjectName1Str = self.getSubjectCode(trainingname: FirstTrainingDropDown.text!)
        
        salonCode2Str = self.getSalonCode(salonName: SecondSalonNameDropDown.text!)
        salonName2Str = self.getSalonName(saloncode: SecondSalonCodeDropDown.text!)
        subjectName2Str = self.getSubjectCode(trainingname: SecondTrainingDropDown.text!)
        
        if(salonCode1Str.count == 0){
            self.salonName1 = ""
        }
        if(salonName1Str.count == 0){
            self.salonCode1 = ""
        }
        if(subjectName1Str.count == 0){
            self.subjectCode1 = ""
        }
        if(salonCode2Str.count == 0){
            self.salonName2 = ""
        }
        if(salonName2Str.count == 0){
            self.salonCode2 = ""
        }
        if(subjectName2Str.count == 0){
            self.subjectCode2 = ""
        }
    }
    
    fileprivate func validateRow() ->  Bool {
        if (((FirstSalonNameDropDown.text!.count > 0) && (FirstTrainingDropDown.text!.count > 0)) && (FirstSalonCodeDropDown.text!.count == 0)){
            self.showtoast(controller: self, message: "Please Select First Salon Code", seconds: 1.0)
            return false
        }
        
      else  if (((FirstSalonCodeDropDown.text!.count > 0) && (FirstTrainingDropDown.text!.count > 0)) && (FirstSalonNameDropDown.text!.count == 0)){
            self.showtoast(controller: self, message: "Please Select First Salon Name", seconds: 1.0)
            return false
        }
        
      else  if (((FirstSalonCodeDropDown.text!.count > 0) && (FirstSalonNameDropDown.text!.count > 0)) && (FirstTrainingDropDown.text!.count == 0)){
            self.showtoast(controller: self, message: "Please Select Training Salon 1", seconds: 1.0)
            return false
        }
      else  if (((SecondSalonNameDropDown.text!.count > 0) && (SecondTrainingDropDown.text!.count > 0)) && (SecondSalonCodeDropDown.text!.count == 0)){
              self.showtoast(controller: self, message: "Please Select Second Salon Code", seconds: 1.0)
              return false
          }
          
        else  if (((SecondSalonCodeDropDown.text!.count > 0) && (SecondTrainingDropDown.text!.count > 0)) && (SecondSalonNameDropDown.text!.count == 0)){
              self.showtoast(controller: self, message: "Please Select Second Salon Name", seconds: 1.0)
              return false
          }
          
        else  if (((SecondSalonCodeDropDown.text!.count > 0) && (SecondSalonNameDropDown.text!.count > 0)) && (SecondTrainingDropDown.text!.count == 0)){
              self.showtoast(controller: self, message: "Please Select Training Salon 2", seconds: 1.0)
              return false
          }

        return true
    }
    
    

    fileprivate func insertData(selectedText: String! , eventName : String!){
        if(self.validation() && self.validateRow() && self.validateNetwork()){
            self.deletePostCalender()
            self.EmptyData()
            self.insertPostCalender(TRNAPPID: TRNAPPID, ENTRY_TYPE: "1", TRAINER_CODE: UserDefaults.standard.string(forKey: "userid")!, IMPACT_DATE: AppDelegate.impactDateCalendar!, PLANNED_ACTIVITY: eventName, CHANGE_REQUESTED: selectedText, DATE_APPLIED:  getTodayDateStringYMD(), STATUS: "0", CREATEDDATETIME: getTodayDateStringYMD(), CREATEDBY: UserDefaults.standard.string(forKey: "userid")!, DATAAREAID: "7200", Post: "0", INSALON_1_CODE: "", NEW_INSALON_1_CODE: self.salonCode1, INSALON_1_SUBJECT:self.oldsubjectCode1, NEW_INSALON_1_SUBJECT: self.subjectCode1, INSALON_2_CODE: self.oldsalonCode2, NEW_INSALON_2_CODE: self.salonCode2, INSALON_2_SUBJECT: self.oldsubjectCode2, NEW_INSALON_2_SUBJECT: self.subjectCode2, ACTIVITY_SUBJECT: "", NEW_ACTIVITY_SUBJECT: "")
            
            if(validateNetwork()){
                AppDelegate.isIntentDone = "0"
                self.postCalendar()
            }
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


    
    @IBAction func backBtnClick(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    //MARK:- SUBJECT
    fileprivate func fillSubjectData(){
        subjectNamearray1.removeAll()
        subjectCodearray1.removeAll()
        subjectNamearray2.removeAll()
        subjectCodearray2.removeAll()
       

        FirstTrainingDropDown.optionArray.removeAll()
        SecondTrainingDropDown.optionArray.removeAll()

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
            
            FirstTrainingDropDown.optionArray.append(trainingNameStr)
            SecondTrainingDropDown.optionArray.append(trainingNameStr)
            
            subjectNamearray1.append(trainingNameStr)
            subjectCodearray1.append(trainingCodeStr)
            subjectNamearray2.append(trainingNameStr)
            subjectCodearray2.append(trainingCodeStr)

        }
    }
    fileprivate func setupOnClickSubject(){
           FirstTrainingDropDown.didSelect{(selectedText , index ,id) in
               print("Selected String: \(selectedText) \n index: \(index)")
               self.subjectName1 = self.subjectNamearray1[index]
               self.subjectCode1 = self.subjectCodearray1[index]
               
               self.FirstTrainingDropDown.text! = self.subjectName1!
           }
        
        SecondTrainingDropDown.didSelect{(selectedText , index ,id) in
            print("Selected String: \(selectedText) \n index: \(index)")
            self.subjectName2 = self.subjectNamearray2[index]
            self.subjectCode2 = self.subjectCodearray2[index]
            
            self.SecondTrainingDropDown.text! = self.subjectName2!
        }

       }
    
    func fillDropDownData () {
        salonNamearray1.removeAll()
        salonCodearray1.removeAll()
        FirstSalonNameDropDown.optionArray.removeAll()
        FirstSalonCodeDropDown.optionArray.removeAll()
        
        salonNamearray2.removeAll()
        salonCodearray2.removeAll()
        SecondSalonNameDropDown.optionArray.removeAll()
        SecondSalonCodeDropDown.optionArray.removeAll()

        
        var stmt:OpaquePointer?
        let queryString = "SELECT * FROM salon"
        
        if sqlite3_prepare_v2(DatabaseConnection.dbs, queryString, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(DatabaseConnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return
        }
        
        while(sqlite3_step(stmt) == SQLITE_ROW){
            let salonNameStr = String(cString: sqlite3_column_text(stmt, 1))
            let salonCodeStr = String(cString: sqlite3_column_text(stmt, 0))
            
            FirstSalonNameDropDown.optionArray.append(salonNameStr)
            FirstSalonCodeDropDown.optionArray.append(salonCodeStr)
            salonCodearray1.append(salonCodeStr)
            salonNamearray1.append(salonNameStr)
            
            SecondSalonNameDropDown.optionArray.append(salonNameStr)
            SecondSalonCodeDropDown.optionArray.append(salonCodeStr)
            salonCodearray2.append(salonCodeStr)
            salonNamearray2.append(salonNameStr)


        }
    }
    //MARK:- SALON CODE CLICK
    fileprivate func setupOnClicksalon(){
        FirstSalonCodeDropDown.didSelect{(selectedText , index ,id) in
            print("Selected String: \(selectedText) \n index: \(index)")
            self.salonCode1 = self.salonCodearray1[index]
            self.salonName1 = self.salonNamearray1[index]
            
            self.FirstSalonCodeDropDown.text! = self.salonCode1!
             self.FirstSalonNameDropDown.text! = self.salonName1!
        }
    
        FirstSalonNameDropDown.didSelect{(selectedText , index ,id) in
            print("Selected String: \(selectedText) \n index: \(index)")
            self.salonCode1 = self.salonCodearray1[index]
            self.salonName1 = self.salonNamearray1[index]
            
            self.FirstSalonCodeDropDown.text! = self.salonCode1!
             self.FirstSalonNameDropDown.text! = self.salonName1!
        }
    
        SecondSalonCodeDropDown.didSelect{(selectedText , index ,id) in
            print("Selected String: \(selectedText) \n index: \(index)")
            self.salonCode2 = self.salonCodearray2[index]
            self.salonName2 = self.salonNamearray2[index]
            
            self.SecondSalonCodeDropDown.text! = self.salonCode2!
            self.SecondSalonNameDropDown.text! = self.salonName2!
        }
        
        SecondSalonNameDropDown.didSelect{(selectedText , index ,id) in
            print("Selected String: \(selectedText) \n index: \(index)")
            self.salonCode2 = self.salonCodearray2[index]
            self.salonName2 = self.salonNamearray2[index]
            
            self.SecondSalonCodeDropDown.text! = self.salonCode2!
            self.SecondSalonNameDropDown.text! = self.salonName2!
        }
}


   

}
