//
//  EditStylistViewController.swift
//  Wella.2
//
//  Created by Acxiom Consulting on 12/02/21.
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
class EditStylistViewController: ExecuteApi,  CLLocationManagerDelegate , UINavigationControllerDelegate, UITextViewDelegate {
    
    //MARK:- OUTLETS
    @IBOutlet weak var colorLevelTextField: UITextField!
    @IBOutlet weak var anniversaryTextField: UITextField!
    @IBOutlet weak var cityDropDown: DropDown!
    @IBOutlet weak var salonAddressLabel: UILabel!
    @IBOutlet weak var salonNameDropDown: DropDown!
    @IBOutlet weak var stylistDOBTextField: UITextField!
    @IBOutlet weak var stylistAddressTextView: UITextView!
    @IBOutlet weak var stylistEmailTextField: UITextField!
    @IBOutlet weak var stylistContactTextField: UITextField!
    @IBOutlet weak var selectGenderTextField: UITextField!
    @IBOutlet weak var stylistNameTextFIeld: UITextField!
    @IBOutlet weak var stylistCodeTextField: UITextField!
    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet weak var salonCodeDropDown: DropDown!

    
    @IBAction func saveBtnClick(_ sender: UIButton) {
        INSERTDATA()
    }
    
    //MARK:- VARIABLE DECALARTION
    let datetime: String? = nil
    var datePicker: UIDatePicker?
    var datePicker2 : UIDatePicker?
    var date = Date()
    let formatter = DateFormatter()
    
    var salonCodearray : [String]! = []
    var salonNamearray : [String]! = []
    var salonAddressarray : [String]! = []
    var salonSiteCodearray : [String]! = []
    var salonPsrCodearray : [String]! = []
    var GenderNamearray : [String]! = []
    var GenderCodearray : [String]! = []
    var cityNamearray : [String]! = []
    var cityIdarray : [String]! = []
    
    //MARK:- OLD VALUES
    var stylistCode : String! = ""
    var stylistName : String! = ""
    var stylistGenderName : String! = ""
    var stylistGenderCode : String! = ""
    var stylistContact : String! = ""
    var stylistEmail : String! = ""
    var stylistAddress : String! = ""
    var stylistDOB : String! = ""
    var salonName : String! = ""
    var salonCode : String! = ""
    var salonAddress : String! = ""
    var city : String! = ""
    var anniversary : String! = ""
    var colorlevel : String! = ""
    
    //MARK:- NEW VALUES
    var stylistCode1 : String! = ""
    var stylistName1 : String! = ""
    var stylistGenderName1 : String! = ""
    var stylistGenderCode1 : String! = ""
    var stylistContact1 : String! = ""
    var stylistEmail1 : String! = ""
    var stylistAddress1 : String! = ""
    var stylistDOB1 : String! = ""
    var salonName1 : String! = ""
    var salonCode1 : String! = ""
    var salonAddress1 : String! = ""
    var city1 : String! = ""
    var anniversary1 : String! = ""
    var colorlevel1 : String! = ""
    
    var dobformated : String! = ""
    var anniversaryformated : String! = ""
    
