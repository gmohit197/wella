    //
//  MyinsalonViewController.swift
//  Wella.2
//
//  Created by Acxiom on 01/09/18.
//  Copyright © 2018 Acxiom. All rights reserved.
//

import UIKit
import Alamofire
import SQLite3
import CoreLocation
import SystemConfiguration
import SwiftEventBus

    class MyinsalonViewController: ExecuteApi, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate, UITextFieldDelegate{
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return myworkshopdata.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "workshopcell", for:  indexPath) as! workshopcell
            
            let list: workshoplistdata
            list = myworkshopdata[indexPath.row]
            
            cell.sno.text = list.sno
            cell.salon.text = list.salon
            cell.stylistno.text = list.stylist
            
            return cell
        }
        
        var listid: [String]!
        var menuvc: menuViewController!
        var myworkshopdata = [workshoplistdata]()
        var locationManager:CLLocationManager!
        var ids: [String]!
        var flag: Int = 0
        var flag1:Bool = true
        
        @IBOutlet weak var inputTextField: UITextField!
        @IBOutlet var spinners: [DropDown]!
        public var datePicker : UIDatePicker?
        let date = Date()
        let formatter = DateFormatter()
        var psrcodearray: [String]!
        var saloncodearray: [String]!
        var trainingarray: [String]!
        var selectedpsr: String?
        var selectedsalon : String?
        var trainertype: String?
        var training: String?
        var idstr: String?
        var lat: String! = ""
        var longi: String! = ""
        var salonname: String!
        
        @IBOutlet weak var address: UILabel!
        @IBOutlet weak var downloadbtn: UIButton!
        
        @IBOutlet weak var workshoptable: UITableView!
        //@IBOutlet weak var noofstylist: UITextField!
        
        @IBOutlet weak var stylistcontact: UITextField!
        @IBOutlet weak var noofmodel: UITextField!
        //var returncatcher = ReturnCatcher()
        
        @IBOutlet weak var stylistRemark: UITextField!
        @IBOutlet weak var stylistName: UITextField!
        
        @IBOutlet weak var savebtn: UIButton!
        
        var result: String?
        override func viewDidLoad() {
            super.viewDidLoad()
            
 //            trininglocation.delegate = returncatcher
//            remark.delegate = returncatcher
            
            determineMyCurrentLocation()
            AppDelegate.menubool = true
            let tap = UITapGestureRecognizer(target: self, action: #selector(singleTapped))
            tap.numberOfTapsRequired = 2
            view.addGestureRecognizer(tap)
            myworkshopdata.removeAll()
            menuvc = self.storyboard?.instantiateViewController(withIdentifier: "menuViewController") as? menuViewController
            let swiperyt = UISwipeGestureRecognizer(target: self, action: #selector(self.gesturerecognise))
            swiperyt.direction = UISwipeGestureRecognizerDirection.right
            downloadbtn.isEnabled = false
            let swipelft = UISwipeGestureRecognizer(target: self, action: #selector(self.gesturerecognise))
            swipelft.direction = UISwipeGestureRecognizerDirection.left
            self.view.addGestureRecognizer(swiperyt)
            self.view.addGestureRecognizer(swipelft)
            
            let toolbar = UIToolbar()
            toolbar.sizeToFit()
            
            let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(self.doneClicked))
            
            toolbar.setItems([doneButton], animated: false)
            
            noofmodel.inputAccessoryView = toolbar
            stylistcontact.inputAccessoryView = toolbar
            
            noofmodel.text = ""
            stylistcontact.text = ""
            datePicker = UIDatePicker()
            datePicker?.datePickerMode = .date
            
            datePicker?.addTarget(self, action: #selector(MyworkshopViewController.dateChanged(datePicker:)), for: .valueChanged)
            
            inputTextField.inputView = datePicker
            
            formatter.dateFormat = "dd-MMM-yyyy"
            let datepicker = formatter.string(from: date)
            
            stylistcontact.attributedPlaceholder = NSAttributedString(string: "Stylist Contact Number",attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray])
            
            inputTextField.text = datepicker
            workshoptable.delegate = self
            workshoptable.dataSource = self
            
            formatter.dateFormat = "ddMMyyyyHHMMSS"
            result = "WRK_SHP" + formatter.string(from: self.date)
            ids = []
            psrcodearray = []
            saloncodearray = []
            trainingarray = []
            listid = []
            setinsalonspinnerdata()
            settraining()
            
            spinners[2].isEnabled = false
            spinners[3].isEnabled = false
            spinners[1].didSelect { (selected, index, id) in
                self.idstr = self.ids[index]
                self.downloadbtn.isEnabled = true
                self.spinners[2].optionArray.removeAll()
                self.setpsr(siteCode: self.ids[index])
                
            }
            
            spinners[2].didSelect{(selectedText , index ,id) in
                print("Selected String: \(selectedText) \n index: \(index)")
                
                self.selectedpsr = self.psrcodearray[index]
                self.address.text = ""
                self.stylistcontact.text = ""
                self.spinners[3].text = "SELECT Salon"
                self.spinners[3].optionArray.removeAll()
                self.setsalon(siteCode: self.idstr!, psrcode: self.selectedpsr!)
                
            }
            
            spinners[3].didSelect{(selectedText , index ,id) in
                print("Selected String: \(selectedText) \n index: \(index)")
                self.salonname = selectedText
                self.selectedsalon = self.saloncodearray[index]
                //self.spinners[3].optionArray.removeAll()
                
                self.setaddress(saloncode: self.selectedsalon!)
            }
            
            spinners[0].didSelect{(selectedText , index ,id) in
                print("Selected String: \(selectedText) \n index: \(index)")
                self.trainertype = selectedText
                self.training = self.trainingarray[index]
            }
            
            let longPressGesture:UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(self.handleLongPress))
            longPressGesture.minimumPressDuration = 1.0 // 1 second press
            longPressGesture.delegate = self as? UIGestureRecognizerDelegate
            self.workshoptable.addGestureRecognizer(longPressGesture)
            
        }
        @objc func handleLongPress(_ gestureRecognizer: UILongPressGestureRecognizer){
            if gestureRecognizer.state == .ended {
                let touchPoint = gestureRecognizer.location(in: self.workshoptable)
                if let indexPath = workshoptable.indexPathForRow(at: touchPoint) {
                    let index = indexPath.row
                    self.showalert(index: index)
                    self.setlist()
                }
            }
            self.textFieldDidBeginEditing(textField: stylistcontact)
            self.textFieldDidBeginEditing(textField: noofmodel)
            
        }
        
        @objc func doneClicked()
        {
            view.endEditing(true)
        }
        
        @objc func singleTapped() {
            // do something here
            view.endEditing(true)
        }
        func showalert(index: Int?){
            let alert = UIAlertController(title: "Delete Line!!!", message: "Do you want to delete the selected line?", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.default, handler: { (action) in
                self.deleteworkshopline(datetime: self.listid[index!])
                self.setlist()
            }))
            alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.cancel, handler: { (action) in
                alert.dismiss(animated: true, completion: nil)
            }))
            self.present(alert, animated: true)
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
                spinners[1].optionArray.append(branchspinnerdata)
                ids.append(id)
            }
        }
        
        
        @objc func dateChanged(datePicker: UIDatePicker) {
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd-MMM-yyyy"
            inputTextField.text = dateFormatter.string(from: datePicker.date)
        }
        
        @IBAction func tapPiece(_ gestureRecognizer : UITapGestureRecognizer ) {
            guard gestureRecognizer.view != nil else { return }
            
            if gestureRecognizer.state == .ended {      // Move the view down and to the right when tapped.
                let animator = UIViewPropertyAnimator(duration: 0.2, curve: .easeInOut, animations: {
                    gestureRecognizer.view!.center.x += 100
                    gestureRecognizer.view!.center.y += 100
                })
                animator.startAnimation()
            }}
        
        
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
                spinners[2].optionArray.append(psrname)
                psrcodearray.append(psrcode)
            }
            if spinners[2].optionArray.count == 1 {
                spinners[2].isEnabled = false
                spinners[3].isEnabled = false
            }
            else {
                spinners[2].isEnabled = true
                spinners[3].isEnabled = true
            }
        }
        
        func setsalon(siteCode:String, psrcode:String)
        {   saloncodearray.removeAll()
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
                spinners[3].optionArray.append(salonname)
                saloncodearray.append(saloncode)
            }
            //        if self.spinners[3].optionArray.count == 1 {
            //            self.spinners[3].optionArray.removeAll()
            //        }
        }
        
        func setaddress(saloncode: String)
        {
            var stmt1:OpaquePointer?
            let queryString = "select addres from salondetail where saloncode= '" + saloncode + "'"
            
            
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
        
        func settraining()
        {
            trainingarray.removeAll()
            var stmt1:OpaquePointer?
            let queryString = "select 'SELECT TRAINING' as trainingcode,'SELECT TRAINING' as trainingname union all select distinct trainingcode,trainingname from TrainingMaster"
            
            if sqlite3_prepare_v2(DatabaseConnection.dbs, queryString, -1, &stmt1, nil) != SQLITE_OK{
                let errmsg = String(cString: sqlite3_errmsg(DatabaseConnection.dbs)!)
                print("error preparing get: \(errmsg)")
                return
            }
            
            while(sqlite3_step(stmt1) == SQLITE_ROW){
                print("\n")
                
                let trainingcode = String(cString: sqlite3_column_text(stmt1, 0))
                let trainingname = String(cString: sqlite3_column_text(stmt1, 1))
                
                spinners[0].optionArray.append(trainingname)
                
                trainingarray.append(trainingcode)
                
            }}
        @IBAction func downloadbtn(_ sender: UIButton) {
            self.checknet()
            if AppDelegate.ntwrk > 0 {
                let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
                activityIndicator.center = CGPoint(x: view.bounds.size.width/2, y: view.bounds.size.height/2)
                activityIndicator.color = UIColor.black
                view.addSubview(activityIndicator)
                activityIndicator.startAnimating()
                print("loader activated")
                DispatchQueue.main.async {
                    Alamofire.request(Constants.BASE_URL + Constants.URL_getMyInSalon1 + self.idstr! + Constants.URL_getMyInSalon2).validate().responseJSON {
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
                                activityIndicator.stopAnimating()
                                self.view.isUserInteractionEnabled = true
                                print("loader deactivated")
                                
                            }
                            else {
                                self.showtoast(controller: self, message: "Data not available", seconds: 1.5)
                            }
                            activityIndicator.stopAnimating()
                            self.view.isUserInteractionEnabled = true
                            print("loader deactivated")
                        }
                            break
                            
                        case .failure(let error): print("error======> \(error)")
                        activityIndicator.stopAnimating()
                        self.view.isUserInteractionEnabled = true
                        print("loader deactivated")
                            break
                        }
                        self.address.text = ""
                        self.stylistcontact.text = ""
                        self.spinners[2].text = "SELECT Seller"
                        self.spinners[3].text = "SELECT Salon"
                        self.spinners[2].optionArray.removeAll()
                        self.spinners[3].optionArray.removeAll()
                        
                        self.setpsr(siteCode: self.idstr!)
                    }
                    
                }
                
            }
            else {
                self.showtoast(controller: self, message: "Please check your Internet Connection", seconds: 1.5)
            }
        }
        
        public func updateLatLong(id: String?){
            let updatelat = "UPDATE InsertWorkshop SET Lat = '\(self.lat!)',longi = '\(self.longi!)' WHERE id = '" + id! + "'"
            
            if sqlite3_exec(DatabaseConnection.dbs, updatelat, nil, nil, nil) != SQLITE_OK{
                print("Error creating Table \(updatelat)")
                return
            }
        }
        
        @IBAction func save(_ sender: Any) {
            if flag > 0{
                
                    self.updateLatLong(id: result)
                    self.updatemyworkshop(id: result, model: self.noofmodel.text!, remark: self.stylistRemark.text!)
                
                    self.showtoast(controller: self, message: "Data saved successfully", seconds: 1.5)
                self.checknet()
                if AppDelegate.ntwrk > 0
                {
                    self.uploaddata()
                   
                }else
                {
                    self.showtoast(controller: self, message: "Please check Your Internet Connection", seconds: 1.5)
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.55) {
                    self.performSegue(withIdentifier: "insalonsavesegue", sender: (Any).self)
                }
            }
            else
            {
                self.showtoast(controller: self, message: "List Can't be empty", seconds: 2.0)
            }
        }
        
        func uploaddata(){
            var stmt1:OpaquePointer?
            let queryString = "SELECT * FROM InsertWorkshop WHERE id = '" + self.result! + "'"
            if sqlite3_prepare_v2(DatabaseConnection.dbs, queryString, -1, &stmt1, nil) != SQLITE_OK{
                let errmsg = String(cString: sqlite3_errmsg(DatabaseConnection.dbs)!)
                print("error preparing get: \(errmsg)")
                return
            }
            
            var body: [AnyObject] = []
            
            DispatchQueue.main.async {
                while(sqlite3_step(stmt1) == SQLITE_ROW){
                    //String(cString: sqlite3_column_text(stmt, 1))
                    let date = String(cString: sqlite3_column_text(stmt1, 0))
                    let location = String(cString: sqlite3_column_text(stmt1, 2))
                    
                    let trainingcode = String(cString: sqlite3_column_text(stmt1, 1))
                    //let trainercode = UserDefaults.standard.string(forKey: "userid")
                    let sitecode = String(cString: sqlite3_column_text(stmt1, 3))
                    let sellercode = String(cString: sqlite3_column_text(stmt1, 6))
                    let saloncode = String(cString: sqlite3_column_text(stmt1, 4))
                    let noofstylist = String(cString: sqlite3_column_text(stmt1, 8))
                    let model = String(cString: sqlite3_column_text(stmt1, 10))
                    let remark = String(cString: sqlite3_column_text(stmt1, 11))
                    let lat = String(cString: sqlite3_column_text(stmt1, 13)) == "" ? "0" :  String(cString: sqlite3_column_text(stmt1, 13))
                    let longi = String(cString: sqlite3_column_text(stmt1, 14)) == "" ? "0" :  String(cString: sqlite3_column_text(stmt1, 14))
                    let salonremark = String(cString: sqlite3_column_text(stmt1, 16))
                    let stylistname = String(cString: sqlite3_column_text(stmt1, 17))
                    let stylistcontact = String(cString: sqlite3_column_text(stmt1, 18))
                    
                    //            let recid = String(cString: sqlite3_column_text(stmt1, 0))
                    //            let createdby = String(cString: sqlite3_column_text(stmt1, 0))
                    //            let modifiedby = String(cString: sqlite3_column_text(stmt1, 0))
                    
                   // var  stat: NSString?
                    print("\n")
                    
                    let parameters: [String: AnyObject] = [
                        "TRAININGDATE":date as AnyObject,
                        "LOCATION":location as AnyObject,
                        "TRAININGTYPE" : "INSALON" as AnyObject,
                        "TRAININGCODE" : trainingcode as AnyObject,
                        "TRAINERCODE" : UserDefaults.standard.string(forKey: "userid")! as AnyObject,
                        "SITECODE" : sitecode as AnyObject,
                        "SELLERCODE" : sellercode as AnyObject,
                        "SALONCODE" : saloncode as AnyObject,
                        "NOOFSTYLIST" : noofstylist as AnyObject,
                        "NOOFMODEL" : model as AnyObject,
                        "REMARK" : remark as AnyObject,
                        "Lat" : lat as AnyObject,
                        "Long" : longi as AnyObject,
                        "SALONREMARK" : salonremark as AnyObject,
                        "STYLISTNAME" : stylistname as AnyObject,
                        "STYLISTMOBILENO" : stylistcontact as AnyObject,
                        ]
                    //print(self.json(from :parameters))
                    
                    body.append(parameters as AnyObject)
                }
                var lines: [String: [AnyObject]] = [:]
                lines = [
                    "Workshop" : body
                ]
                let mbody: [[String: [AnyObject]]] = [
                    lines
                    
                ]
               // print(self.json(from: mbody))
                var url: URL!
                
                let stringurl:String = Constants.BASE_URL + Constants.URL_postworkshop
                url = URL(string: stringurl)
                
                var request = URLRequest(url: url)
                request.httpMethod = "POST"
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                
                request.httpBody = try! JSONSerialization.data(withJSONObject: mbody, options: [])
                
                
                Alamofire.request(request).responseJSON { response in
                    
                    switch (response.result) {
                    case .success:
                        self.updateworkshop(id: self.result)
                        self.insertsynclog(tablename: "Post Salon", status: "success", post: "0")
                        self.showtoast(controller: self, message: "Data uploaded successfully", seconds: 1.5)
//                        SwiftEventBus.post("gotonext")
                        break
                        
                    case .failure:
                        self.insertsynclog(tablename: "Post Salon", status: "Failure", post: "0")
                        self.showtoast(controller: self, message: "Something went wrong! Please try again later...", seconds: 1.5)
//                        SwiftEventBus.post("gotonext")
                        break
                    }
                }
                self.postsynclog()
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
            
            print("user latitude = \(userLocation.coordinate.latitude)")
            print("user longitude = \(userLocation.coordinate.longitude)")
            lat = String(userLocation.coordinate.latitude)
            longi = String(userLocation.coordinate.longitude)
            
        }
        
        func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
        {
            print("Error \(error)")
        }
        
        @IBAction func addbtn(_ sender: UIButton) {
            
            if self.stylistcontact.text! == "" || self.stylistName.text! == "" || self.spinners[2].optionArray.isEmpty || self.spinners[3].optionArray.isEmpty
            {
                self.showtoast(controller: self, message: "Field(s) can't be empty", seconds: 2.0)
            }
                
            else if self.stylistcontact.text!.count < 10 {
                self.showtoast(controller: self, message: "Please Enter Valid Mobile No", seconds: 2.0)
            }
                
            else
            {
                let datetime: String?
                datetime = getTodayString()
                
                if validation()
                {
                    self.InsertWorkshop(date: self.inputTextField.text!, trainingcode: self.training, traininglocations: self.idstr!, branchcode: self.idstr, saloncodes: self.selectedsalon, salonname: self.salonname, sellercodes: self.selectedpsr, addresses: self.address.text!, noofstylisttrainedstr: "1", post: "0", modelno: self.noofmodel.text!, remark: "", id: result, Lat: "0.000000000000", longi: "0.000000000000", datetime: datetime, salonremark: self.stylistRemark.text!, stylistname: self.stylistName.text!, stylistcontact: self.stylistcontact.text!)
                    
                    print("data in workshop_table inserted ")
                    self.setlist()
                    self.stylistName.text = ""
                    self.stylistcontact.text = ""
                }
            }
        }
        func checknumbername (){
            flag1 = true
            var stmt1:OpaquePointer?
            let query = "SELECT * FROM InsertWorkshop WHERE id ='"+result!+"' and (stylistname = '\(self.stylistName.text!)' collate nocase or stylistcontact = '\(self.stylistcontact.text!)' ) "
            if sqlite3_prepare_v2(DatabaseConnection.dbs, query, -1, &stmt1, nil) != SQLITE_OK{
                let errmsg = String(cString: sqlite3_errmsg(DatabaseConnection.dbs)!)
                print("error preparing get: \(errmsg)")
                return
            }
            //        date text,trainingcode text,traininglocations text ,branchcode text, saloncodes text, salonname text,sellercodes text,addresses text,noofstylisttrainedstr text,post text,modelno text,remark text,id text,Lat text,longi text,datetime text,salonremark text,stylistname text,stylistcontact text)"
            
            if(sqlite3_step(stmt1) == SQLITE_ROW){
                flag1 = false
            }
        }
        func setlist(){
            self.myworkshopdata.removeAll()
            var stmt1:OpaquePointer?
            
            UserDefaults.standard.removeObject(forKey: "dtrfromdate")
            UserDefaults.standard.removeObject(forKey: "dtrtodate")
            //var sno = 0;
            let query = "SELECT * FROM InsertWorkshop WHERE id ='"+result!+"'"
            self.listid.removeAll()
            if sqlite3_prepare_v2(DatabaseConnection.dbs, query, -1, &stmt1, nil) != SQLITE_OK{
                let errmsg = String(cString: sqlite3_errmsg(DatabaseConnection.dbs)!)
                print("error preparing get: \(errmsg)")
                return
            }
            
            while(sqlite3_step(stmt1) == SQLITE_ROW){
                //String(cString: sqlite3_column_text(stmt, 1))
                let salon = String(cString: sqlite3_column_text(stmt1, 5))
                let stylistcontact = String(cString: sqlite3_column_text(stmt1, 18))
                let datetime = String(cString: sqlite3_column_text(stmt1, 15))
                let stylistname = String(cString: sqlite3_column_text(stmt1, 17))
                
                self.listid.append(datetime)
                self.myworkshopdata.append(workshoplistdata(sno: salon, salon: stylistname, stylist: stylistcontact))
                
                flag = flag+1
            }
            self.workshoptable.reloadData()
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
            checknumbername()
            if self.idstr == nil || self.idstr == ""
            {
                self.showtoast(controller: self, message: "Please Select Salon Branch", seconds: 2.0)
                return false
            }
             
            else if self.noofmodel.text == ""
            {
              self.showtoast(controller: self, message: "NO. OF Model Can't Empty", seconds: 2.0)
            }
                
            else if self.selectedpsr == nil || self.selectedpsr == "" || self.selectedpsr == "SELECT Seller"
            {
                self.showtoast(controller: self, message: "Please Select Seller", seconds: 2.0)
                return false
            }
            else if self.selectedsalon == nil || self.selectedsalon == "" || self.selectedsalon == "SELECT SALON"
            {self.showtoast(controller: self, message: "Please SELECT SALON", seconds: 2.0)
                return false
            }
                
            else if self.trainertype == nil || self.trainertype == "" || self.trainertype == "SELECT TRAINING"
            {
                self.showtoast(controller: self, message: "Please SELECT TRAINING", seconds: 2.0)
                return false
            }else if !flag1{
                self.showtoast(controller: self, message: "Data already exists Please Enter different Stylist Details", seconds: 2.2)
                return false
            }
            return true
        }
    }
