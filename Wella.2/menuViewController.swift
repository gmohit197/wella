//
//  menuViewController.swift
//  Wella.2
//
//  Created by Acxiom on 22/08/18.
//  Copyright © 2018 Acxiom. All rights reserved.
//

import UIKit
import Alamofire
import SQLite3
import SwiftEventBus

class menuViewController: ExecuteApi {
    var menuvc: menuViewController!
    @IBOutlet weak var calendar: UILabel!
    @IBOutlet weak var activityForDay: UILabel!
    @IBOutlet weak var designation: UITextView!
    @IBOutlet weak var username: UITextView!
    @IBOutlet weak var myImageView: UIImageView!
    @IBOutlet weak var home: UILabel!
    @IBOutlet weak var profile: UILabel!
    @IBOutlet weak var dtr: UILabel!
    @IBOutlet weak var stylistassesment: UILabel!
    @IBOutlet weak var myInsalon: UILabel!
    @IBOutlet weak var upload: UILabel!
    @IBOutlet weak var download: UILabel!
    @IBOutlet weak var logout: UILabel!
    @IBOutlet weak var homeimg: UIImageView!
    @IBOutlet weak var profileimg: UIImageView!
    @IBOutlet weak var dtrimg: UIImageView!
    @IBOutlet weak var stylistimg: UIImageView!
    @IBOutlet weak var myInsalonimg: UIImageView!
    @IBOutlet weak var uploadimg: UIImageView!
    @IBOutlet weak var downloadimg: UIImageView!
    @IBOutlet weak var logoutimg: UIImageView!
    @IBOutlet weak var activityForDayimg: UIImageView!
    @IBOutlet weak var calendarimg: UIImageView!
    @IBOutlet weak var salonTrackingStackView: UIStackView!
    
 //   var menuvc : menuViewController!

    
//    override func viewWillAppear(_ animated: Bool) {
//    DispatchQueue.main.async {
//        (UIApplication.shared.delegate as! AppDelegate).restrictRotation = .portrait
//    }
//    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        let value = UIInterfaceOrientation.portrait.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let value = UIInterfaceOrientation.portrait.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
        menuvc = (self.storyboard?.instantiateViewController(withIdentifier: "menuViewController") as! menuViewController)

        let profileImage = self.getProfileImage()
        self.myImageView.layer.cornerRadius = self.myImageView.frame.size.width / 2 ;
        self.myImageView.clipsToBounds = true
        if profileImage != ""
        {
            let dataDecoded:Data = Data(base64Encoded:profileImage,options:Data.Base64DecodingOptions.ignoreUnknownCharacters)!
            let decodedimage:UIImage = UIImage(data: dataDecoded as Data)!
            myImageView.image=decodedimage
        }
        
        userdetail()
        home.isUserInteractionEnabled = true
        homeimg.isUserInteractionEnabled = true
        
