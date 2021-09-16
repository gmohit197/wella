//
//  ViewController.swift
//  Wella.2
//
//  Created by Acxiom on 19/08/18.
//  Copyright © 2018 Acxiom. All rights reserved.
//

import UIKit
import Alamofire
import SQLite3
import SystemConfiguration

class ViewController: ExecuteApi{
    var userid: String?
    var userpasswrd: String?
    var isblocked:  Bool?
    
    @IBOutlet weak var pwdn: UITextField!
    @IBOutlet weak var usern: UITextField!
    @IBOutlet weak var remmbrswitch: UISwitch!
    @IBOutlet weak var versionnu: UILabel!
    var versionnumber: String!
    
    var currentDatabaseVersion: Int16?
    
    override func viewWillAppear(_ animated: Bool) {
//        DispatchQueue.main.async {
//            (UIApplication.shared.delegate as! AppDelegate).restrictRotation = .portrait
//        }
           self.navigationController?.setNavigationBarHidden(true, animated: true)
       }
       
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        let value = UIInterfaceOrientation.portrait.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
    }
    
    
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        let value = UIInterfaceOrientation.portrait.rawValue
       UIDevice.current.setValue(value, forKey: "orientation")
        self.navigationController?.isToolbarHidden = true
        self.navigationItem.hidesBackButton = true
        self.navigationController?.isNavigationBarHidden = true
        
        versionnumber = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        self.versionnu.text = "Version: " + versionnumber
        
        NotificationCenter.default.addObserver(self, selector: #selector(statusManager), name: .flagsChanged, object: Network.reachability)
        updateUserInterface()
        AppDelegate.DATABASE_VERSION = 1
         currentDatabaseVersion =  Int16( UserDefaults.standard.integer(forKey: "database_version"))
        if(currentDatabaseVersion == 0 )
        {
            currentDatabaseVersion = AppDelegate.DATABASE_VERSION
        }
        branddatas()
      
        let latestVersion: Int16? = onUpgrade(oldversion: currentDatabaseVersion, newversion: AppDelegate.DATABASE_VERSION )
         UserDefaults.standard.set(latestVersion, forKey: "database_version")
        self.hideKeyboardWhenTappedAround()
        
        usern.text = ""
        pwdn.text = ""
        
        if UserDefaults.standard.string(forKey: "userid")  != nil
        {
            usern.text = UserDefaults.standard.string(forKey: "userid")
            usern.isEnabled = false
        }
//        usern.text = "TRN001"
//        pwdn.text = "59144"
       // self.gotoWorkshopFromLogin()
    }
    
    
    
    @IBAction func loginbtn(_ sender: UIButton) {
        self.checknet()
        if AppDelegate.ntwrk > 0 {
            if (usern.text == "" || pwdn.text == "")
            {
                showtoast(controller: self, message: "Please provide valid Username and password", seconds: 2.0)
            }
            else
            {
                getuserdata()
            }
        }
        else if UserDefaults.standard.string(forKey: "userid") == nil  || UserDefaults.standard.string(forKey: "userpassword") == nil || UserDefaults.standard.string(forKey: "executeapi") == nil{
            self.showtoast(controller: self, message: "Please check your Internet Connection...", seconds: 2.0)
        }
        else if UserDefaults.standard.string(forKey: "userid") != nil  || UserDefaults.standard.string(forKey: "userpassword") != nil{
            if UserDefaults.standard.string(forKey: "isblocked") == "1" {
            isblocked = true
            }
            else {
            isblocked = false
            }
            userid = userid?.uppercased()
            userpasswrd = userpasswrd?.uppercased()
            userid = UserDefaults.standard.string(forKey: "userid")
            userpasswrd = UserDefaults.standard.string(forKey: "userpassword")
            self.validate()
        }
    }
    
    @IBAction func remmberbtn(_ sender: UISwitch) {
        
        if remmbrswitch.isOn {
            if UserDefaults.standard.string(forKey: "userid") == nil  || UserDefaults.standard.string(forKey: "userpassword") == nil {
                showtoast(controller: self, message: "Please login first", seconds: 2.0)
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    self.remmbrswitch.setOn(false, animated: true)
                }
            }
            else {
                usern.text = UserDefaults.standard.string(forKey: "userid")
                pwdn.text = UserDefaults.standard.string(forKey: "userpassword")
            }
        }
    }
    func getuserdata () {
        UserDefaults.standard.set(self.usern.text, forKey: "loginuser")
        UserDefaults.standard.set(self.pwdn.text, forKey: "loginpwd")
        let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
        activityIndicator.center = CGPoint(x: view.bounds.size.width/2, y: view.bounds.size.height/2)
        activityIndicator.color = UIColor.white
        view.addSubview(activityIndicator)
        view.isUserInteractionEnabled = false
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.9)
        activityIndicator.startAnimating()
        print("loader activated")
