//
//  addStylist.swift
//  Wella.2
//
//  Created by Acxiom on 21/09/18.
//  Copyright © 2018 Acxiom. All rights reserved.
//

import UIKit
import Dropdowns
import SQLite3
import Foundation
import Alamofire
import CoreLocation

class addStylist: ExecuteApi, CLLocationManagerDelegate, UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    var menuvc : menuViewController!
    var ids: [String]!
    var strBase64 = ""
    
    @IBOutlet weak var submit: UIButton!
    @IBOutlet weak var imageframe: UIImageView!
    @IBOutlet weak var camerabutton: UIButton!
    @IBOutlet weak var emailid: UITextField!
    @IBOutlet weak var stylistname: UITextField!
    @IBOutlet weak var mobileno: UILabel!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var download: UIButton!
    
    static let shared = addStylist()
    
    fileprivate var currentVC: UIViewController!
    
    //MARK: Internal Properties
    var imagePickedBlock: ((UIImage) -> Void)?
    var psrcodearray: [String]!
    var saloncodearray: [String]!
    var selectedpsr: String?
    var selectedsalon : String?
    var idstr: String?
    var salonname: String!
    var categoryarray: [String]!
    var levelarray: [String]!
    var selectedlevelcode = ""
    var selectedcategorycode = ""
    var locationManager:CLLocationManager!
    var lat: String! = ""
    var longi: String! = ""
    
    @IBOutlet var spinners: [DropDown]!

    @IBAction func submitbtn(_ sender: UIButton) {
        let datetime: String?
        datetime = getTodayString()
        //TRN001
        //59144
        
        self.checknet()
        if AppDelegate.ntwrk > 0 {
            if validation()
            {
                insertaddstylist(stylistname: self.stylistname.text, sitecode: self.idstr, saloncode: selectedsalon, contact: self.mobileno.text, email: self.emailid.text, address: self.address.text, lat: lat, long: longi, usercode: "", category: self.selectedcategorycode, levelcode: self.selectedlevelcode, sellercode: self.selectedpsr, image: self.strBase64, post: "0", id: datetime)
                self.postaddstylist()
                
                self.showtoast(controller: self, message: "Data saved successfully", seconds: 1.8)
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.9) {
                    self.performSegue(withIdentifier: "stylist", sender: (Any).self)
                }
            }
        }
        else
        {
            self.showtoast(controller: self, message: "Please Check Your Internet Connection", seconds: 1.5)
        }
  }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        stylistname.delegate = self
        emailid.delegate = self
        determineMyCurrentLocation()
        AppDelegate.menubool = true
        mobileno.text = AppDelegate.mobilenumber
        
        menuvc = (self.storyboard?.instantiateViewController(withIdentifier: "menuViewController") as! menuViewController)

        emailid.delegate = self
        stylistname.delegate = self
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(singleTapped))
        tap.numberOfTapsRequired = 2
        view.addGestureRecognizer(tap)

        let swiperyt = UISwipeGestureRecognizer(target: self, action: #selector(self.gesturerecognise))
        swiperyt.direction = UISwipeGestureRecognizerDirection.right
        
        download.isEnabled = false
        
        let swipelft = UISwipeGestureRecognizer(target: self, action: #selector(self.gesturerecognise))
        swipelft.direction = UISwipeGestureRecognizerDirection.left
        
        self.view.addGestureRecognizer(swiperyt)
        self.view.addGestureRecognizer(swipelft)

        ids = []
        psrcodearray = []
        saloncodearray = []
        categoryarray = []
        levelarray = []
        setinsalonspinnerdata()
        setcategory ()
        setlevel ()
        self.address.text = ""
        self.stylistname.text = ""
        self.emailid.text = ""
        self.spinners[3].text = "SELECT Category"
        self.spinners[4].text = "SELECT Level"
        self.spinners[1].text = "SELECT Seller"
        self.spinners[2].text = "SELECT Salon"
        self.spinners[0].text = "SELECT Branch"
        spinners[0].didSelect { (selected, index, id) in
            self.idstr = self.ids[index]
            self.download.isEnabled = true
           self.spinners[1].optionArray.removeAll()
                self.setpsr(siteCode: self.ids[index])
            
        }
//        spinners[1].listDidAppear {
//            if self.spinners[1].optionArray.isEmpty {
//                self.showtoast(controller: self, message: "Data not Available...CLICK \"Download\"", seconds: 2.0)
//                self.spinners[1].hideList()
//            }
//        }
//        spinners[2].listDidAppear {
//            if self.spinners[2].optionArray.isEmpty {
//                self.showtoast(controller: self, message: "Data not Available...CLICK \"Download\"", seconds: 2.0)
//                self.spinners[2].hideList()
//            }
//        }
        spinners[1].didSelect{(selectedText , index ,id) in
            print("Selected String: \(selectedText) \n index: \(index)")
            
            self.selectedpsr = self.psrcodearray[index]
            self.spinners[2].optionArray.removeAll()
           self.setsalon(siteCode: self.idstr!, psrcode: self.selectedpsr!)
            self.address.text = ""
            self.stylistname.text = ""
            self.emailid.text = ""
            self.spinners[3].text = "SELECT Category"
            self.spinners[4].text = "SELECT Level"
            self.spinners[2].text = "SELECT Salon"
        }
        
        spinners[2].didSelect{(selectedText , index ,id) in
            print("Selected String: \(selectedText) \n index: \(index)")
            self.salonname = selectedText
            self.selectedsalon = self.saloncodearray[index]
            //self.spinners[3].optionArray.removeAll()
            self.setaddress(saloncode: self.selectedsalon!)
        }
       
        spinners[3].didSelect{(selectedText , index ,id) in
            print("Selected String: \(selectedText) \n index: \(index)")
            self.selectedcategorycode = self.categoryarray[index]
            //self.spinners[3].optionArray.removeAll()
        }
        spinners[4].didSelect{(selectedText , index ,id) in
            print("Selected String: \(selectedText) \n index: \(index)")
            self.selectedlevelcode = self.levelarray[index]
            //self.spinners[3].optionArray.removeAll()
            
        }
    }
    @objc func singleTapped() {
        // do something here
        view.endEditing(true)
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
    
    func setinsalonspinnerdata () {
        var stmt:OpaquePointer?
        let queryString = "SELECT * FROM Branch"
        
        if sqlite3_prepare_v2(DatabaseConnection.dbs, queryString, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(DatabaseConnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return
        }
        
        while(sqlite3_step(stmt) == SQLITE_ROW){
            //String(cString: sqlite3_column_text(stmt, 1))
            
            let branchspinnerdata = String(cString: sqlite3_column_text(stmt, 1))
            let id = String(cString: sqlite3_column_text(stmt, 0))
            print("\(branchspinnerdata)")
            spinners[0].optionArray.append(branchspinnerdata)
            ids.append(id)
            
            
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
    @IBAction func openCamera(_ sender: Any) {
        
        showActionSheet(vc: self)
    }
    
    func camera()
    {
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            let myPickerController = UIImagePickerController()
            myPickerController.delegate = self;
            myPickerController.sourceType = .camera
            currentVC.present(myPickerController, animated: true, completion: nil)
        }
        
    }
    
    func photoLibrary()
    {
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            let myPickerController = UIImagePickerController()
            myPickerController.delegate = self;
            myPickerController.sourceType = .photoLibrary
            currentVC.present(myPickerController, animated: true, completion: nil)
        }
        
    }
    
    func showActionSheet(vc: UIViewController) {
        currentVC = vc
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (alert:UIAlertAction!) -> Void in
            self.camera()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { (alert:UIAlertAction!) -> Void in
            self.photoLibrary()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        vc.present(actionSheet, animated: true, completion: nil)
    }
    
}


extension addStylist: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        currentVC.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            
            self.imagePickedBlock?(image)
            imageframe.image=image
            let imageData:NSData = UIImagePNGRepresentation(image)! as NSData
            strBase64 = imageData.base64EncodedString(options: .lineLength64Characters)
        }else{
            print("Something went wrong")
        }
        currentVC.dismiss(animated: true, completion: nil)
    }
    
    func setcategory ()
    {
        var stmt2:OpaquePointer?
        let queryString = "select 'Select Category'as catgcode,'Select Category' as catgname union all select distinct catgcode,catgname from AddCategory"
        if sqlite3_prepare_v2(DatabaseConnection.dbs, queryString, -1, &stmt2, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(DatabaseConnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return
        }
        
        while(sqlite3_step(stmt2) == SQLITE_ROW){
            print("\n")
            
            let catgcode = String(cString: sqlite3_column_text(stmt2, 0))
            let catgname = String(cString: sqlite3_column_text(stmt2, 1))
            
            spinners[3].optionArray.append(catgname)
            print("\(catgcode)")
           categoryarray.append(catgcode)
            
        }
        
    }
    
    func setlevel ()
    {
        var stmt3:OpaquePointer?
        let queryString = "select 'Select Level'as levelcode,'Select Level' as levelname union all select distinct levelcode,levelname from Addlevel"
        if sqlite3_prepare_v2(DatabaseConnection.dbs, queryString, -1, &stmt3, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(DatabaseConnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return
        }
        
        while(sqlite3_step(stmt3) == SQLITE_ROW){
            print("\n")
            
            let levelcode = String(cString: sqlite3_column_text(stmt3, 0))
            let levelname = String(cString: sqlite3_column_text(stmt3, 1))
            
            spinners[4].optionArray.append(levelname)
            print("\(levelcode)")
            levelarray.append(levelcode)
            
        }
        
    }
    
    func setpsr(siteCode:String)
    {
        psrcodearray.removeAll()
        var stmt1:OpaquePointer?
        let queryString = "select 'SELECT Seller' as psrcode,'SELECT Seller' as psrname union all select distinct psrcode,psrname  from SalonDetail where sitE_CODE='"+siteCode+"'"
        
        if sqlite3_prepare_v2(DatabaseConnection.dbs, queryString, -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(DatabaseConnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return
        }
        
        while(sqlite3_step(stmt1) == SQLITE_ROW){
            //String(cString: sqlite3_column_text(stmt, 1))
            let psrcode = String(cString: sqlite3_column_text(stmt1, 0))
            let psrname = String(cString: sqlite3_column_text(stmt1, 1))
            print("\n")
            spinners[1].optionArray.append(psrname)
            psrcodearray.append(psrcode)
        }
        if spinners[1].optionArray.count == 1 {
            spinners[1].isEnabled = false
            spinners[2].isEnabled = false
        }
        else {
            spinners[1].isEnabled = true
            spinners[2].isEnabled = true
        }
    }
    
    func setsalon(siteCode:String, psrcode:String)
    {
        saloncodearray.removeAll()
        var stmt1:OpaquePointer?
        let queryString = "select 'SELECT SALON' as saloncode,'SELECT SALON' as salonname union all select distinct saloncode,beatName||\" - \"||salonname as salonname from SalonDetail where sitE_CODE='"+siteCode+"' and psrcode='"+psrcode+"'"
        
        if sqlite3_prepare_v2(DatabaseConnection.dbs, queryString, -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(DatabaseConnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return
        }
        
        while(sqlite3_step(stmt1) == SQLITE_ROW){
            //String(cString: sqlite3_column_text(stmt, 1))
            let saloncode = String(cString: sqlite3_column_text(stmt1, 0))
            let salonname = String(cString: sqlite3_column_text(stmt1, 1))
            print("\n")
            spinners[2].optionArray.append(salonname)
            saloncodearray.append(saloncode)
        }
    }
    
    func setaddress(saloncode: String)
    {
        var stmt1:OpaquePointer?
        let queryString = "select addres from salondetail where saloncode= '"+saloncode+"'"
        
        
        if sqlite3_prepare_v2(DatabaseConnection.dbs, queryString, -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(DatabaseConnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return
        }
        
        while(sqlite3_step(stmt1) == SQLITE_ROW){
            //String(cString: sqlite3_column_text(stmt, 1))
            let addressstr = String(cString: sqlite3_column_text(stmt1, 0))
            address.text = addressstr
            print("\n")
            
        }
    }
    
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
    
    @IBAction func download(_ sender: UIButton) {
        self.checknet()
         if AppDelegate.ntwrk > 0 {
        let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
        activityIndicator.center = CGPoint(x: view.bounds.size.width/2, y: view.bounds.size.height/2)
        activityIndicator.color = UIColor.black
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        print("loader activated")
        
 DispatchQueue.main.async {
        Alamofire.request(Constants.BASE_URL+Constants.URL_getMyInSalon1 + self.idstr! + Constants.URL_getMyInSalon2).validate().responseJSON {
            response in
            switch response.result {
            case .success(let value): print("success======> \(value)")
            if  let json = response.result.value{
                self.deleteinsalondata()
                print("\n My InSalon =====  spinner data request")
                let listarray : NSArray = json as! NSArray
                 if listarray.count > 0 {
                for i in 0..<listarray.count{
                    let sitecode = String (((listarray[i] as AnyObject).value(forKey:"sitecode") as? String)!)
                    let saloncode = String (((listarray[i] as AnyObject).value(forKey:"saloncode") as? String)!)
                    let salonname = String (((listarray[i] as AnyObject).value(forKey:"salonname") as? String)!)
                    let addresS1 = String (((listarray[i] as AnyObject).value(forKey:"addresS1") as? String)!)
                    let contact = String (((listarray[i] as AnyObject).value(forKey:"contact") as? String)!)
                    let beatName = String (((listarray[i] as AnyObject).value(forKey:"beatName") as? String)!)
                    let psrcode = String (((listarray[i] as AnyObject).value(forKey:"psrcode") as? String)!)
                    let psrName = String (((listarray[i] as AnyObject).value(forKey:"psrName") as? String)!)
                    print("data inserted ===== \(i) >>> \(sitecode)  \(salonname) \(saloncode) \(addresS1) \(contact) \(beatName) \(psrName)  \(psrcode)")
                    self.insertgetmyinsalon(sitecode: sitecode, saloncode: saloncode, salonname: salonname, addres: addresS1, contact: contact, beatname: beatName, psrcode: psrcode, psrname: psrName)
                    }
                 }
                 else {
                    self.showtoast(controller: self, message: "Data not available...", seconds: 1.5)
                }}
            break
            case .failure(let error): print("error======> \(error)")
            break
            }
            activityIndicator.stopAnimating()
            self.view.isUserInteractionEnabled = true
            print("loader deactivated")
            self.spinners[1].optionArray.removeAll()
            self.spinners[2].optionArray.removeAll()
            self.setpsr(siteCode: self.idstr!)
            self.address.text = ""
            self.stylistname.text = ""
            self.emailid.text = ""
            self.spinners[3].text = "SELECT Category"
            self.spinners[4].text = "SELECT Level"
            self.spinners[1].text = "SELECT Seller"
            self.spinners[2].text = "SELECT Salon"
            } } }
         else
         {
            self.showtoast(controller: self, message: "Please Check Your Internet", seconds: 2.0)
        }
}

    func getTodayString() -> String{
        
        let date = Date()
        let calender = Calendar.current
        let components = calender.dateComponents([.year,.month,.day,.hour,.minute,.second], from: date)
        
        let year = components.year
        let month = components.month
        let day = components.day
        let hour = components.hour
        let minute = components.minute
        let second = components.second
        
        let today_string = String(day!) + String(month!) + String(year!) + String(hour!)  + String(minute!) +  String(second!)
        
        return today_string
        
    }
    func validation() -> Bool
    {
        if self.idstr == nil || self.idstr == ""
        {
        self.showtoast(controller: self, message: "Please Select Salon Branch", seconds: 2.0)
            return false
        }
        
        else if self.selectedpsr == nil || self.selectedpsr == ""    || self.selectedpsr == "SELECT Seller"
        {
            self.showtoast(controller: self, message: "Please Select Seller", seconds: 2.0)
            return false
        }
        else if self.selectedsalon == nil || self.selectedsalon == ""    || self.selectedsalon == "SELECT SALON"
        {self.showtoast(controller: self, message: "Please SELECT SALON", seconds: 2.0)
            return false
        }
        
        else if self.selectedcategorycode == nil || self.selectedcategorycode == ""    || self.selectedcategorycode == "Select Category"
        {
            self.showtoast(controller: self, message: "Please Select Category", seconds: 2.0)
            return false
        }
        
        else if self.selectedlevelcode == nil || self.selectedlevelcode == ""    || self.selectedlevelcode == "Select Level"
        {
            self.showtoast(controller: self, message: "Please Select Level", seconds: 2.0)
            return false
        }
        else if self.stylistname.text == ""
        {
            self.showtoast(controller: self, message: "Please Fill Stylist Name", seconds: 2.0)
            return false
        }
        return true
    }
    
}


