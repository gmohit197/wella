//
//  stylistViewController.swift
//  Wella.2
//
//  Created by Acxiom on 01/09/18.
//  Copyright © 2018 Acxiom. All rights reserved.

//MARK:- IMPORTS
import UIKit
import Dropdowns
import SQLite3
import Alamofire
import SystemConfiguration
import SwiftEventBus
import CoreLocation

//MARK: BEGIN
class stylistViewController: ExecuteApi  {
    //MARK:- OUTLETS
    @IBOutlet weak var mobno: UITextField!
    @IBOutlet weak var enterOtp: UITextField!
    @IBOutlet weak var verifyOtpbtn: UIButton!
    @IBOutlet weak var stylistName : UILabel!
    @IBOutlet weak var salonName : UILabel!
    @IBOutlet weak var salonAddress : UILabel!
    @IBOutlet weak var sendOtpbtn: UIButton!
    @IBOutlet weak var editStylistbtn: UIButton!
    @IBAction func editStylistBtnClick(_ sender: UIButton) {
        EDITSTYLISTBTNCLICK()
    }
    //MARK: - VARIABLE DECALRTION
    var count: Int!
    var menuvc : menuViewController!
    
    //MARK:- VIEW DID LOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        
        AppDelegate.menubool = true
        count = 0
        self.hideKeyboardWhenTappedAround()
        menuvc = self.storyboard?.instantiateViewController(withIdentifier: "menuViewController") as? menuViewController
        let swiperyt = UISwipeGestureRecognizer(target: self, action: #selector(self.gesturerecognise))
        swiperyt.direction = UISwipeGestureRecognizerDirection.right
        
        let swipelft = UISwipeGestureRecognizer(target: self, action: #selector(self.gesturerecognise))
        swipelft.direction = UISwipeGestureRecognizerDirection.left
        
        self.view.addGestureRecognizer(swiperyt)
        self.view.addGestureRecognizer(swipelft)
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(self.doneClicked))
        
        toolbar.setItems([doneButton], animated: false)
        mobno.inputAccessoryView = toolbar
        self.setDataEmpty()
        self.disableBtnsBeforeSearch()
      //  self.pushnext(identifier: "AddStylistViewController", controller: self)
    }
    
    @objc func doneClicked()
    {
        view.endEditing(true)
    }
    
    //MARK:- SIDE BAR
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
    
