//
//  SalonTrackingViewController.swift
//  Wella.2
//
//  Created by Acxiom Consulting on 04/03/21.
//  Copyright © 2021 Acxiom. All rights reserved.

//MARK:- IMPORTS
import UIKit
import Dropdowns
import SQLite3
import Alamofire
import SystemConfiguration
import SwiftEventBus

//MARK:- BEGIN
class SalonTrackingViewController: ExecuteApi
    ,  UITableViewDelegate, UITableViewDataSource
{
    //MARK:- OUTLETS
    
    @IBOutlet weak var ytdtylist2: UILabel!
    @IBOutlet weak var ytdlylist2: UILabel!
    @IBOutlet weak var mtdtylist2: UILabel!
    @IBOutlet weak var mtdlylist2: UILabel!
    @IBOutlet weak var l2mSaleslist2: UILabel!
    @IBOutlet weak var catList2: UILabel!
    @IBOutlet weak var ytdtylist1: UILabel!
    @IBOutlet weak var ytdlylist1: UILabel!
    @IBOutlet weak var mtdtylist1: UILabel!
    @IBOutlet weak var mtdlylist1: UILabel!
    @IBOutlet weak var l2mSaleslist1: UILabel!
    @IBOutlet weak var salonCodeDropDown: DropDown!
    @IBOutlet weak var salonNameDropDown: DropDown!
    @IBOutlet weak var CategorystackView: UIStackView!
    @IBOutlet weak var brandStackView: UIStackView!
    @IBOutlet weak var salonList2: UITableView!
    @IBOutlet weak var salonList1: UITableView!
    @IBAction func searchBtnClick(_ sender: UIButton) {
        INSERTDATA()
    }

    //MARK:- VARIABLE DECALARTION
    var menuvc: menuViewController!
    var salonlist1data = [SalonList1Adapter]()
    var salonlist2data = [SalonList2Adapter]()
    var salonCode : String!
    var salonName : String!
    var salonCodearray : [String]! = []
    var salonNamearray : [String]! = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let value = UIInterfaceOrientation.portrait.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
        setUpSideBar()
        setupLabels()
        fillDropDownData()
        setupOnClicksalonCode()
        setupOnClickSalonName()
        setUpFields()
    }
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        let value = UIInterfaceOrientation.portrait.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
    }
    
    fileprivate func setUpFields(){
        if(!(AppDelegate.salonCodeSalonTracking == "")){
        self.salonCodeDropDown.text! = AppDelegate.salonCodeSalonTracking
        self.salonNameDropDown.text! = self.getSalonName(saloncode: AppDelegate.salonCodeSalonTracking)
        INSERTDATA()
        }
    }
    
    //MARK:- SEARCHBTN CLICK
    fileprivate func INSERTDATA(){
                self.checknet()
                if AppDelegate.ntwrk > 0 {
                    if Validation(){
                        self.view.isUserInteractionEnabled = false
                        let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
                        activityIndicator.center = CGPoint(x: view.bounds.size.width/2, y: view.bounds.size.height/2)
                        activityIndicator.color = UIColor.black
                        view.addSubview(activityIndicator)
                        activityIndicator.startAnimating()

                        DispatchQueue.main.async {
                            Alamofire.request(Constants.BASE_URL+Constants.URl_salontracking_new+self.salonCodeDropDown.text!).validate().responseJSON {
                                response in
                                switch response.result {
                                case .success(let value): print("success===========> \(value)")
                                if  let json = response.result.value{
                                    self.deletsalontrackingtabledata()
                                    let listarray : NSArray = json as! NSArray
                                    if listarray.count > 0 {
                                        for i in 0..<listarray.count{
                                            let entity = String (((listarray[i] as AnyObject).value(forKey:"entity") as? String)!)
                                            let l2msales = String(describing: ((listarray[i] as AnyObject).value(forKey:"tY L2M Sales") as? Double)!)
                                            let mtdly = String(((listarray[i] as AnyObject).value(forKey:"mtD LY") as? Double)!)
                                            let mtdty = String(((listarray[i] as AnyObject).value(forKey:"mtD TY") as? Double)!)
                                            let ytdty = String(((listarray[i] as AnyObject).value(forKey:"ytD TY") as? Double)!)
                                            let ytdly = String(((listarray[i] as AnyObject).value(forKey:"ytD LY") as? Double)!)
                                            
                                            var type = ""
                                            if(i < 5){
                                                type = "List1"
                                            }
                                            else {
                                                type = "List2"
                                            }
                                            
                                            self.insertsalontrackingdata(entity: entity, l2msales: l2msales, mtdly: mtdly, mtdty: mtdty, ytdly: ytdly, ytdty: ytdty,type : type )
                                        }}
                                    else {
                                        self.showtoast(controller: self, message: "Data not available...", seconds: 1.5)
                                    }}
                            //    SwiftEventBus.post("setlist")
                                self.setList1()
                                activityIndicator.stopAnimating()
                                activityIndicator.hidesWhenStopped = true
                                self.view.isUserInteractionEnabled = true
                                    break
                                    
                                case .failure(let error): print("error============> \(error)")
                                self.setList1()
                                activityIndicator.stopAnimating()
                                activityIndicator.hidesWhenStopped = true
                                self.view.isUserInteractionEnabled = true
                                    break
                                }
                            }
                        }
                    }
                }
                else
                {
                    self.showtoast(controller: self, message: "Please Check Your Internet", seconds: 2.0)
                    
                }

    }
    fileprivate func setupLabels(){
        l2mSaleslist1.text! = "L2M" + "\n" + "Sales"
        mtdtylist1.text! = "MTD" + "\n" + "LY"
        mtdtylist1.text! = "MTD" + "\n" + "TY"
        ytdlylist1.text! = "FY" + "\n" + "LY"
        ytdtylist1.text! = "YTD" + "\n" + "TY"
        
        catList2.text! = "Category" + "\n" + "Name"
        l2mSaleslist2.text! = "L2M" + "\n" + "Sales"
        mtdtylist2.text! = "MTD" + "\n" + "LY"
        mtdtylist2.text! = "MTD" + "\n" + "TY"
        ytdlylist2.text! = "FY" + "\n" + "LY"
        ytdtylist2.text! = "YTD" + "\n" + "TY"

    }
    
    func fillDropDownData () {
        salonNamearray.removeAll()
        salonCodearray.removeAll()
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
            let salonNameStr = String(cString: sqlite3_column_text(stmt, 1))
            let salonCodeStr = String(cString: sqlite3_column_text(stmt, 0))
            
            salonNameDropDown.optionArray.append(salonNameStr)
            salonCodeDropDown.optionArray.append(salonCodeStr)
            salonCodearray.append(salonCodeStr)
            salonNamearray.append(salonNameStr)

        }
    }

    
    fileprivate func setupOnClicksalonCode(){
        salonCodeDropDown.didSelect{(selectedText , index ,id) in
            print("Selected String: \(selectedText) \n index: \(index)")
            self.salonCode = self.salonCodearray[index]
            self.salonName = self.salonNamearray[index]
            
            self.salonCodeDropDown.text! = self.salonCode!
            self.salonNameDropDown.text! = self.salonName!
            
         //   self.setSalonNameFromSalonCode(salonCode : self.salonCode)
        }
    }
    fileprivate func setupOnClickSalonName(){
        salonNameDropDown.didSelect{(selectedText , index ,id) in
            print("Selected String: \(selectedText) \n index: \(index)")
            self.salonCode = self.salonCodearray[index]
            self.salonName = self.salonNamearray[index]
            
            self.salonCodeDropDown.text! = self.salonCode!
            self.salonNameDropDown.text! = self.salonName!

//            self.setSalonCodeFromSalonName(salonName : self.salonName)
        }
        
        
    }
    fileprivate func setSalonCodeFromSalonName(salonName : String?){
        salonNameDropDown.text! = salonCode!
    }
    fileprivate func setSalonNameFromSalonCode(salonCode : String?) {
        salonCodeDropDown.text! = salonCode!

    }

    
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return (tableView == salonList1) ? salonlist1data.count : salonlist2data.count
        //   return salonlist1data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //        let cell = tableView.dequeueReusableCell(withIdentifier: "list1cell", for:  indexPath) as! SalonList1TableViewCell
        //
        //        let list: SalonList1Adapter
        //        list = salonlist1data[indexPath.row]
        //
        //
        //        cell.brand.text = list.entity
        //        cell.l2msales.text = list.l2msales
        //        cell.mtdly.text = list.mtdly
        //        cell.mtdty.text = list.mtdty
        //        cell.ytdly.text = list.ytdly
        //        cell.ytdty.text = list.ytdty
        //
        //        return cell
          if tableView == salonList1 {
                            let cell = tableView.dequeueReusableCell(withIdentifier: "list1cell") as! SalonList1TableViewCell
            let list: SalonList1Adapter
            list = salonlist1data[indexPath.row]
            
            
            cell.brand.text = list.entity
            cell.l2msales.text = list.l2msales
            cell.mtdly.text = list.mtdly
            cell.mtdty.text = list.mtdty
            cell.ytdly.text = list.ytdly
            cell.ytdty.text = list.ytdty
            
            return cell
                    }
        
            if tableView == salonList2 {
                            let cell = tableView.dequeueReusableCell(withIdentifier: "list2cell") as! SalonList2TableViewCell
            let list: SalonList2Adapter
            list = salonlist2data[indexPath.row]
            
            cell.catname.text = list.entity
            cell.l2msales.text = list.l2msales
            cell.mtdly.text = list.mtdly
            cell.mtdty.text = list.mtdty
            cell.ytdly.text = list.ytdly
            cell.ytdty.text = list.ytdty
            
            return cell
            
                    
        }
            return UITableViewCell()
    }
    fileprivate func Validation() -> Bool {
        if(salonCodeDropDown.text! == ""){
            
            return false
        }
        else if (salonNameDropDown.text! == ""){
            return false
        }
        return true
    }
    //MARK:-SALONLIST1 SET
    func setList1()
    {
        
        self.salonlist1data.removeAll()
        self.salonList1.isHidden = false
        var stmt4:OpaquePointer?
        let typStr : String! = "List1"
        let queryString = "SELECT * FROM salontrackingdata  WHERE type = '" + typStr! + "'"
   //     let queryString = "SELECT * FROM salontrackingdata"

        print("SetList1"+queryString)
        if sqlite3_prepare_v2(DatabaseConnection.dbs, queryString, -1, &stmt4, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(DatabaseConnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return
        }
        
        while(sqlite3_step(stmt4) == SQLITE_ROW){

            let entity = String(cString: sqlite3_column_text(stmt4, 0))
            let l2msales = String(cString: sqlite3_column_text(stmt4, 1))
            let mtdly = String(cString: sqlite3_column_text(stmt4, 2))
            let mtdty = String(cString: sqlite3_column_text(stmt4, 3))
            let ytdly = String(cString: sqlite3_column_text(stmt4, 4))
            let ytdty = String(cString: sqlite3_column_text(stmt4, 5))

            self.salonlist1data.append(SalonList1Adapter(entity: entity, l2msales: l2msales, mtdly: mtdly, mtdty: mtdty, ytdly: ytdly, ytdty: ytdty))

            
        }
        self.salonList1.reloadData()
        
        self.setList2()
    }
    //MARK:-SALONLIST2 SET
    func setList2()
    {
        
        self.salonlist2data.removeAll()
        self.salonList2.isHidden = false
        var stmt4:OpaquePointer?
        var typStr : String! = "List2"
        let queryString = "SELECT * FROM salontrackingdata  WHERE type = '" + typStr! + "'"
//        let queryString = "SELECT * FROM salontrackingdata"

        print("SetList2"+queryString)
        if sqlite3_prepare_v2(DatabaseConnection.dbs, queryString, -1, &stmt4, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(DatabaseConnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return
        }
        
        while(sqlite3_step(stmt4) == SQLITE_ROW){

            let entity = String(cString: sqlite3_column_text(stmt4, 0))
            let l2msales = String(cString: sqlite3_column_text(stmt4, 1))
            let mtdly = String(cString: sqlite3_column_text(stmt4, 2))
            let mtdty = String(cString: sqlite3_column_text(stmt4, 3))
            let ytdly = String(cString: sqlite3_column_text(stmt4, 4))
            let ytdty = String(cString: sqlite3_column_text(stmt4, 5))

            self.salonlist2data.append(SalonList2Adapter(entity: entity, l2msales: l2msales, mtdly: mtdly, mtdty: mtdty, ytdly: ytdly, ytdty: ytdty))

            
        }
        self.salonList2.reloadData()
       
    }
}
