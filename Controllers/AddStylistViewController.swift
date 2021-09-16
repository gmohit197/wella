//
//  AddStylistViewController.swift
//  Wella.2
//
//  Created by Acxiom Consulting on 05/03/21.
//  Copyright © 2021 Acxiom. All rights reserved.


//MARK:- IMPORTS
import UIKit
import Dropdowns
import SQLite3
import Alamofire
import SystemConfiguration
import SwiftEventBus
import CoreLocation

//MARK:- BEGINNING
class AddStylistViewController: ExecuteApi,  CLLocationManagerDelegate , UINavigationControllerDelegate, UITextViewDelegate {

    //MARK:- OUTLETS
    @IBOutlet weak var submitBtn: UIButton!
    @IBOutlet weak var colorLevelTextField: DropDown!
    @IBOutlet weak var anniversaryTextField: UITextField!
    @IBOutlet weak var cityDropDown: DropDown!
    @IBOutlet weak var salonAddressLabel: UILabel!
    @IBOutlet weak var salonNameDropDown: DropDown!
    @IBOutlet weak var stylistDOBTextField: UITextField!
    @IBOutlet weak var stylistAddressTextView: UITextView!
    @IBOutlet weak var stylistEmailTextField: UITextField!
    @IBOutlet weak var stylistContactTextField: UITextField!
    @IBOutlet weak var selectGenderDropDown: DropDown!
    @IBOutlet weak var stylistNameTextFIeld: UITextField!
    @IBOutlet weak var salonCodeDropDown: DropDown!

    @IBAction func submitBtnClick(_ sender: UIButton) {
           INSERTDATA()
       }
   
    //MARK:- VARIABLE DECLARATION
    var menuvc: menuViewController!
    var salonCode : String! = ""
    var salonName : String! = ""
    var salonAddress : String! = ""
    var salonPsrCode : String! = ""
    var salonSiteCode : String! = ""
    var genderName : String! = ""
    var genderCode : String! = ""
    var cityName : String! = ""
    var locationManager:CLLocationManager!
    var lat: String! = ""
    var longi: String! = ""
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
    var colorNamearray : [String]! = []
    var colorIdarray : [String]! = []
    
    var colorName : String! = ""
    var colorId : String! = ""
    
    var dobformated : String! = ""
    var anniversaryformated : String! = ""



    
    //MARK:- VIEW DID LOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        let value = UIInterfaceOrientation.portrait.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
        self.stylistContactTextField.text! = AppDelegate.mobilenumber!
    //    self.stylistContactTextField.text! = "9315993285"