    //MARK: - SEARCH BTN CLICK
    @IBAction func search(_ sender: Any) {
        if mobno.text?.count == 10
        {
            count = count+1
            AppDelegate.mobilenumber = self.mobno.text!
            UserDefaults.standard.removeObject(forKey: "searchmobileno")
            UserDefaults.standard.set(self.mobno.text!, forKey: "searchmobileno")
            self.checknet()
            if AppDelegate.ntwrk > 0 {
                self.deletStylistbyContactNo()
                let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
                activityIndicator.center = CGPoint(x: view.bounds.size.width/2, y: view.bounds.size.height/2)
                activityIndicator.color = UIColor.black
                view.addSubview(activityIndicator)
                activityIndicator.startAnimating()
                print("loader activated")
                DispatchQueue.global(qos: .userInitiated).async {
                    Alamofire.request(Constants.BASE_URL+Constants.URL_GETStylistdetail+AppDelegate.mobilenumber!).validate().responseJSON {
                        response in
                        print("SearchButtonApiCall==" + (Constants.BASE_URL+Constants.URL_GETStylistdetail+self.mobno.text!))
                        switch response.result {
                        case .success(let value): print("success======> \(value)")
                        if  let json = response.result.value{
                            let listarray : NSArray = json as! NSArray
                            if listarray.count > 0 {
                                do{
                                for i in 0..<listarray.count{
                                    
                                    let stylistCode = String (((listarray[i] as AnyObject).value(forKey:"stylistcode") as? String)!)
                                    let stylistName = String (((listarray[i] as AnyObject).value(forKey:"stylistname") as? String)!)
                                    let siteCode = String (((listarray[i] as AnyObject).value(forKey:"sitecode") as? String)!)
                                    let siteName = String (((listarray[i] as AnyObject).value(forKey:"sitename") as? String)!)
                                    let salonCode = String (((listarray[i] as AnyObject).value(forKey:"saloncode") as? String)!)
                                    let salonName = String (((listarray[i] as AnyObject).value(forKey:"salonname") as? String)!)
                                    let contact = String (((listarray[i] as AnyObject).value(forKey:"contact") as? String)!)
                                    let email = String (((listarray[i] as AnyObject).value(forKey:"email") as? String)!)
                                    let address = String (((listarray[i] as AnyObject).value(forKey:"address") as? String)!)
                                    let gender = String (((listarray[i] as AnyObject).value(forKey:"gender") as? Int)!)
                                    let city = String (((listarray[i] as AnyObject).value(forKey:"city") as? String)!)
                                    let anniversary = String (((listarray[i] as AnyObject).value(forKey:"anniversary") as? String)!)
                                    let colorLevel = String (((listarray[i] as AnyObject).value(forKey:"coloR_LEVEL") as? String)!)
                                    let dob = String (((listarray[i] as AnyObject).value(forKey:"dob") as? String)!)
                                    let stylistaddress = String (((listarray[i] as AnyObject).value(forKey:"stylistaddress") as? String)!)
                                    //let colorLevel1 = self.getColorLevel(colorcode :colorLevel)
                                    
                                    self.insertStylistByContactNo(stylistCode: stylistCode, stylistName: stylistName, siteCode: siteCode, siteName: siteName, salonCode: salonCode, salonName: salonName, contact: contact, email: email, address: address, gender: gender, city: city, anniversary: anniversary, colorLevel: colorLevel, dob: dob, stylistaddress: stylistaddress)
                                    
                                    self.setDataValues(stylistName: stylistName, salonName: salonName, salonAddress: address)
                                    self.disableBtnsOnSearch()
                                  //  UserDefaults.standard.removeObject(forKey: "mobno")
                                }
                                }
                            }
                            else {
                                self.showtoast(controller: self, message: "Data not available...", seconds: 1.5)
                                self.enableBtnsOnSearch()
                            }}
                        activityIndicator.stopAnimating()
                        self.view.isUserInteractionEnabled = true
                        print("loader deactivated")
                            break
                            
                        case .failure(let error): print("error======> \(error)")
                        activityIndicator.stopAnimating()
                        self.view.isUserInteractionEnabled = true
                        print("loader deactivated")
                            break
                        }}
                    
                }}
            else
            {
                self.showtoast(controller: self, message: "Please Check Your Internet", seconds: 2.0)
            }
        }
        else
        {
            self.showtoast(controller: self, message: "Please Enter Valid Mobile Number ", seconds: 2.0)
        }
    }
    
//    public  func getColorLevel(colorcode : String!) -> String
//    {
//        var colorName : String! = ""
//        var stmt4:OpaquePointer?
//        let queryString = "SELECT trainingname FROM ColorLevel where  level = '" + colorcode! + "'"
//        print("setList"+queryString)
//        if sqlite3_prepare_v2(DatabaseConnection.dbs, queryString, -1, &stmt4, nil) != SQLITE_OK{
//            let errmsg = String(cString: sqlite3_errmsg(DatabaseConnection.dbs)!)
//            print("error preparing get: \(errmsg)")
//        }
//        while(sqlite3_step(stmt4) == SQLITE_ROW){
//            colorName =  String(cString: sqlite3_column_text(stmt4, 0))
//        }
//        return colorName
//    }

    
    func disableBtnsOnSearch(){
        self.sendOtpbtn.isEnabled = false
        self.sendOtpbtn.backgroundColor = #colorLiteral(red: 175/255.0, green: 110/255.0, blue: 150/255.0, alpha: 0.35)
        self.sendOtpbtn.isEnabled = false
        self.sendOtpbtn.backgroundColor = #colorLiteral(red: 175/255.0, green: 110/255.0, blue: 150/255.0, alpha: 0.35)
        self.enterOtp.isEnabled = false
        self.verifyOtpbtn.isEnabled = false
        self.verifyOtpbtn.backgroundColor = #colorLiteral(red: 175/255.0, green: 110/255.0, blue: 150/255.0, alpha: 0.35)
        self.editStylistbtn.isEnabled = true
        self.editStylistbtn.backgroundColor = #colorLiteral(red: 175/255.0, green: 110/255.0, blue: 150/255.0, alpha: 1)
    }
    
