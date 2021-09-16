//
//  Salontracking.swift
//  Wella.2
//
//  Created by Acxiom Consulting on 05/10/18.
//  Copyright © 2018 Acxiom. All rights reserved.
//

import UIKit
import Dropdowns
import SQLite3
import Alamofire
import SystemConfiguration
import SwiftEventBus

class salontracking: ExecuteApi, UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return salontrackingdata.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "trackcell", for:  indexPath) as! salontrackingcellTableViewCell
        
        let list: salontrackinglistdata
        list = salontrackingdata[indexPath.row]
        
        cell.brand.text = list.brand
        cell.ytd.text = list.ytd
        cell.mtd.text = list.mtd
        
        return cell
    }
    
    @IBOutlet weak var trackinglistview: UITableView!

    var menuvc: menuViewController!
    var salontrackingdata = [salontrackinglistdata]()

    var ids: [String]!
    
    @IBOutlet weak var download: UIButton!
    
    var psrcodearray: [String]!
    var saloncodearray: [String]!
    var selectedpsr: String?
    var selectedsalon : String?
    var idstr: String?
    var salonname: String!
    
    @IBOutlet var spinners: [DropDown]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        AppDelegate.menubool = true
        
        menuvc = (self.storyboard?.instantiateViewController(withIdentifier: "menuViewController") as! menuViewController)
        
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
        setinsalonspinnerdata()
        
        spinners[0].didSelect { (selected, index, id) in
            self.idstr = self.ids[index]
            self.download.isEnabled = true
            if self.psrcodearray.isEmpty {
                self.setpsr(siteCode: self.ids[index])
            }
        }