        let myUITextView = UITextView.init()
        myUITextView.delegate = self
        stylistAddressTextView.delegate = self
        setUpSideBar()
        setupDatePicker()
        determineMyCurrentLocation()
        fillDropDownData()
        setupDidSelect()
        setupOnClickSalonName()
        setupOnClickGender()
        anniversaryTextField.text! = ""
    }
    
    
    //MARK:- TEXTVIEW NIL
    func textViewDidBeginEditing(_ textView: UITextView) {
        stylistAddressTextView.text!.removeAll()
    }
    
    //MARK:- DATE PICKER
    fileprivate func setupDatePicker(){
        datePicker = UIDatePicker()
        datePicker?.datePickerMode = .date
        datePicker2 = UIDatePicker()
        datePicker2?.datePickerMode = .date
        datePicker?.maximumDate = self.date
        datePicker2?.maximumDate = self.date

        datePicker?.addTarget(self, action: #selector(AddStylistViewController.dateChanged(datePicker:)), for: .valueChanged)
        datePicker2?.addTarget(self, action: #selector(AddStylistViewController.dateChanged(datePicker2:)), for: .valueChanged)
        stylistDOBTextField.inputView = datePicker
        anniversaryTextField.inputView = datePicker2
//     formatter.dateFormat = "dd-MMM-yyyy"
//        let result = formatter.string(from: date)
//        stylistDOBTextField.text = result
//        anniversaryTextField.text = result
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
    
    //MARK:- SETUP DID SELECT
    fileprivate func setupDidSelect(){
        setupOnClickGender()
        setupOnClickSalonName()
        setupOnClickCity()
        setupOnClickColorLevel()
        setupOnClickSalonCode()
    }
    
    //MARK:- COLOR SELECT
    fileprivate func setupOnClickColorLevel(){
        colorLevelTextField.didSelect{(selectedText , index ,id) in
            print("Selected String: \(selectedText) \n index: \(index)")
            self.colorName = self.colorNamearray[index]
            self.colorId = self.colorIdarray[index]
            self.colorLevelTextField.text! = self.colorName!
        }
    }

    
    //MARK:- CITY SELECT
    fileprivate func setupOnClickCity(){
        cityDropDown.didSelect{(selectedText , index ,id) in
            print("Selected String: \(selectedText) \n index: \(index)")
            self.cityName = self.cityNamearray[index]
            self.cityDropDown.text! = self.cityName!
         }
    }
 
    //MARK:- GENDER SELECT
    fileprivate func setupOnClickGender(){
        selectGenderDropDown.didSelect{(selectedText , index ,id) in
            print("Selected String: \(selectedText) \n index: \(index)")
            self.selectGenderDropDown.text! = self.GenderNamearray[index]
            self.genderCode = self.GenderCodearray[index]
         }
    }

    //MARK:- SALON SELECT
    fileprivate func setupOnClickSalonName(){
        salonNameDropDown.didSelect{(selectedText , index ,id) in
            print("Selected String: \(selectedText) \n index: \(index)")
            self.salonName = self.salonNamearray[index]
            self.salonCode = self.salonCodearray[index]
            self.salonAddress = self.salonAddressarray[index]
            self.salonPsrCode = self.salonPsrCodearray[index]
            self.salonSiteCode = self.salonSiteCodearray[index]
            
            self.salonNameDropDown.text! = self.salonName!
            self.salonAddressLabel.text! = ""
            self.salonAddressLabel.text! = self.salonAddress!
            self.salonCodeDropDown.text! = self.salonCode!
        }
    }
    
    fileprivate func setupOnClickSalonCode(){
        salonCodeDropDown.didSelect{(selectedText , index ,id) in
            print("Selected String: \(selectedText) \n index: \(index)")
            self.salonName = self.salonNamearray[index]
            self.salonCode = self.salonCodearray[index]
            self.salonAddress = self.salonAddressarray[index]
            self.salonPsrCode = self.salonPsrCodearray[index]
            self.salonSiteCode = self.salonSiteCodearray[index]
            
            self.salonNameDropDown.text! = self.salonName!
            self.salonCodeDropDown.text! = self.salonCode!
            self.salonAddressLabel.text! = ""
            self.salonAddressLabel.text! = self.salonAddress!
        }
    }
    
    //MARK:- FILL DROPDOWN
    fileprivate  func fillDropDownData () {
        fillGenderDropDownData()
        fillCityNameDropDownData()
        fillSalonNameData()
        fillColorLevelDropDownData()
    }
    
    //MARK:- COLORLEVEL DROP
    fileprivate func fillColorLevelDropDownData(){
        colorNamearray.removeAll()
        colorIdarray.removeAll()
        colorLevelTextField.optionArray.removeAll()
        
        var stmt:OpaquePointer?
        let queryString = "SELECT * FROM ColorLevel"
        
        if sqlite3_prepare_v2(DatabaseConnection.dbs, queryString, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(DatabaseConnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return
        }
        while(sqlite3_step(stmt) == SQLITE_ROW){
            let colorNameStr = String(cString: sqlite3_column_text(stmt, 0))
            let colorIdStr = String(cString: sqlite3_column_text(stmt, 1))
            
            colorLevelTextField.optionArray.append(colorNameStr)
            colorNamearray.append(colorNameStr)
            colorIdarray.append(colorIdStr)
        }
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
    //MARK:- GENDER DROP
    fileprivate func fillGenderDropDownData(){
        GenderNamearray.removeAll()
        GenderCodearray.removeAll()
        selectGenderDropDown.optionArray.removeAll()
        
        GenderCodearray.append("0")
        GenderCodearray.append("1")
        GenderCodearray.append("2")
        
        GenderNamearray.append("Male")
        GenderNamearray.append("Female")
        GenderNamearray.append("Prefer Not to Say")
        
        selectGenderDropDown.optionArray.append("Male")
        selectGenderDropDown.optionArray.append("Female")
        selectGenderDropDown.optionArray.append("Prefer Not to Say")
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
    override func stylistGetSuccess(){
        self.hideSyncloader()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
             self.push(vcId: "dashnc", vc: self)
        }
    }
    
    //MARK:- OVERRIDE
    override func stylistGetFailure(){
        self.hideSyncloader()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.push(vcId: "dashnc", vc: self)
        }
    }
    
    
    //MARK:- OVERRIDE
    override func addStylistPostSuccess(){
        self.showtoast(controller: self, message: "Data Submitted Successfully", seconds: 1.0)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.executeStylistData()
        }
    }
    override func addStylistPostFailure(){
           self.showtoast(controller: self, message: "Data Not Submitted", seconds: 1.0)
           DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.push(vcId: "dashnc", vc: self)
           }
       }
    
   
    //MARK:- DATA INSERTION
    fileprivate func INSERTDATA(){
        if(validation() && validateNetwork()){
            do{
                self.stylistDOBTextField.text! = dobformated
                self.anniversaryTextField.text! = anniversaryformated
                print("Color Level======================================================")
                print(self.colorId!)

                self.deletAddStylistPost()
                self.insertAddStylistPost(id: UserDefaults.standard.string(forKey: "userid")! + getTodayStringNew(),stylistname: self.stylistNameTextFIeld.text!, sitecode: self.salonSiteCode!, saloncode: self.salonCode!, contact: self.stylistContactTextField.text!, email: self.stylistEmailTextField.text!, salonaddress: self.salonAddressLabel.text!, lat: lat, long: longi, usercode: UserDefaults.standard.string(forKey: "userid")!, gender: self.genderCode!, city: self.cityName!, dob: self.stylistDOBTextField.text!, anniversary: self.anniversaryTextField.text!, colorlevel: self.colorId!)
                self.submitBtn.isEnabled = false
                self.showSyncloader(title: "Syncing....")
                postAddStylistData()
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
        var isValidate : Bool = true
     //   do{
        if(stylistNameTextFIeld.text!.isEmpty || stylistNameTextFIeld.text! == ""){
            self.showtoast(controller: self, message: "Please Fill Stylist Name", seconds: 1.0)
            isValidate = false
            return false
        }
        else  if(selectGenderDropDown.text == nil || self.genderCode == nil || selectGenderDropDown.text!.isEmpty || selectGenderDropDown.text! == "" || selectGenderDropDown.text! == "Select Gender" || self.genderCode!.isEmpty || self.genderCode == ""){
            self.showtoast(controller: self, message: "Please Select Gender", seconds: 1.0)
            isValidate = false
            return false
        }

//        else  if(stylistEmailTextField.text == nil || stylistEmailTextField.text!.isEmpty || stylistEmailTextField.text! == "" || stylistEmailTextField.text! == "Email") {
//              stylistEmailTextField.text! = ""
//          //  isValidate = false
//
//          //  return false
////            self.showtoast(controller: self, message: "Please Enter Valid EmailID", seconds: 1.0)
////            return false
//        }
    
//        else if (!(stylistEmailTextField.text! == "Email")){
//
//        }
        else  if(!(stylistEmailTextField.text! == "" || stylistEmailTextField.text! == "Email")) && !(isValidEmail(stylistEmailTextField.text!)) {
            self.showtoast(controller: self, message: "Please fill Valid Email", seconds: 1.0)
             isValidate = false
            return false
        }
        else  if(salonCodeDropDown.text == nil || self.salonCode == nil ||     salonCodeDropDown.text!.isEmpty || salonCodeDropDown.text! == "" || salonCodeDropDown.text! == "Select Salon Code" || self.salonCode.isEmpty || self.salonCode! == ""){
              self.showtoast(controller: self, message: "Please Select Salon Code", seconds: 1.0)
              isValidate = false
              return false
          }
        
        else  if(salonNameDropDown.text == nil || self.salonName == nil ||     salonNameDropDown.text!.isEmpty || salonNameDropDown.text! == "" || salonNameDropDown.text! == "Select Salon" || self.salonName.isEmpty || self.salonName! == ""){
              self.showtoast(controller: self, message: "Please Select Salon Name", seconds: 1.0)
              isValidate = false
              return false
          }
        else  if(salonAddressLabel.text!.isEmpty || salonAddressLabel.text! == "" ||       salonAddressLabel.text! == "Salon Address"){
              self.showtoast(controller: self, message: "Please Fill Salon Address", seconds: 1.0)
              return false
          }
        else  if(cityDropDown.text!.isEmpty || cityDropDown.text! == "" || cityDropDown.text! == "Select City" || self.cityName.isEmpty || self.cityName! == ""){
              self.showtoast(controller: self, message: "Please Fill City", seconds: 1.0)
             isValidate = false
              return false
          }
        else  if(stylistDOBTextField.text!.isEmpty || stylistDOBTextField.text! == "" || stylistDOBTextField.text! == "Select DOB"){
              self.showtoast(controller: self, message: "Please Select DOB", seconds: 1.0)
             isValidate = false
              return false
          }
//        else  if(anniversaryTextField.text!.isEmpty || anniversaryTextField.text! == "" || anniversaryTextField.text! == "Select Anniversary"){
//            anniversaryTextField.text! = ""
//
//        }
        else  if(colorLevelTextField.text!.isEmpty || colorLevelTextField.text! == "" ||        colorLevelTextField.text! == "Color Level"){
                 self.showtoast(controller: self, message: "Please Select Color Level", seconds: 1.0)
             isValidate = false
                 return false
            }
                    else  if(stylistEmailTextField.text == nil || stylistEmailTextField.text!.isEmpty || stylistEmailTextField.text! == "" || stylistEmailTextField.text! == "Email") {
                          stylistEmailTextField.text! = ""
                    }

                else  if(anniversaryTextField.text!.isEmpty || anniversaryTextField.text! == "" || anniversaryTextField.text! == "Select Anniversary"){
                    anniversaryTextField.text! = ""
         
                }
        

        
        return isValidate
        //    }
    }
    
    //MARK:- VALIDATE EMAIL
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
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
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        let value = UIInterfaceOrientation.portrait.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
    }
}
//MARK:- END