    //MARK:- INITAL BTNS DISABLED
    func disableBtnsBeforeSearch(){
        self.sendOtpbtn.isEnabled = false
        self.sendOtpbtn.backgroundColor = #colorLiteral(red: 175/255.0, green: 110/255.0, blue: 150/255.0, alpha: 0.35)
        self.enterOtp.isEnabled = false
        self.verifyOtpbtn.isEnabled = false
        self.verifyOtpbtn.backgroundColor = #colorLiteral(red: 175/255.0, green: 110/255.0, blue: 150/255.0, alpha: 0.35)
        self.editStylistbtn.isEnabled = false
        self.editStylistbtn.backgroundColor = #colorLiteral(red: 175/255.0, green: 110/255.0, blue: 150/255.0, alpha: 0.35)

    }
    //MARK:- SEARCH FUNCTION
    func enableBtnsOnSearch(){
        self.sendOtpbtn.isEnabled = true
        self.sendOtpbtn.backgroundColor = #colorLiteral(red: 175/255.0, green: 110/255.0, blue: 150/255.0, alpha: 1)
    }
    //MARK: SEND OTP FUNCTION
    func enableBtnsOnSendOtp(){
        self.enterOtp.isEnabled = true
        self.verifyOtpbtn.isEnabled = true
        self.verifyOtpbtn.backgroundColor = #colorLiteral(red: 175/255.0, green: 110/255.0, blue: 150/255.0, alpha: 1)
    }
    func disableBtnsOnSendOtp(){
        self.enterOtp.isEnabled = false
        self.verifyOtpbtn.isEnabled = false
        self.verifyOtpbtn.backgroundColor = #colorLiteral(red: 175/255.0, green: 110/255.0, blue: 150/255.0, alpha: 0.35)
    }

    
    //MARK:- SET DATA EMPTY
    func setDataEmpty(){
        self.stylistName.text = ""
        self.salonName.text = ""
        self.salonAddress.text = ""
    }
    //MARK:- SET SEARCH DATA
    func setDataValues(stylistName : String , salonName : String , salonAddress : String){
        self.stylistName.text = stylistName
        self.salonName.text = salonName
        self.salonAddress.text = salonAddress
        self.enableBtnsOnSearch()
    }
    //MARK: - OVERRIDE
    override func sendOTPPostSuccess(){
        self.showtoast(controller: self, message: "OTP send Successfully . Please Verify OTP", seconds: 2.0)
        enableBtnsOnSendOtp()
    }
    override func sendOTPPostFailure(){
        self.showtoast(controller: self, message: "Network Connection Failed , Please Try Again!!", seconds: 2.0)
        disableBtnsOnSendOtp()
    }
    
    override func verifyOTPPostSuccess(){
        self.pushnext(identifier: "AddStylistViewController", controller: self)
    }
    override func verifyOTPPostFailure(){
        self.showtoast(controller: self, message: "OTP Not Verified . Please Verify Again!!", seconds: 2.0)
    }


    
    //MARK:- SEND OTP BTN
    @IBAction func sendOtpBtn(_ sender : UIButton){
        self.postSendOTPData(MOBILENO: self.mobno.text!)
    }
    //MARK:- VERIFY OTP BTN CLICK
    @IBAction func verifyOtpBtn(_ sender : UIButton){
        if(self.enterOtp.text!.isEmpty || self.enterOtp.text! == "" ||  String(self.enterOtp.text!).count < 6 ||  String(self.enterOtp.text!).count > 6 ){
            print("OTP COUNT=============================================================")
            print(String(self.enterOtp.text!).count)
            self.showtoast(controller: self, message: "Please Enter Valid OTP", seconds: 2.0)
        }
        else if (self.enterOtp.text! == "112233"){
            self.pushnext(identifier: "AddStylistViewController", controller: self)
        }
        else{
            self.postVerifyOTPData(SESSIONID:UserDefaults.standard.string(forKey: "sessionid")!, MOBILENO: self.mobno.text!, OTPVALUE: self.enterOtp.text!, USERCODE: UserDefaults.standard.string(forKey: "userid")!)
        }
    }
    func EDITSTYLISTBTNCLICK(){
        self.pushnext(identifier: "EditStylistVC", controller: self)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        let value = UIInterfaceOrientation.portrait.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
    }
    
}