    //MARK:- VIEW DID LOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        let value = UIInterfaceOrientation.portrait.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
        fillDropDownData()
        setupDidSelect()
        setupDatePicker()
        fetchData()
        fillDataInLables()
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        stylistAddressTextView.text!.removeAll()
    }
    
    //MARK:- FILLDATA IN STRINGS
    fileprivate func fillInitialdatainStrings(){
        self.stylistCode = ""
        self.stylistName = ""
        self.stylistGenderName = ""
        self.stylistGenderCode = ""
        self.stylistContact = ""
        self.stylistEmail = ""
        self.stylistAddress = ""
        self.stylistDOB = ""
        self.salonName = ""
        self.salonAddress = ""
        self.city = ""
        self.anniversary = ""
        self.colorlevel = ""
    }
    
    //MARK:- SETUP DATA IN LABELS
    fileprivate func fillDataInLables(){
        self.stylistCodeTextField.text! = self.stylistCode
        self.stylistNameTextFIeld.text! = self.stylistName
        self.selectGenderTextField.text! = self.stylistGenderName
        self.stylistContactTextField.text! = self.stylistContact
        self.stylistEmailTextField.text! = self.stylistEmail
        self.stylistAddressTextView.text! = self.stylistAddress
        self.stylistDOBTextField.text! = self.stylistDOB
        self.salonNameDropDown.text! = self.salonName!
        self.salonAddressLabel.text! = self.salonAddress
        self.cityDropDown.text! = self.city!
        self.anniversaryTextField.text! = self.anniversary
        self.colorLevelTextField.text! = self.colorlevel
        self.salonCodeDropDown.text! = self.salonCode!
    }
    
    //MARK:- FILL DROPDOWN
    fileprivate  func fillDropDownData () {
        fillCityNameDropDownData()
        fillSalonNameData()
    }
    
    //MARK:- CITY DROP
    fileprivate func fillCityNameDropDownData(){
        cityNamearray.removeAll()
        cityIdarray.removeAll()
        cityDropDown.optionArray.removeAll()
        
        var stmt:OpaquePointer?
        let queryString = "SELECT * FROM citymaster"
        
        if sqlite3_prepare_v2(DatabaseConnection.dbs, queryString, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(DatabaseConnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return
        }
        while(sqlite3_step(stmt) == SQLITE_ROW){
            let cityNameStr = String(cString: sqlite3_column_text(stmt, 1))
            let cityIdStr = String(cString: sqlite3_column_text(stmt, 0))
            
            cityDropDown.optionArray.append(cityNameStr)
            cityNamearray.append(cityNameStr)
            cityIdarray.append(cityIdStr)
        }
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
            salonSiteCodearray.append(salonSiteCodeStr)
            salonPsrCodearray.append(salonPsrCodeStr)
        }
    }
    
    //MARK:- OVERRIDE
    override func editStylistPostSuccess(){
        self.showtoast(controller: self, message: "Change Request Submitted to Manager For Approval", seconds: 1.0)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.push(vcId: "dashnc", vc: self)
        }
    }
    override func editStylistPostFailure(){
          self.showtoast(controller: self, message: "Data Not Submitted", seconds: 1.0)
              DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                  self.push(vcId: "dashnc", vc: self)
              }
    }
    
