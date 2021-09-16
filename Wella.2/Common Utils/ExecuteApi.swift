//
//  ExecuteApi.swift
//  Wella.2
//
//  Created by Acxiom Consulting on 27/09/18.
//  Copyright © 2018 Acxiom. All rights reserved.
//

import Foundation
import UIKit
import SQLite3
import Alamofire
import Alamofire_SwiftyJSON
import SwiftEventBus

public class ExecuteApi: BaseActivity {

    public func executeapifunc(view: UIView){
        //        let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
        //        activityIndicator.center = CGPoint(x: view.bounds.size.width/2, y: view.bounds.size.height/2)
        //        activityIndicator.color = UIColor.black
        //        view.addSubview(activityIndicator)
        UserDefaults.standard.set(self.getdate(), forKey: "executeapi")
        //        view.isUserInteractionEnabled = false
        //        activityIndicator.startAnimating()
        //        print("loader activated")
        
        DispatchQueue.main.async {
            //  self.executeDashList()
            //  self.executeChannel()
            self.executeDashboardDsu()
            self.executeTrainingLineChart()
            self.executeStylistLineChart()
            self.executePieChart()
            //    self.executeBranch()
            self.executeProfile()
            self.executeGetTrainingData()
            //   self.executeAddStylistCategory()
            //   self.executeAddStylistLevel()
            //    self.executeDashboardFirstLevel()
            //    self.executeDashboardSecondLevel()
            self.executeStylistData()
            self.executeHome_Prod_Data()
            self.executeHome_ProdUnprod_Data()
            self.executeColorLevel()
            self.executeProfileNew()
            self.executeSalon()
            self.executeTodayActivity()
            self.executeTODAYWORKSHINSALONVIRTUAL()
            self.executeURL_GETALLOWTRAININGTYPEMASTER()
            self.executeGETTODAYMULTIWORKSHOP()
            self.executeURL_GetCalender()
            self.executeURL_GetCalenderPending()
            self.executeCityMaster()
            //            activityIndicator.stopAnimating()
            //            view.isUserInteractionEnabled = true
            //            print("loader deactivated")
            
            //  self.callback()
        }
    }
    
    public func callback(){
        
    }
    
    public override var shouldAutorotate: Bool {
           return false
       }
    