        let taphome = UITapGestureRecognizer(target: self, action: #selector(clickHome))
        let taphomeimg = UITapGestureRecognizer(target: self, action: #selector(clickHome))
        taphome.numberOfTapsRequired=1
        taphomeimg.numberOfTapsRequired=1
        home.addGestureRecognizer(taphome)
        homeimg.addGestureRecognizer(taphomeimg)
        
        profile.isUserInteractionEnabled = true
        profileimg.isUserInteractionEnabled = true
        
        let tapprofile = UITapGestureRecognizer(target: self, action: #selector(clickProfile))
        let tapproimg = UITapGestureRecognizer(target: self, action: #selector(clickProfile))
        tapprofile.numberOfTapsRequired=1
        tapproimg.numberOfTapsRequired=1
        profile.addGestureRecognizer(tapprofile)
        profileimg.addGestureRecognizer(tapproimg)
        
        dtr.isUserInteractionEnabled = true
        dtrimg.isUserInteractionEnabled = true
        
        let tapdtr = UITapGestureRecognizer(target: self, action: #selector(clickdtr))
        let tapdtrimg = UITapGestureRecognizer(target: self, action: #selector(clickdtr))
        tapdtr.numberOfTapsRequired=1
        tapdtrimg.numberOfTapsRequired=1
        dtr.addGestureRecognizer(tapdtr)
        dtrimg.addGestureRecognizer(tapdtrimg)
        
        stylistassesment.isUserInteractionEnabled = true
        stylistimg.isUserInteractionEnabled = true
        
        let tapstylist = UITapGestureRecognizer(target: self, action: #selector(clickStylist))
        let tapstylistimg = UITapGestureRecognizer(target: self, action: #selector(clickStylist))
        tapstylist.numberOfTapsRequired=1
        tapstylistimg.numberOfTapsRequired=1
        stylistassesment.addGestureRecognizer(tapstylist)
        stylistimg.addGestureRecognizer(tapstylistimg)
        
        myInsalon.isUserInteractionEnabled = true
        myInsalonimg.isUserInteractionEnabled = true
        
        let tapMyinsalon = UITapGestureRecognizer(target: self, action: #selector(clickMyinsalon))
        let tapMyinsalonimg = UITapGestureRecognizer(target: self, action: #selector(clickMyinsalon))
        tapMyinsalon.numberOfTapsRequired=1
        tapMyinsalonimg.numberOfTapsRequired=1
        myInsalon.addGestureRecognizer(tapMyinsalon)
        myInsalonimg.addGestureRecognizer(tapMyinsalonimg)
        
        upload.isUserInteractionEnabled = true
        uploadimg.isUserInteractionEnabled = true
        
        let tapUpload = UITapGestureRecognizer(target: self, action: #selector(clickUpload))
        let tapUploadimg = UITapGestureRecognizer(target: self, action: #selector(clickUpload))
        tapUpload.numberOfTapsRequired=1
        tapUploadimg.numberOfTapsRequired=1
        upload.addGestureRecognizer(tapUpload)
        uploadimg.addGestureRecognizer(tapUploadimg)
        
        download.isUserInteractionEnabled = true
        downloadimg.isUserInteractionEnabled = true
        
        let tapDownload = UITapGestureRecognizer(target: self, action: #selector(clickDownload))
        let tapDownloadimg = UITapGestureRecognizer(target: self, action: #selector(clickDownload))
        tapDownload.numberOfTapsRequired=1
        tapDownloadimg.numberOfTapsRequired=1
        download.addGestureRecognizer(tapDownload)
        downloadimg.addGestureRecognizer(tapDownloadimg)
        
        
        activityForDay.isUserInteractionEnabled = true
        activityForDayimg.isUserInteractionEnabled = true
        
        let tapMyActivity = UITapGestureRecognizer(target: self, action: #selector(clickMyActivity))
        let tapMyActivityimg = UITapGestureRecognizer(target: self, action: #selector(clickMyActivity))
        tapMyActivity.numberOfTapsRequired=1
        tapMyActivityimg.numberOfTapsRequired=1
        activityForDay.addGestureRecognizer(tapMyActivity)
        activityForDayimg.addGestureRecognizer(tapMyActivityimg)
        
        calendar.isUserInteractionEnabled = true
        calendarimg.isUserInteractionEnabled = true
        
        let tapCalendar = UITapGestureRecognizer(target: self, action: #selector(clickCalendar))
        let tapCalendarimg = UITapGestureRecognizer(target: self, action: #selector(clickCalendar))
        tapCalendar.numberOfTapsRequired=1
        tapCalendarimg.numberOfTapsRequired=1
        calendar.addGestureRecognizer(tapCalendar)
        calendarimg.addGestureRecognizer(tapCalendarimg)
        
        logout.isUserInteractionEnabled = true
        logoutimg.isUserInteractionEnabled = true
        
        let taplogout = UITapGestureRecognizer(target: self, action: #selector(clickLogout))
        let taplogoutimg = UITapGestureRecognizer(target: self, action: #selector(clickLogout))
        taplogout.numberOfTapsRequired=1
        taplogoutimg.numberOfTapsRequired=1
        logout.addGestureRecognizer(taplogout)
        logoutimg.addGestureRecognizer(taplogoutimg)
        
        salonTrackingStackView.isUserInteractionEnabled = true
        
        let tapsalonTracking = UITapGestureRecognizer(target: self, action: #selector(clickSalonTracking))
        tapsalonTracking.numberOfTapsRequired=1
        salonTrackingStackView.addGestureRecognizer(tapsalonTracking)
        
    }
    
    func userdetail()
    {
        var prof:OpaquePointer?
        let queryString = "SELECT * FROM User_Profile"
        if sqlite3_prepare_v2(DatabaseConnection.dbs, queryString, -1, &prof, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(DatabaseConnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return
        }
        while(sqlite3_step(prof) == SQLITE_ROW){
            let trainername = String(cString: sqlite3_column_text(prof, 6))
            let designation = String(cString: sqlite3_column_text(prof, 16))
            self.username.text = trainername
            self.designation.text = designation
        }
    }
    
    @objc func clickHome(){
        let home:HomeViewController = self.storyboard?.instantiateViewController(withIdentifier: "home") as! HomeViewController
        self.navigationController?.pushViewController(home, animated: true)
    }
    
    @objc func clickProfile(){
//        let proname:profileViewController = self.storyboard?.instantiateViewController(withIdentifier: "proname") as! profileViewController
//        self.navigationController?.pushViewController(proname, animated: true)
        //
        self.pushnext(identifier: "MyProfileViewController", controller: self)

    }
    
    @objc func clickWorkshop(){
        let workshop:MyworkshopViewController = self.storyboard?.instantiateViewController(withIdentifier: "workshop") as! MyworkshopViewController
        self.navigationController?.pushViewController(workshop, animated: true)
    }
    @objc func clickMyActivity(){
        self.pushnext(identifier: "myactivityvc", controller: self)
    }
    
    @objc func clickCalendar(){
        //calendar
 //       self.pushnext(identifier: "calendar", controller: self)
//CalendarPlannedViewController
//FSCalendarViewController
//        self.pushnext(identifier: "CalendarPlannedViewController", controller: self)
        self.pushnext(identifier: "FSCalendarViewController", controller: self)
    //    self.push(vcId: "FSCalendarViewController", vc: self )
      //  self.showtoast(controller: self, message: "Coming Soon", seconds: 1.0)
    }

    @objc func clickdtr(){
         self.pushnext(identifier: "calendar", controller: self)

        
//        let dtr:DTRViewController = self.storyboard?.instantiateViewController(withIdentifier: "dtr") as! DTRViewController
//        self.navigationController?.pushViewController(dtr, animated: true)
//        print("DTR is clickable");
    }
    
    @objc func clickStylist(){
        let stylist:stylistViewController = self.storyboard?.instantiateViewController(withIdentifier: "stylist") as! stylistViewController
        self.navigationController?.pushViewController(stylist, animated: true)
    }
    
    @objc func clickMyinsalon(){
        let myinsalon:MyinsalonViewController = self.storyboard?.instantiateViewController(withIdentifier: "myinsalon") as! MyinsalonViewController
        self.navigationController?.pushViewController(myinsalon, animated: true)
    }
    
    @objc func clickMystylist(){
        let mystylist:mystylistViewController = self.storyboard?.instantiateViewController(withIdentifier: "mystylist") as! mystylistViewController
        self.navigationController?.pushViewController(mystylist, animated: true)
    }
    
    @objc func clickUpload(){
        self.checknet()
        if AppDelegate.ntwrk > 0 {
            self.view.isUserInteractionEnabled = false
            print("sending request")
            let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
            activityIndicator.center = CGPoint(x: view.bounds.size.width/2, y: view.bounds.size.height/2)
            activityIndicator.color = UIColor.black
            view.addSubview(activityIndicator)
            activityIndicator.startAnimating()
            print("loader activated")
            DispatchQueue.main.async {
                self.postMyinsalon()
                self.postaddstylist()
                self.postsynclog()
                activityIndicator.stopAnimating()
                self.view.isUserInteractionEnabled = true
                print("loader deactivated")
                self.showtoast(controller: self, message: " Data is Uploaded", seconds: 1.0)
            }
        }
        else {
            self.showtoast(controller: self, message: "Please Check Your Internet Connection", seconds: 1.5)
        }
    }
    
    
    @objc func clickDownload(){
        self.checknet()
        if AppDelegate.ntwrk > 0 {
            AppDelegate.isDownloadClick = true
//            self.showloader(title: "Loading please wait...")
            self.showSyncloader(title: "Loading please wait...")
            self.executeapifunc(view: self.view)
            
        //    self.hideSyncloader()
            print("download is clicked");
        //   self.hidemenu()
        }
        else
        {
            self.showtoast(controller: self, message: "Please check your Internet connection", seconds: 2.0)
        }
    }
    
    @objc func clickLogout(){
        self.push(vcId: "LOGINNC", vc: self)
        
    }
    
    @objc func clickSalonTracking(){
        AppDelegate.salonCodeSalonTracking = ""
        self.pushnext(identifier: "SalonTrackingVC", controller: self)
        
    }

    override func callback(){
        dismiss(animated: true, completion: nil)
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
}