//    override func editStylistPostError(){
//        self.showtoast(controller: self, message: "Network Connection Failed , Please Try Again Later! ", seconds: 1.0)
//    }
    
    //MARK:- DATA INSERTION
    fileprivate func INSERTDATA(){
        if(validation() && validateNetwork()){
            do{
                stylistDOBTextField.text! = dobformated
                anniversaryTextField.text! = anniversaryformated
                self.deletEditStylistPost()
                self.insertEditStylistPost(trnappid: UserDefaults.standard.string(forKey: "userid")! + getTodayStringNew(), trainercode: UserDefaults.standard.string(forKey: "userid")!, entrytype: "2", dateapplied: getTodayDateStringYMD(), stylistcode: self.stylistCodeTextField.text!, dob: stylistDOB, newdob: stylistDOBTextField.text!, saloncode: salonCode, newsaloncode: self.salonCode1, address: stylistAddress, newaddress: stylistAddressTextView.text!, city: city, newcity: cityDropDown.text!, anniversary: anniversary, newanniversary: anniversaryTextField.text!, status: "0",post : "0", dataareaid: "7200")
                saveBtn.isEnabled = false
                postEditStylistData()
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
    
    //MARK:- FETCHDATA FROM QUERY
    fileprivate func fetchData(){
        
        var stmt:OpaquePointer?
        let queryString = "SELECT * FROM StylistbyContactNo"
        if sqlite3_prepare_v2(DatabaseConnection.dbs, queryString, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(DatabaseConnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return
        }
        while(sqlite3_step(stmt) == SQLITE_ROW){
            let stylistCodeStr = String(cString: sqlite3_column_text(stmt, 0))
            let stylistNameStr = String(cString: sqlite3_column_text(stmt, 1))
            let salonCodeStr = String(cString: sqlite3_column_text(stmt, 4))
            let stylistGenderCodeStr = String(cString: sqlite3_column_text(stmt, 9))
            let stylistContactStr = String(cString: sqlite3_column_text(stmt, 6))
            let stylistEmailStr = String(cString: sqlite3_column_text(stmt, 7))
            let stylistAddressStr = String(cString: sqlite3_column_text(stmt, 14))
            let stylistDOBStr = String(cString: sqlite3_column_text(stmt, 13))
            let salonNameStr = String(cString: sqlite3_column_text(stmt, 5))
            let salonAddressStr = String(cString: sqlite3_column_text(stmt, 8))
            let cityStr = String(cString: sqlite3_column_text(stmt, 10))
            let anniversaryStr = String(cString: sqlite3_column_text(stmt, 11))
            let colorlevelStr = String(cString: sqlite3_column_text(stmt, 12))

            var stylistGenderNameStr : String! = ""
            switch stylistGenderCodeStr {
            case "0":
                stylistGenderNameStr = "Male"
            case "1":
                stylistGenderNameStr = "Female"
            case "2":
                stylistGenderNameStr = "Prefer Not to Say"
            default:
                stylistGenderNameStr = "Wrong"
                break
            }
            self.salonCode = salonCodeStr
            self.salonCode1 = salonCodeStr
            self.stylistCode = stylistCodeStr
            self.stylistName = stylistNameStr
            self.stylistGenderName = stylistGenderNameStr
            self.stylistGenderCode = stylistGenderCodeStr
            self.stylistContact = stylistContactStr
            self.stylistEmail = stylistEmailStr
            self.stylistAddress = stylistAddressStr
            self.stylistDOB = stylistDOBStr
            self.salonName = salonNameStr
            self.salonAddress = salonAddressStr
            self.city = cityStr
            self.anniversary = anniversaryStr
            self.colorlevel = colorlevelStr
        }

    }
    
    
    //MARK:- VALIDATION
    fileprivate func validation() -> Bool {
        do{
            //        if(stylistNameTextFIeld.text!.isEmpty || stylistNameTextFIeld.text! == ""){
            //            self.showtoast(controller: self, message: "Please Enter Stylist Name", seconds: 1.0)
            //            return false
            //        }
            //        else  if(selectGenderTextField.text == nil || self.stylistGenderCode == nil || selectGenderTextField.text!.isEmpty || selectGenderTextField.text! == "" || selectGenderTextField.text! == "Select Gender" || self.stylistGenderCode!.isEmpty || self.stylistGenderCode == ""){
            //            self.showtoast(controller: self, message: "Please Select Gender", seconds: 1.0)
            //            return false
            //        }
            //
            //        else  if(stylistEmailTextField.text == nil || stylistEmailTextField.text!.isEmpty || stylistEmailTextField.text! == "" || stylistEmailTextField.text! == "Email") {
            //            self.showtoast(controller: self, message: "Please Enter Valid EmailID", seconds: 1.0)
            //            return false
            //        }
            //        else  if(!(isValidEmail(stylistEmailTextField.text!))) {
            //            self.showtoast(controller: self, message: "Please Enter Valid EmailID", seconds: 1.0)
            //            return false
            //        }
            //        else
            
            if(salonCodeDropDown.text == nil || self.salonCode == nil ||     salonCodeDropDown.text!.isEmpty || salonCodeDropDown.text! == "" || salonCodeDropDown.text! == "Select Salon Code" || self.salonCode.isEmpty || self.salonCode! == ""){
                self.showtoast(controller: self, message: "Please Select Salon Code", seconds: 1.0)
                return false
            }
            
            if(salonNameDropDown.text == nil || self.salonName == nil ||     salonNameDropDown.text!.isEmpty || salonNameDropDown.text! == "" || salonNameDropDown.text! == "Select Salon" || self.salonName.isEmpty || self.salonName! == ""){
                self.showtoast(controller: self, message: "Please Select Salon Name", seconds: 1.0)
                return false
            }
                //        else  if(salonAddressLabel.text!.isEmpty || salonAddressLabel.text! == "" || salonAddressLabel.text! == "Salon Address"){
                //              self.showtoast(controller: self, message: "Please Enter Salon Address", seconds: 1.0)
                //              return false
                //          }
            else  if(cityDropDown.text!.isEmpty || cityDropDown.text! == "" || cityDropDown.text! == "Select City"){
                self.showtoast(controller: self, message: "Please Fill City", seconds: 1.0)
                return false
            }
            else  if(stylistDOBTextField.text!.isEmpty || stylistDOBTextField.text! == "" || stylistDOBTextField.text! == "Select DOB"){
                self.showtoast(controller: self, message: "Please Select Your DOB", seconds: 1.0)
                return false
            }
            //        else  if(anniversaryTextField.text!.isEmpty || anniversaryTextField.text! == "" || anniversaryTextField.text! == "Select Anniversary"){
            //            anniversaryTextField.text! = ""
            //            return true
            //        }
            //        else  if(colorLevelTextField.text!.isEmpty || colorLevelTextField.text! == "" || colorLevelTextField.text! == "Color Level"){
            //            colorLevelTextField.text! = ""
            //            return true
            //            }
            //
        }
        return true
    }
    
    //MARK:- VALIDATE EMAIL
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    //MARK:- SETUP DID SELECT
    fileprivate func setupDidSelect(){
        setupOnClickSalonName()
        setupOnClickCity()
        setupOnClickSalonCode()
    }

    
    //MARK:- CITY SELECT
    fileprivate func setupOnClickCity(){
        cityDropDown.didSelect{(selectedText , index ,id) in
            print("Selected String: \(selectedText) \n index: \(index)")
            self.city1 = self.cityNamearray[index]
            self.cityDropDown.text! = self.city1!
         }
    }
    //MARK:- SALON SELECT
    fileprivate func setupOnClickSalonName(){
        salonNameDropDown.didSelect{(selectedText , index ,id) in
            print("Selected String: \(selectedText) \n index: \(index)")
            self.salonName1 = self.salonNamearray[index]
            self.salonCode1 = self.salonCodearray[index]
            self.salonAddress1 = self.salonAddressarray[index]
            
            self.salonNameDropDown.text! = self.salonName1!
            self.salonCodeDropDown.text! = self.salonCode1!
            self.salonAddressLabel.text! = self.salonAddress1!
        }
    }
    //MARK:- SALON SELECT
    fileprivate func setupOnClickSalonCode(){
        salonCodeDropDown.didSelect{(selectedText , index ,id) in
            print("Selected String: \(selectedText) \n index: \(index)")
            self.salonName1 = self.salonNamearray[index]
            self.salonCode1 = self.salonCodearray[index]
            self.salonAddress1 = self.salonAddressarray[index]
            
            self.salonNameDropDown.text! = self.salonName1!
            self.salonCodeDropDown.text! = self.salonCode1!
            self.salonAddressLabel.text! = self.salonAddress1!
        }
    }
    
    //MARK:- DATE PICKER
    fileprivate func setupDatePicker(){
        datePicker = UIDatePicker()
        datePicker?.datePickerMode = .date
        datePicker2 = UIDatePicker()
        datePicker2?.datePickerMode = .date
        datePicker?.maximumDate = self.date
        datePicker2?.maximumDate = self.date
        
        datePicker?.addTarget(self, action: #selector(EditStylistViewController.dateChanged(datePicker:)), for: .valueChanged)
        datePicker2?.addTarget(self, action: #selector(EditStylistViewController.dateChanged(datePicker2:)), for: .valueChanged)
        stylistDOBTextField.inputView = datePicker
        anniversaryTextField.inputView = datePicker2
    }
    //MARK:- DATE CHANGED
    @objc func dateChanged(datePicker: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MMM-YYYY"
        stylistDOBTextField.text = dateFormatter.string(from: datePicker.date)
        
        formatter.dateFormat = "YYYY-MM-dd"
        let result = formatter.string(from: datePicker.date)
        dobformated = result
    }
    
    @objc func dateChanged(datePicker2: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MMM-YYYY"
        anniversaryTextField.text = dateFormatter.string(from: datePicker2.date)
        
        formatter.dateFormat = "YYYY-MM-dd"
        let result = formatter.string(from: datePicker2.date)
        anniversaryformated = result
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        let value = UIInterfaceOrientation.portrait.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
    }
}