//        DispatchQueue.global(qos: .userInitiated).async {
            DispatchQueue.main.async {
                Alamofire.request(Constants.BASE_URL + "ConfigInfo?USERID=\(self.usern.text!)&PASSWORD=\(self.pwdn.text!)").validate().responseJSON{
                response in
                print("LOGIN URL======================================================")
                print(Constants.BASE_URL + "ConfigInfo?USERID=\(self.usern.text!)&PASSWORD=\(self.pwdn.text!)")
                switch response.result {
                case .success(let value): print("success======> \(value)")
                if let json = response.result.value{
                    let listarray : NSArray = json as! NSArray
                    if listarray.count > 0{
                    UserDefaults.standard.set((listarray[0] as AnyObject).value(forKey: "username") as? String, forKey: "username")
                    UserDefaults.standard.set((listarray[0] as AnyObject).value(forKey: "usercode") as? String, forKey: "usercode")
                    self.userid  = String (((listarray[0] as AnyObject).value(forKey:"userid") as? String)!)
                    self.userpasswrd  = String (((listarray[0] as AnyObject).value(forKey:"userpassword") as? String)!)
                    self.isblocked  = ((listarray[0] as AnyObject).value(forKey:"blocked") as? Bool)!
                    UserDefaults.standard.set((listarray[0] as AnyObject).value(forKey: "mobileno") as? String, forKey: "mobileno")
                    UserDefaults.standard.set((listarray[0] as AnyObject).value(forKey: "designation") as? String, forKey: "designation")
                    UserDefaults.standard.set((listarray[0] as AnyObject).value(forKey: "state") as? String, forKey: "state")
                    UserDefaults.standard.set((listarray[0] as AnyObject).value(forKey: "usertype") as? Int64, forKey: "usertype")
                        activityIndicator.stopAnimating()
                       // activityIndicator.stopAnimating()
                        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.0)
                        self.view.isUserInteractionEnabled = true
                        print("loader deactivated")
                        self.validate()
                    }
                    else{
                       self.showtoast(controller: self, message: "invalid Username or Password", seconds: 2.0)
                    }
                    activityIndicator.stopAnimating()
                    self.view.backgroundColor = UIColor.black.withAlphaComponent(0.0)
                    self.view.isUserInteractionEnabled = true
                    print("loader deactivated")
                }
                    break
                case .failure(let error): print("error======> \(error)")
                    activityIndicator.stopAnimating()
                    self.view.backgroundColor = UIColor.black.withAlphaComponent(0.0)
                    self.view.isUserInteractionEnabled = true
                    print("loader deactivated")
                    break
            }}
}
}
    func validate() {
        let usertext : String = usern.text!.uppercased()
        let passtext : String = pwdn.text!.uppercased()

        if userid! == usertext {
            if userpasswrd! == passtext {
                if !self.isblocked! {
                    setSharedPrefData(isblocked:self.isblocked!)

                    if UserDefaults.standard.string(forKey: "executeapi") != self.getdate(){
                        UserDefaults.standard.set(true, forKey: "islogged")
                        AppDelegate.isDownloadClick = false

                        self.showSyncloader(title: "Please wait...")
                 //       self.showloader(title: "Please wait...")
                        self.executeapifunc(view: self.view)
                       
                    }
                    else {
                        UserDefaults.standard.set(true, forKey: "islogged")
                        self.callback()
                    }
                }
                else {
                    showtoast(controller: self, message: "User blocked", seconds: 1.8)
                }
            }
            else {
                showtoast(controller: self, message: "Invalid Password", seconds: 1.8)
            }
        }
        else {
            showtoast(controller: self, message: "Invalid User ID", seconds: 1.8)
        }
    }
    
    func updateUserInterface() {
        guard let status = Network.reachability?.status else { return }
        switch status {
        case .unreachable:
            view.backgroundColor = .red
        case .wifi:
            return
        case .wwan:
            view.backgroundColor = .yellow
        }
        print("Reachability Summary")
        print("Status:", status)
        print("HostName:", Network.reachability?.hostname ?? "nil")
        print("Reachable:", Network.reachability?.isReachable ?? "nil")
        print("Wifi:", Network.reachability?.isReachableViaWiFi ?? "nil")
    }
    
    @objc func statusManager(_ notification: Notification) {
        updateUserInterface()
    }
    override func callback(){
        print("CallBackFunction Called--------------------------------------------------------------------------------------")
       // dismiss(animated: true, completion: nil)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
             self.pushHome(vcId: "dashnc", vc: self)
        }

    }
    
    fileprivate func gotoWorkshopFromLogin(){
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.pushnext(identifier:"MyWorkshopViewController", controller: self)
             self.push(vcId: "dashnc", vc: self)
        }

    }
    
    fileprivate func setSharedPrefData(isblocked : Bool!) {
        //save here-----shared pref.
        UserDefaults.standard.set(userid, forKey: "userid")
        UserDefaults.standard.set(userpasswrd, forKey: "userpassword")
        
        if (self.isblocked) == true {
            UserDefaults.standard.set("1", forKey: "isblocked")
        }
        else {
            UserDefaults.standard.set("0", forKey: "isblocked")
        }

    }
}
