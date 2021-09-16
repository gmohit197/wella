//
//  PlannedForWorkshopViewController.swift
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

class PlannedForWorkshopViewController: ExecuteApi {

    @IBAction func SubmitBtnClick(_ sender: UIButton) {
        INSERTDATA()
        
    }
    @IBAction func cancelBtnClick(_ sender: UIButton) {
        BACKTOSCREEN()
    }
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var training3DropDown: DropDown!
    @IBOutlet weak var training2DropDown: DropDown!
    @IBOutlet weak var training1DropDown: DropDown!
    
    var subjectNamearray1 : [String]! = []
    var subjectCodearray1 : [String]! = []
    var subjectNamearray2 : [String]! = []
    var subjectCodearray2 : [String]! = []
    var subjectNamearray3: [String]! = []
    var subjectCodearray3 : [String]! = []

    var subjectName1 : String! = ""
    var subjectCode1 : String! = ""
    var subjectName2 : String! = ""
    var subjectCode2 : String! = ""
    var subjectName3 : String! = ""
    var subjectCode3 : String! = ""
   
    var oldsubjectCode : String! = ""
    var selectedText : String! = ""
    var eventName : String! = ""
    var TRNAPPID : String! = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let value = UIInterfaceOrientation.portrait.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
        
        self.selectedText = AppDelegate.selectedText
        self.eventName = AppDelegate.calendarevent
        self.dateLabel.text! = AppDelegate.palnnedcalendardate

        
        self.headerLabel.text! = "Change Activity Name : " + selectedText!
         self.TRNAPPID! = UserDefaults.standard.string(forKey: "userid")! + getTodayStringNew()
        self.fillSubjectData()
        self.setupOnClickSubject1()
        self.getOldSubjectCode(eventDate: AppDelegate.palnnedcalendardate)
        
        if(selectedText == "Virtual Training"){
            self.showDropDown(dropdown: training2DropDown)
            self.showDropDown(dropdown: training3DropDown)
            self.setupOnClickSubject2()
            self.setupOnClickSubject3()
        }
        else{
            self.hideDropDown(dropdown: training2DropDown)
            self.hideDropDown(dropdown: training3DropDown)
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
          super.viewWillTransition(to: size, with: coordinator)
          let value = UIInterfaceOrientation.portrait.rawValue
          UIDevice.current.setValue(value, forKey: "orientation")
      }
    
    fileprivate func getOldSubjectCode(eventDate : String){
           var stmt4:OpaquePointer?
           let queryString = "select distinct substr(date,6,8) as dateSubStr,activitY_SUBJECT from Calender where dateSubStr like '%" + eventDate + "%' "
           print("SetPlannedList"+queryString)
           if sqlite3_prepare_v2(DatabaseConnection.dbs, queryString, -1, &stmt4, nil) != SQLITE_OK{
               let errmsg = String(cString: sqlite3_errmsg(DatabaseConnection.dbs)!)
               print("error preparing get: \(errmsg)")
               return
           }
           if(sqlite3_step(stmt4) == SQLITE_ROW){
            self.oldsubjectCode =  String(cString: sqlite3_column_text(stmt4, 1))
        }
    }
    
    fileprivate func validation () -> Bool {
        if(training1DropDown.text == nil || self.subjectCode1 == nil ||     training1DropDown.text!.isEmpty || training1DropDown.text! == "" || training1DropDown.text! == "Select Training 1" || self.subjectCode1.isEmpty || self.subjectCode1! == ""){
            self.training1DropDown.text! = ""
            self.subjectCode1! = ""
            self.training2DropDown.text! = ""
            self.subjectCode2 = ""
            self.training3DropDown.text! = ""
            self.subjectCode3 = ""
            self.showtoast(controller: self, message: "Please Select Training 1", seconds: 1.0)
            return false
        }
            
         if(training2DropDown.isHidden == false && (self.training2DropDown.text!.count > 0) && (training2DropDown.text == nil || self.subjectCode2 == nil || training2DropDown.text!.isEmpty || training2DropDown.text! == "" || training2DropDown.text! == "Select Training 2" || self.subjectCode2.isEmpty || self.subjectCode2! == "")){
            self.training2DropDown.text! = ""
            self.subjectCode2 = ""
            self.training3DropDown.text! = ""
            self.subjectCode3 = ""
            self.showtoast(controller: self, message: "Please Select Training 2", seconds: 1.0)
            return false
        }
        if(training3DropDown.isHidden == false && (self.training3DropDown.text!.count > 0) && (training3DropDown.text == nil || self.subjectCode3 == nil || training3DropDown.text!.isEmpty || training3DropDown.text! == "" || training3DropDown.text! == "Select Training 3" || self.subjectCode3.isEmpty || self.subjectCode3! == "")){
            self.training3DropDown.text! = ""
            self.subjectCode3 = ""
            self.showtoast(controller: self, message: "Please Select Training 3", seconds: 1.0)
            return false
        }
         if (self.training3DropDown.text!.count > 0 && self.training2DropDown.text!.count == 0){
            self.training3DropDown.text! = ""
            self.subjectCode3 = ""
            self.training2DropDown.text! = ""
            self.subjectCode2 = ""
            self.showtoast(controller: self, message: "Please Select Training 2", seconds: 1.0)
            return false
        }
        return true
    }
    