    func postsynclog(){
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
            DispatchQueue.main.async
                {
                    var stmt1: OpaquePointer?
                    let querypost = "SELECT * FROM PostSynclog WHERE post = '0'"
                    if sqlite3_prepare_v2(DatabaseConnection.dbs, querypost, -1, &stmt1, nil) != SQLITE_OK{
                        let errmsg = String(cString: sqlite3_errmsg(DatabaseConnection.dbs)!)
                        print("error preparing get: \(errmsg)")
                        return
                    }
                    while(sqlite3_step(stmt1) == SQLITE_ROW){
                        let tablename = String(cString: sqlite3_column_text(stmt1, 0))
                        let device = String(cString: sqlite3_column_text(stmt1, 1))
                        let manufecture = String(cString: sqlite3_column_text(stmt1, 2))
                        let osversion = String(cString: sqlite3_column_text(stmt1, 3))
                        let appversion = String(cString: sqlite3_column_text(stmt1, 4))
                        let datetime = String(cString: sqlite3_column_text(stmt1, 5))
                        let status = String(cString: sqlite3_column_text(stmt1, 6))
                        let userid = String(cString: sqlite3_column_text(stmt1, 7))
                        let usertype = String(cString: sqlite3_column_text(stmt1, 8))
                        let syncid = String(cString: sqlite3_column_text(stmt1, 9))
                        var  stat: NSString?
                        print("\n")
                        let parameters: [String: AnyObject] = [
                            "Usercode" : userid as AnyObject,
                            "UserType" : usertype as AnyObject,
                            "SyncLogId" : syncid as AnyObject,
                            "SyncDateTime" : datetime as AnyObject,
                            "SyncVersion" : appversion as AnyObject,
                            "Model" : device as AnyObject,
                            "Manufacturer" : manufecture as AnyObject,
                            "Version" : osversion as AnyObject,
                            "LogMsg" : status as AnyObject,
                            "TABLENAME" : tablename as AnyObject,
                        ]
                        print(self.json(from: parameters)!);
                        
                        Alamofire.request(Constants.BASE_URL + Constants.URL_PostSynclog, method: .post, parameters: parameters, encoding: JSONEncoding.default)
                            .responseJSON { response in
                                print("Response =========>>>>\(response.response! as Any)")
                                print("Error ============>>>>\(response.error as Any)")
                                print("Data =============>>>>\(response.data! as Any)")
                                print("Result =========>>>>>\(response.result)")
                                
                                stat = response.result.description as NSString
                                print("status =========>>>>>\(String(describing: stat!))")
                                switch response.result {
                                case .success :
                                    //self.showtoast(controller: self, message: "Upload Status: Success", seconds: 2.0)
                                    self.updatepostsynclog(syncid: syncid)
                                    
                                    break
                                    
                                case .failure(let error):
                                    print("ERROR=========>>>>>>\(error)")
                                    self.showtoast(controller: self, message: "Upload Status: ERROR", seconds: 2.0)
                                    break
                                }
                        }
                    }
                    
                    //                DispatchQueue.main.async {
                    //                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    //
                    //                      // stop animating now that background task is finished
                    activityIndicator.stopAnimating()
                    self.view.isUserInteractionEnabled = true
                    print("loader deactivated")
                    self.showtoast(controller: self, message: " Data is Uploaded", seconds: 1.0)
                    //                    }
                    //                }
            }
        }
        else {
            self.showtoast(controller: self, message: "Please Check Your Internet Connection", seconds: 1.5)
        }
    }
    
    func postaddstylist()
    {
        DispatchQueue.main.async{
            var stmt5:OpaquePointer?
            let queryString = "SELECT * FROM Addstylist WHERE post = '0'"
            if sqlite3_prepare_v2(DatabaseConnection.dbs, queryString, -1, &stmt5, nil) != SQLITE_OK{
                let errmsg = String(cString: sqlite3_errmsg(DatabaseConnection.dbs)!)
                print("error preparing get: \(errmsg)")
                return
            }
            
            while(sqlite3_step(stmt5) == SQLITE_ROW){
                //String(cString: sqlite3_column_text(stmt, 1))
                let STYLISTNAME = String(cString: sqlite3_column_text(stmt5, 0))
                let SITECODE = String(cString: sqlite3_column_text(stmt5, 1))
                let SALONCODE = String(cString: sqlite3_column_text(stmt5, 2))
                let CONTACT = String(cString: sqlite3_column_text(stmt5, 3))
                let EMAIL = String(cString: sqlite3_column_text(stmt5, 4))
                let ADDRESS = String(cString: sqlite3_column_text(stmt5, 5))
                let LAT = String(cString: sqlite3_column_text(stmt5, 6)) == "" ? "0" : String(cString: sqlite3_column_text(stmt5, 6))
                let LONG = String(cString: sqlite3_column_text(stmt5, 7)) == "" ? "0" : String(cString: sqlite3_column_text(stmt5, 7))
                let USERCODE = String(cString: sqlite3_column_text(stmt5, 8))
                let CATEGORY = String(cString: sqlite3_column_text(stmt5, 9))
                let LEVELCODE = String(cString: sqlite3_column_text(stmt5, 10))
                let SELLERCODE = String(cString: sqlite3_column_text(stmt5, 11))
                let IMAGE = String(cString: sqlite3_column_text(stmt5, 12))
                let id = String(cString: sqlite3_column_text(stmt5, 14))
                
                var  stat: NSString?
                print("\n")
                
                
                let parameters: [String: AnyObject] = [
                    "STYLISTNAME":STYLISTNAME as AnyObject,
                    "SITECODE":SITECODE as AnyObject,
                    "SALONCODE" : SALONCODE as AnyObject,
                    "CONTACT" : CONTACT as AnyObject,
                    "EMAIL" : EMAIL as AnyObject,
                    "ADDRESS" : ADDRESS as AnyObject,
                    "LAT" : LAT as AnyObject,
                    "LONG" : LONG as AnyObject,
                    "USERCODE" : UserDefaults.standard.string(forKey: "userid")! as AnyObject,
                    "CATEGORY" : CATEGORY as AnyObject,
                    "LEVELCODE" : LEVELCODE as AnyObject,
                    "SELLERCODE" : SELLERCODE as AnyObject,
                    "IMAGE" : IMAGE as AnyObject,
                ]
                Alamofire.request(Constants.BASE_URL + Constants.URL_AddStylistdetail, method: .post, parameters: parameters, encoding: JSONEncoding.default)
                    .responseJSON {
                        response in
                        print("Response =========>>>>\(response.response as Any)")
                        print("Error ============>>>>\(response.error as Any)")
                        print("Data =============>>>>\(response.data as Any)")
                        print("Result =========>>>>>\(response.result)")
                        stat = response.result.description as NSString
                        print("status =========>>>>>\(String(describing: stat!))")
                        switch response.result {
                        case .success :
                            //self.showtoast(controller: self, message: "Upload Status: Success", seconds: 2.0)
                            self.updatestylist(id: id)
                            self.insertsynclog(tablename: "Addstylist", status: "Success", post: "0")
                            break
                            
                        case .failure(let error):
                            self.showtoast(controller: self, message: "Upload Status: \(error)", seconds: 2.0)
                            self.insertsynclog(tablename: "Addstylist", status: "Failure", post: "0")
                            break
                        }
                }
            }
            self.postsynclog()
        }
    }
    
    func postMyinsalon()
    {
        DispatchQueue.main.async
            {
                var stmt1:OpaquePointer?
                let queryString = "SELECT * FROM InSalonDetail WHERE post = '0'"
                if sqlite3_prepare_v2(DatabaseConnection.dbs, queryString, -1, &stmt1, nil) != SQLITE_OK{
                    let errmsg = String(cString: sqlite3_errmsg(DatabaseConnection.dbs)!)
                    print("error preparing get: \(errmsg)")
                    return
                }
                while(sqlite3_step(stmt1) == SQLITE_ROW){
                    //String(cString: sqlite3_column_text(stmt, 1))
                    let trainercode = String(cString: sqlite3_column_text(stmt1, 1))
                    let sitecode = String(cString: sqlite3_column_text(stmt1, 3))
                    let sellercode = String(cString: sqlite3_column_text(stmt1, 13))
                    let noofstylist = String(cString: sqlite3_column_text(stmt1, 5))
                    let noofmodel = String(cString: sqlite3_column_text(stmt1, 6))
                    let remark = String(cString: sqlite3_column_text(stmt1, 7))
                    let lat = String(cString: sqlite3_column_text(stmt1, 8)) == "" ? "0" : String(cString: sqlite3_column_text(stmt1, 8))
                    let long = String(cString: sqlite3_column_text(stmt1, 9)) == "" ? "0" : String(cString: sqlite3_column_text(stmt1, 9))
                    let date = String(cString: sqlite3_column_text(stmt1, 10))
                    let saloncode = String(cString: sqlite3_column_text(stmt1, 4))
                    let pkey = String(cString: sqlite3_column_text(stmt1, 12))
                    var  stat: NSString?
                    print("\n")
                    
                    let parameters: [String: AnyObject] = [
                        "TRAININGTYPE" : "INSALON" as AnyObject,
                        "TRAININGCODE" : trainercode as AnyObject,
                        "TRAINERCODE" : UserDefaults.standard.string(forKey: "userid")! as AnyObject,
                        "SITECODE" : sitecode as AnyObject,
                        "SELLERCODE" : sellercode as AnyObject,
                        "SALONCODE" : saloncode as AnyObject,
                        "NOOFSTYLIST" : noofstylist as AnyObject,
                        "NOOFMODEL" : noofmodel as AnyObject,
                        "REMARK" : remark as AnyObject,
                        "Lat" : lat as AnyObject,
                        "Long" : long as AnyObject,
                        "LOCATION" : saloncode as AnyObject,
                        "TRAININGDATE" : date as AnyObject
                    ]
                    print(self.json(from: parameters)!);
                    
                    Alamofire.request(Constants.BASE_URL + Constants.URL_Postinsalon, method: .post, parameters: parameters, encoding: JSONEncoding.default)
                        .responseJSON { response in
                            print("Response =========>>>>\(response.response as Any)")
                            print("Error ============>>>>\(response.error as Any)")
                            print("Data =============>>>>\(response.data as Any)")
                            print("Result =========>>>>>\(response.result)")
                            
                            stat = response.result.description as NSString
                            print("status =========>>>>>\(String(describing: stat!))")
                            switch response.result {
                            case .success :
                                //self.showtoast(controller: self, message: "Upload Status: Success", seconds: 2.0)
                                self.updatemyinssalon(pkey: pkey)
                                self.insertsynclog(tablename: "InSalonDetail", status: "success", post: "0")
                                break
                                
                            case .failure(let error):
                                self.insertsynclog(tablename: "InSalonDetail", status: "Failure", post: "0")
                                self.showtoast(controller: self, message: "Upload Status: \(error)", seconds: 2.0)
                                break
                            }
                    }
                }
                self.postsynclog()
        }
    }
    func postSendOTP(mobileNo : Int)
    {
        DispatchQueue.main.async{
            var  stat: NSString?
            print("\n")
            let parameters: [String: AnyObject] = [
                "MOBILENO":mobileNo as AnyObject,
            ]
            Alamofire.request(Constants.BASE_URL + Constants.URL_POSTSENDOTP, method: .post, parameters: parameters, encoding: JSONEncoding.default)
                .responseJSON {
                    response in
                    print("Response =========>>>>\(response.response as Any)")
                    print("Error ============>>>>\(response.error as Any)")
                    print("Data =============>>>>\(response.data as Any)")
                    print("Result =========>>>>>\(response.result)")
                    stat = response.result.description as NSString
                    print("status =========>>>>>\(String(describing: stat!))")
                    switch response.result {
                    case .success :
                        self.sendOTPStatusDetail()
                        break
                        
                    case .failure(let error):
                        self.sendOTPStatusOTPFail()
                        self.sendOTPStatusFail()
                        break
                    }
            }
        }
        self.postsynclog()
    }
    
    public func sendOTPStatusDetail(){
        
    }
    
    public func sendOTPStatusOTPFail(){
        
    }
    
    public func sendOTPStatusFail(){
        
    }
    
    func executeDashList(){
        Alamofire.request(Constants.BASE_URL + Constants.URL_GET_list).validate().responseJSON {
            response in
            switch response.result {
            case .success(let value): print("success======> \(value)")
            if  let json = response.result.value{
                let listarray : NSArray = json as! NSArray
                if listarray.count > 0 {
                    self.deletebrandtable()
                    for i in 0..<listarray.count{
                        let product = String (((listarray[i] as AnyObject).value(forKey:"productgroup") as? String)!)
                        let distrimtd = String(((listarray[i] as AnyObject).value(forKey:"amT_MTD") as? Int32)!)
                        let distriytd = String(((listarray[i] as AnyObject).value(forKey:"amT_YTD") as? Int32)!)
                        let volumemtd = String(((listarray[i] as AnyObject).value(forKey:"noofcustomeR_MTD") as? Int32)!)
                        let volumeytd = String(((listarray[i] as AnyObject).value(forKey:"noofcustomeR_YTD") as? Int32)!)
                        print("insert============product: \(String(describing: product))")
                        print("insert============distrimtd:\(String(describing: distrimtd))")
                        print("insert============distriytd:\(String(describing: distriytd))")
                        print("insert============volumemtd:\(String(describing: volumemtd))")
                        print("insert============volumeytd:\(String(describing: volumeytd))")
                        
                        self.insertdashlist(productgroup: product,distrimtd: distrimtd,distriytd: distriytd,volumeytd: volumeytd,volumemtd: volumemtd)
                    }
                }
                else {
                    self.showtoast(controller: self, message: "Data not available...", seconds: 1.5)
                }
            }
            
                break
                
            case .failure(let error): print("error======> \(error)")
            
                break
            }
        }
    }
    func executeChannel(){
        var channel: String?
        
        Alamofire.request(Constants.BASE_URL + Constants.URL_PIChart).validate().responseJSON {
            response in
            switch response.result {
                
            case .success(let value): print("success======> \(value)")
            
            if  let json = response.result.value{
                let listarray : NSArray = json as! NSArray
                
                for i in 0..<listarray.count{
                    channel = String(((listarray[i] as AnyObject).value(forKey:"channeL_TYPE") as? String)!)
                    
                    if channel == "GOLD" {
                        UserDefaults.standard.set((listarray[i] as AnyObject).value(forKey:"nO_BILLS") as? Double, forKey: "goldvalue")
                    }
                    if channel == "KA - EL" {
                        UserDefaults.standard.set((listarray[i] as AnyObject).value(forKey:"nO_BILLS") as? Double, forKey: "kaelvalue")
                    }
                    if channel == "KA - PT" {
                        UserDefaults.standard.set((listarray[i] as AnyObject).value(forKey:"nO_BILLS") as? Double, forKey: "kaptvalue")
                    }
                    if channel == "SILVER" {
                        UserDefaults.standard.set((listarray[i] as AnyObject).value(forKey:"nO_BILLS") as? Double, forKey: "silvervalue")
                    }
                }
            }
                break
                
            case .failure(let error): print("error======> \(error)")
            
                break
            }
        }
        
    }
    func executeBranch(){
        Alamofire.request(Constants.BASE_URL+Constants.URL_GET_Branchspinner).validate().responseJSON {
            response in
            switch response.result {
            case .success(let value): print("success======> \(value)")
            if  let json = response.result.value{
                self.deletebranchtable()
                let listarray : NSArray = json as! NSArray
                for i in 0..<listarray.count{
                    let sitecode = String (((listarray[i] as AnyObject).value(forKey:"sitecode") as? String)!)
                    let sitename = String (((listarray[i] as AnyObject).value(forKey:"sitename") as? String)!)
                    print("insert========\(sitename)")
                    self.insertbranchspinner(siteid: sitecode, sitename: sitename)
                }}
                break
            case .failure(let error): print("error======> \(error)")
                break
            }
        }
    }
    
    func executeProfile(){
        Alamofire.request(Constants.BASE_URL+Constants.URL_GET_PROFILE).validate().responseJSON {
            response in
            switch response.result {
                
            case .success(let value): print("success======> \(value)")
            
            if  let json = response.result.value{
                
                self.deleteuserdetailtable()
                let listarray : NSArray = json as! NSArray
                
                for i in 0..<listarray.count{
                    let regionname = String (((listarray[i] as AnyObject).value(forKey:"regionname") as? String)?.description ?? "")
                    let zonecode = String (((listarray[i] as AnyObject).value(forKey:"zonecode") as? String)!)
                    let saleofficecode = String (((listarray[i] as AnyObject).value(forKey:"saleofficecode") as? String)!)
                    let sitecode = String (((listarray[i] as AnyObject).value(forKey:"sitecode") as? String)!)
                    let sitename = String (((listarray[i] as AnyObject).value(forKey:"sitename") as? String)!)
                    let trainercode = String (((listarray[i] as AnyObject).value(forKey:"trainercode") as? String)!)
                    let trainername = String (((listarray[i] as AnyObject).value(forKey:"trainername") as? String)!)
                    let expertise = String (((listarray[i] as AnyObject).value(forKey:"expertise") as? String)!)
                    let expertisename = String (((listarray[i] as AnyObject).value(forKey:"expertisename") as? String)!)
                    let address = String (((listarray[i] as AnyObject).value(forKey:"address") as? String)!)
                    let contactno = String (((listarray[i] as AnyObject).value(forKey:"contactno") as? String)!)
                    let email = String (((listarray[i] as AnyObject).value(forKey:"email") as? String)!)
                    let isblocked = String (((listarray[i] as AnyObject).value(forKey:"isblocked") as? String)!)
                    let levelcode = String (((listarray[i] as AnyObject).value(forKey:"levelcode") as? String)!)
                    let levelname = String (((listarray[i] as AnyObject).value(forKey:"levelname") as? String)!)
                    let doj = ""
                    let designation = String (((listarray[i] as AnyObject).value(forKey:"designation") as? String)!)
                    let statecode = String (((listarray[i] as AnyObject).value(forKey:"statecode") as? String)!)
                    let statename = String (((listarray[i] as AnyObject).value(forKey:"statename") as? String)!)
                    
                    self.insertuserdetail(regionname: regionname, zonecode: zonecode, saleofficecode: saleofficecode, sitecode: sitecode, sitename: sitename, trainercode: trainercode, trainername: trainername, expertise: expertise, expertisename: expertisename, address: address, contactno: contactno, email: email, isblocked: isblocked, levelcode: levelcode, levelname: levelname, doj: doj, designation: designation, statecode: statecode, statename: statename)
                }}
                break
                
            case .failure(let error): print("error======> \(error)")
            
                break
            }
        }
        
    }
    func executeGetTrainingData(){
        self.deletetrainingData()
        Alamofire.request(Constants.BASE_URL + Constants.URL_getTrainingdata).validate().responseJSON {
            response in
            switch response.result {
                
            case .success(let value): print("success======> \(value)")
            
            if  let json = response.result.value{
                
                let listarray : NSArray = json as! NSArray
                
                for i in 0..<listarray.count{
                    let trainingcode = String (((listarray[i] as AnyObject).value(forKey:"trainingcode") as? String)!)
                    let trainingname = String (((listarray[i] as AnyObject).value(forKey:"trainingname") as? String)!)
                    self.getTrainingdata(trainingcode: trainingcode, trainingname: trainingname)
                    print("Training spinner data inserted")
                }
                
            }
                break
                
            case .failure(let error): print("error======> \(error)")
            
                break
            }
            
        }
        
    }
    func executeAddStylistCategory(){
        
        
        Alamofire.request(Constants.BASE_URL + Constants.URL_AddstylistCategory).validate().responseJSON {
            response in
            switch response.result {
            case .success(let value): print("success======> \(value)")
            
            if  let json = response.result.value{
                
                
                let listarray : NSArray = json as! NSArray
                
                for i in 0..<listarray.count{
                    let catgcode = String (((listarray[i] as AnyObject).value(forKey:"catgcode") as? String)!)
                    let catgname = String (((listarray[i] as AnyObject).value(forKey:"catgname") as? String)!)
                    self.getCategory(catgcode: catgcode, catgname: catgname)
                    print("Category spinner data inserted")
                }}
                break
                
            case .failure(let error): print("error======> \(error)")
            
                break
            }
        }
        
    }
    func executeAddStylistLevel(){
        
        Alamofire.request(Constants.BASE_URL + Constants.URL_Addstylistlevel).validate().responseJSON {
            response in
            switch response.result {
            case .success(let value): print("success======> \(value)")
            
            if  let json = response.result.value{
                
                
                let listarray : NSArray = json as! NSArray
                
                for i in 0..<listarray.count{
                    let levelcode = String (((listarray[i] as AnyObject).value(forKey:"levelcode") as? String)!)
                    let levelname = String (((listarray[i] as AnyObject).value(forKey:"levelname") as? String)!)
                    self.getLevel(levelcode: levelcode, levelname: levelname)
                    print("Level spinner data inserted")
                }}
                break
                
            case .failure(let error): print("error======> \(error)")
            
                break
            }
        }
        
    }
    func executeDashboardFirstLevel(){
        Alamofire.request(Constants.BASE_URL+Constants.URL_dashboardfirstlevel).validate().responseJSON{
            response in
            switch response.result {
            case .success(let value): print("success======> \(value)")
            if let json = response.result.value{
                let listarray : NSArray = json as! NSArray
                //                UserDefaults.standard.set(String (((listarray[0] as AnyObject).value(forKey:"doorstrained") as? Int32)!), forKey: "doorstrained")
                //                UserDefaults.standard.set(String (((listarray[0] as AnyObject).value(forKey:"stylisttrained") as? Int32)!), forKey: "stylisttrained")
                //                UserDefaults.standard.set(String (((listarray[0] as AnyObject).value(forKey:"uniquedoorstrained") as? Int32)!), forKey: "uniquedoorstrained")
                
                
            }
                break
                
            case .failure(let error): print("error======> \(error)")
                break
            }}
        
    }
    func executeDashboardSecondLevel(){
        Alamofire.request(Constants.BASE_URL+Constants.URL_dashboardSecondlevel).validate().responseJSON{
            response in
            switch response.result {
                
            case .success(let value): print("success======> \(value)")
            
            if let json = response.result.value{
                let listarray : NSArray = json as! NSArray
                UserDefaults.standard.set(String (((listarray[0] as AnyObject).value(forKey:"gold") as? Int32)!), forKey: "gold")
                UserDefaults.standard.set(String (((listarray[0] as AnyObject).value(forKey:"silver") as? Int32)!), forKey: "silver")
                UserDefaults.standard.set(String (((listarray[0] as AnyObject).value(forKey:"key") as? Int32)!), forKey: "key")
                UserDefaults.standard.set(String (((listarray[0] as AnyObject).value(forKey:"others") as? Int32)!), forKey: "others")
            }
                break
            case .failure(let error): print("error======> \(error)")
                break
            }}
    }
    
    func executeDashboardDsu(){
        Alamofire.request(Constants.BASE_URL + Constants.URL_dashboardDsu).validate().responseJSON {
            response in
            print("DashboardURL==============================================================")
            print(Constants.BASE_URL + Constants.URL_dashboardDsu)
            switch response.result {
            case .success(let value): print("success======> \(value)")
            if  let json = response.result.value{
                let listarray : NSArray = json as! NSArray
                if listarray.count > 0 {
                    self.deletedashboarddsu()
                    for i in 0..<listarray.count{
                        let virtual = String(((listarray[i] as AnyObject).value(forKey:"virtualTraining") as? Int)!)
                        let talkdoortarget = String(((listarray[i] as AnyObject).value(forKey:"talkdoortarget") as? Int)!)
                        let trainingtarget = String(((listarray[i] as AnyObject).value(forKey:"traningtarget") as? Int)!)
                        let stylishtarget = String (((listarray[i] as AnyObject).value(forKey:"stylishtarget") as? Int)!)
                        let talkdoorach = String(((listarray[i] as AnyObject).value(forKey:"talkdoorach") as? Int)!)
                        let trainingach = String(((listarray[i] as AnyObject).value(forKey:"traningach") as? Int)!)
                        let stylishach = String(((listarray[i] as AnyObject).value(forKey:"stylishach") as? Int)!)
                        let uniquedoortrained = String(((listarray[i] as AnyObject).value(forKey:"uniqdoortrained") as? Int)!)
                        let insalon =  String (((listarray[i] as AnyObject).value(forKey:"insalon") as? Int)!)
                        let workshop =  String(((listarray[i] as AnyObject).value(forKey:"workShop") as? Int)!)
                        
                        print("insert============insalon: \(String(describing: insalon))")
                        print("insert============workshop:\(String(describing: workshop))")
                        print("insert============virtual:\(String(describing: virtual))")
                        print("insert============talkdoortarget:\(String(describing: talkdoortarget))")
                        print("insert============trainingtarget:\(String(describing: trainingtarget))")
                        print("insert============stylishtarget: \(String(describing: stylishtarget))")
                        print("insert============talkdoorach:\(String(describing: talkdoorach))")
                        print("insert============trainingach:\(String(describing: trainingach))")
                        print("insert============stylishach:\(String(describing: stylishach))")
                        print("insert============uniquedoortrained:\(String(describing: uniquedoortrained))")
                        
                        self.insertdashdsu(doorstrained: trainingtarget, stylisttrained: stylishtarget, uniquedoorstrained: uniquedoortrained, topdoorstrained: talkdoortarget, doorstrainedach: trainingach, stylisttrainedach: stylishach, uniquedoorstrainedach: uniquedoortrained, topdoorstrainedach: talkdoorach, insalon: insalon, virtualtraining: virtual, workshop: workshop)
                    }
                }
                else {
                    self.showtoast(controller: self, message: "Data not available...", seconds: 1.5)
                }
            }
                break
                
            case .failure(let error): print("error======> \(error)")
            
                break
            }
        }
    }
    func executeTrainingLineChart(){
        Alamofire.request(Constants.BASE_URL + Constants.URL_trainingLineChart).validate().responseJSON {
            response in
            switch response.result {
            case .success(let value): print("success======> \(value)")
            if  let json = response.result.value{
                let listarray : NSArray = json as! NSArray
                if listarray.count > 0 {
                    self.deletetraininglinechart()
                    for i in 0..<listarray.count{
                        let trainingmonth = String(((listarray[i] as AnyObject).value(forKey:"trainingmonth") as? String)!)
                        let trainingconducted = String(((listarray[i] as AnyObject).value(forKey:"trainingconducted") as? Int)!)
                        
                        print("insert============trainingmonth: \(String(describing: trainingmonth))")
                        print("insert============trainingconducted:\(String(describing: trainingconducted))")
                        
                        self.insertTrainingLineChart(trainingmonth: trainingmonth, trainingconducted: trainingconducted)
                    }
                }
                else {
                    self.showtoast(controller: self, message: "Data not available...", seconds: 1.5)
                }
            }
            
                break
                
            case .failure(let error): print("error======> \(error)")
            
                break
            }
        }
    }
    func executeStylistLineChart(){
        Alamofire.request(Constants.BASE_URL + Constants.URL_StylistLineChart).validate().responseJSON {
            response in
            switch response.result {
            case .success(let value): print("success======> \(value)")
            if  let json = response.result.value{
                let listarray : NSArray = json as! NSArray
                if listarray.count > 0 {
                    self.deletestylistlinechart()
                    for i in 0..<listarray.count{
                        let trainingmonth = String(((listarray[i] as AnyObject).value(forKey:"trainingmonth") as? String)!)
                        let participantcount = String(((listarray[i] as AnyObject).value(forKey:"participantcount") as? Int)!)
                        
                        print("insert============trainingmonth: \(String(describing: trainingmonth))")
                        print("insert============participantcount:\(String(describing: participantcount))")
                        
                        self.insertStylistLineChart(trainingmonth: trainingmonth, participantcount: participantcount)
                    }
                }
                else {
                    self.showtoast(controller: self, message: "Data not available...", seconds: 1.5)
                }
            }
            
                break
                
            case .failure(let error): print("error======> \(error)")
            
                break
            }
        }
    }
    
    func executePieChart(){
        Alamofire.request(Constants.BASE_URL + Constants.URL_PieChart).validate().responseJSON {
            response in
            switch response.result {
            case .success(let value): print("success======> \(value)")
            if  let json = response.result.value{
                let listarray : NSArray = json as! NSArray
                if listarray.count > 0 {
                    self.deletepiechart()
                    for i in 0..<listarray.count{
                        let trainingname = String(((listarray[i] as AnyObject).value(forKey:"trainingname") as? String)!)
                        let counttrainingcode = String(((listarray[i] as AnyObject).value(forKey:"counttrainingcode") as? Int)!)
                        
                        print("insert============trainingname: \(String(describing: trainingname))")
                        print("insert============counttrainingcode:\(String(describing: counttrainingcode))")
                        
                        self.insertPieChart(trainingname: trainingname, counttrainingcode: counttrainingcode)
                    }
                }
                else {
                    self.showtoast(controller: self, message: "Data not available...", seconds: 1.5)
                }
            }
            
                break
                
            case .failure(let error): print("error======> \(error)")
            
                break
            }
        }
    }
    
    // MARK:- SALON DATA
    func executeSalon(){
        Alamofire.request(Constants.BASE_URL+Constants.URL_SalonDetails).validate().responseJSON {
            response in
            switch response.result {
            case .success(let value): print("success======> \(value)")
            if  let json = response.result.value{
                self.deleteSalonTable()
                let listarray : NSArray = json as! NSArray
                for i in 0..<listarray.count{
                    
                    let saloncode = String(((listarray[i] as AnyObject).value(forKey:"saloncode") as? String)!)
                    let salonname = String(((listarray[i] as AnyObject).value(forKey:"salonname") as? String)!).replacingOccurrences(of: "'", with: "")
                    let salonaddress = String(((listarray[i] as AnyObject).value(forKey:"addresS1") as? String)!)
                    let sitecode = String(((listarray[i] as AnyObject).value(forKey:"sitE_CODE") as? String)!)
                    let psrcode = String(((listarray[i] as AnyObject).value(forKey:"psR_CODE") as? String)!)
                    
                    print("insert========\(saloncode)")
                    print("insert========\(salonname)")
                    print("insert========\(salonaddress)")
                    print("insert========\(sitecode)")
                    print("insert========\(psrcode)")
                    
                    self.insertSalonData(saloncode: saloncode, salonname: salonname, salonaddress: salonaddress,sitecode: sitecode,psrcode : psrcode)
                }}
                break
            case .failure(let error): print("error======> \(error)")
                break
            }
        }
    }
    
    // MARK:- CITY DATA
    func executeCityMaster(){
        Alamofire.request(Constants.BASE_URL+Constants.URL_CityMaster).validate().responseJSON {
            response in
            switch response.result {
            case .success(let value): print("success======> \(value)")
            if  let json = response.result.value{
                self.deleteCityMaster()
                let listarray : NSArray = json as! NSArray
                for i in 0..<listarray.count{
                    
                    let cityid = String(((listarray[i] as AnyObject).value(forKey:"city_Id") as? Int)!)
                    let cityname = String(((listarray[i] as AnyObject).value(forKey:"city_Name") as? String)!)
                    let statename = String(((listarray[i] as AnyObject).value(forKey:"state_Name") as? String)!)
                    
                    print("insert========\(cityid)")
                    print("insert========\(cityname)")
                    print("insert========\(statename)")
                    
                    
                    self.insertCityMaster(cityid: cityid, cityname: cityname, statename: statename)
                }}
                break
            case .failure(let error): print("error======> \(error)")
                break
            }
            
            self.goToHome()
        }
    }
    
    
    public func goToHome(){
        self.hideSyncloader()
        if(AppDelegate.isDownloadClick){
            SwiftEventBus.post("dashboardupdate")
        }
        else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.push(vcId: "dashnc", vc: self)
            }
        }
    }
    
    //MARK:- POST ADD STYLIST DATA
    public func postAddStylistData()
    {
        //        self.view.isUserInteractionEnabled = false
        //        print("sending request")
        //        let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
        //        activityIndicator.center = CGPoint(x: view.bounds.size.width/2, y: view.bounds.size.height/2)
        //        activityIndicator.color = UIColor.black
        //        view.addSubview(activityIndicator)
        //        activityIndicator.startAnimating()
        //        print("loader activated")
        
        //    //         let PostAddStylist = "CREATE TABLE IF NOT EXISTS AddStylistPost( trnappid text, stylistname text,sitecode text,saloncode text,contact text,email text,address text,lat text,long text,usercode text,gender text,city text,dob text ,anniversary text,colorlevel text,verified text,post text)"
        
        DispatchQueue.main.async{
            var stmt5:OpaquePointer?
            let queryString = "SELECT trnappid,stylistname,sitecode,saloncode,contact,email,address,lat,long,usercode,gender,city,dob,anniversary,colorlevel,verified FROM AddStylistPost WHERE post = '1'"
            if sqlite3_prepare_v2(DatabaseConnection.dbs, queryString, -1, &stmt5, nil) != SQLITE_OK{
                let errmsg = String(cString: sqlite3_errmsg(DatabaseConnection.dbs)!)
                print("error preparing get: \(errmsg)")
                return
            }
            
            while(sqlite3_step(stmt5) == SQLITE_ROW){
                let TRNAPPID =  String(cString: sqlite3_column_text(stmt5, 0))
                let STYLISTNAME = String(cString: sqlite3_column_text(stmt5, 1))
                let SITECODE = String(cString: sqlite3_column_text(stmt5, 2))
                let SALONCODE = String(cString: sqlite3_column_text(stmt5, 3))
                let CONTACT = String(cString: sqlite3_column_text(stmt5, 4))
                let EMAIL = String(cString: sqlite3_column_text(stmt5, 5))
                let ADDRESS = String(cString: sqlite3_column_text(stmt5, 6))
                let LAT = String(cString: sqlite3_column_text(stmt5, 7)) == "" ? "0" : String(cString: sqlite3_column_text(stmt5, 7))
                let LONG = String(cString: sqlite3_column_text(stmt5, 8)) == "" ? "0" : String(cString: sqlite3_column_text(stmt5, 8))
                let USERCODE = String(cString: sqlite3_column_text(stmt5, 9))
                let GENDER = String(cString: sqlite3_column_text(stmt5, 10))
                let CITY = String(cString: sqlite3_column_text(stmt5, 11))
                let DOB = String(cString: sqlite3_column_text(stmt5, 12))
                let ANNIVERSARY = String(cString: sqlite3_column_text(stmt5, 13))
                let COLORLEVEL = String(cString: sqlite3_column_text(stmt5, 14))
                let VERIFIED = String(cString: sqlite3_column_text(stmt5, 15))
                
                
                var  stat: NSString?
                print("\n")
                
                
                let parameters: [String: AnyObject] = [
                    "STYLISTNAME":STYLISTNAME as AnyObject,
                    "SITECODE":SITECODE as AnyObject,
                    "SALONCODE" : SALONCODE as AnyObject,
                    "CONTACT" : CONTACT as AnyObject,
                    "EMAIL" : EMAIL as AnyObject,
                    "ADDRESS" : ADDRESS as AnyObject,
                    "LAT" : LAT as AnyObject,
                    "LONG" : LONG as AnyObject,
                    "USERCODE" : USERCODE as AnyObject,
                    "GENDER" : GENDER as AnyObject,
                    "CITY" : CITY as AnyObject,
                    "DOB" : DOB as AnyObject,
                    "ANNIVERSARY" : ANNIVERSARY as AnyObject,
                    "COLOR_LEVEL" : COLORLEVEL as AnyObject,
                    "VERIFIED" : VERIFIED as AnyObject,
                ]
                
                print("ADD STYLIST POST===============================================")
                print(self.json(from: parameters)!);
                
                Alamofire.request(Constants.BASE_URL + Constants.URL_AddStylistdetail, method: .post, parameters: parameters, encoding: JSONEncoding.default)
                    .responseJSON {
                        response in
                        print("Response =========>>>>\(response.response as Any)")
                        print("Error ============>>>>\(response.error as Any)")
                        print("Data =============>>>>\(response.data as Any)")
                        print("Result =========>>>>>\(response.result)")
                        stat = response.result.description as NSString
                        print("status =========>>>>>\(String(describing: stat!))")
                        switch response.result {
                        case .success :
                            if (response.response?.statusCode == 200){
                                self.updateAddStylistPost(trnappid: TRNAPPID)
                                self.addStylistPostSuccess()
                                self.insertsynclog(tablename: "Addstylist", status: "Success", post: "0")
                            }
                            else{
                                self.addStylistPostFailure()
                            }
                            break
                            
                        case .failure(let error):
                         //   self.showtoast(controller: self, message: "Upload Status: \(error)", seconds: 2.0)
                            self.insertsynclog(tablename: "Addstylist", status: "Failure", post: "0")
                            self.addStylistPostFailure()
                            break
                        }
                }
            }
            //            activityIndicator.stopAnimating()
            //            self.view.isUserInteractionEnabled = true
            //            print("loader deactivated")
            //  self.postsynclog()
        }
    }
    
    public func addStylistPostSuccess(){}
    public func addStylistPostFailure(){}
    
    //         let PostAddStylist = "CREATE TABLE IF NOT EXISTS AddStylistPost( trnappid text, stylistname text,sitecode text,saloncode text,contact text,email text,address text,lat text,long text,usercode text,gender text,city text,dob text ,anniversary text,colorlevel text,verified text,post text)"
    
    //    let PostEditStylist = "CREATE TABLE IF NOT EXISTS EditStylistPost (trnappid text,trainercode text,entrytype text,impactdate text,dateapplied text,stylistcode text,dob text ,newdob text,saloncode text, newsaloncode text,address text,newaddress text,city text,newcity text,anniversary text,newanniversary text,status text,createddatetime text,createdby text,dataareaid text,post text, gender text)"
    
    
    //MARK:- POST EDIT STYLIST DATA
    public func postEditStylistData()
    {
                self.view.isUserInteractionEnabled = false
                print("sending request")
                let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
                activityIndicator.center = CGPoint(x: view.bounds.size.width/2, y: view.bounds.size.height/2)
                activityIndicator.color = UIColor.black
                view.addSubview(activityIndicator)
                activityIndicator.startAnimating()
                print("loader activated")
        
        DispatchQueue.main.async{
            var stmt5:OpaquePointer?
            let queryString = "SELECT trnappid,entrytype,trainercode,dateapplied,stylistcode,dob,newdob,saloncode,newsaloncode,address,newaddress,city,newcity,anniversary,newanniversary,status,dataareaid FROM EditStylistPost WHERE post = '0'"
            if sqlite3_prepare_v2(DatabaseConnection.dbs, queryString, -1, &stmt5, nil) != SQLITE_OK{
                let errmsg = String(cString: sqlite3_errmsg(DatabaseConnection.dbs)!)
                print("error preparing get: \(errmsg)")
                return
            }
            
            while(sqlite3_step(stmt5) == SQLITE_ROW){
                let TRNAPPID =  String(cString: sqlite3_column_text(stmt5, 0))
                let ENTRYTYPE = String(cString: sqlite3_column_text(stmt5, 1))
                let TRAINERCODE = String(cString: sqlite3_column_text(stmt5, 2))
                let DATEAPPLIED = String(cString: sqlite3_column_text(stmt5, 3))
                let STYLISTCODE = String(cString: sqlite3_column_text(stmt5, 4))
                let DOB = String(cString: sqlite3_column_text(stmt5, 5))
                let NEWDOB = String(cString: sqlite3_column_text(stmt5, 6))
                let SALONCODE = String(cString: sqlite3_column_text(stmt5, 7))
                let NEWSALONCODE = String(cString: sqlite3_column_text(stmt5, 8))
                let ADDRESS = String(cString: sqlite3_column_text(stmt5, 9))
                let NEWADDRESS = String(cString: sqlite3_column_text(stmt5, 10))
                let CITY = String(cString: sqlite3_column_text(stmt5, 11))
                let NEWCITY = String(cString: sqlite3_column_text(stmt5, 12))
                let ANNIVERSARY = String(cString: sqlite3_column_text(stmt5, 13))
                let NEWANNIVERSARY = String(cString: sqlite3_column_text(stmt5, 14))
                let STATUS = String(cString: sqlite3_column_text(stmt5, 15))
                let DATAAREAID = String(cString: sqlite3_column_text(stmt5, 16))
                
                var  stat: NSString?
                print("\n")
                
                
                let parameters: [String: AnyObject] = [
                    "ID":TRNAPPID as AnyObject,
                    "ENTRY_TYPE": ENTRYTYPE as AnyObject,
                    "TRAINER_CODE" : TRAINERCODE as AnyObject,
                    "DATE_APPLIED" : DATEAPPLIED as AnyObject,
                    "STYLIST_CODE" : STYLISTCODE as AnyObject,
                    "DOB" : DOB as AnyObject,
                    "NEW_DOB" : NEWDOB as AnyObject,
                    "SALONCODE" : SALONCODE as AnyObject,
                    "NEW_SALONCODE" : NEWSALONCODE as AnyObject,
                    "ADDRESS" : ADDRESS as AnyObject,
                    "NEW_ADDRESS" : NEWADDRESS as AnyObject,
                    "CITY" : CITY as AnyObject,
                    "NEW_CITY" : NEWCITY as AnyObject,
                    "ANNIVERSARY" : ANNIVERSARY as AnyObject,
                    "NEW_ANNIVERSARY" : NEWANNIVERSARY as AnyObject,
                    "STATUS" : STATUS as AnyObject,
                    "DATAAREAID" : DATAAREAID as AnyObject,
                    
                ]
                
                print("EDIT STYLIST POST=================================================================================================")
                print(self.json(from: parameters)!);
                Alamofire.request(Constants.BASE_URL + Constants.URL_EditStylistDetailS, method: .post, parameters: parameters, encoding: JSONEncoding.default)
                    .responseJSON {
                        response in
                        print("Response =========>>>>\(response.response as Any)")
                        print("Error ============>>>>\(response.error as Any)")
                        print("Data =============>>>>\(response.data as Any)")
                        print("Result =========>>>>>\(response.result)")
                        stat = response.result.description as NSString
                        print("status =========>>>>>\(String(describing: stat!))")
                        switch response.result {
                        case .success :
                             if (response.response?.statusCode == 200){
                            self.updateEditStylistPost(trnappid: TRNAPPID)
                            self.editStylistPostSuccess()
                            self.insertsynclog(tablename: "EditStylistPost", status: "Success", post: "0")
                             }
                             else {
                                self.editStylistPostFailure()
                             }
                            break
                            
                        case .failure(let error):
                         //   self.showtoast(controller: self, message: "Upload Status: \(error)", seconds: 2.0)
                            self.insertsynclog(tablename: "EditStylistPost", status: "Failure", post: "0")
                            self.editStylistPostFailure()
                            break
                        }
                }
            }
            activityIndicator.stopAnimating()
            self.view.isUserInteractionEnabled = true
            print("loader deactivated")
            //  self.postsynclog()
        }
    }
    
    public func editStylistPostSuccess(){}
    public func editStylistPostFailure(){}
     public func editStylistPostError(){}
    
    
    //MARK:- POST SEND OTP
    public func postSendOTPData(MOBILENO : String?)
    {
        
                self.view.isUserInteractionEnabled = false
                print("sending request")
                let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
                activityIndicator.center = CGPoint(x: view.bounds.size.width/2, y: view.bounds.size.height/2)
                activityIndicator.color = UIColor.black
                view.addSubview(activityIndicator)
                activityIndicator.startAnimating()
                print("loader activated")
        
        DispatchQueue.main.async{
            var array : NSString? = ""
            var  stat: NSString? = ""
            print("\n")
            let parameters: [String: AnyObject] = [
                "MOBILENO":MOBILENO as AnyObject,
            ]
            Alamofire.request(Constants.BASE_URL + Constants.URL_POSTSendOTP, method: .post, parameters: parameters, encoding: JSONEncoding.default)
                .responseJSON {
                    response in
                    print("Response =========>>>>\(response.response as Any)")
                    print("Response =========>>>>\(response.result.value as Any)")
                    print("Error ============>>>>\(response.error as Any)")
                    print("Data =============>>>>\(response.data! as Any)")
                    print("Result =========>>>>>\(response.result)")
                    stat = (response.result.description.suffix(28) as NSString)
                    print("status =========>>>>>\(String(describing: stat!))")
                    switch response.result {
                    case .success :
                        if  let json = response.result.value{
                            let listarray : NSArray = json as! NSArray
                            print(listarray)
                            if listarray.count > 0 {
                                for i in 0..<listarray.count{
                                    let response:String =  String (((listarray[i] as  AnyObject).value(forKey:"response") as? String)!)
                                    let status : String = String(response.prefix(19))
                                    let details : String = String(response.suffix(38))
                                    let Details : String = String(details.prefix(36))
                                    if(status.contains("Success")){
                                        UserDefaults.standard.set(Details, forKey: "sessionid")
                                        print(details)
                                        print(status)
                                        self.sendOTPPostSuccess()
                                    }
                                    else {
                                        self.sendOTPPostFailure()
                                    }
                                }}}
                       
                        break
                        
                    case .failure(let error):
                        self.sendOTPPostError()
                        break
                    }
            }
        }
                    activityIndicator.stopAnimating()
                    self.view.isUserInteractionEnabled = true
                    print("loader deactivated")
    }
    
    public func sendOTPPostSuccess(){}
    public func sendOTPPostFailure(){}
    public func sendOTPPostError(){}
    
    //MARK:- POST VERIFY OTP
    public func postVerifyOTPData(SESSIONID : String? , MOBILENO : String? ,OTPVALUE : String? , USERCODE : String?)
    {
                self.view.isUserInteractionEnabled = false
                print("sending request")
                let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
                activityIndicator.center = CGPoint(x: view.bounds.size.width/2, y: view.bounds.size.height/2)
                activityIndicator.color = UIColor.black
                view.addSubview(activityIndicator)
                activityIndicator.startAnimating()
                print("loader activated")
        
        DispatchQueue.main.async{
            var  stat: NSString? = ""
            print("\n")
            let parameters: [String: AnyObject] = [
                "SESSIONID":SESSIONID as AnyObject,
                "OTPVALUE":OTPVALUE as AnyObject,
                "MOBILENO":MOBILENO as AnyObject,
                "user_code":USERCODE as AnyObject,
            ]
            Alamofire.request(Constants.BASE_URL + Constants.URL_POSTVerifyOTP, method: .post, parameters: parameters, encoding: JSONEncoding.default)
                .responseJSON {
                    response in
                    print("Response =========>>>>\(response.response as Any)")
                    print("Error ============>>>>\(response.error as Any)")
                    print("Data =============>>>>\(response.data as Any)")
                    print("Result =========>>>>>\(response.result)")
                    stat = response.result.description as NSString
                    print("status =========>>>>>\(String(describing: stat!))")
                    switch response.result {
                    case .success :
                        if (response.response?.statusCode == 200){
                            if  let json = response.result.value{
                                let listarray : NSArray = json as! NSArray
                                print(listarray)
                                if listarray.count > 0 {
                                    for i in 0..<listarray.count{
                                        let response:String =  String (((listarray[i] as  AnyObject).value(forKey:"response") as? String)!)
                                        let status : String = String(response.prefix(19))
                                   //     let details : String = String(response.suffix(38))
                                   //     let Details : String = String(details.prefix(36))
                                        if(status.contains("Success")){
                                          //  UserDefaults.standard.set(Details, forKey: "sessionid")
                                         //   print(details)
                                            print(status)
                                             self.verifyOTPPostSuccess()
                                        }
                                        else {
                                            self.verifyOTPPostFailure()
                                        }
                                    }}}
                        }
                        else {
                            self.verifyOTPPostFailure()
                        }
                        break
                        
                    case .failure(let error):
                        self.verifyOTPPostError()
                        break
                    }
            }
        }
                    activityIndicator.stopAnimating()
                    self.view.isUserInteractionEnabled = true
                    print("loader deactivated")
//          self.postsynclog()
        
        
    }
    
    public func verifyOTPPostSuccess(){}
    public func verifyOTPPostFailure(){}
    public func verifyOTPPostError(){}

    
    
    func postHotDayData(trainingtype : String!){
        var stmt1:OpaquePointer?
        var id : String? = ""
        //  let PostHotDayMarketVisit = "CREATE TABLE IF NOT EXISTS hotdaymarketvisit(trnappid         text,trainercode text,trainingtype text,salonname text, saloncode text , location text , lat text , long text , trainingdate text , salonaddress text , post text,sitecode text,sellercode text,isedit text)"
        let queryString = "SELECT trnappid,trainingtype,trainercode,sitecode,sellercode,saloncode,lat,long,trainingdate,remark  FROM hotdaymarketvisit WHERE post = '0' and trainingtype = '" + trainingtype! + "' "
        
        if sqlite3_prepare_v2(DatabaseConnection.dbs, queryString, -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(DatabaseConnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return
        }
        
        var body: [AnyObject] = []
        
        DispatchQueue.main.async {
            while(sqlite3_step(stmt1) == SQLITE_ROW){
                id = String(cString: sqlite3_column_text(stmt1, 0))
                let TRNAPPID = String(cString: sqlite3_column_text(stmt1, 0))
                let TRAININGTYPE = String(cString: sqlite3_column_text(stmt1, 1))
                let TRAINERCODE = String(cString: sqlite3_column_text(stmt1, 2))
                let SITECODE = String(cString: sqlite3_column_text(stmt1, 3))
                let SELLERCODE = String(cString: sqlite3_column_text(stmt1, 4))
                let SALONCODE = String(cString: sqlite3_column_text(stmt1, 5))
                let Lat = String(cString: sqlite3_column_text(stmt1, 6)) == "" ? "0" :  String(cString: sqlite3_column_text(stmt1, 6))
                let Long = String(cString: sqlite3_column_text(stmt1, 7)) == "" ? "0" :  String(cString: sqlite3_column_text(stmt1, 7))
                let TRAININGDATE = String(cString: sqlite3_column_text(stmt1, 8))
                let REMARK = String(cString: sqlite3_column_text(stmt1, 9))

                var  status: NSString? = ""
                print("\n")
                
                let parameters: [String: AnyObject] = [
                    "TRNAPPID":TRNAPPID as AnyObject,
                    "TRAININGTYPE":TRAININGTYPE as AnyObject,
                    "TRAINERCODE" : TRAINERCODE as AnyObject,
                    "SITECODE" : SITECODE as AnyObject,
                    "SELLERCODE" :SELLERCODE as AnyObject,
                    "SALONCODE" : SALONCODE as AnyObject,
                    "Lat" : Lat as AnyObject,
                    "Long" : Long as AnyObject,
                    "TRAININGDATE" : TRAININGDATE as AnyObject,
                    "REMARK" : REMARK as AnyObject,
                ]
                print(self.json(from :parameters)!)
                
                body.append(parameters as AnyObject)
            }
            var lines: [String: [AnyObject]] = [:]
            lines = [
                "Line" : body
            ]
            let mbody: [[String: [AnyObject]]] = [
                lines
            ]
            print(self.json(from: mbody)!)
            var url: URL!
            let stringurl:String = Constants.BASE_URL + Constants.URL_POST_HOTDAY
            url = URL(string: stringurl)
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = try! JSONSerialization.data(withJSONObject: mbody, options: [])
            Alamofire.request(request).responseJSON { response in
                print("Response =========>>>>\(response.response as Any)")
                print("Error ============>>>>\(response.error as Any)")
                print("Data =============>>>>\(response.data as Any)")
                print("Result =========>>>>>\(response.result)")
                print("\nresponse.result.value \(response.result.value!) \n\n")
                print("StatusCode ============>>>>\(response.response?.statusCode as Any)")
                
                switch (response.result) {
                case .success:
                    if (response.response?.statusCode == 200){
                        self.updatehotdaymarketvisit(trnappid: id)
                        self.insertsynclog(tablename: "hotdaymarketvisit", status: "success", post: "0")
                        self.hotDayPostSuccess()
                    }
                    else {
                        self.hotDayPostError()
                    }
                    break
                case .failure:
                    self.insertsynclog(tablename: "hotdaymarketvisit", status: "Failure", post: "0")
                    self.hotDayPostFailure()
                    break
                }
            }
            //  self.postsynclog()
        }
    }
    
    public func hotDayPostSuccess(){}
    public func hotDayPostError(){}
    public func hotDayPostFailure(){}
    
    //let PostAddLeave = "CREATE TABLE IF NOT EXISTS addleave(trnappid text,trainingtype text,trainercode text,lat text,long text,trainingdate text,post text)"
    
    //MARK:- POST ADD LEAVE
    public func postAddLeaveData()
    {
        //        self.view.isUserInteractionEnabled = false
        //        print("sending request")
        //        let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
        //        activityIndicator.center = CGPoint(x: view.bounds.size.width/2, y: view.bounds.size.height/2)
        //        activityIndicator.color = UIColor.black
        //        view.addSubview(activityIndicator)
        //        activityIndicator.startAnimating()
        //        print("loader activated")
        
        DispatchQueue.main.async{
            var stmt5:OpaquePointer?
            let queryString = "SELECT * FROM addleave WHERE post = '0'"
            if sqlite3_prepare_v2(DatabaseConnection.dbs, queryString, -1, &stmt5, nil) != SQLITE_OK{
                let errmsg = String(cString: sqlite3_errmsg(DatabaseConnection.dbs)!)
                print("error preparing get: \(errmsg)")
                return
            }
            
            while(sqlite3_step(stmt5) == SQLITE_ROW){
                let TRNAPPID =  String(cString: sqlite3_column_text(stmt5, 0))
                let TRAININGTYPE = String(cString: sqlite3_column_text(stmt5, 1))
                let TRAINERCODE = String(cString: sqlite3_column_text(stmt5, 2))
                let LAT = String(cString: sqlite3_column_text(stmt5, 3)) == "" ? "0" :  String(cString: sqlite3_column_text(stmt5, 3))
                let LONG = String(cString: sqlite3_column_text(stmt5, 4)) == "" ? "0" :  String(cString: sqlite3_column_text(stmt5, 4))
                let TRAININGDATE = String(cString: sqlite3_column_text(stmt5, 5))
                
                var  stat: NSString?
                print("\n")
                
                
                let parameters: [String: AnyObject] = [
                    "TRNAPPID":TRNAPPID as AnyObject,
                    "TRAININGTYPE": TRAININGTYPE as AnyObject,
                    "TRAINERCODE" : TRAINERCODE as AnyObject,
                    "Lat" : LAT as AnyObject,
                    "Long" : LONG as AnyObject,
                    "TRAININGDATE" : TRAININGDATE as AnyObject,
                ]
                print("LEAVE REQUEST=================================================================================================")
                print(self.json(from: parameters)!);
                
                Alamofire.request(Constants.BASE_URL + Constants.URL_POST_ADD_LEAVE, method: .post, parameters: parameters, encoding: JSONEncoding.default)
                    .responseJSON {
                        response in
                        print("Response =========>>>>\(response.response as Any)")
                        print("Error ============>>>>\(response.error as Any)")
                        print("Data =============>>>>\(response.data as Any)")
                        print("Result =========>>>>>\(response.result)")
                        stat = response.result.description as NSString
                        print("status =========>>>>>\(String(describing: stat!))")
                        switch response.result {
                        case .success :
                            if (response.response?.statusCode == 200){
                            self.updateaddleavePost(trnappid: TRNAPPID)
                            self.addLeavePostSuccess()
                            self.insertsynclog(tablename: "addleave", status: "Success", post: "0")
                            }
                            else {
                                self.addLeaveError()
                            }
                            break
                            
                        case .failure(let error):
                            self.showtoast(controller: self, message: "Upload Status: \(error)", seconds: 2.0)
                            self.insertsynclog(tablename: "addleave", status: "Failure", post: "0")
                            self.addLeaveFailure()
                            break
                        }
                }
            }
            //            activityIndicator.stopAnimating()
            //            self.view.isUserInteractionEnabled = true
            //            print("loader deactivated")
            //  self.postsynclog()
        }
    }
    
    public func addLeavePostSuccess(){}
    public func addLeaveFailure(){}
    public func addLeaveError(){}
    
    //MARK:- POST Internal Training
    public func postInternalTrainingData()
    {
        //        self.view.isUserInteractionEnabled = false
        //        print("sending request")
        //        let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
        //        activityIndicator.center = CGPoint(x: view.bounds.size.width/2, y: view.bounds.size.height/2)
        //        activityIndicator.color = UIColor.black
        //        view.addSubview(activityIndicator)
        //        activityIndicator.startAnimating()
        //        print("loader activated")
        //        let PostInternalOtherTraining = "CREATE TABLE IF NOT EXISTS internalotherpost(trnappid text,trainingtype text,trainercode text,lat text,long text,trainingdate text,remark text ,post text)"
        
        DispatchQueue.main.async{
            var stmt5:OpaquePointer?
            let queryString = "SELECT * FROM internalotherpost WHERE post = '0'"
            if sqlite3_prepare_v2(DatabaseConnection.dbs, queryString, -1, &stmt5, nil) != SQLITE_OK{
                let errmsg = String(cString: sqlite3_errmsg(DatabaseConnection.dbs)!)
                print("error preparing get: \(errmsg)")
                return
            }
            
            while(sqlite3_step(stmt5) == SQLITE_ROW){
                let TRNAPPID =  String(cString: sqlite3_column_text(stmt5, 0))
                let TRAININGTYPE = String(cString: sqlite3_column_text(stmt5, 1))
                let TRAINERCODE = String(cString: sqlite3_column_text(stmt5, 2))
                let LAT = String(cString: sqlite3_column_text(stmt5, 3)) == "" ? "0" :  String(cString: sqlite3_column_text(stmt5, 3))
                let LONG = String(cString: sqlite3_column_text(stmt5, 4)) == "" ? "0" :  String(cString: sqlite3_column_text(stmt5, 4))
                let TRAININGDATE = String(cString: sqlite3_column_text(stmt5, 5))
                let REMARK = String(cString: sqlite3_column_text(stmt5, 6))
                
                
                var  stat: NSString?
                print("\n")
                
                
                let parameters: [String: AnyObject] = [
                    "TRNAPPID":TRNAPPID as AnyObject,
                    "TRAININGTYPE": TRAININGTYPE as AnyObject,
                    "TRAINERCODE" : TRAINERCODE as AnyObject,
                    "Lat" : LAT as AnyObject,
                    "Long" : LONG as AnyObject,
                    "TRAININGDATE" : TRAININGDATE as AnyObject,
                    "REMARK" : REMARK as AnyObject,
                    
                ]
                print("INTERNAL  REQUEST=================================================================================================")
                print(self.json(from: parameters)!);
                
                Alamofire.request(Constants.BASE_URL + Constants.URL_POST_INTERNAL_TRAINING, method: .post, parameters: parameters, encoding: JSONEncoding.default)
                    .responseJSON {
                        response in
                        print("Response =========>>>>\(response.response as Any)")
                        print("Error ============>>>>\(response.error as Any)")
                        print("Data =============>>>>\(response.data as Any)")
                        print("Result =========>>>>>\(response.result)")
                        stat = response.result.description as NSString
                        print("status =========>>>>>\(String(describing: stat!))")
                        switch response.result {
                        case .success :
                            if (response.response?.statusCode == 200){
                            self.updateinternalotherpostPost(trnappid: TRNAPPID)
                            self.internalTrainingPostSuccess()
                            self.insertsynclog(tablename: "internalotherpost", status: "Success", post: "0")
                            }
                            else {
                                 self.internalTrainingPostFailure()
                            }
                            break
                            
                        case .failure(let error):
                            self.showtoast(controller: self, message: "Upload Status: \(error)", seconds: 2.0)
                            self.insertsynclog(tablename: "internalotherpost", status: "Failure", post: "0")
                            self.internalTrainingPostFailure()
                            break
                        }
                }
            }
            //            activityIndicator.stopAnimating()
            //            self.view.isUserInteractionEnabled = true
            //            print("loader deactivated")
            //  self.postsynclog()
        }
    }
    
    public func internalTrainingPostSuccess(){}
    public func internalTrainingPostFailure(){}
    
    //MARK:- POST OTHER Training
    public func postOtherData()
    {
        //        self.view.isUserInteractionEnabled = false
        //        print("sending request")
        //        let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
        //        activityIndicator.center = CGPoint(x: view.bounds.size.width/2, y: view.bounds.size.height/2)
        //        activityIndicator.color = UIColor.black
        //        view.addSubview(activityIndicator)
        //        activityIndicator.startAnimating()
        //        print("loader activated")
        //        let PostInternalOtherTraining = "CREATE TABLE IF NOT EXISTS internalotherpost(trnappid text,trainingtype text,trainercode text,lat text,long text,trainingdate text,remark text ,post text)"
        
        DispatchQueue.main.async{
            var stmt5:OpaquePointer?
            let queryString = "SELECT * FROM internalotherpost WHERE post = '0'"
            if sqlite3_prepare_v2(DatabaseConnection.dbs, queryString, -1, &stmt5, nil) != SQLITE_OK{
                let errmsg = String(cString: sqlite3_errmsg(DatabaseConnection.dbs)!)
                print("error preparing get: \(errmsg)")
                return
            }
            
            while(sqlite3_step(stmt5) == SQLITE_ROW){
                let TRNAPPID =  String(cString: sqlite3_column_text(stmt5, 0))
                let TRAININGTYPE = String(cString: sqlite3_column_text(stmt5, 1))
                let TRAINERCODE = String(cString: sqlite3_column_text(stmt5, 2))
                let LAT = String(cString: sqlite3_column_text(stmt5, 3)) == "" ? "0" :  String(cString: sqlite3_column_text(stmt5, 3))
                let LONG = String(cString: sqlite3_column_text(stmt5, 4)) == "" ? "0" :  String(cString: sqlite3_column_text(stmt5, 4))
                let TRAININGDATE = String(cString: sqlite3_column_text(stmt5, 5))
                let REMARK = String(cString: sqlite3_column_text(stmt5, 6))
                
                
                var  stat: NSString?
                print("\n")
                
                
                let parameters: [String: AnyObject] = [
                    "TRNAPPID":TRNAPPID as AnyObject,
                    "TRAININGTYPE": TRAININGTYPE as AnyObject,
                    "TRAINERCODE" : TRAINERCODE as AnyObject,
                    "Lat" : LAT as AnyObject,
                    "Long" : LONG as AnyObject,
                    "TRAININGDATE" : TRAININGDATE as AnyObject,
                    "REMARK" : REMARK as AnyObject,
                    
                ]
                print("OTHER  REQUEST=================================================================================================")
                print(self.json(from: parameters)!);
                
                Alamofire.request(Constants.BASE_URL + Constants.URL_POST_OTHER_TRAINING, method: .post, parameters: parameters, encoding: JSONEncoding.default)
                    .responseJSON {
                        response in
                        print("Response =========>>>>\(response.response as Any)")
                        print("Error ============>>>>\(response.error as Any)")
                        print("Data =============>>>>\(response.data as Any)")
                        print("Result =========>>>>>\(response.result)")
                        stat = response.result.description as NSString
                        print("status =========>>>>>\(String(describing: stat!))")
                        switch response.result {
                        case .success :
                            if (response.response?.statusCode == 200){
                                self.updateinternalotherpostPost(trnappid: TRNAPPID)
                                self.otherPostSuccess()
                                self.insertsynclog(tablename: "internalotherpost", status: "Success", post: "0")
                            }
                            else {
                                self.otherPostFailure()
                            }
                            break
                            
                        case .failure(let error):
                            self.showtoast(controller: self, message: "Upload Status: \(error)", seconds: 2.0)
                            self.insertsynclog(tablename: "internalotherpost", status: "Failure", post: "0")
                            self.otherPostFailure()
                            break
                        }
                }
            }
            //            activityIndicator.stopAnimating()
            //            self.view.isUserInteractionEnabled = true
            //            print("loader deactivated")
            //  self.postsynclog()
        }
    }
    
    public func otherPostSuccess(){}
    public func otherPostFailure(){}
    
    func executeStylistData(){
        Alamofire.request(Constants.BASE_URL + Constants.URL_GETSTYLISTDATA).validate().responseJSON {
            response in
            switch response.result {
            case .success(let value): print("success======> \(value)")
            if  let json = response.result.value{
                let listarray : NSArray = json as! NSArray
                if listarray.count > 0 {
                    self.deletStylistData()
                    for i in 0..<listarray.count{
                        let stylistname = String(((listarray[i] as AnyObject).value(forKey:"stylistname") as? String)!).replacingOccurrences(of: "'", with: "")
                        let stylistcode = String(((listarray[i] as AnyObject).value(forKey:"stylistcode") as? String)!)
                        let contact = String(((listarray[i] as AnyObject).value(forKey:"contact") as? String)!)
                        let saloncode = String(((listarray[i] as AnyObject).value(forKey:"saloncode") as? String)!)
                        let salonname = String(((listarray[i] as AnyObject).value(forKey:"salonname") as? String)!).replacingOccurrences(of: "'", with: "")
                        
                        print("insert============stylistname: \(String(describing: stylistname))")
                        print("insert============stylistcode:\(String(describing: stylistcode))")
                        print("insert============contact: \(String(describing: contact))")
                        print("insert============saloncode:\(String(describing: saloncode))")
                        print("insert============salonname:\(String(describing: salonname))")
                        
                        self.insertStylistData(stylistname: stylistname, stylistcode: stylistcode, contact: contact, salonname: salonname, saloncode: saloncode)
                    }
                    self.stylistGetSuccess()
                }
                else {
                    self.stylistGetSuccess()
//                    self.showtoast(controller: self, message: "Data not available...", seconds: 1.5)
                }
            }
            
                break
                
            case .failure(let error): print("error======> \(error)")
            self.stylistGetFailure()

                break
            }
        }
    }
    
    public func stylistGetSuccess(){}
    public func stylistGetFailure(){}

    
    //===========================================================================================
    //MARK:- POSTSALONHEADERLINE
    
    func POSTSALONHEADERLINE()
    {
        
        var requestBody : [String: AnyObject] = [:]
        var parameter: [String: AnyObject] = [:]
        var array: [Any] = []
        
        self.checknet()
        if AppDelegate.ntwrk > 0 {
//                         let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
//                         activityIndicator.center = CGPoint(x: view.bounds.size.width/2, y: view.bounds.size.height/2)
//                         activityIndicator.color = UIColor.black
//                         view.addSubview(activityIndicator)
//                         view.isUserInteractionEnabled = false
//                         if(AppDelegate.isDebug){
//                         print("loader activated")
//                         }
            var stmt1:OpaquePointer?
            let queryString = "SELECT * FROM SalonWorkshopHeadar WHERE Post = '1' AND TRAININGTYPE = 'InSalon'"
            if sqlite3_prepare_v2(DatabaseConnection.dbs, queryString, -1, &stmt1, nil) != SQLITE_OK{
                let errmsg = String(cString: sqlite3_errmsg(DatabaseConnection.dbs)!)
                if(AppDelegate.isDebug){
                    print("error preparing get: \(errmsg)")
                }
                return
            }
            
            while(sqlite3_step(stmt1) == SQLITE_ROW){
                var url: URL!
                
                let stringurl:String = Constants.BASE_URL + Constants.URL_POST_TRAINING_INSALON
                url = URL(string: stringurl)
                
                var request = URLRequest(url: url)
                request.httpMethod = "POST"
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                
//                parameters = [
//                    "Header" : UserDefaults.standard.string(forKey: "did")! as AnyObject
//                ]
                
                //parameter array
                let TRNAPPID : String =  String(cString: sqlite3_column_text(stmt1, 0))
                
                array.removeAll()
                array.append(self.getSecondaryJsonHeader(sono: String(TRNAPPID)) as Any)
                array.append(self.getSecondaryJsonLine(sono: String(TRNAPPID)) as Any)
                
                let body: [[String: [AnyObject]]] = [
                    self.getSecondaryJsonHeader(sono: String(TRNAPPID)) ,
                    self.getSecondaryJsonLine(sono: String(TRNAPPID))
                ]
                if(AppDelegate.isDebug){
                    print("hello =====")
                    print(json(from: body))
                    print("\n")
                }
                var  stat: NSString?
                print("\n")
                request.httpBody = try! JSONSerialization.data(withJSONObject: array, options: [])
                if(AppDelegate.isDebug){
                    print(body)
                }
                var a = self.json(from: body)
                
                if(AppDelegate.isDebug){
                    print("postSecondaryOrder ====> \(a!)")
                }
                DispatchQueue.main.async {
                    Alamofire.request(request).validate().responseJSON {
                        response in
                        print("Response =========>>>>\(response.response as Any)")
                        print("Error ============>>>>\(response.error as Any)")
                        print("Data =============>>>>\(response.data as Any)")
                        print("Result =========>>>>>\(response.result)")
                        stat = response.result.description as NSString
                        print("status =========>>>>>\(String(describing: stat!))")
                        switch response.result {
                        case .success :
                            if (response.response?.statusCode == 200){
                                self.updateSalonWorkshopHeadarPost(trnappid: TRNAPPID)
                                self.updateInSalonDetailPost(trnappid: TRNAPPID)
                                self.SalonPostSuccess()
                                self.insertsynclog(tablename: "SalonWorkshopHeadar", status: "Success", post: "0")
                            }
                            else {
                                self.SalonPostError()
                            }
                            break
                        case .failure(let error):
                            self.insertsynclog(tablename: "SalonWorkshopHeadar", status: "Failure", post: "0")
                            self.SalonPostFailure()
                            break
                        }
                    }
                }
            }
        }
        else {
            self.showtoast(controller: self, message: "Please check your Internet connection", seconds: 2.0)
        }
    }
    
    func getSecondaryJsonHeader(sono: String?) -> [String: [AnyObject]]  {
        var stmt1:OpaquePointer?
        let queryString = "select  TRNAPPID, TRAININGTYPE , TRAININGCODE , TRAINERCODE , SITECODE , SELLERCODE , Lat, Long,TRAININGDATE,REMARK , ENDDATE , SALONCODE from SalonWorkshopHeadar where Post = 1  and TRNAPPID= '\(sono!)'"
        if sqlite3_prepare_v2(DatabaseConnection.dbs, queryString, -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(DatabaseConnection.dbs)!)
            print("error preparing get: \(errmsg)")
        }
        var indentHeaderb: [String: AnyObject] = [:]
        while(sqlite3_step(stmt1) == SQLITE_ROW){
             let LAT = String(cString: sqlite3_column_text(stmt1, 6)) == "" ? "0" : String(cString: sqlite3_column_text(stmt1, 6))
             let LONG = String(cString: sqlite3_column_text(stmt1, 7)) == "" ? "0" : String(cString: sqlite3_column_text(stmt1, 7))
            indentHeaderb = [
                
                "TRNAPPID" : String(cString: sqlite3_column_text(stmt1, 0)) as AnyObject,
                "TRAININGTYPE" : String(cString: sqlite3_column_text(stmt1, 1)) as AnyObject,
                "TRAININGCODE" : String(cString: sqlite3_column_text(stmt1, 2)) as AnyObject,
                "TRAINERCODE" : String(cString: sqlite3_column_text(stmt1, 3)) as AnyObject,
                "SITECODE" : String(cString: sqlite3_column_text(stmt1, 4)) as AnyObject,
                "SELLERCODE" : String(cString: sqlite3_column_text(stmt1, 5)) as AnyObject,
                "Lat" : LAT as AnyObject,
                "Long" : LONG as AnyObject,
                "TRAININGDATE" : String(cString: sqlite3_column_text(stmt1, 8)) as AnyObject,
                "REMARK" : String(cString: sqlite3_column_text(stmt1, 9)) as AnyObject,
                "ENDDATE" : String(cString: sqlite3_column_text(stmt1, 10)) as AnyObject,
                "SALONCODE" : String(cString: sqlite3_column_text(stmt1, 11)) as AnyObject,
            ]
        }
        var body: [AnyObject] = []
        body.append(indentHeaderb as AnyObject)
        let indent = [
            "Header" : body
        ]
        print(indent as AnyObject)
        let indentHeader: [String: [AnyObject]] = ["Header": body]
        var data = NSArray(object: indentHeader)
        print("data==============================================================")
        print(data)
        print("indentHeader======================================================")
        print(indentHeader)
        return indentHeader
    }
    
    func getSecondaryJsonLine(sono: String?) -> [String: [AnyObject]] {
        var indentLine: [String: [AnyObject]] = [:]
        var stmt1: OpaquePointer?
        let query = "select TRNAPPID ,trainingdate,STYLISTCODE ,stylistname,stylistmobileno ,salonecodes,salonremark  from InSalonDetail WHERE post = '1' and TRNAPPID= '\(sono!)'"
        
        if sqlite3_prepare_v2(DatabaseConnection.dbs, query, -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(DatabaseConnection.dbs)!)
            print("error preparing get: \(errmsg)")
        }
        
        var count:Int! = 1
        var body: [AnyObject] = []
        
        while(sqlite3_step(stmt1) == SQLITE_ROW){
            var line: [String: AnyObject] = [:]
            
            line = [
                "TRNAPPID" : String(cString: sqlite3_column_text(stmt1, 0)) as AnyObject,
                "TRAININGDATE" : String(cString: sqlite3_column_text(stmt1, 1)) as AnyObject,
                "STYLISTCODE" : String(cString: sqlite3_column_text(stmt1, 2)) as AnyObject,
                "STYLISTNAME" : String(cString: sqlite3_column_text(stmt1, 3)) as AnyObject,
                "STYLISTMOBILENO" : String(cString: sqlite3_column_text(stmt1, 4)) as AnyObject,
                "SALONCODE" : String(cString: sqlite3_column_text(stmt1, 5)) as AnyObject,
                "SALONREMARK" : String(cString: sqlite3_column_text(stmt1, 6)) as AnyObject,
            ]
            count = count + 1
            body.append(line as AnyObject)
        }
        
        indentLine = [
            "Line" : body
        ]
        return indentLine
    }
    public func SalonPostSuccess(){}
    public func SalonPostFailure(){}
    public func SalonPostError(){}
    
    
    fileprivate func getCountOfHeaderVirtual()->Int{
        var count : Int! = 0
        var stmt1:OpaquePointer?
        let queryString = "SELECT * FROM SalonWorkshopHeadar WHERE Post = '1' AND TRAININGTYPE = 'Virtual Training'"
        if sqlite3_prepare_v2(DatabaseConnection.dbs, queryString, -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(DatabaseConnection.dbs)!)
            if(AppDelegate.isDebug){
                print("error preparing get: \(errmsg)")
            }
          
        }
        
        while(sqlite3_step(stmt1) == SQLITE_ROW){
            count = count + 1
        }
        return count
    }
    
    //MARK:- POSTVIRTUALHEADERLINE
    
    func POSTVIRTUALHEADERLINE()
    {
        var countHeader: Int! = 0
        var countHeaderPost : Int! = 0
        var requestBody : [String: AnyObject] = [:]
        var parameter: [String: AnyObject] = [:]
        var array: [Any] = []
        self.checknet()
        countHeader = self.getCountOfHeaderVirtual()
        
        if AppDelegate.ntwrk > 0 {
            //             let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
            //             activityIndicator.center = CGPoint(x: view.bounds.size.width/2, y: view.bounds.size.height/2)
            //             activityIndicator.color = UIColor.black
            //             view.addSubview(activityIndicator)
            //             view.isUserInteractionEnabled = false
            //             if(AppDelegate.isDebug){
            //             print("loader activated")
            //             }
            var stmt1:OpaquePointer?
            let queryString = "SELECT * FROM SalonWorkshopHeadar WHERE Post = '1' AND TRAININGTYPE = 'Virtual Training'"
            if sqlite3_prepare_v2(DatabaseConnection.dbs, queryString, -1, &stmt1, nil) != SQLITE_OK{
                let errmsg = String(cString: sqlite3_errmsg(DatabaseConnection.dbs)!)
                if(AppDelegate.isDebug){
                    print("error preparing get: \(errmsg)")
                }
                return
            }
            
            while(sqlite3_step(stmt1) == SQLITE_ROW){
                var url: URL!
                
                let stringurl:String = Constants.BASE_URL + Constants.URL_POST_TRAINING_INSALON
                url = URL(string: stringurl)
                
                var request = URLRequest(url: url)
                request.httpMethod = "POST"
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                 let TRNAPPID : String =  String(cString: sqlite3_column_text(stmt1, 0))
                array.removeAll()
                array.append(self.getVirtualJsonHeader(sono: String(TRNAPPID)) as Any)
                array.append(self.getVirtualJsonLine(sono: String(TRNAPPID)) as Any)
                if(AppDelegate.isDebug){
                print("ACTUAL ARRAY==================================================")
                print(array)
                }
                //parameter array
                
                let body: [[String: [AnyObject]]] = [
                    self.getVirtualJsonHeader(sono: String(TRNAPPID)) ,
                    self.getVirtualJsonLine(sono: String(TRNAPPID))
                ]
                if(AppDelegate.isDebug){
                    print("hello =====")
                    print(json(from: body))
                    print("\n")
                }
                var  stat: NSString?
                print("\n")
                request.httpBody = try! JSONSerialization.data(withJSONObject: body, options: [])
                if(AppDelegate.isDebug){
                    print(body)
                }
                var a = self.json(from: body)
                if(AppDelegate.isDebug){
                    print("postSecondaryOrder ====> \(a!)")
                }
                DispatchQueue.main.async {
                    Alamofire.request(request).validate().responseJSON {
                        response in
                        if(AppDelegate.isDebug){
                        print("Response =========>>>>\(response.response as Any)")
                        print("Error ============>>>>\(response.error as Any)")
                        print("Data =============>>>>\(response.data as Any)")
                        print("Result =========>>>>>\(response.result)")
                        }
                        stat = response.result.description as NSString
                        print("status =========>>>>>\(String(describing: stat!))")
                        
                        switch response.result {
                        case .success :
                            if (response.response?.statusCode == 200){
                                countHeaderPost = countHeaderPost + 1
                                self.updateSalonWorkshopHeadarPost(trnappid: TRNAPPID)
                                self.updateVirtualTrainingPost(trnappid: TRNAPPID)
                                self.VirtualPostSuccess()
                                self.insertsynclog(tablename: "SalonWorkshopHeadar", status: "Success", post: "0")
                            }
                            else {
                                self.VirtualPostError()
                            }
                            break
                        case .failure(let error):
                            self.insertsynclog(tablename: "SalonWorkshopHeadar", status: "Failure", post: "0")
                            self.VirtualPostFailure()
                            break
                        }
                    }
//                    if(!(countHeader == countHeaderPost) && (AppDelegate.isRetryDone == "0") ){
//                        self.POSTVIRTUALHEADERLINE()
//                    }
                }
            }
        }
        else {
            self.showtoast(controller: self, message: "Please check your Internet connection", seconds: 2.0)
        }
    }
    
    func getVirtualJsonHeader(sono: String?) -> [String: [AnyObject]] {
        var stmt1:OpaquePointer?
        
        let queryString = "select  TRNAPPID, TRAININGTYPE , TRAININGCODE , TRAINERCODE , SITECODE , SELLERCODE , Lat, Long,TRAININGDATE,REMARK, SALONCODE from SalonWorkshopHeadar where Post = 1  and TRNAPPID= '\(sono!)'"
        
        if sqlite3_prepare_v2(DatabaseConnection.dbs, queryString, -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(DatabaseConnection.dbs)!)
            print("error preparing get: \(errmsg)")
            
        }
        var indentHeaderb: [String: AnyObject] = [:]
        while(sqlite3_step(stmt1) == SQLITE_ROW){
            let LAT = String(cString: sqlite3_column_text(stmt1, 6)) == "" ? "0" : String(cString: sqlite3_column_text(stmt1, 6))
            let LONG = String(cString: sqlite3_column_text(stmt1, 7)) == "" ? "0" : String(cString: sqlite3_column_text(stmt1, 7))
            
            indentHeaderb = [
                "TRNAPPID" : String(cString: sqlite3_column_text(stmt1, 0)) as AnyObject,
                "TRAININGTYPE" : String(cString: sqlite3_column_text(stmt1, 1)) as AnyObject,
                "TRAININGCODE" : String(cString: sqlite3_column_text(stmt1, 2)) as AnyObject,
                "TRAINERCODE" : String(cString: sqlite3_column_text(stmt1, 3)) as AnyObject,
                "SITECODE" : String(cString: sqlite3_column_text(stmt1, 4)) as AnyObject,
                "SELLERCODE" : String(cString: sqlite3_column_text(stmt1, 5)) as AnyObject,
                "Lat" : LAT as AnyObject,
                "Long" : LONG as AnyObject,
//                "Lat" : "0.0" as AnyObject,
//                "Long" : "0.0" as AnyObject,
                "TRAININGDATE" : String(cString: sqlite3_column_text(stmt1, 8)) as AnyObject,
                "REMARK" : String(cString: sqlite3_column_text(stmt1, 9)) as AnyObject,
                "SALONCODE" : String(cString: sqlite3_column_text(stmt1, 10)) as AnyObject,
                //  "SALONCODE" : "" as AnyObject,
            ]
        }
        var body: [AnyObject] = []
        body.append(indentHeaderb as AnyObject)
        let indentHeader: [String: [AnyObject]] = ["Header": body ]
        if(AppDelegate.isDebug){
        print("VirtualHeader===========================")
        print(indentHeader)
        }
        return indentHeader
    }
    
    //         let query = "INSERT INTO VirtualTrainingUpdate (TRNAPPID,TRAININGDATE,STYLISTCODE,STYLISTNAME,STYLISTMOBILENO,SALONCODE,SALONREMARK,TRAININGSUBJECT,isEdit,colorcode,post) VALUES
    func getVirtualJsonLine(sono: String?) -> [String: [AnyObject]] {
        var indentLine: [String: [AnyObject]] = [:]
        var stmt1: OpaquePointer?
        let query = "select TRNAPPID ,TRAININGDATE,STYLISTCODE ,STYLISTNAME,STYLISTMOBILENO ,SALONCODE,SALONREMARK  from VirtualTrainingUpdate WHERE post = '1' and TRNAPPID= '\(sono!)'"
        
        if sqlite3_prepare_v2(DatabaseConnection.dbs, query, -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(DatabaseConnection.dbs)!)
            print("error preparing get: \(errmsg)")
            
        }
        var count:Int! = 1
        var body: [AnyObject] = []
        
        while(sqlite3_step(stmt1) == SQLITE_ROW){
            var line: [String: AnyObject] = [:]
            
            line = [
                "TRNAPPID" : String(cString: sqlite3_column_text(stmt1, 0)) as AnyObject,
                "TRAININGDATE" : String(cString: sqlite3_column_text(stmt1, 1)) as AnyObject,
                "STYLISTCODE" : String(cString: sqlite3_column_text(stmt1, 2)) as AnyObject,
                "STYLISTNAME" : String(cString: sqlite3_column_text(stmt1, 3)) as AnyObject,
                "STYLISTMOBILENO" : String(cString: sqlite3_column_text(stmt1, 4)) as AnyObject,
                "SALONCODE" : String(cString: sqlite3_column_text(stmt1, 5)) as AnyObject,
                "SALONREMARK" : String(cString: sqlite3_column_text(stmt1, 6)) as AnyObject,
            ]
            count = count + 1
            body.append(line as AnyObject)
        }
        
        indentLine = [
            "Line" : body
        ]
        if(AppDelegate.isDebug){
        print("VirtualLine=============")
        print(indentLine)
        }
        return indentLine
    }
    public func VirtualPostSuccess(){}
    public func VirtualPostFailure(){}
    public func VirtualPostError(){}
    
    
    
    
    //MARK:- POSTWORKSHOPHEADERLINE
    
    func POSTWORKSHOPHEADERLINE()
    {
        var requestBody : [String: AnyObject] = [:]
        var parameter: [String: AnyObject] = [:]
        var array: [Any] = []
        self.checknet()
        if AppDelegate.ntwrk > 0 {
            //             let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
            //             activityIndicator.center = CGPoint(x: view.bounds.size.width/2, y: view.bounds.size.height/2)
            //             activityIndicator.color = UIColor.black
            //             view.addSubview(activityIndicator)
            //             view.isUserInteractionEnabled = false
            //             if(AppDelegate.isDebug){
            //             print("loader activated")
            //             }
            var stmt1:OpaquePointer?
            let queryString = "SELECT * FROM WorkshopHeaderUpdated WHERE Post = '1' AND TRAININGTYPE = 'WorkShop'"
            if sqlite3_prepare_v2(DatabaseConnection.dbs, queryString, -1, &stmt1, nil) != SQLITE_OK{
                let errmsg = String(cString: sqlite3_errmsg(DatabaseConnection.dbs)!)
                if(AppDelegate.isDebug){
                    print("error preparing get: \(errmsg)")
                }
                return
            }
            
            while(sqlite3_step(stmt1) == SQLITE_ROW){
                var url: URL!
                
                let stringurl:String =  Constants.BASE_URL + Constants.URL_POST_TRAINING_WORKSHOP
                url = URL(string: stringurl)
                print("URL====================================================")
                print(stringurl)
                
                var request = URLRequest(url: url)
                request.httpMethod = "POST"
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                
                //parameter array
                let TRNAPPID : String =  String(cString: sqlite3_column_text(stmt1, 0))
                
                array.removeAll()
                array.append(self.getWorkshopJsonHeader(sono: String(TRNAPPID)) as Any)
                array.append(self.getWorkshopJsonLine(sono: String(TRNAPPID)) as Any)
                print("ACTUAL ARRAY==================================================")
                print(array)
                
                
                let body: [[String: [AnyObject]]] = [
                    self.getWorkshopJsonHeader(sono: String(TRNAPPID)) ,
                    self.getWorkshopJsonLine(sono: String(TRNAPPID))
                ]
                
                if(AppDelegate.isDebug){
                    print("hello =====")
                    print(json(from: body)!)
                    print("\n")
                    print("ARRAY======================================================")
                    print(json(from: array)!)
                }
                var  stat: NSString?
                print("\n")
                request.httpBody = try! JSONSerialization.data(withJSONObject: array, options: [])
                if(AppDelegate.isDebug){
                    print(body)
                }
                var a = self.json(from: body)
                if(AppDelegate.isDebug){
                    print("postSecondaryOrder ====> \(a!)")
                }
                DispatchQueue.main.async {
                    Alamofire.request(request).validate().responseJSON {
                        response in
                        print("Response =========>>>>\(response.response as Any)")
                        print("Error ============>>>>\(response.error as Any)")
                        print("Data =============>>>>\(response.data as Any)")
                        print("Result =========>>>>>\(response.result)")
                        stat = response.result.description as NSString
                        print("status =========>>>>>\(String(describing: stat!))")
                        switch response.result {
                        case .success :
                            if (response.response?.statusCode == 200){
                                self.updateInsertWorkshopPost(trnappid: TRNAPPID)
                                self.updateWorkshopHeaderUpdatedPost(trnappid: TRNAPPID)
                                self.WorkshopPostSuccess()
                                self.insertsynclog(tablename: "WorkshopHeaderUpdated", status: "Success", post: "0")
                            }
                            else {
                                self.WorkshopPostError()
                            }
                            break
                        case .failure(let error):
                            self.insertsynclog(tablename: "WorkshopHeaderUpdated", status: "Failure", post: "0")
                            self.WorkshopPostFailure()
                            break
                        }
                    }
                }
            }
        }
        else {
            self.showtoast(controller: self, message: "Please check your Internet connection", seconds: 2.0)
        }
    }
    
    func getWorkshopJsonHeader(sono: String?) -> [String: [AnyObject]] {
        var stmt1:OpaquePointer?
        //let POSTWorkshopHeaderUpdatedtable = "CREATE TABLE IF NOT EXISTS WorkshopHeaderUpdated (TRNAPPID text,TRAININGTYPE text,TRAININGCODE text,TRAINERCODE text, SITECODE text , SELLERCODE text , Lat text , Long text , TRAININGDATE text , REMARK text,Post text,WORKSHOPDAY2DATE text,WORKSHOPDAY3DATE text,ISMULTIDAYWORKSHOP text,isEdit text,LOCATION text)"
        
        
        let queryString = "select  TRNAPPID, TRAININGTYPE , TRAININGCODE , TRAINERCODE , SITECODE , SELLERCODE , Lat, Long,TRAININGDATE,REMARK, WORKSHOPDAY2DATE,WORKSHOPDAY3DATE,ISMULTIDAYWORKSHOP,LOCATION from WorkshopHeaderUpdated where Post = 1  and TRNAPPID= '\(sono!)'"
        
        if sqlite3_prepare_v2(DatabaseConnection.dbs, queryString, -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(DatabaseConnection.dbs)!)
            print("error preparing get: \(errmsg)")
            
        }
        var indentHeaderb: [String: AnyObject] = [:]
        while(sqlite3_step(stmt1) == SQLITE_ROW){
            let LAT = String(cString: sqlite3_column_text(stmt1, 6)) == "" ? "0" : String(cString: sqlite3_column_text(stmt1, 6))
            let LONG = String(cString: sqlite3_column_text(stmt1, 7)) == "" ? "0" : String(cString: sqlite3_column_text(stmt1, 7))
            indentHeaderb = [
                "TRNAPPID" : String(cString: sqlite3_column_text(stmt1, 0)) as AnyObject,
                "TRAININGTYPE" : String(cString: sqlite3_column_text(stmt1, 1)) as AnyObject,
                "TRAININGCODE" : String(cString: sqlite3_column_text(stmt1, 2)) as AnyObject,
                "TRAINERCODE" : String(cString: sqlite3_column_text(stmt1, 3)) as AnyObject,
                "SITECODE" : String(cString: sqlite3_column_text(stmt1, 4)) as AnyObject,
                "SELLERCODE" : String(cString: sqlite3_column_text(stmt1, 5)) as AnyObject,
                "Lat" : LAT as AnyObject,
                "Long" : LONG as AnyObject,
                "TRAININGDATE" : String(cString: sqlite3_column_text(stmt1, 8)) as AnyObject,
                "REMARK" : String(cString: sqlite3_column_text(stmt1, 9)) as AnyObject,
                "WORKSHOPDAY2DATE" : String(cString: sqlite3_column_text(stmt1, 10)) as AnyObject,
                "WORKSHOPDAY3DATE" : String(cString: sqlite3_column_text(stmt1, 11)) as AnyObject,
                "ISMULTIDAYWORKSHOP" : String(cString: sqlite3_column_text(stmt1, 12)) as AnyObject,
                "LOCATION" : String(cString: sqlite3_column_text(stmt1, 13)) as AnyObject,
            ]
        }
        var body: [AnyObject] = []
        body.append(indentHeaderb as AnyObject)
        let indentHeader: [String: [AnyObject]] = ["Header": body ]
        
        return indentHeader
    }
    
    //         let query = "INSERT INTO VirtualTrainingUpdate (TRNAPPID,TRAININGDATE,STYLISTCODE,STYLISTNAME,STYLISTMOBILENO,SALONCODE,SALONREMARK,TRAININGSUBJECT,isEdit,colorcode,post) VALUES
    func getWorkshopJsonLine(sono: String?) -> [String: [AnyObject]] {
        var indentLine: [String: [AnyObject]] = [:]
        var stmt1: OpaquePointer?
        
        // //let POSTInsertWorkshoptable = "CREATE TABLE IF NOT EXISTS InsertWorkshop(TRNAPPID text,date text,trainingcode text,traininglocations text,branchcode text,saloncodes text,salonname text,sellercodes text,addresses text,noofstylisttrainedstr text,post text,modelno text,remark text,id text,Lat text,longi text,datetime text,saloncodes text , stylistmobileno text ,stylistname text,stylistcode text,isEdit text)"
        let query = "select TRNAPPID ,date,stylistcode ,stylistname,stylistmobileno ,saloncodes,remark  from InsertWorkshop WHERE post = '1' and TRNAPPID= '\(sono!)'"
        
        if sqlite3_prepare_v2(DatabaseConnection.dbs, query, -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(DatabaseConnection.dbs)!)
            print("error preparing get: \(errmsg)")
            
        }
        var count:Int! = 1
        var body: [AnyObject] = []
        
        while(sqlite3_step(stmt1) == SQLITE_ROW){
            var line: [String: AnyObject] = [:]
            
            line = [
                "TRNAPPID" : String(cString: sqlite3_column_text(stmt1, 0)) as AnyObject,
                "TRAININGDATE" : String(cString: sqlite3_column_text(stmt1, 1)) as AnyObject,
                "STYLISTCODE" : String(cString: sqlite3_column_text(stmt1, 2)) as AnyObject,
                "STYLISTNAME" : String(cString: sqlite3_column_text(stmt1, 3)) as AnyObject,
                "STYLISTMOBILENO" : String(cString: sqlite3_column_text(stmt1, 4)) as AnyObject,
                "SALONCODE" : String(cString: sqlite3_column_text(stmt1, 5)) as AnyObject,
                "SALONREMARK" : String(cString: sqlite3_column_text(stmt1, 6)) as AnyObject,
            ]
            count = count + 1
            body.append(line as AnyObject)
        }
        
        indentLine = [
            "Line" : body
        ]
        return indentLine
    }
    public func WorkshopPostSuccess(){}
    public func WorkshopPostFailure(){}
    public func WorkshopPostError(){}
    
    
    //    [
    //      {
    //        "productivecount": 1,
    //        "totalproductivecount": 8,
    //        "productivecountlm": 1,
    //        "totalfycount": 4,
    //        "prodper": 12
    //      }
    //    ]
    //MARK:- GETHOMEPROD
    func executeHome_Prod_Data(){
        Alamofire.request(Constants.BASE_URL + Constants.URL_Home_Prod).validate().responseJSON {
            response in
            switch response.result {
            case .success(let value): print("success======> \(value)")
            if  let json = response.result.value{
                let listarray : NSArray = json as! NSArray
                if listarray.count > 0 {
                    self.deleteHomeProd()
                    for i in 0..<listarray.count{
                        let productivecount = String(((listarray[i] as AnyObject).value(forKey:"productivecount") as? Int)!)
                        let totalproductivecount = String(((listarray[i] as AnyObject).value(forKey:"totalproductivecount") as? Int)!)
                        let productivecountlm = String(((listarray[i] as AnyObject).value(forKey:"productivecountlm") as? Int)!)
                        let totalfycount = String(((listarray[i] as AnyObject).value(forKey:"totalfycount") as? Int)!)
                        let prodper = String(((listarray[i] as AnyObject).value(forKey:"prodper") as? Int)!)
                        
                        self.insertHomeProd(productivecount: productivecount, totalproductivecount: totalproductivecount, productivecountlm: productivecountlm, totalfycount: totalfycount, prodper: prodper)
                    }
                }
                else {
                    self.showtoast(controller: self, message: "Data not available...", seconds: 1.5)
                }
            }
            
                break
                
            case .failure(let error): print("error======> \(error)")
            
                break
            }
        }
    }
    
    
    //  {
    //      "typecustomer": "UNPRODUCTIVE",
    //      "customeR_CODE": "DUM0003"
    //    },
    //    {
    //MARK:- GETHOMEPRODUNPROD
    func executeHome_ProdUnprod_Data(){
        Alamofire.request(Constants.BASE_URL + Constants.URL_Home_Prod_Unprod).validate().responseJSON {
            response in
            switch response.result {
            case .success(let value): print("success======> \(value)")
            if  let json = response.result.value{
                let listarray : NSArray = json as! NSArray
                if listarray.count > 0 {
                    self.deleteHomeProd_UnProd()
                    for i in 0..<listarray.count{
                        let typecustomer = String(((listarray[i] as AnyObject).value(forKey:"typecustomer") as? String)!)
                        let customeR_CODE = String(((listarray[i] as AnyObject).value(forKey:"customeR_CODE") as? String)!)
                        
                        self.insertHomeProd_UnProd(typecustomer: typecustomer, customeR_CODE: customeR_CODE)
                    }
                }
                else {
                    self.showtoast(controller: self, message: "Data not available...", seconds: 1.5)
                }
            }
            
                break
                
            case .failure(let error): print("error======> \(error)")
            
                break
            }
        }
    }
    
    //  "trainingname": "1.1 - Color Discovery KP/BL",
    //   "level": "1.1"
    //MARK:- GETCOLORLEVEL
    func executeColorLevel(){
        Alamofire.request(Constants.BASE_URL + Constants.URL_ColorLevel).validate().responseJSON {
            response in
            switch response.result {
            case .success(let value): print("success======> \(value)")
            if  let json = response.result.value{
                let listarray : NSArray = json as! NSArray
                if listarray.count > 0 {
                    self.deleteColorLevel()
                    for i in 0..<listarray.count{
                        let trainingname = String(((listarray[i] as AnyObject).value(forKey:"trainingname") as? String)!)
                        let level = String(((listarray[i] as AnyObject).value(forKey:"level") as? String)!)
                        
                        self.insertColorLevel(trainingname: trainingname, level: level)
                    }
                }
                else {
                    self.showtoast(controller: self, message: "Data not available...", seconds: 1.5)
                }
            }
            
                break
                
            case .failure(let error): print("error======> \(error)")
            
                break
            }
        }
    }
    
    //MARK:- PROFILE NEW
    func executeProfileNew(){
        Alamofire.request(Constants.BASE_URL+Constants.URL_GET_PROFILE_NEW).validate().responseJSON {
            response in
            switch response.result {
            case .success(let value): print("success======> \(value)")
            if  let json = response.result.value{
                self.deleteUserProfileNew()
                let listarray : NSArray = json as! NSArray
                for i in 0..<listarray.count{
                    
                    let trainercode = String (((listarray[i] as AnyObject).value(forKey:"trainercode") as? String)!)
                    let trainername = String (((listarray[i] as AnyObject).value(forKey:"trainername") as? String)!)
                    let contactno = String (((listarray[i] as AnyObject).value(forKey:"contactno") as? String)!)
                    let email = String (((listarray[i] as AnyObject).value(forKey:"email") as? String)!)
                    let reportinGMANAGER = String (((listarray[i] as AnyObject).value(forKey:"reportinG MANAGER") as? String)!)
                    let stylisTTRAINEDYTD = String (((listarray[i] as AnyObject).value(forKey:"stylisT TRAINED YTD") as? Int)!)
                    let uniquedoorSTRAINEDYTD = String (((listarray[i] as AnyObject).value(forKey:"uniquedoorS TRAINED YTD") as? Int)!)
                    let traininGCONDUCTEDYTD = String (((listarray[i] as AnyObject).value(forKey:"traininG CONDUCTED YTD") as? Int)!)
                    let toPDOORSTRAINEDYTD = String (((listarray[i] as AnyObject).value(forKey:"toP DOORS TRAINED YTD") as? Int)!)
                    
                    self.insertUserProfileNew(trainercode: trainercode, trainername: trainername, contactno: contactno, email: email, reportinGMANAGER: reportinGMANAGER, stylisTTRAINEDYTD: stylisTTRAINEDYTD, uniquedoorSTRAINEDYTD: uniquedoorSTRAINEDYTD , traininGCONDUCTEDYTD: traininGCONDUCTEDYTD, toPDOORSTRAINEDYTD: toPDOORSTRAINEDYTD)
                    
                }}
                break
            case .failure(let error): print("error======> \(error)")
                break
            }
        }
    }
    
    
    //    },
    //MARK:- GETTODAYACTIVITY
    func executeTodayActivity(){
        var salonaddress : String! = ""
        var salonname : String! = ""
        self.deletePostDeleteData()
        self.deletinternalotherpostPost()
        self.deletaddleavePost()
        self.delethotdaymarketvisitPost()
        Alamofire.request(Constants.BASE_URL + Constants.URL_GETTODAYTRAININGDATA).validate().responseJSON {
            response in
            switch response.result {
            case .success(let value): print("success======> \(value)")
            if  let json = response.result.value{
                let listarray : NSArray = json as! NSArray
                if listarray.count > 0 {
                    for i in 0..<listarray.count{
                        let trnappid = String(((listarray[i] as AnyObject).value(forKey:"trnappid") as? String)!)
//                      let trainingdoc = String(((listarray[i] as AnyObject).value(forKey:"trainingdoc") as? String)!)
                        let trainingdate = String(((listarray[i] as AnyObject).value(forKey:"trainingdate") as? String)!)
           //           let location = String(((listarray[i] as AnyObject).value(forKey:"location") as? String)!)
                        let trainingtype = String(((listarray[i] as AnyObject).value(forKey:"trainingtype") as? String)!)
                   //   let trainingcode = String(((listarray[i] as AnyObject).value(forKey:"trainingcode") as? String)!)
                        let trainercode = String(((listarray[i] as AnyObject).value(forKey:"trainercode") as? String)!)
                        let sitecode = String(((listarray[i] as AnyObject).value(forKey:"sitecode") as? String)!)
                        let sellercode = String(((listarray[i] as AnyObject).value(forKey:"sellercode") as? String)!)
                        let saloncode = String(((listarray[i] as AnyObject).value(forKey:"saloncode") as? String)!)
                    //  let noofstylist = String(((listarray[i] as AnyObject).value(forKey:"noofstylist") as? String)!)
                    //  let noofmodel = String(((listarray[i] as AnyObject).value(forKey:"noofmodel") as? String)!)
                        let remarks = String(((listarray[i] as AnyObject).value(forKey:"remarks") as? String)!)
                  //    let stylistmobileno = String(((listarray[i] as AnyObject).value(forKey:"stylistmobileno") as? String)!)
                   //   let stylistname = String(((listarray[i] as AnyObject).value(forKey:"stylistname") as? String)!)
                   //   let stylistcode = String(((listarray[i] as AnyObject).value(forKey:"stylistcode") as? String)!)

                    
                        if(trainingtype == "Internal Training" || trainingtype == "Other" ) {
                            self.insertPostDeleteData(TRNAPPID: trnappid, TRAINERCODE: trainercode, DATAAREAID: "7200", Post: "0", ActivityType: trainingtype)

                            self.insertinternalotherPost(trnappid: trnappid, trainingtype: trainingtype, trainercode: trainercode, lat: "0", long: "0", trainingdate: trainingdate, remark: remarks, post: "0")
                        }
                        else if (trainingtype == "Leave"){
                            self.insertPostDeleteData(TRNAPPID: trnappid, TRAINERCODE: trainercode, DATAAREAID: "7200", Post: "0", ActivityType: trainingtype)

                            self.insertAddLeavePost(trnappid: trnappid, trainingtype: trainingtype, trainercode: trainercode, lat: "0", long: "0", trainingdate: trainingdate, post: "0")
                        }
                        else if (trainingtype == "Hot Day" || trainingtype == "Market Visit"){
                            salonaddress = self.getSalonAddress(saloncode : saloncode)
                            salonname = self.getSalonName (saloncode : saloncode)
                            
                            self.insertPostDeleteData(TRNAPPID: trnappid, TRAINERCODE: trainercode, DATAAREAID: "7200", Post: "0", ActivityType: trainingtype)

                            self.insertHotDayPost(trainercode: trainercode, saloncode: saloncode, salonaddress: salonaddress , trnappid:  trnappid , salonname: salonname , lat: "0", long: "0" , trainingdate: trainingdate, sitecode: sitecode, sellercode: sellercode, trainingtype: trainingtype , post: "0")
                        }
                    }
                }
            }
            
                break
                
            case .failure(let error): print("error======> \(error)")
            
                break
            }
        }
    }
    fileprivate func getSalonAddress(saloncode : String!) -> String
    {
        var salonAddress : String! = ""
        var stmt4:OpaquePointer?
        let queryString = "SELECT salonaddress FROM salon where  saloncode = '" + saloncode! + "'"
        print("setList"+queryString)
        if sqlite3_prepare_v2(DatabaseConnection.dbs, queryString, -1, &stmt4, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(DatabaseConnection.dbs)!)
            print("error preparing get: \(errmsg)")
        }
        while(sqlite3_step(stmt4) == SQLITE_ROW){
            salonAddress =  String(cString: sqlite3_column_text(stmt4, 0))
        }
        return salonAddress
    }
    public  func getSalonName(saloncode : String!) -> String
    {
        var salonName : String! = ""
        var stmt4:OpaquePointer?
        let queryString = "SELECT salonname FROM salon where  saloncode = '" + saloncode! + "'"
        print("setList"+queryString)
        if sqlite3_prepare_v2(DatabaseConnection.dbs, queryString, -1, &stmt4, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(DatabaseConnection.dbs)!)
            print("error preparing get: \(errmsg)")
        }
        while(sqlite3_step(stmt4) == SQLITE_ROW){
            salonName =  String(cString: sqlite3_column_text(stmt4, 0))
        }
        return salonName
    }
    
    public  func getSalonCode(salonName : String!) -> String
    {
        var salonCode : String! = ""
        var stmt4:OpaquePointer?
        let queryString = "SELECT saloncode FROM salon where  salonname = '" + salonName! + "'"
        print("setList"+queryString)
        if sqlite3_prepare_v2(DatabaseConnection.dbs, queryString, -1, &stmt4, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(DatabaseConnection.dbs)!)
            print("error preparing get: \(errmsg)")
        }
        while(sqlite3_step(stmt4) == SQLITE_ROW){
            salonCode =  String(cString: sqlite3_column_text(stmt4, 0))
        }
        return salonCode
    }
    
    
    fileprivate  func getColorCode(trainingtype : String!) -> String
    {
        var count : Int = 0
        var colorcode : String! = "first"
        var stmt4:OpaquePointer?
        let queryString = "SELECT TRNAPPID FROM SalonWorkshopHeadar where  TRAININGTYPE = '" + trainingtype! + "'"
        print("setList"+queryString)
        if sqlite3_prepare_v2(DatabaseConnection.dbs, queryString, -1, &stmt4, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(DatabaseConnection.dbs)!)
            print("error preparing get: \(errmsg)")
        }
        
        while(sqlite3_step(stmt4) == SQLITE_ROW){
            colorcode =  "second"
            count = count + 1
            if(count > 1 && trainingtype == "Virtual Training"){
               colorcode = "third"
            }
        }
        return colorcode
    }
    
    
    public func getSubjectName(trainingcode : String!) -> String
    {
        var trainingname : String! = ""
        var stmt4:OpaquePointer?
        let queryString = "SELECT distinct trainingname FROM TrainingMaster where  trainingcode = '" + trainingcode! + "'"
        print("setList"+queryString)
        if sqlite3_prepare_v2(DatabaseConnection.dbs, queryString, -1, &stmt4, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(DatabaseConnection.dbs)!)
            print("error preparing get: \(errmsg)")
        }
        while(sqlite3_step(stmt4) == SQLITE_ROW){
             trainingname =  String(cString: sqlite3_column_text(stmt4, 0))
        }
        return trainingname
    }
    
    
    public func getSubjectCode(trainingname : String!) -> String
      {
          var trainingCode : String! = ""
          var stmt4:OpaquePointer?
          let queryString = "SELECT distinct trainingcode FROM TrainingMaster where  trainingname = '" + trainingname! + "'"
          print("setList"+queryString)
          if sqlite3_prepare_v2(DatabaseConnection.dbs, queryString, -1, &stmt4, nil) != SQLITE_OK{
              let errmsg = String(cString: sqlite3_errmsg(DatabaseConnection.dbs)!)
              print("error preparing get: \(errmsg)")
          }
          while(sqlite3_step(stmt4) == SQLITE_ROW){
               trainingCode =  String(cString: sqlite3_column_text(stmt4, 0))
          }
          return trainingCode
      }
    
    fileprivate  func getNop(trnappid : String!,trainingType :String!) -> Int
    {
        var queryString : String! = ""
        var nopcount : Int! = 0
        var stmt4:OpaquePointer?
        if(trainingType == "InSalon"){
         queryString = "SELECT TRNAPPID FROM InSalonDetail where  TRNAPPID = '" + trnappid! + "'"
        }
        else {
            queryString = "SELECT TRNAPPID FROM VirtualTrainingUpdate where  TRNAPPID = '" + trnappid! + "'"
        }
        print("setList"+queryString)
        if sqlite3_prepare_v2(DatabaseConnection.dbs, queryString, -1, &stmt4, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(DatabaseConnection.dbs)!)
            print("error preparing get: \(errmsg)")
        }
        while(sqlite3_step(stmt4) == SQLITE_ROW){
            nopcount =  nopcount + 1
        }
        return nopcount
    }



    
    //MARK:- GETTODAYWORKSHINSALONVIRTUAL
    func executeTODAYWORKSHINSALONVIRTUAL(){
        self.deletaIVirtualTrainingPost()
        self.deletaSalonWorkshopHeadarPost()   //done
        self.deleteWorkshopHeaderUpdated()   // done
        self.deleteInsertWorkshopdata()
        self.deletaInSalonDetailPost()
        
        var locationline : String! = ""
        var trainingcode : String! = ""
        Alamofire.request(Constants.BASE_URL + Constants.URL_GETTODAYWKSHPINSLNTRAININGDATA).validate().responseJSON {
            response in
            print("executeTODAYWORKSHINSALONVIRTUAL=========================================")
            print(Constants.BASE_URL + Constants.URL_GETTODAYWKSHPINSLNTRAININGDATA)
            switch response.result {
            case .success(let value): print("success======> \(value)")
            if let json = response.result.value as? [[String:Any]]{
                for result in json {
                    let ismultidayworkshop = result["ismultidayworkshop"] as! Int
                    let lat = result["lat"] as! Double
                    let long = result["long"] as! Double
                    let remarks = result["remarks"] as! String
                    let saloncode = result["saloncode"] as! String
                    let sellercode = result["sellercode"] as! String
                    let sitecode = result["sitecode"] as! String
                    let trainercode = result["trainercode"] as! String
                     trainingcode = result["trainingcode"] as! String
                    let trainingdate = result["trainingdate"] as! String
                    let trainingdoc = result["trainingdoc"] as! String
                    let trainingtype = result["trainingtype"] as! String
                    let trnappid = result["trnappid"] as! String
                    let workshopdaY2DATE = result["workshopdaY2DATE"] as! String
                    let workshopdaY3DATE = result["workshopdaY3DATE"] as! String
                    
                    if let lines = result["lines"] as? [[String:Any]]{
                        for line in lines {
                            let trnappidline = line["trnappid"] as! String
                            let trainingdocline = line["trainingdoc"] as! String
                            let trainingdateline = line["trainingdate"] as! String
                            locationline = line["location"] as! String
                            let trainingtypeline = line["trainingtype"] as! String
                            let trnappid  = line["trnappid"] as! String
                            let sitecodeline = line["sitecode"] as! String
                            let sellercodeline = line["sellercode"] as! String
                            let noofstylistline = line["noofstylist"] as! String
                            let noofmodelline = line["noofmodel"] as! String
                            let remarkline = line["remark"] as! String
                            let stylistmobilenoline = line["stylistmobileno"] as! String
                            let stylistnameline = line["stylistname"] as! String
                            let saloncodeline = line["saloncode"] as! String
                            let stylistcodeline = line["stylistcode"] as! String
                            let salonname = self.getSalonName(saloncode: saloncodeline)
                            let colorcode = self.getColorCode(trainingtype: trainingtype)
                            let subject = self.getSubjectName(trainingcode : trainingcode)
                            
                            if(trainingtype == "WorkShop"){
                                self.insertLineInsertWorkshop(trnappid: trnappidline, trainingdate: trainingdateline, stylistcode: stylistcodeline, stylistname: stylistnameline, stylistnumber: stylistmobilenoline, saloncode: saloncodeline, salonname: salonname, salonremark: remarkline, isedit: "1", post: "1")
                            }
                            else if (trainingtype == "InSalon"){
                                self.insertLineInsalon(trnappid: trnappidline, saloncode: saloncodeline, trainingdate: trainingdateline, datetime: "", stylistname: stylistnameline, stylistnumber: stylistmobilenoline, salonname: salonname , stylistcode: stylistcodeline, isedit: "0", salonremark: remarkline, colorcode: colorcode, post: "1")
                            }
                            else if (trainingtype == "Virtual Training"){
                                self.insertLineVirtualTraining(trnappid: trnappidline, trainingdate: trainingdateline, stylistcode: stylistcodeline, stylistname: stylistnameline, stylistnumber: stylistmobilenoline, saloncode: saloncodeline, salonremark: remarkline, traininingsubject: subject, isedit: "0", colorcode: colorcode, post: "1")
                            }
                        }
                    }
                    if(trainingtype == "WorkShop"){
                        self.insertPostDeleteData(TRNAPPID: trnappid, TRAINERCODE: trainercode, DATAAREAID: "7200", Post: "0", ActivityType: trainingtype)
                        self.insertWorkshopHeaderUpdated(trnappid: trnappid, trainingtype: trainingtype, trainingcode: trainingcode, trainercode: trainercode, sitecode: sitecode, sellercode: sellercode, Lat: String(lat), Long: String(long), trainingdate: trainingdate, remark: remarks, post: "1", workshopday2date: workshopdaY2DATE, workshopday3date: workshopdaY3DATE, ismultidayworkshop:String(ismultidayworkshop), isEdit: "1", location: locationline)
                    }
                    else if (trainingtype == "InSalon" || trainingtype == "Virtual Training"){
                        
                        let salonname = self.getSalonName(saloncode: saloncode)
                        let colorcode = self.getColorCode(trainingtype: trainingtype)
                        let subject = self.getSubjectName(trainingcode : trainingcode)
                        let nop = self.getNop(trnappid: trnappid, trainingType: trainingtype)
                        
                        self.insertPostDeleteData(TRNAPPID: trnappid, TRAINERCODE: trainercode, DATAAREAID: "7200", Post: "0", ActivityType: trainingtype)


                        self.insertHeaderInsalonWorkShop(trnappid: trnappid, trainingtype: trainingtype, trainingcode: trainingcode, trainercode: trainercode, sitecode: sitecode, sellercode: sellercode, Lat: String(lat), Long:String(long), trainingdate: trainingdate, remark: remarks, enddate: "", saloncode: saloncode, isedit: "0", post: "1", nop: String(nop), colorcode: colorcode, salonname: salonname, subject: subject)
//                        self.updateSalonWorkshopHeadarNOPINC(trnappid: trnappid)
                    }
                }
                break
                }
            case .failure(let error): print("error======> \(error)")
                break
            }
        }
    }
    //MARK:- URL_GETALLOWTRAININGTYPEMASTER
    func executeURL_GETALLOWTRAININGTYPEMASTER(){
        self.deleteGetAllowTrainingTypeMaster()
        Alamofire.request(Constants.BASE_URL + Constants.URL_GETALLOWTRAININGTYPEMASTER).validate().responseJSON {
            response in
            switch response.result {
            case .success(let value): print("success======> \(value)")
            if  let json = response.result.value{
                let listarray : NSArray = json as! NSArray
                if listarray.count > 0 {
                    
                    for i in 0..<listarray.count{
                        let primarY_DESCRIPTION = String(((listarray[i] as AnyObject).value(forKey:"primarY_DESCRIPTION") as? String)!)
                        let secondarY_DESCRIPTION = String(((listarray[i] as AnyObject).value(forKey:"secondarY_DESCRIPTION") as? String)!)
                        self.insertGetAllowTrainingTypeMaster(primarY_DESCRIPTION: primarY_DESCRIPTION, secondarY_DESCRIPTION: secondarY_DESCRIPTION)
                    }
                }
            }
                break
            case .failure(let error): print("error======> \(error)")
                break
            }
             SwiftEventBus.post("desc")
            self.getAllowDone()
        }
    }
    
    public func getAllowDone(){
        
    }
  //GETTODAYMULTIWORKSHOP?TRAINERCODE=TRN001&SEARCHTRAININGTYPE=1
    //MARK:- GETTODAYMULTIWORKSHOP
    func executeGETTODAYMULTIWORKSHOP(){
        var locationline : String! = ""
        var trainingcode : String! = ""
        Alamofire.request(Constants.BASE_URL + Constants.URL_GETTODAYMULTIWORKSHOP).validate().responseJSON {
            response in
            switch response.result {
            case .success(let value): print("success======> \(value)")
            
            self.deleteWorkshopHeaderUpdated()   // done
            self.deleteInsertWorkshopdata()
            
            if let json = response.result.value as? [[String:Any]]{
                for result in json {
                    let ismultidayworkshop = result["ismultidayworkshop"] as! Int
                    let lat = result["lat"] as! Int
                    let long = result["long"] as! Int
                    let remarks = result["remarks"] as! String
                    let saloncode = result["saloncode"] as! String
                    let sellercode = result["sellercode"] as! String
                    let sitecode = result["sitecode"] as! String
                    let trainercode = result["trainercode"] as! String
                     trainingcode = result["trainingcode"] as! String
                    let trainingdate = result["trainingdate"] as! String
                    let trainingdoc = result["trainingdoc"] as! String
                    let trainingtype = result["trainingtype"] as! String
                    let trnappid = result["trnappid"] as! String
                    let workshopdaY2DATE = result["workshopdaY2DATE"] as! String
                    let workshopdaY3DATE = result["workshopdaY3DATE"] as! String
                    
                    if let lines = result["lines"] as? [[String:Any]]{
                        for line in lines {
                            let trnappidline = line["trnappid"] as! String
                            let trainingdocline = line["trainingdoc"] as! String
                            let trainingdateline = line["trainingdate"] as! String
                            locationline = line["location"] as! String
                            let trainingtypeline = line["trainingtype"] as! String
                            let trnappid  = line["trnappid"] as! String
                            let sitecodeline = line["sitecode"] as! String
                            let sellercodeline = line["sellercode"] as! String
                            let noofstylistline = line["noofstylist"] as! String
                            let noofmodelline = line["noofmodel"] as! String
                            let remarkline = line["remark"] as! String
                            let stylistmobilenoline = line["stylistmobileno"] as! String
                            let stylistnameline = line["stylistname"] as! String
                            let saloncodeline = line["saloncode"] as! String
                            let stylistcodeline = line["stylistcode"] as! String
                            let salonname = self.getSalonName(saloncode: saloncodeline)
                            let colorcode = self.getColorCode(trainingtype:trainingtype)
                            let subject = self.getSubjectName(trainingcode : trainingcode)
                            
                            if(trainingtype == "WorkShop"){
                                self.insertLineInsertWorkshop(trnappid: trnappidline, trainingdate: trainingdate, stylistcode: stylistcodeline, stylistname: stylistnameline, stylistnumber: stylistmobilenoline, saloncode: saloncodeline, salonname: salonname, salonremark: remarkline, isedit: "2", post: "1")
                            }
                        }
                    }
                    if(trainingtype == "WorkShop"){
                        self.insertPostDeleteData(TRNAPPID: trnappid, TRAINERCODE: trainercode, DATAAREAID: "7200", Post: "0", ActivityType: trainingtype)
                        self.insertWorkshopHeaderUpdated(trnappid: trnappid, trainingtype: trainingtype, trainingcode: trainingcode, trainercode: trainercode, sitecode: sitecode, sellercode: sellercode, Lat: String(lat), Long: String(long), trainingdate: trainingdate, remark: remarks, post: "1", workshopday2date: workshopdaY2DATE, workshopday3date: workshopdaY3DATE, ismultidayworkshop:String(ismultidayworkshop), isEdit: "2", location: locationline)
                    }
                }
                break
                }
            case .failure(let error): print("error======> \(error)")
                break
            }
        }
    }

      //MARK:- URL_GetCalender
      func executeURL_GetCalender(){
          self.deleteCalender()
          Alamofire.request(Constants.BASE_URL + Constants.URL_GetCalender).validate().responseJSON {
              response in
              switch response.result {
              case .success(let value): print("success======> \(value)")
              if  let json = response.result.value{
                  let listarray : NSArray = json as! NSArray
                  if listarray.count > 0 {
                    for i in 0..<listarray.count{
                        
                        let date = String(((listarray[i] as AnyObject).value(forKey:"date") as? String)!)
                        let isblock = String(((listarray[i] as AnyObject).value(forKey:"isblock") as? Int)!)
                        let blocK_REASON = String(((listarray[i] as AnyObject).value(forKey:"blocK_REASON") as? String)!)
                        let activitY_NAME = String(((listarray[i] as AnyObject).value(forKey:"activitY_NAME") as? String)!)
                        let activitY_SUBJECT = String(((listarray[i] as AnyObject).value(forKey:"activitY_SUBJECT") as? String)!)
                        let insaloN_1_CODE = String(((listarray[i] as AnyObject).value(forKey:"insaloN_1_CODE") as? String)!)
                        let insaloN_1_SUBJECT = String(((listarray[i] as AnyObject).value(forKey:"insaloN_1_SUBJECT") as? String)!)
                        let insaloN_2_CODE = String(((listarray[i] as AnyObject).value(forKey:"insaloN_2_CODE") as? String)!)
                        let insaloN_2_SUBJECT = String(((listarray[i] as AnyObject).value(forKey:"insaloN_2_SUBJECT") as? String)!)
                        let approveD_ACTIVITY_NAME = String(((listarray[i] as AnyObject).value(forKey:"approveD_ACTIVITY_NAME") as? String)!)
                        let approveD_ACTIVITY_SUBJECT = String(((listarray[i] as AnyObject).value(forKey:"approveD_ACTIVITY_SUBJECT") as? String)!)
                        let approveD_INSALON_1_CODE = String(((listarray[i] as AnyObject).value(forKey:"approveD_INSALON_1_CODE") as? String)!)
                        let approveD_INSALON_1_SUBJECT = String(((listarray[i] as AnyObject).value(forKey:"approveD_INSALON_1_SUBJECT") as? String)!)
                        let approveD_INSALON_2_CODE = String(((listarray[i] as AnyObject).value(forKey:"approveD_INSALON_2_CODE") as? String)!)
                        let approveD_INSALON_2_SUBJECT = String(((listarray[i] as AnyObject).value(forKey:"approveD_INSALON_2_SUBJECT") as? String)!)
                        let trainercode = String(((listarray[i] as AnyObject).value(forKey:"trainercode") as? String)!)
                        let shorT_DESC = String(((listarray[i] as AnyObject).value(forKey:"shorT_DESC") as? String)!)
                        let salonnamE1 = String(((listarray[i] as AnyObject).value(forKey:"salonnamE1") as? String)!).replacingOccurrences(of: "'", with: "")
                        let salonnamE2 = String(((listarray[i] as AnyObject).value(forKey:"salonnamE2") as? String)!).replacingOccurrences(of: "'", with: "")
                        let apP_SALONNAME1 = String(((listarray[i] as AnyObject).value(forKey:"apP_SALONNAME1") as? String)!).replacingOccurrences(of: "'", with: "")
                        let apP_SALONNAME2 = String(((listarray[i] as AnyObject).value(forKey:"apP_SALONNAME2") as? String)!).replacingOccurrences(of: "'", with: "")
                        let status = String(((listarray[i] as AnyObject).value(forKey:"status") as? Int)!)
                        
                        self.insertCalender(date: date, activitY_NAME: activitY_NAME, trainercode: trainercode, activitY_SUBJECT: activitY_SUBJECT, insaloN_1_CODE: insaloN_1_CODE, insaloN_1_SUBJECT: insaloN_1_SUBJECT, insaloN_2_CODE: insaloN_2_CODE, insaloN_2_SUBJECT: insaloN_2_SUBJECT, salonnamE1: salonnamE1, salonnamE2: salonnamE2, shorT_DESC: shorT_DESC, status: status, isblock: isblock, blocK_REASON: blocK_REASON, approveD_ACTIVITY_NAME: approveD_ACTIVITY_NAME, approveD_ACTIVITY_SUBJECT: approveD_ACTIVITY_SUBJECT, approveD_INSALON_1_CODE: approveD_INSALON_1_CODE, approveD_INSALON_1_SUBJECT: approveD_INSALON_1_SUBJECT, approveD_INSALON_2_CODE: approveD_INSALON_2_CODE, approveD_INSALON_2_SUBJECT: approveD_INSALON_2_SUBJECT, apP_SALONNAME1: apP_SALONNAME1, apP_SALONNAME2: apP_SALONNAME2)

                   }
                  }
                  else {
                      self.showtoast(controller: self, message: "Data not available...", seconds: 1.5)
                  }
              }
              
                  break
                  
              case .failure(let error): print("error======> \(error)")
              
                  break
              }
          }
      }
    
    //http://163.47.143.188:4808/api/GetCalenderPending?TRAINERCODE=TRN001
      //MARK:- URL_GetCalenderPending
      func executeURL_GetCalenderPending(){
          self.deleteGetCalenderPending()
          Alamofire.request(Constants.BASE_URL + Constants.URL_GetCalenderPending).validate().responseJSON {
              response in
              switch response.result {
              case .success(let value): print("success======> \(value)")
              if  let json = response.result.value{
                  let listarray : NSArray = json as! NSArray
                  if listarray.count > 0 {
                      for i in 0..<listarray.count{
                        
                        let date = String(((listarray[i] as AnyObject).value(forKey:"date") as? String)!)
                        let changE_REQUESTED = String(((listarray[i] as AnyObject).value(forKey:"changE_REQUESTED") as? String)!)
                        let traineR_CODE = String(((listarray[i] as AnyObject).value(forKey:"traineR_CODE") as? String)!)
                        let impacT_DATE = String(((listarray[i] as AnyObject).value(forKey:"impacT_DATE") as? String)!)
                        let datE_APPLIED = String(((listarray[i] as AnyObject).value(forKey:"datE_APPLIED") as? String)!)
                        let neW_INSALON_1_SUBJECT = String(((listarray[i] as AnyObject).value(forKey:"neW_INSALON_1_SUBJECT") as? String)!)
                        let neW_INSALON_2_SUBJECT = String(((listarray[i] as AnyObject).value(forKey:"neW_INSALON_2_SUBJECT") as? String)!)
                        let shorT_DESC = String(((listarray[i] as AnyObject).value(forKey:"shorT_DESC") as? String)!)
                        let neW_SALONNAME1 = String(((listarray[i] as AnyObject).value(forKey:"neW_SALONNAME1") as? String)!).replacingOccurrences(of: "'", with: "")
                        let neW_SALONCODE1 = String(((listarray[i] as AnyObject).value(forKey:"neW_SALONCODE1") as? String)!)
                        let neW_SALONNAME2 = String(((listarray[i] as AnyObject).value(forKey:"neW_SALONNAME2") as? String)!).replacingOccurrences(of: "'", with: "")
                        let neW_SALONCODE2 = String(((listarray[i] as AnyObject).value(forKey:"neW_SALONCODE2") as? String)!)
                        let neW_ACTIVITY_SUBJECT = String(((listarray[i] as AnyObject).value(forKey:"neW_ACTIVITY_SUBJECT") as? String)!)
                        
                        self.insertCalenderPending(date: date, changE_REQUESTED: changE_REQUESTED, traineR_CODE: traineR_CODE, impacT_DATE: impacT_DATE, datE_APPLIED: datE_APPLIED, neW_INSALON_1_SUBJECT: neW_INSALON_1_SUBJECT, neW_INSALON_2_SUBJECT: neW_INSALON_2_SUBJECT, shorT_DESC: shorT_DESC, neW_SALONNAME1: neW_SALONNAME1, neW_SALONCODE1: neW_SALONCODE1, neW_SALONNAME2: neW_SALONNAME2, neW_SALONCODE2: neW_SALONCODE2, neW_ACTIVITY_SUBJECT: neW_ACTIVITY_SUBJECT)
//                        self.insertCalenderPending(date: date, changE_REQUESTED: changE_REQUESTED, traineR_CODE: traineR_CODE, impacT_DATE: impacT_DATE, datE_APPLIED: datE_APPLIED, neW_INSALON_1_SUBJECT: neW_INSALON_1_SUBJECT, neW_SALONNAME2: neW_SALONNAME2, neW_SALONCODE2: neW_SALONCODE2, neW_ACTIVITY_SUBJECT: neW_ACTIVITY_SUBJECT)
                    }
                  }
                  else {
                      self.showtoast(controller: self, message: "Data not available...", seconds: 1.5)
                  }
                    }
                  break
                  
              case .failure(let error): print("error======> \(error)")
              
                  break
              }
          }
      }
    //MARK:- POST DELETE DATA
    public func postDeleteData(ActivityType:String!)
    {
        //        self.view.isUserInteractionEnabled = false
        //        print("sending request")
        //        let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
        //        activityIndicator.center = CGPoint(x: view.bounds.size.width/2, y: view.bounds.size.height/2)
        //        activityIndicator.color = UIColor.black
        //        view.addSubview(activityIndicator)
        //        activityIndicator.startAnimating()
        //        print("loader activated")
        //        let PostInternalOtherTraining = "CREATE TABLE IF NOT EXISTS internalotherpost(trnappid text,trainingtype text,trainercode text,lat text,long text,trainingdate text,remark text ,post text)"
   //CREATE  TABLE IF NOT EXISTS  PostDeleteData (TRNAPPID text,TRAINERCODE text,DATAAREAID text,Post text,ActivityType text)
        DispatchQueue.main.async{
            var stmt5:OpaquePointer?
            let queryString = "SELECT TRNAPPID,TRAINERCODE,DATAAREAID FROM PostDeleteData WHERE post = '0' and ActivityType = '" + ActivityType + "' "
            print(queryString)
            if sqlite3_prepare_v2(DatabaseConnection.dbs, queryString, -1, &stmt5, nil) != SQLITE_OK{
                let errmsg = String(cString: sqlite3_errmsg(DatabaseConnection.dbs)!)
                print("error preparing get: \(errmsg)")
                return
            }
            
            while(sqlite3_step(stmt5) == SQLITE_ROW){
                let TRNAPPID =  String(cString: sqlite3_column_text(stmt5, 0))
                let TRAINERCODE = String(cString: sqlite3_column_text(stmt5, 1))
                let DATAAREAID = String(cString: sqlite3_column_text(stmt5, 2))
                
                var  stat: NSString?
                print("\n")
                let parameters: [String: AnyObject] = [
                    "TRNAPPID":TRNAPPID as AnyObject,
                    "TRAINERCODE" : TRAINERCODE as AnyObject,
                    "DATAAREAID" : DATAAREAID as AnyObject,
                ]
                print("DELETE  REQUEST=====================================")
                print(self.json(from: parameters)!);
                
                Alamofire.request(Constants.BASE_URL + Constants.URL_PostDeleteData, method: .post, parameters: parameters, encoding: JSONEncoding.default)
                    .responseJSON {
                        response in
                        print("Response =========>>>>\(response.response as Any)")
                        print("Error ============>>>>\(response.error as Any)")
                        print("Data =============>>>>\(response.data as Any)")
                        print("Result =========>>>>>\(response.result)")
                        stat = response.result.description as NSString
                        print("status =========>>>>>\(String(describing: stat!))")
                        switch response.result {
                        case .success :
                            if (response.response?.statusCode == 200){
                                self.updatePostDeleteData(trnappid: TRNAPPID)
                                self.insertsynclog(tablename: "PostDeleteData", status: "Success", post: "0")
                            }
                            else {
//                                self.deletePostFailure()
                            }
                            break
                            
                        case .failure(let error):
                          //  self.showtoast(controller: self, message: "Upload Status: \(error)", seconds: 2.0)
                            self.insertsynclog(tablename: "PostDeleteData", status: "Failure", post: "0")
//                            self.deletePostError()
                            break
                        }
                }
            }
            self.deletePostSuccess()
            //            activityIndicator.stopAnimating()
            //            self.view.isUserInteractionEnabled = true
            //            print("loader deactivated")
            //  self.postsynclog()
        }
    }
    
    public func deletePostSuccess(){}
    public func deletePostFailure(){}
    public func deletePostError(){}

    //MARK:- POST CALENDAR
    public func postCalendar()
    {
                self.view.isUserInteractionEnabled = false
                print("sending request")
                let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
                activityIndicator.center = CGPoint(x: view.bounds.size.width/2, y: view.bounds.size.height/2)
                activityIndicator.color = UIColor.black
                view.addSubview(activityIndicator)
                activityIndicator.startAnimating()
                print("loader activated")
        //    //        let PostCalender = "CREATE TABLE IF NOT EXISTS  PostCalender (ENTRY_TYPE text,TRAINER_CODE text,IMPACT_DATE text,PLANNED_ACTIVITY text,CHANGE_REQUESTED text,DATE_APPLIED text,STATUS text ,CREATEDDATETIME text,CREATEDBY text,DATAAREAID text, TRNAPPID text, Post text,INSALON_1_CODE text,NEW_INSALON_1_CODE text,INSALON_1_SUBJECT text,NEW_INSALON_1_SUBJECT text,INSALON_2_CODE text,NEW_INSALON_2_CODE text,INSALON_2_SUBJECT text,NEW_INSALON_2_SUBJECT text,ACTIVITY_SUBJECT text,NEW_ACTIVITY_SUBJECT text)"

        DispatchQueue.main.async{
            var stmt5:OpaquePointer?
            let queryString = "SELECT TRNAPPID,ENTRY_TYPE,TRAINER_CODE,IMPACT_DATE,PLANNED_ACTIVITY,CHANGE_REQUESTED,DATE_APPLIED,STATUS,CREATEDBY,DATAAREAID,INSALON_1_CODE,NEW_INSALON_1_CODE,INSALON_1_SUBJECT,NEW_INSALON_1_SUBJECT,INSALON_2_CODE,NEW_INSALON_2_CODE,INSALON_2_SUBJECT,NEW_INSALON_2_SUBJECT ,ACTIVITY_SUBJECT ,NEW_ACTIVITY_SUBJECT FROM PostCalender WHERE Post = '0'"
            
            if sqlite3_prepare_v2(DatabaseConnection.dbs, queryString, -1, &stmt5, nil) != SQLITE_OK{
                let errmsg = String(cString: sqlite3_errmsg(DatabaseConnection.dbs)!)
                print("error preparing get: \(errmsg)")
                return
            }
            while(sqlite3_step(stmt5) == SQLITE_ROW){
                let TRNAPPID =  String(cString: sqlite3_column_text(stmt5, 0))
                let ENTRYTYPE = String(cString: sqlite3_column_text(stmt5, 1))
                let TRAINERCODE = String(cString: sqlite3_column_text(stmt5, 2))
                let IMPACT_DATE = String(cString: sqlite3_column_text(stmt5, 3))
                let PLANNED_ACTIVITY = String(cString: sqlite3_column_text(stmt5, 4))
                let CHANGE_REQUESTED = String(cString: sqlite3_column_text(stmt5, 5))
                let DATEAPPLIED = String(cString: sqlite3_column_text(stmt5, 6))
                let STATUS = String(cString: sqlite3_column_text(stmt5, 7))
                let CREATEDBY = String(cString: sqlite3_column_text(stmt5, 8))
                let DATAAREAID = String(cString: sqlite3_column_text(stmt5, 9))
                let INSALON_1_CODE = String(cString: sqlite3_column_text(stmt5, 10))
                let NEW_INSALON_1_CODE = String(cString: sqlite3_column_text(stmt5, 11))
                let INSALON_1_SUBJECT = String(cString: sqlite3_column_text(stmt5, 12))
                let NEW_INSALON_1_SUBJECT = String(cString: sqlite3_column_text(stmt5, 13))
                let INSALON_2_CODE = String(cString: sqlite3_column_text(stmt5, 14))
                let NEW_INSALON_2_CODE = String(cString: sqlite3_column_text(stmt5, 15))
                let INSALON_2_SUBJECT = String(cString: sqlite3_column_text(stmt5, 16))
                let NEW_INSALON_2_SUBJECT = String(cString: sqlite3_column_text(stmt5, 17))
                let ACTIVITY_SUBJECT = String(cString: sqlite3_column_text(stmt5, 18))
                let NEW_ACTIVITY_SUBJECT = String(cString: sqlite3_column_text(stmt5, 19))
                
                var  stat: NSString?
                print("\n")
                
                
                let parameters: [String: AnyObject] = [
                    "ID":TRNAPPID as AnyObject,
                    "ENTRY_TYPE": ENTRYTYPE as AnyObject,
                    "TRAINER_CODE" : TRAINERCODE as AnyObject,
                    "IMPACT_DATE": IMPACT_DATE as AnyObject,
                    "PLANNED_ACTIVITY": PLANNED_ACTIVITY as AnyObject,
                    "CHANGE_REQUESTED" : CHANGE_REQUESTED as AnyObject,
                    "DATE_APPLIED" : DATEAPPLIED as AnyObject,
                    "STATUS" : STATUS as AnyObject,
                    "CREATEDBY" : CREATEDBY as AnyObject,
                    "DATAAREAID" : DATAAREAID as AnyObject,
                    "INSALON_1_CODE" : INSALON_1_CODE as AnyObject,
                    "NEW_INSALON_1_CODE" : NEW_INSALON_1_CODE as AnyObject,
                    "INSALON_1_SUBJECT" : INSALON_1_SUBJECT as AnyObject,
                    "NEW_INSALON_1_SUBJECT" : NEW_INSALON_1_SUBJECT as AnyObject,
                    "INSALON_2_CODE" : INSALON_2_CODE as AnyObject,
                    "NEW_INSALON_2_CODE" : NEW_INSALON_2_CODE as AnyObject,
                    "INSALON_2_SUBJECT" : INSALON_2_SUBJECT as AnyObject,
                    "NEW_INSALON_2_SUBJECT" : NEW_INSALON_2_SUBJECT as AnyObject,
                    "ACTIVITY_SUBJECT" : ACTIVITY_SUBJECT as AnyObject,
                    "NEW_ACTIVITY_SUBJECT" : NEW_ACTIVITY_SUBJECT as AnyObject,
                    
                ]
                
                print("POST CALENDAR POST=================================================================================================")
                print(self.json(from: parameters)!);
                Alamofire.request(Constants.BASE_URL + Constants.URL_PostCalendar, method: .post, parameters: parameters, encoding: JSONEncoding.default)
                    .responseJSON {
                        response in
                        print("Response =========>>>>\(response.response as Any)")
                        print("Error ============>>>>\(response.error as Any)")
                        print("Data =============>>>>\(response.data as Any)")
                        print("Result =========>>>>>\(response.result)")
                        stat = response.result.description as NSString
                        print("status =========>>>>>\(String(describing: stat!))")
                        switch response.result {
                        case .success :
                             if (response.response?.statusCode == 200){
                            self.updatePostCalenderPost(trnappid: TRNAPPID)
                                
                            self.postCalendarPostSuccess()
                            self.insertsynclog(tablename: "PostCalendar", status: "Success", post: "0")
                             }
                             else {
                                self.postCalendnrPostFailure()
                             }
                            break
                            
                        case .failure(let error):
                         //   self.showtoast(controller: self, message: "Upload Status: \(error)", seconds: 2.0)
                            self.insertsynclog(tablename: "PostCalendar", status: "Failure", post: "0")
                            self.postCalendarPostError()
                            break
                        }
                }
            }
            activityIndicator.stopAnimating()
            self.view.isUserInteractionEnabled = true
            print("loader deactivated")
            //  self.postsynclog()
        }
    }
    
    public func postCalendarPostSuccess(){}
    public func postCalendnrPostFailure(){}
     public func postCalendarPostError(){}

         //MARK:- URL_GetCalender
          func executeURL_GetCalende1(){
              self.deleteCalender()
              Alamofire.request(Constants.BASE_URL + Constants.URL_GetCalender).validate().responseJSON {
                  response in
                  switch response.result {
                  case .success(let value): print("success======> \(value)")
                  if  let json = response.result.value{
                      let listarray : NSArray = json as! NSArray
                      if listarray.count > 0 {
                        for i in 0..<listarray.count{
                            
                            let date = String(((listarray[i] as AnyObject).value(forKey:"date") as? String)!)
                            let isblock = String(((listarray[i] as AnyObject).value(forKey:"isblock") as? Int)!)
                            let blocK_REASON = String(((listarray[i] as AnyObject).value(forKey:"blocK_REASON") as? String)!)
                            let activitY_NAME = String(((listarray[i] as AnyObject).value(forKey:"activitY_NAME") as? String)!)
                            let activitY_SUBJECT = String(((listarray[i] as AnyObject).value(forKey:"activitY_SUBJECT") as? String)!)
                            let insaloN_1_CODE = String(((listarray[i] as AnyObject).value(forKey:"insaloN_1_CODE") as? String)!)
                            let insaloN_1_SUBJECT = String(((listarray[i] as AnyObject).value(forKey:"insaloN_1_SUBJECT") as? String)!)
                            let insaloN_2_CODE = String(((listarray[i] as AnyObject).value(forKey:"insaloN_2_CODE") as? String)!)
                            let insaloN_2_SUBJECT = String(((listarray[i] as AnyObject).value(forKey:"insaloN_2_SUBJECT") as? String)!)
                            let approveD_ACTIVITY_NAME = String(((listarray[i] as AnyObject).value(forKey:"approveD_ACTIVITY_NAME") as? String)!)
                            let approveD_ACTIVITY_SUBJECT = String(((listarray[i] as AnyObject).value(forKey:"approveD_ACTIVITY_SUBJECT") as? String)!)
                            let approveD_INSALON_1_CODE = String(((listarray[i] as AnyObject).value(forKey:"approveD_INSALON_1_CODE") as? String)!)
                            let approveD_INSALON_1_SUBJECT = String(((listarray[i] as AnyObject).value(forKey:"approveD_INSALON_1_SUBJECT") as? String)!)
                            let approveD_INSALON_2_CODE = String(((listarray[i] as AnyObject).value(forKey:"approveD_INSALON_2_CODE") as? String)!)
                            let approveD_INSALON_2_SUBJECT = String(((listarray[i] as AnyObject).value(forKey:"approveD_INSALON_2_SUBJECT") as? String)!)
                            let trainercode = String(((listarray[i] as AnyObject).value(forKey:"trainercode") as? String)!)
                            let shorT_DESC = String(((listarray[i] as AnyObject).value(forKey:"shorT_DESC") as? String)!)
                            let salonnamE1 = String(((listarray[i] as AnyObject).value(forKey:"salonnamE1") as? String)!).replacingOccurrences(of: "'", with: "")
                            let salonnamE2 = String(((listarray[i] as AnyObject).value(forKey:"salonnamE2") as? String)!).replacingOccurrences(of: "'", with: "")
                            let apP_SALONNAME1 = String(((listarray[i] as AnyObject).value(forKey:"apP_SALONNAME1") as? String)!).replacingOccurrences(of: "'", with: "")
                            let apP_SALONNAME2 = String(((listarray[i] as AnyObject).value(forKey:"apP_SALONNAME2") as? String)!).replacingOccurrences(of: "'", with: "")
                            let status = String(((listarray[i] as AnyObject).value(forKey:"status") as? Int)!)
                            
                            self.insertCalender(date: date, activitY_NAME: activitY_NAME, trainercode: trainercode, activitY_SUBJECT: activitY_SUBJECT, insaloN_1_CODE: insaloN_1_CODE, insaloN_1_SUBJECT: insaloN_1_SUBJECT, insaloN_2_CODE: insaloN_2_CODE, insaloN_2_SUBJECT: insaloN_2_SUBJECT, salonnamE1: salonnamE1, salonnamE2: salonnamE2, shorT_DESC: shorT_DESC, status: status, isblock: isblock, blocK_REASON: blocK_REASON, approveD_ACTIVITY_NAME: approveD_ACTIVITY_NAME, approveD_ACTIVITY_SUBJECT: approveD_ACTIVITY_SUBJECT, approveD_INSALON_1_CODE: approveD_INSALON_1_CODE, approveD_INSALON_1_SUBJECT: approveD_INSALON_1_SUBJECT, approveD_INSALON_2_CODE: approveD_INSALON_2_CODE, approveD_INSALON_2_SUBJECT: approveD_INSALON_2_SUBJECT, apP_SALONNAME1: apP_SALONNAME1, apP_SALONNAME2: apP_SALONNAME2)

                       }
                      }
                  }
                      break
                  case .failure(let error): print("error======> \(error)")
                      break
                  }
              }
          }
        
    //http://163.47.143.188:4808/api/GetCalenderPending?TRAINERCODE=TRN001
    //MARK:- URL_GetCalenderPending
    func executeURL_GetCalenderPending1(){
        self.deleteGetCalenderPending()
        Alamofire.request(Constants.BASE_URL + Constants.URL_GetCalenderPending).validate().responseJSON {
            response in
            switch response.result {
            case .success(let value): print("success======> \(value)")
            if  let json = response.result.value{
                let listarray : NSArray = json as! NSArray
                if listarray.count > 0 {
                    for i in 0..<listarray.count{
                        
                        let date = String(((listarray[i] as AnyObject).value(forKey:"date") as? String)!)
                        let changE_REQUESTED = String(((listarray[i] as AnyObject).value(forKey:"changE_REQUESTED") as? String)!)
                        let traineR_CODE = String(((listarray[i] as AnyObject).value(forKey:"traineR_CODE") as? String)!)
                        let impacT_DATE = String(((listarray[i] as AnyObject).value(forKey:"impacT_DATE") as? String)!)
                        let datE_APPLIED = String(((listarray[i] as AnyObject).value(forKey:"datE_APPLIED") as? String)!)
                        let neW_INSALON_1_SUBJECT = String(((listarray[i] as AnyObject).value(forKey:"neW_INSALON_1_SUBJECT") as? String)!)
                        let neW_INSALON_2_SUBJECT = String(((listarray[i] as AnyObject).value(forKey:"neW_INSALON_2_SUBJECT") as? String)!)
                        let shorT_DESC = String(((listarray[i] as AnyObject).value(forKey:"shorT_DESC") as? String)!)
                        let neW_SALONNAME1 = String(((listarray[i] as AnyObject).value(forKey:"neW_SALONNAME1") as? String)!).replacingOccurrences(of: "'", with: "")
                        let neW_SALONCODE1 = String(((listarray[i] as AnyObject).value(forKey:"neW_SALONCODE1") as? String)!)
                        let neW_SALONNAME2 = String(((listarray[i] as AnyObject).value(forKey:"neW_SALONNAME2") as? String)!).replacingOccurrences(of: "'", with: "")
                        let neW_SALONCODE2 = String(((listarray[i] as AnyObject).value(forKey:"neW_SALONCODE2") as? String)!)
                        let neW_ACTIVITY_SUBJECT = String(((listarray[i] as AnyObject).value(forKey:"neW_ACTIVITY_SUBJECT") as? String)!)
                        
                        self.insertCalenderPending(date: date, changE_REQUESTED: changE_REQUESTED, traineR_CODE: traineR_CODE, impacT_DATE: impacT_DATE, datE_APPLIED: datE_APPLIED, neW_INSALON_1_SUBJECT: neW_INSALON_1_SUBJECT, neW_INSALON_2_SUBJECT: neW_INSALON_2_SUBJECT, shorT_DESC: shorT_DESC, neW_SALONNAME1: neW_SALONNAME1, neW_SALONCODE1: neW_SALONCODE1, neW_SALONNAME2: neW_SALONNAME2, neW_SALONCODE2: neW_SALONCODE2, neW_ACTIVITY_SUBJECT: neW_ACTIVITY_SUBJECT)
                    }
                }
            }
                break
                
            case .failure(let error): print("error======> \(error)")
            
                break
            }
            SwiftEventBus.post("setcalendar")
        }
    }

}