//        spinners[1].listWillAppear {
//            if self.spinners[1].optionArray.count == 1 {
//                self.spinners[1].optionArray.removeAll()
//                self.spinners[2].optionArray.removeAll()
//                self.showtoast(controller: self, message: "Data not Available...CLICK \"Download\"", seconds: 2.0)
//
//               // self.spinners[1].hideList()
//            }
//        }
//        spinners[2].listWillAppear {
//            if self.spinners[2].optionArray.count == 1 {
//                self.showtoast(controller: self, message: "Data not Available...CLICK \"Download\"", seconds: 2.0)
////                self.spinners[2].hideList()
//            }
//        }
        spinners[1].didSelect{(selectedText , index ,id) in
            print("Selected String: \(selectedText) \n index: \(index)")
            self.saloncodearray.removeAll()
            self.selectedpsr = self.psrcodearray[index]
            UserDefaults.standard.set(self.selectedpsr, forKey: "psrcode")
            self.spinners[2].optionArray.removeAll()
                self.setsalon(siteCode: self.idstr!, psrcode: self.selectedpsr!)
            }
        
        spinners[2].didSelect{(selectedText , index ,id) in
            print("Selected String: \(selectedText) \n index: \(index)")
            self.salonname = selectedText
            self.selectedsalon = self.saloncodearray[index]
            UserDefaults.standard.set(self.selectedsalon, forKey: "customercode")
            //self.spinners[3].optionArray.removeAll()
        }
        self.trackinglistview.delegate = self
        self.trackinglistview.dataSource = self
        self.spinners[2].text = "SELECT Salon"
        self.spinners[1].text = "SELECT Seller"
        self.spinners[1].isEnabled = false
        self.spinners[2].isEnabled = false
        SwiftEventBus.onMainThread(self, name: "setlist") {_ in
            self.setlist()
            self.deletsalontrackingtable()
        }
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
    
    func setpsr(siteCode:String)
    {
        self.psrcodearray.removeAll()
        var stmt1:OpaquePointer?
        let queryString = "select 'SELECT Seller' as psrcode,'SELECT Seller' as psrname union all select distinct psrcode,psrname  from SalonDetail where sitE_CODE='"+siteCode+"'"
        self.spinners[2].text = "SELECT Salon"
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
        spinners[1].text = spinners[1].optionArray[0]
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
        
        var stmt1:OpaquePointer?
        let queryString = "select 'SELECT Salon' as saloncode,'SELECT SALON' as salonname union all select distinct saloncode,beatName||\" - \"||salonname as salonname from SalonDetail where sitE_CODE='"+siteCode+"' and psrcode='"+psrcode+"'"
        
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
        }  }
    
    @IBAction func download(_ sender: UIButton) {
        self.checknet()
        if AppDelegate.ntwrk > 0 {
        let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
        activityIndicator.center = CGPoint(x: view.bounds.size.width/2, y: view.bounds.size.height/2)
        activityIndicator.color = UIColor.black
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        print("loader activated")
            self.spinners[1].optionArray.removeAll()
            self.spinners[2].optionArray.removeAll()
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
                    }}
                    else {
                        self.showtoast(controller: self, message: "Data not available...", seconds: 1.5)
                }}
                    break
                    case .failure(let error): print("error======> \(error)")
                    break
            }
            self.setpsr(siteCode: self.idstr!)
            activityIndicator.stopAnimating()
            self.trackinglistview.isHidden = true
            self.view.isUserInteractionEnabled = true
            print("loader deactivated")
            }}
        }
        else
        {
            self.showtoast(controller: self, message: "Please Check Your Internet", seconds: 2.0)
        }
}
    
    @IBAction func view(_ sender: UIButton) {
        self.checknet()
        if AppDelegate.ntwrk > 0 {
        if validation(){
            DispatchQueue.main.async {
        Alamofire.request(Constants.BASE_URL+Constants.URl_salontracking).validate().responseJSON {
            response in
            switch response.result {
            case .success(let value): print("success===========> \(value)")
                if  let json = response.result.value{
                    
                    self.deletsalontrackingtable()
                    let listarray : NSArray = json as! NSArray
                    if listarray.count > 0 {
                    for i in 0..<listarray.count{
                        let productgroup = String (((listarray[i] as AnyObject).value(forKey:"productgroup") as? String)!)
                        let distriytd = String(((listarray[i] as AnyObject).value(forKey:"amT_YTD") as? Int32)!)
                        let distrimtd = String(((listarray[i] as AnyObject).value(forKey:"amT_MTD") as? Int32)!)
                        let volumeytd = String(((listarray[i] as AnyObject).value(forKey:"noofcustomeR_YTD") as? Int32)!)
                        let volumemtd = String(((listarray[i] as AnyObject).value(forKey:"noofcustomeR_MTD") as? Int32)!)
                        
                        
                        self.insertsalontrackinglist(productgroup: productgroup, distriytd: distriytd, distrimtd: distrimtd, volumeytd: volumeytd, volumemtd: volumemtd )
                        }}
                    else {
                        self.showtoast(controller: self, message: "Data not available...", seconds: 1.5)
                    }}
                SwiftEventBus.post("setlist")
                break
                
            case .failure(let error): print("error============> \(error)")
            SwiftEventBus.post("setlist")
                break
            }
            
                }
//        self.setlist()
//        self.deletsalontrackingtable()
            }}
            
        }
        else
        {
            self.showtoast(controller: self, message: "Please Check Your Internet", seconds: 2.0)
            
        }
}
    
    
    func setlist()
    {
        
        self.salontrackingdata.removeAll()
        self.trackinglistview.isHidden = false
        var stmt4:OpaquePointer?
        let queryString = "SELECT * FROM Salontracking"
        
        if sqlite3_prepare_v2(DatabaseConnection.dbs, queryString, -1, &stmt4, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(DatabaseConnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return
        }
        
        while(sqlite3_step(stmt4) == SQLITE_ROW){

            let product1 = String(cString: sqlite3_column_text(stmt4, 0))
            let distriytd1 = String(cString: sqlite3_column_text(stmt4, 1))
            let distrimtd1 = String(cString: sqlite3_column_text(stmt4, 2))

            self.salontrackingdata.append(salontrackinglistdata(brand: product1, ytd: distriytd1 , mtd: distrimtd1))
            
        }
        self.trackinglistview.reloadData()
    }
    
    func validation() -> Bool
    {
        if self.idstr == nil || self.idstr == ""
        {
            self.showtoast(controller: self, message: "Please Select Salon Branch", seconds: 2.0)
            return false
        }
            
        else if self.selectedpsr == nil || self.selectedpsr == "" || self.selectedpsr == "SELECT Seller"
        {
            self.showtoast(controller: self, message: "Please Select Seller", seconds: 2.0)
            return false
        }
        else if self.selectedsalon == nil || self.selectedsalon == ""    || self.selectedsalon == "SELECT SALON"
        {self.showtoast(controller: self, message: "Please SELECT SALON", seconds: 2.0)
            return false
        }
        return true
    }
}