    fileprivate func showDropDown(dropdown: DropDown){
        dropdown.isHidden = false
    }
    
    fileprivate func hideDropDown(dropdown: DropDown){
        dropdown.isHidden = true
    }
    
    fileprivate func setupOnClickSubject1(){
        training1DropDown.didSelect{(selectedText , index ,id) in
            print("Selected String: \(selectedText) \n index: \(index)")
            self.subjectName1 = self.subjectNamearray1[index]
            self.subjectCode1 = self.subjectCodearray1[index]
            
            self.training1DropDown.text! = self.subjectName1!
        }
    }
    
    fileprivate func INSERTDATA(){
        self.insertData(selectedText: selectedText, eventName: eventName)
    }
    
    fileprivate func BACKTOSCREEN(){
         self.navigationController?.popViewController(animated: true)
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

    fileprivate func dataModifyFromTrainingType(){
        if(selectedText == "Workshop"){
            self.subjectCode3 = self.subjectCode1
            self.subjectCode1 = ""
        }
    }
    
    fileprivate func insertData(selectedText: String! , eventName : String!){
        if(self.validation() && validateNetwork()){
            self.deletePostCalender()
            self.dataModifyFromTrainingType()
            self.insertPostCalender(TRNAPPID: TRNAPPID, ENTRY_TYPE: "1", TRAINER_CODE: UserDefaults.standard.string(forKey: "userid")!, IMPACT_DATE: AppDelegate.impactDateCalendar!, PLANNED_ACTIVITY: eventName, CHANGE_REQUESTED: selectedText, DATE_APPLIED:  getTodayDateStringYMD(), STATUS: "0", CREATEDDATETIME: getTodayDateStringYMD(), CREATEDBY: UserDefaults.standard.string(forKey: "userid")!, DATAAREAID: "7200", Post: "0", INSALON_1_CODE: "", NEW_INSALON_1_CODE: "", INSALON_1_SUBJECT:"" , NEW_INSALON_1_SUBJECT: self.subjectCode1, INSALON_2_CODE: "", NEW_INSALON_2_CODE: "", INSALON_2_SUBJECT: "", NEW_INSALON_2_SUBJECT: self.subjectCode2, ACTIVITY_SUBJECT: self.oldsubjectCode, NEW_ACTIVITY_SUBJECT: self.subjectCode3)
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

    

    fileprivate func setupOnClickSubject2(){
           training2DropDown.didSelect{(selectedText , index ,id) in
               print("Selected String: \(selectedText) \n index: \(index)")
                
            
               self.subjectName2 = self.subjectNamearray2[index]
               self.subjectCode2 = self.subjectCodearray2[index]
               
               self.training2DropDown.text! = self.subjectName2!
           }
       }
    fileprivate func setupOnClickSubject3(){
           training3DropDown.didSelect{(selectedText , index ,id) in
               print("Selected String: \(selectedText) \n index: \(index)")
               self.subjectName3 = self.subjectNamearray3[index]
               self.subjectCode3 = self.subjectCodearray3[index]
               
               self.training3DropDown.text! = self.subjectName3!
           }
       }
   

    @IBAction func BackBtnClick(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK:- SUBJECT
    fileprivate func fillSubjectData(){
        subjectNamearray1.removeAll()
        subjectCodearray1.removeAll()
        subjectNamearray2.removeAll()
        subjectCodearray2.removeAll()
        subjectNamearray3.removeAll()
        subjectCodearray3.removeAll()

        training1DropDown.optionArray.removeAll()
        training2DropDown.optionArray.removeAll()
        training3DropDown.optionArray.removeAll()

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
            
            training1DropDown.optionArray.append(trainingNameStr)
            training2DropDown.optionArray.append(trainingNameStr)
            training3DropDown.optionArray.append(trainingNameStr)
            
            subjectNamearray1.append(trainingNameStr)
            subjectCodearray1.append(trainingCodeStr)
            subjectNamearray2.append(trainingNameStr)
            subjectCodearray2.append(trainingCodeStr)
            subjectNamearray3.append(trainingNameStr)
            subjectCodearray3.append(trainingCodeStr)

        }
    }

}
