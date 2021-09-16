//
//  DatabaseConnection.swift
//  Wella.2
//
//  Created by Acxiom on 14/09/18.
//  Copyright © 2018 Acxiom. All rights reserved.
//


import UIKit
import SQLite3
import Alamofire

public class DatabaseConnection: UIViewController  {
    
    public static var dbs: OpaquePointer?
    var i=0;
    var j=0;
    public func branddatas (){
        
        let fileUrl = try!
            FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("WellaDatabase.sqlite")
        
        
        if sqlite3_open(fileUrl.path, &DatabaseConnection.dbs) != SQLITE_OK{
            print("Error in opening Database")
            return
        }
        print("path======> (\(fileUrl))")
        print("database created")
        
        let createTable = "CREATE TABLE IF NOT EXISTS Brand (productgroup TEXT,amT_YTD TEXT,noofcustomeR_YTD TEXT,amT_MTD TEXT,noofcustomeR_MTD TEXT)"
        
        let dtrlisttable = "CREATE TABLE IF NOT EXISTS Dtrlisttable (saloncode text,date TEXT,training TEXT,salon TEXT,stylist TEXT,trainingtype TEXT,stylistname TEXT,stylistmobileno TEXT,trainingdoc TEXT)"
        
        let mystylistlisttable = "CREATE TABLE IF NOT EXISTS MystylistList (slno TEXT, stylist TEXT, contact TEXT, salon TEXT, seller TEXT)"
        
        let Branchtable = "CREATE TABLE IF NOT EXISTS Branch (sitecode TEXT,sitename TEXT)"
        
        let createTableProfileImage = "CREATE TABLE IF NOT EXISTS ProfileImage(userimage TEXT)"
        
        let userdetailtable = "CREATE TABLE IF NOT EXISTS User_Profile (regionname TEXT,zonecode TEXT,saleofficecode TEXT,sitecode TEXT,sitename TEXT,trainercode TEXT,trainername TEXT,expertise TEXT,expertisename TEXT,address TEXT,contactno TEXT,email TEXT,isblocked TEXT,levelcode TEXT,levelname TEXT,doj TEXT,designation TEXT,statecode TEXT,statename TEXT)"
        
        let GetMyInsalontable = "CREATE TABLE IF NOT EXISTS SalonDetail (sitE_CODE text,saloncode text,salonname text,addres text,contact text,beatName Text,psrcode text,psrname text)"
        
        
        let Getmytraining =  "CREATE TABLE IF NOT EXISTS TrainingMaster (trainingcode text,trainingname text)"
        
//        let Getmyworkshop = "CREATE TABLE IF NOT EXISTS InsertWorkshop(date text,trainingcode text,traininglocations text ,branchcode text, saloncodes text, salonname text,sellercodes text,addresses text,noofstylisttrainedstr text,post text,modelno text,remark text,id text,Lat text,longi text,datetime text,salonremark text,stylistname text,stylistcontact text)"
        
        let Getcategory = "CREATE TABLE IF NOT EXISTS AddCategory(catgcode text, catgname text)"
        
        let Getlevel = "CREATE TABLE IF NOT EXISTS Addlevel(levelcode text, levelname text)"
        
        let Getsalontracking = "CREATE TABLE IF NOT EXISTS Salontracking(productgroup text,amT_YTD text,amT_MTD text,noofcustomeR_YTD text,noofcustomeR_MTD text)"
        
        let POSTAddstylist = "CREATE TABLE IF NOT EXISTS Addstylist(stylistname text,sitecode text,saloncode text,contact text,email text,address text,lat text,long text,usercode text,category text,levelcode text,sellercode text,image text,post text,id text)"
        
        let PostSynclog = "CREATE TABLE IF NOT EXISTS PostSynclog(Tablename text,Device text,Manufecture text,Osversion text,AppVersion text,Datetime text,Status text,Userid text,Usertype text,Syncid text,post text)"
        
        let GetDashboardTiles = "CREATE TABLE IF NOT EXISTS dsu(doorstrained text,stylisttrained text,uniquedoorstrained text,topdoorstrained text,doorstrainedach text,stylisttrainedach text,uniquedoorstrainedach text,topdoorstrainedach text,insalon text,virtualtraining text,workshop text)"
        let GetTrainingLineChart = "CREATE TABLE IF NOT EXISTS traininglinechart(trainingmonth text,trainingconducted text)"

        let GetStylistLineChart = "CREATE TABLE IF NOT EXISTS stylistlinechart(trainingmonth text,participantcount text)"

        let GetPieChart = "CREATE TABLE IF NOT EXISTS piechartdata(trainingname text , counttrainingcode text)"

        let Getsalontrackingdata = "CREATE TABLE IF NOT EXISTS salontrackingdata(brand text,l2msales text,mtdly text,mtdty text,ytdly text,ytdty text,type text)"
        
        let GetSalonData = "CREATE TABLE IF NOT EXISTS salon(saloncode text, salonname text, salonaddress text, sitecode text , psrcode text)"
        
        let GetCityMaster = "CREATE TABLE IF NOT EXISTS citymaster(cityid text, cityname text, statename text)"
        
         let PostAddStylist = "CREATE TABLE IF NOT EXISTS AddStylistPost( trnappid text, stylistname text,sitecode text,saloncode text,contact text,email text,address text,lat text,long text,usercode text,gender text,city text,dob text ,anniversary text,colorlevel text,verified text,post text)"
        
        let PostEditStylist = "CREATE TABLE IF NOT EXISTS EditStylistPost (trnappid text,trainercode text,entrytype text,impactdate text,dateapplied text,stylistcode text,dob text ,newdob text,saloncode text, newsaloncode text,address text,newaddress text,city text,newcity text,anniversary text,newanniversary text,status text,createddatetime text,createdby text,dataareaid text,post text, gender text)"
        
        let GetStylistByContactNo = "CREATE TABLE IF NOT EXISTS StylistbyContactNo(stylistcode text,stylistname text,sitecode text,sitename text,saloncode text,salonname text,contact text,email text,address text,gender text,city text,anniversary text,colorlevel text,dob text,stylistaddress text)"
        
        let PostHotDayMarketVisit = "CREATE TABLE IF NOT EXISTS hotdaymarketvisit(trnappid text,trainercode text,trainingtype text,salonname text, saloncode text , location text , lat text , long text , trainingdate text , salonaddress text , post text,sitecode text,sellercode text,isedit text , remark text)"
        
        let PostAddLeave = "CREATE TABLE IF NOT EXISTS addleave(trnappid text,trainingtype text,trainercode text,lat text,long text,trainingdate text,post text)"

        let PostInternalOtherTraining = "CREATE TABLE IF NOT EXISTS internalotherpost(trnappid text,trainingtype text,trainercode text,lat text,long text,trainingdate text,remark text ,post text)"
        
        let PostSalonWorkshopHeadar = "CREATE TABLE IF NOT EXISTS SalonWorkshopHeadar (TRNAPPID text,TRAININGTYPE text,TRAININGCODE text,TRAINERCODE text, SITECODE text , SELLERCODE text , Lat text , Long text , TRAININGDATE text , REMARK text,Post text,ENDDATE text,SALONCODE text,isEdit text,nop text,colorcode text,salonname text,subject text )"
        
        let POSTMyInSalontable = "CREATE TABLE IF NOT EXISTS InSalonDetail(TRNAPPID text,trainingtype text,  trainercodes text,  trainername text,  sitecodes text,salonecodes text,  noofstyletrainer text,  noofmodeluser text,  remark text,traininglocations text,lat text,  longi text,trainingdate text,post text,InSalonDetailID text,SELLERCODE text,address text,datetime text,salonremark text , stylistmobileno text ,stylistname text,salonname text,STYLISTCODE text, isEdit Text,colorcode text)"
        
        let GetStylistData = "CREATE TABLE IF NOT EXISTS stylist(stylistname text,stylistcode text, contact text,salonname text,saloncode text)"
        
        let POSTVirtualTrainingtable = "CREATE TABLE IF NOT EXISTS VirtualTrainingUpdate(TRNAPPID text,TRAININGDATE,STYLISTCODE text,STYLISTNAME text,STYLISTMOBILENO text,SALONCODE text,SALONREMARK text,TRAININGSUBJECT text,post text,isEdit text,colorcode text)"
        
          let GETTrainingDetails = "CREATE TABLE IF NOT EXISTS TrainingDetails(trainingcode text,trainingname text,ismultidayworkshop text,trainingdate text,workshopdaY2DATE text,workshopdaY3DATE text,day text)"
        
        let POSTInsertWorkshoptable = "CREATE TABLE IF NOT EXISTS InsertWorkshop(TRNAPPID text,date text,trainingcode text,traininglocations text,branchcode text,saloncodes text,salonname text,sellercodes text,addresses text,noofstylisttrainedstr text,post text,modelno text,remark text,id text,Lat text,longi text,datetime text,salonremark text , stylistmobileno text ,stylistname text,stylistcode text,isEdit text)"
        
        let POSTWorkshopHeaderUpdatedtable = "CREATE TABLE IF NOT EXISTS WorkshopHeaderUpdated (TRNAPPID text,TRAININGTYPE text,TRAININGCODE text,TRAINERCODE text, SITECODE text , SELLERCODE text , Lat text , Long text , TRAININGDATE text , REMARK text,Post text,WORKSHOPDAY2DATE text,WORKSHOPDAY3DATE text,ISMULTIDAYWORKSHOP text,isEdit text,LOCATION text)"
        
        let GetHomeProd = "CREATE TABLE IF NOT EXISTS HomeProd(productivecount text,totalproductivecount text,productivecountlm text,totalfycount text,prodper text)"
        
        let GetHomeProd_UnProd = "CREATE TABLE IF NOT EXISTS HomeProd_UnProd(typecustomer text,customeR_CODE text)"
        
        let GetColorLevel = "CREATE TABLE IF NOT EXISTS ColorLevel(trainingname text,level text)"
        
        let GetUserProfileNew = "CREATE TABLE IF NOT EXISTS UserProfileNew(trainercode text,trainername text,contactno text,email text,reportinGMANAGER text,stylisTTRAINEDYTD text,uniquedoorSTRAINEDYTD  text,traininGCONDUCTEDYTD text,toPDOORSTRAINEDYTD text)"
        
        let GETALLOWTRAININGTYPEMASTER = "CREATE TABLE IF NOT EXISTS GetAllowTrainingTypeMaster(primarY_DESCRIPTION text,secondarY_DESCRIPTION text)"
        
        let GETCalender = "CREATE TABLE IF NOT EXISTS Calender (date text,activitY_NAME text,trainercode text,activitY_SUBJECT text,insaloN_1_CODE text,insaloN_1_SUBJECT text,insaloN_2_CODE text,insaloN_2_SUBJECT text,salonnamE1 text,salonnamE2 text,shorT_DESC text,status text,isblock text,blocK_REASON text,approveD_ACTIVITY_NAME text,approveD_ACTIVITY_SUBJECT text,approveD_INSALON_1_CODE text,approveD_INSALON_1_SUBJECT text,approveD_INSALON_2_CODE text,approveD_INSALON_2_SUBJECT text,apP_SALONNAME1 text,apP_SALONNAME2 text)"
        
        let PostCalender = "CREATE TABLE IF NOT EXISTS  PostCalender (ENTRY_TYPE text,TRAINER_CODE text,IMPACT_DATE text,PLANNED_ACTIVITY text,CHANGE_REQUESTED text,DATE_APPLIED text,STATUS text ,CREATEDDATETIME text,CREATEDBY text,DATAAREAID text, TRNAPPID text, Post text,INSALON_1_CODE text,NEW_INSALON_1_CODE text,INSALON_1_SUBJECT text,NEW_INSALON_1_SUBJECT text,INSALON_2_CODE text,NEW_INSALON_2_CODE text,INSALON_2_SUBJECT text,NEW_INSALON_2_SUBJECT text,ACTIVITY_SUBJECT text,NEW_ACTIVITY_SUBJECT text)"
        
        let GetCalenderPending = "CREATE TABLE IF NOT EXISTS GetCalenderPending (date text, changE_REQUESTED text,traineR_CODE text, impacT_DATE text,datE_APPLIED text,neW_INSALON_1_SUBJECT text,neW_INSALON_2_SUBJECT text,shorT_DESC text,neW_SALONNAME1 text,neW_SALONCODE1 text,neW_SALONNAME2 text,neW_SALONCODE2 text,neW_ACTIVITY_SUBJECT text)"
        
        let PostDeleteData = "CREATE  TABLE IF NOT EXISTS  PostDeleteData (TRNAPPID text,TRAINERCODE text,DATAAREAID text,Post text,ActivityType text)"
        
        if sqlite3_exec(DatabaseConnection.dbs, Getcategory, nil, nil, nil) != SQLITE_OK{
            print("Error creating Table\(Getcategory)")
            return
        }
        if sqlite3_exec(DatabaseConnection.dbs, Getlevel, nil, nil, nil) != SQLITE_OK{
            print("Error creating Table\(Getlevel)")
            return
        }
        if sqlite3_exec(DatabaseConnection.dbs, createTable, nil, nil, nil) != SQLITE_OK{
            print("Error creating Table\(createTable)")
            return
        }
        if sqlite3_exec(DatabaseConnection.dbs, Getmytraining, nil, nil, nil) != SQLITE_OK{
            print("Error creating Table\(Getmytraining)")
            return
        }
        if sqlite3_exec(DatabaseConnection.dbs, GetMyInsalontable, nil, nil, nil) != SQLITE_OK{
            print("Error creating Table\(GetMyInsalontable)")
            return
        }
        if sqlite3_exec(DatabaseConnection.dbs, mystylistlisttable, nil, nil, nil) != SQLITE_OK{
            print("Error creating Table\(mystylistlisttable)")
            return
        }
        if sqlite3_exec(DatabaseConnection.dbs, userdetailtable, nil, nil, nil) != SQLITE_OK{
            print("Error creating Table\(userdetailtable)")
            return
        }
        if sqlite3_exec(DatabaseConnection.dbs, dtrlisttable, nil, nil, nil) != SQLITE_OK{
            print("Error creating Table\(dtrlisttable)")
            return
        }
        if sqlite3_exec(DatabaseConnection.dbs, Branchtable, nil, nil, nil) != SQLITE_OK{
            print("Error creating Table \(Branchtable)")
            return
        }
        if sqlite3_exec(DatabaseConnection.dbs, createTableProfileImage, nil, nil, nil) != SQLITE_OK{
            print("Error creating Table \(createTableProfileImage)")
            return
        }
//        if sqlite3_exec(DatabaseConnection.dbs, Getmyworkshop, nil, nil, nil) != SQLITE_OK{
//            print("Error creating Table \(Getmyworkshop)")
//            return
//        }
        if sqlite3_exec(DatabaseConnection.dbs, Getsalontracking, nil, nil, nil) != SQLITE_OK{
            print("Error creating Table \(Getsalontracking)")
            return
        }
        if sqlite3_exec(DatabaseConnection.dbs, POSTAddstylist, nil, nil, nil) != SQLITE_OK{
            print("Error creating Table \(POSTAddstylist)")
            return
        }
        if sqlite3_exec(DatabaseConnection.dbs, PostSynclog, nil, nil, nil) != SQLITE_OK{
            print("Error creating Table \(PostSynclog)")
            return
        }
        
        if sqlite3_exec(DatabaseConnection.dbs, GetDashboardTiles, nil, nil, nil) != SQLITE_OK{
            print("Error creating Table\(GetDashboardTiles)")
            return
        }
        if sqlite3_exec(DatabaseConnection.dbs, GetTrainingLineChart, nil, nil, nil) != SQLITE_OK{
            print("Error creating Table\(GetTrainingLineChart)")
            return
        }
        if sqlite3_exec(DatabaseConnection.dbs, GetStylistLineChart, nil, nil, nil) != SQLITE_OK{
            print("Error creating Table\(GetStylistLineChart)")
            return
        }
        if sqlite3_exec(DatabaseConnection.dbs, GetPieChart, nil, nil, nil) != SQLITE_OK{
            print("Error creating Table\(GetPieChart)")
            return
        }
        if sqlite3_exec(DatabaseConnection.dbs, Getsalontrackingdata, nil, nil, nil) != SQLITE_OK{
            print("Error creating Table\(Getsalontrackingdata)")
            return
        }
        if sqlite3_exec(DatabaseConnection.dbs, GetSalonData, nil, nil, nil) != SQLITE_OK{
            print("Error creating Table\(GetSalonData)")
            return
        }
        if sqlite3_exec(DatabaseConnection.dbs, GetCityMaster, nil, nil, nil) != SQLITE_OK{
            print("Error creating Table\(GetCityMaster)")
            return
        }
       if sqlite3_exec(DatabaseConnection.dbs, PostAddStylist, nil, nil, nil) != SQLITE_OK{
            print("Error creating Table\(PostAddStylist)")
            return
        }
        if sqlite3_exec(DatabaseConnection.dbs, PostEditStylist, nil, nil, nil) != SQLITE_OK{
            print("Error creating Table\(PostEditStylist)")
            return
        }
        if sqlite3_exec(DatabaseConnection.dbs, GetStylistByContactNo, nil, nil, nil) != SQLITE_OK{
            print("Error creating Table\(GetStylistByContactNo)")
            return
        }
        if sqlite3_exec(DatabaseConnection.dbs, PostHotDayMarketVisit, nil, nil, nil) != SQLITE_OK{
            print("Error creating Table\(PostHotDayMarketVisit)")
            return
        }
        if sqlite3_exec(DatabaseConnection.dbs, PostAddLeave, nil, nil, nil) != SQLITE_OK{
            print("Error creating Table\(PostAddLeave)")
            return
        }
        if sqlite3_exec(DatabaseConnection.dbs, PostInternalOtherTraining, nil, nil, nil) != SQLITE_OK{
            print("Error creating Table\(PostInternalOtherTraining)")
            return
        }
        if sqlite3_exec(DatabaseConnection.dbs, PostSalonWorkshopHeadar, nil, nil, nil) != SQLITE_OK{
            print("Error creating Table\(PostSalonWorkshopHeadar)")
            return
        }
        if sqlite3_exec(DatabaseConnection.dbs, GetStylistData, nil, nil, nil) != SQLITE_OK{
            print("Error creating Table\(GetStylistData)")
            return
        }
        if sqlite3_exec(DatabaseConnection.dbs, POSTMyInSalontable, nil, nil, nil) != SQLITE_OK{
            print("Error creating Table\(POSTMyInSalontable)")
            return
        }
        if sqlite3_exec(DatabaseConnection.dbs, POSTVirtualTrainingtable, nil, nil, nil) != SQLITE_OK{
            print("Error creating Table\(POSTVirtualTrainingtable)")
            return
        }
        if sqlite3_exec(DatabaseConnection.dbs, GETTrainingDetails, nil, nil, nil) != SQLITE_OK{
            print("Error creating Table\(GETTrainingDetails)")
            return
        }
        if sqlite3_exec(DatabaseConnection.dbs, POSTInsertWorkshoptable, nil, nil, nil) != SQLITE_OK{
            print("Error creating Table\(POSTInsertWorkshoptable)")
            return
        }
        if sqlite3_exec(DatabaseConnection.dbs, POSTWorkshopHeaderUpdatedtable, nil, nil, nil) != SQLITE_OK{
            print("Error creating Table\(POSTWorkshopHeaderUpdatedtable)")
            return
        }
        if sqlite3_exec(DatabaseConnection.dbs, GetHomeProd, nil, nil, nil) != SQLITE_OK{
            print("Error creating Table\(GetHomeProd)")
            return
        }
        if sqlite3_exec(DatabaseConnection.dbs, GetHomeProd_UnProd, nil, nil, nil) != SQLITE_OK{
            print("Error creating Table\(GetHomeProd_UnProd)")
            return
        }
        if sqlite3_exec(DatabaseConnection.dbs, GetColorLevel, nil, nil, nil) != SQLITE_OK{
            print("Error creating Table\(GetColorLevel)")
            return
        }
        if sqlite3_exec(DatabaseConnection.dbs, GetUserProfileNew, nil, nil, nil) != SQLITE_OK{
            print("Error creating Table\(GetUserProfileNew)")
            return
        }
        if sqlite3_exec(DatabaseConnection.dbs, GETALLOWTRAININGTYPEMASTER, nil, nil, nil) != SQLITE_OK{
            print("Error creating Table\(GETALLOWTRAININGTYPEMASTER)")
            return
        }
        if sqlite3_exec(DatabaseConnection.dbs, GETCalender, nil, nil, nil) != SQLITE_OK{
            print("Error creating Table\(GETCalender)")
            return
        }
        if sqlite3_exec(DatabaseConnection.dbs, PostCalender, nil, nil, nil) != SQLITE_OK{
            print("Error creating Table\(PostCalender)")
            return
        }
        if sqlite3_exec(DatabaseConnection.dbs, GetCalenderPending, nil, nil, nil) != SQLITE_OK{
            print("Error creating Table\(GetCalenderPending)")
            return
        }
        if sqlite3_exec(DatabaseConnection.dbs, PostDeleteData, nil, nil, nil) != SQLITE_OK{
            print("Error creating Table\(PostDeleteData)")
            return
        }
        print("Everything is Fine")
    }
    
    public func onUpgrade (oldversion: Int16!  , newversion: Int16! ) ->Int16 {
        
        if oldversion < newversion
        {
            if oldversion < 2
            {
                //                let q = "alter table brand add column test text"
                //                if sqlite3_exec(DatabaseConnection.dbs, q, nil, nil, nil) != SQLITE_OK{
                //                    print("Error adding")
                //
                //                }
                //                else{
                //                print("brand table altered")
                //                }
            }
        }
        return newversion
    }
    
    public func deletebrandtable (){
        let deltable = "DELETE FROM Brand"
        
        if sqlite3_exec(DatabaseConnection.dbs, deltable, nil, nil, nil) != SQLITE_OK{
            print("Error Deleting Table: Brand")
            return
        }
        print("brand table deleted")
    }
    public func deleteworkshopline (datetime: String?){
        let deltable = "DELETE FROM InsertWorkshop WHERE datetime = '" + datetime! + "'"
        
        if sqlite3_exec(DatabaseConnection.dbs, deltable, nil, nil, nil) != SQLITE_OK{
            print("Error Deleting LINE: InsertWorkshop")
            return
        }
        print("line with \(String(describing: datetime)) as id is deleted: InsertWorkshop")
    }
    public func deleteinsalondata (){
        let deltable = "DELETE FROM SalonDetail"
        
        if sqlite3_exec(DatabaseConnection.dbs, deltable, nil, nil, nil) != SQLITE_OK{
            print("Error Deleting Table: Salondetail")
            return
        }
        print("SalonDetail table deleted")
    }
    public func deletebranchtable (){
        let deltable = "DELETE FROM Branch"
        
        if sqlite3_exec(DatabaseConnection.dbs, deltable, nil, nil, nil) != SQLITE_OK{
            print("Error Deleting branch Table: Branch")
            return
        }
        print("branch table deleted")
    }
    public func deletedtrlisttable (){
        let deltable = "DELETE FROM Dtrlisttable"
        
        if sqlite3_exec(DatabaseConnection.dbs, deltable, nil, nil, nil) != SQLITE_OK{
            print("Error Deleting DTRlist Table: Dtrlist")
            return
        }
        print("Dtrlistdata table deleted")
    }
    public func deleteuserdetailtable (){
        let deltable = "DELETE FROM User_Profile"
        
        if sqlite3_exec(DatabaseConnection.dbs, deltable, nil, nil, nil) != SQLITE_OK{
            print("Error Deleting userDetail Table: User_Profile")
            return
        }
        print("userDetail table deleted")
    }
    public func deletemystylisttable ()
    {
        let deltable = "DELETE FROM MystylistList"
        
        if sqlite3_exec(DatabaseConnection.dbs, deltable, nil, nil, nil) != SQLITE_OK{
            print("Error Deleting MystylistList Table: MystylistList")
            return
        }
        print("MystylistList table deleted")
    }
    public func deletsalontrackingtable (){
        let deltable = "DELETE FROM Salontracking"
        
        if sqlite3_exec(DatabaseConnection.dbs, deltable, nil, nil, nil) != SQLITE_OK{
            print("Error Deleting Table: Salontracking")
            return
        }
        print("Salontracking table deleted")
    }
    
    
    public func insertdashlist(productgroup: String?, distrimtd: String?, distriytd: String?, volumeytd: String?, volumemtd: String?){
        
        var stmt: OpaquePointer? = nil
        let product1: NSString = String(productgroup!) as NSString
        let distrimtd1: NSString = String(distrimtd!) as NSString
        let distriytd1: NSString = String(distriytd!) as NSString
        let volumemtd1: NSString = String(volumemtd!) as NSString
        let volumeytd1: NSString = String(volumeytd!) as NSString
        
        let query = "INSERT INTO Brand (productgroup,amT_YTD,noofcustomeR_YTD,amT_MTD,noofcustomeR_MTD) VALUES (?,?,?,?,?)"
        if sqlite3_prepare_v2(DatabaseConnection.dbs, query, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(DatabaseConnection.dbs)!)
            print("error preparing insert: \(errmsg)")
            return
        }
        
        // binding the parameters
        if sqlite3_bind_text(stmt, 1, product1.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(DatabaseConnection.dbs)!)
            print("failure binding \(String(describing: product1)): \(errmsg)")
            return
        }
        print("\(String(describing: product1))")
        
        if sqlite3_bind_text(stmt, 2, distriytd1.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(DatabaseConnection.dbs)!)
            print("failure binding \(String(describing: distriytd1)): \(errmsg)")
            return
        }
        
        print("\(String(describing: distriytd1))")
        
        if sqlite3_bind_text(stmt, 3, volumeytd1.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(DatabaseConnection.dbs)!)
            print("failure binding \(String(describing: volumeytd1)): \(errmsg)")
            return
        }
        
        print("\(String(describing: volumeytd1))")
        
        if sqlite3_bind_text(stmt, 4, distrimtd1.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(DatabaseConnection.dbs)!)
            print("failure binding \(String(describing: distrimtd1)): \(errmsg)")
            return
        }
        
        print("\(String(describing: distrimtd1))")
        
        if sqlite3_bind_text(stmt, 5, volumemtd1.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(DatabaseConnection.dbs)!)
            print("failure binding \(String(describing: volumemtd1)): \(errmsg)")
            return
        }
        
        print("\(String(describing: volumemtd1))")
        
        if sqlite3_step(stmt) != SQLITE_DONE {
            let errmsg = String(cString: sqlite3_errmsg(DatabaseConnection.dbs)!)
            print("failure inserting Brand data: \(errmsg)")
            return
        }
        i=i+1
        print("data saved successfully \(i)")
    }
    
    public func insertbranchspinner (siteid: String?, sitename: String?) {
        var stmt: OpaquePointer? = nil
        
        let siteid1: NSString = String(siteid!) as NSString
        let sitename1: NSString = String(sitename!) as NSString
        
        let query = "INSERT INTO Branch (sitecode, sitename) VALUES (?,?)"
        
        if sqlite3_prepare_v2(DatabaseConnection.dbs, query, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(DatabaseConnection.dbs)!)
            print("error preparing insert: \(errmsg)")
            return
        }
        if sqlite3_bind_text(stmt, 1, siteid1.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(DatabaseConnection.dbs)!)
            print("failure binding \(String(describing: siteid1)): \(errmsg)")
            return
        }
        print("sitecode============>\(String(describing: siteid1))")
        
        if sqlite3_bind_text(stmt, 2, sitename1.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(DatabaseConnection.dbs)!)
            print("failure binding \(String(describing: sitename1)): \(errmsg)")
            return
        }
        print("sitename============>\(String(describing: sitename1))")
        
        if sqlite3_step(stmt) != SQLITE_DONE {
            let errmsg = String(cString: sqlite3_errmsg(DatabaseConnection.dbs)!)
            print("failure inserting Branchspinner data: \(errmsg)")
            return
        }
        else {
            print("\(sqlite3_step(stmt))")
        }
        j=j+1
        print("\n branch table data inserted successfully \(j) ")
    }
    public func insertProfileImage(userimage: String?){
        var ptr: OpaquePointer? = nil
        let userimage1: NSString = String(userimage!) as NSString
        //ProfileImage(userimage TEXT)"
        let query = "INSERT INTO ProfileImage(userimage) VALUES (?)"
        if sqlite3_prepare(DatabaseConnection.dbs, query, -1, &ptr, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(DatabaseConnection.dbs)!)
            print("error preparing insert Profile: \(errmsg)")
            return
        }
        
        //binding the parameters
        if sqlite3_bind_text(ptr, 1, userimage1.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(DatabaseConnection.dbs)!)
            print("failure binding \(String(describing: userimage1)): \(errmsg)")
            return
        }
        print("Profile Image Inserted")
        if sqlite3_step(ptr) != SQLITE_DONE {
            let errmsg = String(cString: sqlite3_errmsg(DatabaseConnection.dbs)!)
            print("failure inserting Branchspinner data: \(errmsg)")
            return
        }
    }
    
    public func insertgetmyinsalon(sitecode: String?, saloncode: String?, salonname: String?, addres: String?,contact: String?, beatname: String?, psrcode: String?, psrname: String?){
        var stmt: OpaquePointer? = nil
        let sitecode1: NSString = String(sitecode!) as NSString
        let saloncode1: NSString = String(saloncode!) as NSString
        let salonname1: NSString = String(salonname!) as NSString
        let addres1: NSString = String(addres!) as NSString
        let contact1: NSString = String(contact!) as NSString
        let beatname1: NSString = String(beatname!) as NSString
        let psrcode1: NSString = String(psrcode!) as NSString
        let psrname1: NSString = String(psrname!) as NSString
        
        let query = "INSERT INTO SalonDetail(sitE_CODE,saloncode ,salonname ,addres ,contact,beatName ,psrcode,psrname) VALUES (?,?,?,?,?,?,?,?)"
        if sqlite3_prepare_v2(DatabaseConnection.dbs, query, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(DatabaseConnection.dbs)!)
            print("error preparing insert: \(errmsg)")
            return
        }
        
        
        // binding the parameters
        if sqlite3_bind_text(stmt, 1, sitecode1.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(DatabaseConnection.dbs)!)
            print("failure binding \(String(describing: sitecode1)): \(errmsg)")
            return
        }
        print("\(String(describing: sitecode1))")
        if sqlite3_bind_text(stmt, 2, saloncode1.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(DatabaseConnection.dbs)!)
            print("failure binding \(String(describing: saloncode1)): \(errmsg)")
            return
        }
        print("\(String(describing: saloncode1))")
        if sqlite3_bind_text(stmt, 3, salonname1.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(DatabaseConnection.dbs)!)
            print("failure binding \(String(describing: salonname1)): \(errmsg)")
            return
        }
        print("\(String(describing: salonname1))")
        if sqlite3_bind_text(stmt, 4, addres1.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(DatabaseConnection.dbs)!)
            print("failure binding \(String(describing: addres1)): \(errmsg)")
            return
        }
        print("\(String(describing: addres1))")
        if sqlite3_bind_text(stmt, 5, contact1.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(DatabaseConnection.dbs)!)
            print("failure binding \(String(describing: contact1)): \(errmsg)")
            return
        }
        print("\(String(describing: contact1))")
        if sqlite3_bind_text(stmt, 6, beatname1.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(DatabaseConnection.dbs)!)
            print("failure binding \(String(describing: beatname1)): \(errmsg)")
            return
        }
        print("\(String(describing: beatname1))")
        if sqlite3_bind_text(stmt, 7, psrcode1.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(DatabaseConnection.dbs)!)
            print("failure binding \(String(describing: psrcode1)): \(errmsg)")
            return
        }
        print("\(String(describing: psrcode1))")
        if sqlite3_bind_text(stmt, 8, psrname1.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(DatabaseConnection.dbs)!)
            print("failure binding \(String(describing: psrname1)): \(errmsg)")
            return
        }
        print("\(String(describing: psrname1))")
        
        if sqlite3_step(stmt) != SQLITE_DONE {
            let errmsg = String(cString: sqlite3_errmsg(DatabaseConnection.dbs)!)
            print("failure inserting Brand data: \(errmsg)")
            return
        }
        print("Data in Get My Insalon table inserted")
        
    }
    
    func  getProfileImage() -> String
    {
        
        var strBase64: String?
        var stmt1:OpaquePointer? = nil
        let queryString = "SELECT * FROM ProfileImage"
        
        
        
        if sqlite3_prepare_v2(DatabaseConnection.dbs, queryString, -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(DatabaseConnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return ""
        }
        
        while(sqlite3_step(stmt1) == SQLITE_ROW){
            strBase64 = String(cString: sqlite3_column_text(stmt1, 0))
        }
        
        if strBase64 == nil || strBase64 == ""
        {
            return  ""
        }
        
        return String(strBase64!)
    }
    
    //stylistname TEXT,stylistmobileno TEXT,trainingdoc TEXT
    public func insertdtrlist(saloncode: String?,date: String?, training: String?, trainingtype: String?, salon: String?, stylist: String?,stylistname: String?,stylistmobileno: String?, trainingdoc: String? ) {
        var stmt: OpaquePointer? = nil
        let date1: NSString = String(date!) as NSString
        let training1:NSString = String(training!) as NSString
        let salon1:NSString = String(salon!) as NSString
        let stylist1:NSString = String(stylist!) as NSString
        let trainingtype1:NSString = String(trainingtype!) as NSString
        let stylistname1:NSString = String(stylistname!) as NSString
        let stylistmobileno1:NSString = String(stylistmobileno!) as NSString
        let trainingdoc1:NSString = String(trainingdoc!) as NSString
        let saloncode:NSString = String(saloncode!) as NSString
        
        let query  = "INSERT INTO dtrlisttable(date,training,salon,stylist,trainingtype,stylistname,stylistmobileno,trainingdoc,saloncode) VALUES (?,?,?,?,?,?,?,?,?)"
        
        if sqlite3_prepare(DatabaseConnection.dbs, query, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(DatabaseConnection.dbs)!)
            print("error preparing insert: \(errmsg)")
            return
        }
        if sqlite3_bind_text(stmt, 1, date1.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(DatabaseConnection.dbs)!)
            print("failure binding \(String(describing: date1)): \(errmsg)")
            return
        }
        print("inserted===============>  \(String(describing: date1))")
        if sqlite3_bind_text(stmt, 2, training1.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(DatabaseConnection.dbs)!)
            print("failure binding \(String(describing: training1)): \(errmsg)")
            return
        }
        print("inserted===============>  \(String(describing: training1))")
        if sqlite3_bind_text(stmt, 3, salon1.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(DatabaseConnection.dbs)!)
            print("failure binding \(String(describing: salon1)): \(errmsg)")
            return
        }
        print("inserted===============>  \(String(describing: salon1))")
        if sqlite3_bind_text(stmt, 4, stylist1.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(DatabaseConnection.dbs)!)
            print("failure binding \(String(describing: stylist1)): \(errmsg)")
            return
        }
        print("inserted===============>  \(String(describing: stylist1))")
        if sqlite3_bind_text(stmt, 5, trainingtype1.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(DatabaseConnection.dbs)!)
            print("failure binding \(String(describing: trainingtype1)): \(errmsg)")
            return
        }
        print("inserted===============>  \(String(describing: trainingtype1))")
        if sqlite3_bind_text(stmt, 6, stylistname1.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(DatabaseConnection.dbs)!)
            print("failure binding \(String(describing: stylistname1)): \(errmsg)")
            return
        }
        print("inserted===============>  \(String(describing: stylistname1))")
        if sqlite3_bind_text(stmt, 7, stylistmobileno1.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(DatabaseConnection.dbs)!)
            print("failure binding \(String(describing: stylistmobileno1)): \(errmsg)")
            return
        }
        print("inserted===============>  \(String(describing: stylistmobileno1))")
        if sqlite3_bind_text(stmt, 8, trainingdoc1.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(DatabaseConnection.dbs)!)
            print("failure binding \(String(describing: trainingdoc1)): \(errmsg)")
            return
        }
        print("inserted===============>  \(String(describing: trainingdoc1))")
        if sqlite3_bind_text(stmt, 9, saloncode.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(DatabaseConnection.dbs)!)
            print("failure binding \(String(describing: saloncode)): \(errmsg)")
            return
        }
        print("inserted===============>  \(String(describing: saloncode))")
        
        if sqlite3_step(stmt) != SQLITE_DONE {
            let errmsg = String(cString: sqlite3_errmsg(DatabaseConnection.dbs)!)
            print("failure inserting Dtrlisttable data: \(errmsg)")
            return
        }
        print("data saved successfully in Dtrlisttable")
    }
    public func insertuserdetail(regionname: String?, zonecode: String?, saleofficecode: String?, sitecode: String?,sitename: String?,trainercode: String?, trainername: String?, expertise: String?, expertisename: String?, address: String?,contactno: String?, email: String?, isblocked: String?, levelcode: String?, levelname: String?, doj: String?,designation: String?,statecode: String?,statename: String?){
        
        var prof: OpaquePointer? = nil
        
        let regionname: NSString = String(regionname!) as NSString
        let zonecode: NSString = String(zonecode!) as NSString
        let saleofficecode: NSString = String(saleofficecode!) as NSString
        let sitecode: NSString = String(sitecode!) as NSString
        let sitename: NSString = String(sitename!) as NSString
        let trainercode: NSString = String(trainercode!) as NSString
        let trainername: NSString = String(trainername!) as NSString
        let expertise: NSString = String(expertise!) as NSString
        let expertisename: NSString = String(expertisename!) as NSString
        let address: NSString = String(address!) as NSString
        let contactno: NSString = String(contactno!) as NSString
        let email: NSString = String(email!) as NSString
        let isblocked: NSString = String(isblocked!) as NSString
        let levelcode: NSString = String(levelcode!) as NSString
        let levelname: NSString = String(levelname!) as NSString
        let doj: NSString = String(doj!) as NSString
        let designation: NSString = String(designation!) as NSString
        let statecode: NSString = String(statecode!) as NSString
        let statename: NSString = String(statename!) as NSString
        
        let query = "INSERT INTO User_Profile (regionname,zonecode,saleofficecode,sitecode,sitename,trainercode,trainername,expertise,expertisename,address,contactno,email,isblocked,levelcode,levelname,doj,designation,statecode,statename) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)"
        
        if sqlite3_prepare(DatabaseConnection.dbs, query, -1, &prof, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(DatabaseConnection.dbs)!)
            print("error preparing insert: \(errmsg)")
            return
        }
        
        // Binding Parameters
        
        if sqlite3_bind_text(prof, 1, regionname.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(DatabaseConnection.dbs)!)
            print("failure binding \(String(describing: regionname)): \(errmsg)")
            return
        }
        if sqlite3_bind_text(prof, 2, zonecode.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(DatabaseConnection.dbs)!)
            print("failure binding \(String(describing: zonecode)): \(errmsg)")
            return
        }
        if sqlite3_bind_text(prof, 3, saleofficecode.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(DatabaseConnection.dbs)!)
            print("failure binding \(String(describing: saleofficecode)): \(errmsg)")
            return
        }
        if sqlite3_bind_text(prof, 4, sitecode.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(DatabaseConnection.dbs)!)
            print("failure binding \(String(describing: sitecode)): \(errmsg)")
            return
        }
        if sqlite3_bind_text(prof, 5, sitename.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(DatabaseConnection.dbs)!)
            print("failure binding \(String(describing: sitename)): \(errmsg)")
            return
        }
        if sqlite3_bind_text(prof, 6, trainercode.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(DatabaseConnection.dbs)!)
            print("failure binding \(String(describing: trainercode)): \(errmsg)")
            return
        }
        
        if sqlite3_bind_text(prof, 7, trainername.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(DatabaseConnection.dbs)!)
            print("failure binding \(String(describing: trainername)): \(errmsg)")
            return
        }
        if sqlite3_bind_text(prof, 8, expertise.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(DatabaseConnection.dbs)!)
            print("failure binding \(String(describing: expertise)): \(errmsg)")
            return
        }
        if sqlite3_bind_text(prof, 9, expertisename.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(DatabaseConnection.dbs)!)
            print("failure binding \(String(describing: expertisename)): \(errmsg)")
            return
        }
        if sqlite3_bind_text(prof, 10, address.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(DatabaseConnection.dbs)!)
            print("failure binding \(String(describing: address)): \(errmsg)")
            return
        }
        if sqlite3_bind_text(prof, 11, contactno.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(DatabaseConnection.dbs)!)
            print("failure binding \(String(describing: contactno)): \(errmsg)")
            return
        }
        
        if sqlite3_bind_text(prof, 12, email.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(DatabaseConnection.dbs)!)
            print("failure binding \(String(describing: email)): \(errmsg)")
            return
        }
        if sqlite3_bind_text(prof, 13, isblocked.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(DatabaseConnection.dbs)!)
            print("failure binding \(String(describing: isblocked)): \(errmsg)")
            return
        }
        if sqlite3_bind_text(prof, 14, levelcode.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(DatabaseConnection.dbs)!)
            print("failure binding \(String(describing: levelcode)): \(errmsg)")
            return
        }
        if sqlite3_bind_text(prof, 15, levelname.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(DatabaseConnection.dbs)!)
            print("failure binding \(String(describing: levelname)): \(errmsg)")
            return
        }
        if sqlite3_bind_text(prof, 16, doj.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(DatabaseConnection.dbs)!)
            print("failure binding \(String(describing: doj)): \(errmsg)")
            return
        }
        if sqlite3_bind_text(prof, 17, designation.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(DatabaseConnection.dbs)!)
            print("failure binding \(String(describing: designation)): \(errmsg)")
            return
        }
        if sqlite3_bind_text(prof, 18, statecode.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(DatabaseConnection.dbs)!)
            print("failure binding \(String(describing: statecode)): \(errmsg)")
            return
        }
        if sqlite3_bind_text(prof, 19, statename.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(DatabaseConnection.dbs)!)
            print("failure binding \(String(describing: statename)): \(errmsg)")
            return
        }
        
        if sqlite3_step(prof) != SQLITE_DONE {
            let errmsg = String(cString: sqlite3_errmsg(DatabaseConnection.dbs)!)
            print("failure inserting User Detail data: \(errmsg)")
            return
        } }
    public func insertmystylist (slno: String?, stylist: String?, contact: String?, salon: String?, seller: String?) {
        
        var stmt: OpaquePointer? = nil
        let slno1: NSString = String(slno!) as NSString
        let stylist1:NSString = String(stylist!) as NSString
        let contact1:NSString = String(contact!) as NSString
        let salon1:NSString = String(salon!) as NSString
        let seller1:NSString = String(seller!) as NSString
        
        let query  = "INSERT INTO MystylistList (slno,stylist,contact,salon,seller) VALUES (?,?,?,?,?)"
        
        if sqlite3_prepare(DatabaseConnection.dbs, query, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(DatabaseConnection.dbs)!)
            print("error preparing insert: \(errmsg)")
            return
        }
        if sqlite3_bind_text(stmt, 1, slno1.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(DatabaseConnection.dbs)!)
            print("failure binding \(String(describing: slno1)): \(errmsg)")
            return
        }
        print("inserted===============>  \(String(describing: slno1))")
        
        if sqlite3_bind_text(stmt, 2, stylist1.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(DatabaseConnection.dbs)!)
            print("failure binding \(String(describing: stylist1)): \(errmsg)")
            return
        }
        print("inserted===============>  \(String(describing: stylist1))")
        
        if sqlite3_bind_text(stmt, 3, contact1.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(DatabaseConnection.dbs)!)
            print("failure binding \(String(describing: contact1)): \(errmsg)")
            return
        }
        print("inserted===============>  \(String(describing: contact1))")
        
        if sqlite3_bind_text(stmt, 4, salon1.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(DatabaseConnection.dbs)!)
            print("failure binding \(String(describing: salon1)): \(errmsg)")
            return
        }
        print("inserted===============>  \(String(describing: salon1))")
        
        if sqlite3_bind_text(stmt, 5, seller1.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(DatabaseConnection.dbs)!)
            print("failure binding \(String(describing: seller1)): \(errmsg)")
            return
        }
        print("inserted===============>  \(String(describing: seller1))")
        
        if sqlite3_step(stmt) != SQLITE_DONE {
            let errmsg = String(cString: sqlite3_errmsg(DatabaseConnection.dbs)!)
            print("failure inserting MyStylist data: \(errmsg)")
            return
        }
        print("data saved successfully in MyStylist Table")
    }
    
    public func postinsalondata (trainingtype: String?, trainercodes: String?, trainername: String?, sitecodes: String?, saloncodes: String?, noofstyletrainer: String?, noofmodeluser: String?, remark: String?, lat: String?, longi: String?, date: String?, post: String?, insalondetailid: String?, sellercode: String?, address: String?){
        var stmt: OpaquePointer? = nil
        let trainingtype1: NSString = String (trainingtype!) as NSString
        let trainercodes1: NSString = String (trainercodes!) as NSString
        let trainername1: NSString = String (trainername!) as NSString
        let sitecodes1: NSString = String (sitecodes!) as NSString
        let saloncodes1: NSString = String (saloncodes!) as NSString
        let noofstyletrainer1: NSString = String (noofstyletrainer!) as NSString
        let noofmodeluser1: NSString = String (noofmodeluser!) as NSString
        let remark1: NSString = String (remark!) as NSString
        let lat1: NSString = String (lat!) as NSString
        let longi1: NSString = String (longi!) as NSString
        let date1: NSString = String (date!) as NSString
        let post1: NSString = String (post!) as NSString
        let insalondetailid1: NSString = String (insalondetailid!) as NSString
        let sellercode1: NSString = String (sellercode!) as NSString
        let address1: NSString = String (address!) as NSString
        
        
        let query = "INSERT INTO InSalonDetail (trainingtype,  trainercodes ,  trainername ,  sitecodes , salonecodes ,  noofstyletrainer ,  noofmodeluser ,remark ,lat ,  longi ,  date ,post ,InSalonDetailID ,SELLERCODE ,address ) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)"
        if sqlite3_prepare_v2(DatabaseConnection.dbs, query, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(DatabaseConnection.dbs)!)
            print("error preparing insert: \(errmsg)")
            return
        }
        
        // binding the parameters
        if sqlite3_bind_text(stmt, 1, trainingtype1.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(DatabaseConnection.dbs)!)
            print("failure binding \(String(describing: trainingtype1)): \(errmsg)")
            return
        }
        print("\(String(describing: trainingtype1))")
        if sqlite3_bind_text(stmt, 2, trainercodes1.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(DatabaseConnection.dbs)!)
            print("failure binding \(String(describing: trainercodes1)): \(errmsg)")
            return
        }
        print("\(String(describing: trainercodes1))")
        if sqlite3_bind_text(stmt, 3, trainername1.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(DatabaseConnection.dbs)!)
            print("failure binding \(String(describing: trainername1)): \(errmsg)")
            return
        }
        print("\(String(describing: trainername1))")
        if sqlite3_bind_text(stmt, 4, sitecodes1.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(DatabaseConnection.dbs)!)
            print("failure binding \(String(describing: sitecodes1)): \(errmsg)")
            return
        }
        print("\(String(describing: sitecodes1))")
        if sqlite3_bind_text(stmt, 5, saloncodes1.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(DatabaseConnection.dbs)!)
            print("failure binding \(String(describing: saloncodes1)): \(errmsg)")
            return
        }
        print("\(String(describing: saloncodes1))")
        if sqlite3_bind_text(stmt, 6, noofstyletrainer1.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(DatabaseConnection.dbs)!)
            print("failure binding \(String(describing: noofstyletrainer1)): \(errmsg)")
            return
        }
        print("\(String(describing: noofstyletrainer1))")
        if sqlite3_bind_text(stmt, 7, noofmodeluser1.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(DatabaseConnection.dbs)!)
            print("failure binding \(String(describing: noofmodeluser1)): \(errmsg)")
            return
        }
        print("\(String(describing: noofmodeluser1))")
        if sqlite3_bind_text(stmt, 8, remark1.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(DatabaseConnection.dbs)!)
            print("failure binding \(String(describing: remark1)): \(errmsg)")
            return
        }
        print("\(String(describing: remark1))")
        if sqlite3_bind_text(stmt, 9, lat1.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(DatabaseConnection.dbs)!)
            print("failure binding \(String(describing: lat1)): \(errmsg)")
            return
        }
        print("\(String(describing: lat1))")
        if sqlite3_bind_text(stmt, 10, longi1.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(DatabaseConnection.dbs)!)
            print("failure binding \(String(describing: longi1)): \(errmsg)")
            return
        }
        print("\(String(describing: longi1))")
        if sqlite3_bind_text(stmt, 11, date1.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(DatabaseConnection.dbs)!)
            print("failure binding \(String(describing: date1)): \(errmsg)")
            return
        }
        print("\(String(describing: date1))")
        if sqlite3_bind_text(stmt, 12, post1.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(DatabaseConnection.dbs)!)
            print("failure binding \(String(describing: post1)): \(errmsg)")
            return
        }
        print("\(String(describing: post1))")
        if sqlite3_bind_text(stmt, 13, insalondetailid1.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(DatabaseConnection.dbs)!)
            print("failure binding \(String(describing: insalondetailid1)): \(errmsg)")
            return
        }
        print("\(String(describing: insalondetailid1))")
        if sqlite3_bind_text(stmt, 14, sellercode1.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(DatabaseConnection.dbs)!)
            print("failure binding \(String(describing: sellercode1)): \(errmsg)")
            return
        }
        print("\(String(describing: sellercode1))")
        if sqlite3_bind_text(stmt, 15, address1.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(DatabaseConnection.dbs)!)
            print("failure binding \(String(describing: address1)): \(errmsg)")
            return
        }
        print("\(String(describing: address1))")
        if sqlite3_step(stmt) != SQLITE_DONE {
            let errmsg = String(cString: sqlite3_errmsg(DatabaseConnection.dbs)!)
            print("failure inserting My InSaloon data: \(errmsg)")
            return
        }
        print("data saved successfully in My InSaloon Table")
        
    }
    
    public func getTrainingdata (trainingcode: String?,trainingname: String? ) {
        
        var stmt: OpaquePointer? = nil
        let trainingcode1: NSString = String(trainingcode!) as NSString
        let trainingname1: NSString = String(trainingname!) as NSString
        
        let query = "INSERT INTO TrainingMaster (trainingcode ,trainingname ) VALUES (?,?)"
        if sqlite3_prepare_v2(DatabaseConnection.dbs, query, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(DatabaseConnection.dbs)!)
            print("error preparing insert: \(errmsg)")
            return
        }
        
        // binding the parameters
        if sqlite3_bind_text(stmt, 1, trainingcode1.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(DatabaseConnection.dbs)!)
            print("failure binding \(String(describing: trainingcode1)): \(errmsg)")
            return
        }
        print("\(String(describing: trainingcode1))")
        if sqlite3_bind_text(stmt, 2, trainingname1.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(DatabaseConnection.dbs)!)
            print("failure binding \(String(describing: trainingname1)): \(errmsg)")
            return
        }
        print("\(String(describing: trainingname1))")
        if sqlite3_step(stmt) != SQLITE_DONE {
            let errmsg = String(cString: sqlite3_errmsg(DatabaseConnection.dbs)!)
            print("failure inserting Trainingspinner data: \(errmsg)")
            return
        }
        print("data saved successfully in Trainingspinner Table")
    }
    public func updatemyinssalon (pkey: String?) {
        
        let updateinsalon = "UPDATE InSalonDetail SET post = '2' WHERE InSalonDetailID = '" + pkey! + "'"
        if sqlite3_exec(DatabaseConnection.dbs, updateinsalon, nil, nil, nil) != SQLITE_OK{
            print("Error creating Table \(updateinsalon)")
            return
        }
    }
    public func updatemyworkshop (id: String?, model: String?, remark: String?) {
        
        let updateinsalon = "UPDATE InsertWorkshop SET remark = '" + remark! + "',modelno = '" + model! + "'  WHERE id = '" + id! + "'"
        if sqlite3_exec(DatabaseConnection.dbs, updateinsalon, nil, nil, nil) != SQLITE_OK{
            print("Error creating Table \(updateinsalon)")
            return
        }
        print("\n workswhop table updated for id - \(id!)")
    }
    public func updateworkshop (id: String?) {
        
        let updateinsalon = "UPDATE InsertWorkshop SET post = '2'  WHERE id = '" + id! + "'"
        if sqlite3_exec(DatabaseConnection.dbs, updateinsalon, nil, nil, nil) != SQLITE_OK{
            print("Error creating Table \(updateinsalon)")
            return
        }
        print("\n workswhop table updated for id - \(id!)  SET post = 2")
    }
    
    public func InsertWorkshop(date: String?, trainingcode: String?, traininglocations: String?, branchcode: String?,saloncodes: String?, salonname: String?, sellercodes: String?, addresses: String?,noofstylisttrainedstr: String?, post: String?, modelno: String?, remark: String?,id: String?, Lat: String?, longi: String?, datetime: String?,salonremark: String?,stylistname: String?,stylistcontact: String?){
        
        var stmt1: OpaquePointer? = nil
        
        let date: NSString = String(date!) as NSString
        let trainingcode: NSString = String(trainingcode!) as NSString
        let traininglocations: NSString = String(traininglocations!) as NSString
        let branchcode: NSString = String(branchcode!) as NSString
        let saloncodes: NSString = String(saloncodes!) as NSString
        let salonname: NSString = String(salonname!) as NSString
        let sellercodes: NSString = String(sellercodes!) as NSString
        let addresses: NSString = String(addresses!) as NSString
        let noofstylisttrainedstr: NSString = String(noofstylisttrainedstr!) as NSString
        let post: NSString = String(post!) as NSString
        let modelno: NSString = String(modelno!) as NSString
        let remark: NSString = String(remark!) as NSString
        let id: NSString = String(id!) as NSString
        let Lat: NSString = String(Lat!) as NSString
        let longi: NSString = String(longi!) as NSString
        let datetime: NSString = String(datetime!) as NSString
        let salonremark: NSString = String(salonremark!) as NSString
        let stylistname: NSString = String(stylistname!) as NSString
        let stylistcontact: NSString = String(stylistcontact!) as NSString
        
        let query = "INSERT INTO InsertWorkshop(date,trainingcode,traininglocations ,branchcode, saloncodes, salonname ,sellercodes,addresses,noofstylisttrainedstr,post,modelno,remark,id,Lat,longi,datetime,salonremark,stylistname,stylistcontact) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)"
        
        if sqlite3_prepare_v2(DatabaseConnection.dbs, query, -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(DatabaseConnection.dbs)!)
            print("error preparing insert: \(errmsg)")
            return
        }
        
        // binding the parameters
        if sqlite3_bind_text(stmt1, 1, date.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(DatabaseConnection.dbs)!)
            print("failure binding \(String(describing: date)): \(errmsg)")
            return
        }
        print("\(String(describing: date))")
        if sqlite3_bind_text(stmt1, 2, trainingcode.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(DatabaseConnection.dbs)!)
            print("failure binding \(String(describing: trainingcode)): \(errmsg)")
            return
        }
        print("\(String(describing: trainingcode))")
        if sqlite3_bind_text(stmt1, 3, traininglocations.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(DatabaseConnection.dbs)!)
            print("failure binding \(String(describing: traininglocations)): \(errmsg)")
            return
        }
        print("\(String(describing: traininglocations))")
        if sqlite3_bind_text(stmt1, 4, branchcode.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(DatabaseConnection.dbs)!)
            print("failure binding \(String(describing: branchcode)): \(errmsg)")
            return
        }
        print("\(String(describing: branchcode))")
        
        if sqlite3_bind_text(stmt1, 5, saloncodes.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(DatabaseConnection.dbs)!)
            print("failure binding \(String(describing: saloncodes)): \(errmsg)")
            return
        }
        print("\(String(describing: saloncodes))")
        
        
        if sqlite3_bind_text(stmt1, 6, salonname.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(DatabaseConnection.dbs)!)
            print("failure binding \(String(describing: salonname)): \(errmsg)")
            return
        }
        print("\(String(describing: salonname))")
        if sqlite3_bind_text(stmt1, 7, sellercodes.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(DatabaseConnection.dbs)!)
            print("failure binding \(String(describing: sellercodes)): \(errmsg)")
            return
        }
        print("\(String(describing: sellercodes))")
        if sqlite3_bind_text(stmt1, 8, addresses.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(DatabaseConnection.dbs)!)
            print("failure binding \(String(describing: addresses)): \(errmsg)")
            return
        }
        print("\(String(describing: addresses))")
        
        //noofstylisttrainedstr,post,modelno,remark,id,Lat,longi,datetime
        
        if sqlite3_bind_text(stmt1, 9, noofstylisttrainedstr.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(DatabaseConnection.dbs)!)
            print("failure binding \(String(describing: noofstylisttrainedstr)): \(errmsg)")
            return
        }
        print("\(String(describing: noofstylisttrainedstr))")
        if sqlite3_bind_text(stmt1, 10, post.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(DatabaseConnection.dbs)!)
            print("failure binding \(String(describing: post)): \(errmsg)")
            return
        }
        print("\(String(describing: post))")
        if sqlite3_bind_text(stmt1, 11, modelno.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(DatabaseConnection.dbs)!)
            print("failure binding \(String(describing: modelno)): \(errmsg)")
            return
        }
        print("\(String(describing: modelno))")
        if sqlite3_bind_text(stmt1, 12, remark.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(DatabaseConnection.dbs)!)
            print("failure binding \(String(describing: remark)): \(errmsg)")
            return
        }
        print("\(String(describing: remark))")
        
        
        if sqlite3_bind_text(stmt1, 13, id.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(DatabaseConnection.dbs)!)
            print("failure binding \(String(describing: id)): \(errmsg)")
            return
        }
        print("\(String(describing: id))")
        if sqlite3_bind_text(stmt1, 14, Lat.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(DatabaseConnection.dbs)!)
            print("failure binding \(String(describing: Lat)): \(errmsg)")
            return
        }
        print("\(String(describing: Lat))")
        if sqlite3_bind_text(stmt1, 15, longi.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(DatabaseConnection.dbs)!)
            print("failure binding \(String(describing: longi)): \(errmsg)")
            return
        }
        print("\(String(describing: longi))")
        if sqlite3_bind_text(stmt1, 16, datetime.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(DatabaseConnection.dbs)!)
            print("failure binding \(String(describing: datetime)): \(errmsg)")
            return
        }
        print("\(String(describing: datetime))")
        if sqlite3_bind_text(stmt1, 17, salonremark.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(DatabaseConnection.dbs)!)
            print("failure binding \(String(describing: salonremark)): \(errmsg)")
            return
        }
        print("\(String(describing: salonremark))")
        if sqlite3_bind_text(stmt1, 18, stylistname.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(DatabaseConnection.dbs)!)
            print("failure binding \(String(describing: stylistname)): \(errmsg)")
            return
        }
        print("\(String(describing: stylistname))")
        if sqlite3_bind_text(stmt1, 19, stylistcontact.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(DatabaseConnection.dbs)!)
            print("failure binding \(String(describing: stylistcontact)): \(errmsg)")
            return
        }
        print("\(String(describing: stylistcontact))")
        
        if sqlite3_step(stmt1) != SQLITE_DONE {
            let errmsg = String(cString: sqlite3_errmsg(DatabaseConnection.dbs)!)
            print("failure inserting workshop data: \(errmsg)")
            return
        }
        print("Data in Get My Workshop table inserted")
        
    }
    public func getCategory (catgcode: String?,catgname: String? ) {
        
        var stmt2: OpaquePointer? = nil
        let catgcode1: NSString = String(catgcode!) as NSString
        let catgname1: NSString = String(catgname!) as NSString
        
        let query = "INSERT INTO AddCategory (catgcode ,catgname ) VALUES (?,?)"
        if sqlite3_prepare_v2(DatabaseConnection.dbs, query, -1, &stmt2, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(DatabaseConnection.dbs)!)
            print("error preparing insert: \(errmsg)")
            return
        }
        
        // binding the parameters
        if sqlite3_bind_text(stmt2, 1, catgcode1.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(DatabaseConnection.dbs)!)
            print("failure binding \(String(describing: catgcode1)): \(errmsg)")
            return
        }
        print("\(String(describing: catgname1))")
        if sqlite3_bind_text(stmt2, 2, catgname1.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(DatabaseConnection.dbs)!)
            print("failure binding \(String(describing: catgname1)): \(errmsg)")
            return
        }
        print("\(String(describing: catgname1))")
        if sqlite3_step(stmt2) != SQLITE_DONE {
            let errmsg = String(cString: sqlite3_errmsg(DatabaseConnection.dbs)!)
            print("failure inserting getCategory data: \(errmsg)")
            return
        }
        print("data saved successfully in GetCategorySpinner Table")
    }
    
    public func getLevel (levelcode: String?,levelname: String? ) {
        
        var stmt3: OpaquePointer? = nil
        let levelcode1: NSString = String(levelcode!) as NSString
        let levelname1: NSString = String(levelname!) as NSString
        
        let query = "INSERT INTO Addlevel (levelcode ,levelname ) VALUES (?,?)"
        if sqlite3_prepare_v2(DatabaseConnection.dbs, query, -1, &stmt3, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(DatabaseConnection.dbs)!)
            print("error preparing insert: \(errmsg)")
            return
        }
        
        // binding the parameters
        if sqlite3_bind_text(stmt3, 1, levelcode1.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(DatabaseConnection.dbs)!)
            print("failure binding \(String(describing: levelcode1)): \(errmsg)")
            return
        }
        print("\(String(describing: levelname1))")
        if sqlite3_bind_text(stmt3, 2, levelname1.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(DatabaseConnection.dbs)!)
            print("failure binding \(String(describing: levelname1)): \(errmsg)")
            return
        }
        print("\(String(describing: levelname1))")
        if sqlite3_step(stmt3) != SQLITE_DONE {
            let errmsg = String(cString: sqlite3_errmsg(DatabaseConnection.dbs)!)
            print("failure inserting getLevel data: \(errmsg)")
            return
        }
        print("data saved successfully in getLevelSpinner Table")
    }
    
    public func insertsalontrackinglist(productgroup: String?, distriytd: String?, distrimtd: String?, volumeytd: String?, volumemtd: String?){
        
        var stmt4: OpaquePointer? = nil
        
        let product1: NSString = String(productgroup!) as NSString
        let distriytd1: NSString = String(distriytd!) as NSString
        let distrimtd1: NSString = String(distrimtd!) as NSString
        let volumeytd1: NSString = String(volumeytd!) as NSString
        let volumemtd1: NSString = String(volumemtd!) as NSString
        
        let query = "INSERT INTO Salontracking  (productgroup,amT_YTD,amT_MTD,noofcustomeR_YTD,noofcustomeR_MTD) VALUES (?,?,?,?,?)"
        
        if sqlite3_prepare_v2(DatabaseConnection.dbs, query, -1, &stmt4, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(DatabaseConnection.dbs)!)
            print("error preparing insert: \(errmsg)")
            return
        }
        
        // binding the parameters
        if sqlite3_bind_text(stmt4, 1, product1.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(DatabaseConnection.dbs)!)
            print("failure binding \(String(describing: product1)): \(errmsg)")
            return
        }
        print("\(String(describing: product1))")
        
        if sqlite3_bind_text(stmt4, 2, distriytd1.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(DatabaseConnection.dbs)!)
            print("failure binding \(String(describing: distriytd1)): \(errmsg)")
            return
        }
        
        print("\(String(describing: distriytd1))")
        
        if sqlite3_bind_text(stmt4, 3, distrimtd1.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(DatabaseConnection.dbs)!)
            print("failure binding \(String(describing: distrimtd1)): \(errmsg)")
            return
        }
        
        print("\(String(describing: distrimtd1))")
        
        if sqlite3_bind_text(stmt4, 4, volumeytd1.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(DatabaseConnection.dbs)!)
            print("failure binding \(String(describing: volumeytd1)): \(errmsg)")
            return
        }
        
        print("\(String(describing: volumeytd1))")
        
        if sqlite3_bind_text(stmt4, 5, volumemtd1.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(DatabaseConnection.dbs)!)
            print("failure binding \(String(describing: volumemtd1)): \(errmsg)")
            return
        }
        
        print("\(String(describing: volumemtd1))")
        
        if sqlite3_step(stmt4) != SQLITE_DONE {
            let errmsg = String(cString: sqlite3_errmsg(DatabaseConnection.dbs)!)
            print("failure inserting Brand data: \(errmsg)")
            return
        }
        i=i+1
        print("data saved successfully in salon tracking \(i)")
    }
    
    public func updatestylist (id: String?) {
        let updatestylist = "UPDATE Addstylist SET post = '2'  WHERE id = '" + id! + "'"
        if sqlite3_exec(DatabaseConnection.dbs, updatestylist, nil, nil, nil) != SQLITE_OK{
            print("Error updating Table \(updatestylist)")
            return
        }
        print("\n AddStylist table updated for id - \(id)  SET post = 2")
    }
    
    
    
    public func insertaddstylist (stylistname: String?, sitecode: String?, saloncode: String?, contact: String?, email: String?, address: String?, lat: String?, long: String?, usercode: String?, category: String?, levelcode: String?, sellercode: String?, image: String?, post: String?, id: String?){
        
        var stmt5: OpaquePointer? = nil
        
        let stylistname1: NSString = String (stylistname!) as NSString
        let sitecode1: NSString = String (sitecode!) as NSString
        let saloncode1: NSString = String (saloncode!) as NSString
        let contact1: NSString = String (contact!) as NSString
        let address1: NSString = String (address!) as NSString
        let email1: NSString = String (email!) as NSString
        let lat1: NSString = String (lat!) as NSString
        let long1: NSString = String (long!) as NSString
        let usercode1: NSString = String (usercode!) as NSString
        let category1: NSString = String (category!) as NSString
        let levelcode1: NSString = String (levelcode!) as NSString
        let sellercode1: NSString = String (sellercode!) as NSString
        let image1: NSString = String (image!) as NSString
        let post1: NSString = String (post!)as NSString
        let id: NSString = String (id!)as NSString
        
        let query = "INSERT INTO Addstylist (stylistname,sitecode,saloncode,contact,email,address,lat,long ,usercode,category, levelcode ,sellercode ,image,post,id) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)"
        if sqlite3_prepare_v2(DatabaseConnection.dbs, query, -1, &stmt5, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(DatabaseConnection.dbs)!)
            print("error preparing insert: \(errmsg)")
            return
        }
        
        //stylistname,sitecode,saloncode,contact,
        
        
        // binding the parameters
        if sqlite3_bind_text(stmt5, 1, stylistname1.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(DatabaseConnection.dbs)!)
            print("failure binding \(String(describing: stylistname1)): \(errmsg)")
            return
        }
        print("\(String(describing: stylistname1))")
        if sqlite3_bind_text(stmt5, 2, sitecode1.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(DatabaseConnection.dbs)!)
            print("failure binding \(String(describing: sitecode1)): \(errmsg)")
            return
        }
        print("\(String(describing: sitecode1))")
        if sqlite3_bind_text(stmt5, 3, saloncode1.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(DatabaseConnection.dbs)!)
            print("failure binding \(String(describing: saloncode1)): \(errmsg)")
            return
        }
        print("\(String(describing: saloncode1))")
        if sqlite3_bind_text(stmt5, 4, contact1.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(DatabaseConnection.dbs)!)
            print("failure binding \(String(describing: contact1)): \(errmsg)")
            return
        }
        print("\(String(describing: contact1))")
        
        if sqlite3_bind_text(stmt5, 5, email1.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(DatabaseConnection.dbs)!)
            print("failure binding \(String(describing: email1)): \(errmsg)")
            return
        }
        print("\(String(describing: email1))")
        if sqlite3_bind_text(stmt5, 6, address1.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(DatabaseConnection.dbs)!)
            print("failure binding \(String(describing: address1)): \(errmsg)")
            return
        }
        print("\(String(describing: address1))")
        if sqlite3_bind_text(stmt5, 7, lat1.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(DatabaseConnection.dbs)!)
            print("failure binding \(String(describing: lat1)): \(errmsg)")
            return
        }
        print("\(String(describing: lat1))")
        
        if sqlite3_bind_text(stmt5, 8, long1.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(DatabaseConnection.dbs)!)
            print("failure binding \(String(describing: long1)): \(errmsg)")
            return
        }
        print("\(String(describing: long1))")
        if sqlite3_bind_text(stmt5, 9, usercode1.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(DatabaseConnection.dbs)!)
            print("failure binding \(String(describing: usercode1)): \(errmsg)")
            return
        }
        print("\(String(describing: usercode1))")
        if sqlite3_bind_text(stmt5, 10, category1.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(DatabaseConnection.dbs)!)
            print("failure binding \(String(describing: category1)): \(errmsg)")
            return
        }
        print("\(String(describing: category1))")
        if sqlite3_bind_text(stmt5, 11, levelcode1.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(DatabaseConnection.dbs)!)
            print("failure binding \(String(describing: levelcode1)): \(errmsg)")
            return
        }
        print("\(String(describing: levelcode1))")
        if sqlite3_bind_text(stmt5, 12, sellercode1.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(DatabaseConnection.dbs)!)
            print("failure binding \(String(describing: sellercode1)): \(errmsg)")
            return
        }
        print("\(String(describing: sellercode1))")
        if sqlite3_bind_text(stmt5, 13, image1.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(DatabaseConnection.dbs)!)
            print("failure binding \(String(describing: image1)): \(errmsg)")
            return
        }
        if sqlite3_bind_text(stmt5, 14, post1.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(DatabaseConnection.dbs)!)
            print("failure binding \(String(describing: post1)): \(errmsg)")
            return
        }
        if sqlite3_bind_text(stmt5, 15, id.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(DatabaseConnection.dbs)!)
            print("failure binding \(String(describing: id)): \(errmsg)")
            return
        }
        if sqlite3_step(stmt5) != SQLITE_DONE {
            let errmsg = String(cString: sqlite3_errmsg(DatabaseConnection.dbs)!)
            print("failure inserting My InSaloon data: \(errmsg)")
            return
        }
        print("data saved successfully in AddStylist Table")
        
    }
    
    public func insertsynclog(tablename: String?,status: String?,post: String?)
    {
        let base  = BaseActivity()
        let query = "insert into PostSynclog(tablename,device,manufecture,osversion,appversion,datetime,status,userid,usertype,syncid,post) VALUES('\(tablename!)','\(AppDelegate.Modelname)','Apple','\(UIDevice.current.systemVersion)','\(base.appversion())','\(base.datetime())','\(status!)','\(UserDefaults.standard.string(forKey: "userid")!)','\(UserDefaults.standard.string(forKey: "usertype")!)','\(base.datetime())',\(post!))"
        
        if sqlite3_exec(DatabaseConnection.dbs, query, nil, nil, nil) != SQLITE_OK{
            print("Error in PostSynclog Table")
            return
        }
        print("Succesful PostSynclog table")
    }
    
    public func updatepostsynclog(syncid: String?) {
        
        let updatepost = "UPDATE PostSynclog SET post = '2' WHERE syncid = '\(syncid!)'"
        if sqlite3_exec(DatabaseConnection.dbs, updatepost, nil, nil, nil) != SQLITE_OK{
            print("Error creating Table \(updatepost)")
            return
        }
    }
    public func deletedashboarddsu (){
        let deltable = "DELETE FROM dsu"
        
        if sqlite3_exec(DatabaseConnection.dbs, deltable, nil, nil, nil) != SQLITE_OK{
            print("Error Deleting Table: dsu")
            return
        }
        print("dsu table deleted")
    }
    
    public func insertdashdsu(doorstrained: String?, stylisttrained: String?, uniquedoorstrained: String?, topdoorstrained: String?, doorstrainedach: String?,stylisttrainedach: String?, uniquedoorstrainedach: String?, topdoorstrainedach: String?, insalon: String?, virtualtraining: String?, workshop: String?){
        //CREATE TABLE IF NOT EXISTS dsu(doorstrained text,stylisttrained text,uniquedoorstrained text,topdoorstrained text,doorstrainedach text,stylisttrainedach text,uniquedoorstrainedach text,topdoorstrainedach text,insalon text,virtualtraining text,workshop text)
        var stmt: OpaquePointer? = nil
        let doorstrained: NSString = String(doorstrained!) as NSString
        let stylisttrained: NSString = String(stylisttrained!) as NSString
        let uniquedoorstrained: NSString = String(uniquedoorstrained!) as NSString
        let topdoorstrained: NSString = String(topdoorstrained!) as NSString
        let doorstrainedach: NSString = String(doorstrainedach!) as NSString
        
        let stylisttrainedach: NSString = String(stylisttrainedach!) as NSString
        let uniquedoorstrainedach: NSString = String(uniquedoorstrainedach!) as NSString
        let topdoorstrainedach: NSString = String(topdoorstrainedach!) as NSString
        let insalon: NSString = String(insalon!) as NSString
        let virtualtraining: NSString = String(virtualtraining!) as NSString
        let workshop: NSString = String(workshop!) as NSString
        
        
        let query = "INSERT INTO dsu (doorstrained,stylisttrained,uniquedoorstrained,topdoorstrained,doorstrainedach,stylisttrainedach,uniquedoorstrainedach,topdoorstrainedach,insalon,virtualtraining,workshop) VALUES (?,?,?,?,?,?,?,?,?,?,?)"
        if sqlite3_prepare_v2(DatabaseConnection.dbs, query, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(DatabaseConnection.dbs)!)
            print("error preparing insert: \(errmsg)")
            return
        }
        
        // binding the parameters
        if sqlite3_bind_text(stmt, 1, doorstrained.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(DatabaseConnection.dbs)!)
            print("failure binding \(String(describing: doorstrained)): \(errmsg)")
            return
        }
        print("\(String(describing: doorstrained))")
        
        if sqlite3_bind_text(stmt, 2, stylisttrained.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(DatabaseConnection.dbs)!)
            print("failure binding \(String(describing: stylisttrained)): \(errmsg)")
            return
        }
        
        print("\(String(describing: stylisttrained))")
        
        if sqlite3_bind_text(stmt, 3, uniquedoorstrained.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(DatabaseConnection.dbs)!)
            print("failure binding \(String(describing: uniquedoorstrained)): \(errmsg)")
            return
        }
        
        print("\(String(describing: uniquedoorstrained))")
        if sqlite3_bind_text(stmt, 4, topdoorstrained.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(DatabaseConnection.dbs)!)
            print("failure binding \(String(describing: topdoorstrained)): \(errmsg)")
            return
        }
        
        print("\(String(describing: topdoorstrained))")
        
        if sqlite3_bind_text(stmt, 5, doorstrainedach.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(DatabaseConnection.dbs)!)
            print("failure binding \(String(describing: doorstrainedach)): \(errmsg)")
            return
        }
        
        print("\(String(describing: doorstrainedach))")
        
        if sqlite3_bind_text(stmt, 6, stylisttrainedach.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(DatabaseConnection.dbs)!)
            print("failure binding \(String(describing: stylisttrainedach)): \(errmsg)")
            return
        }
        // doorstrained,stylisttrained,uniquedoorstrained,topdoorstrained,doorstrainedach,stylisttrainedach,uniquedoorstrainedach,topdoorstrainedach,insalon,virtualtraining,workshop
        
        
        print("\(String(describing: stylisttrainedach))")
        
        if sqlite3_bind_text(stmt, 7, uniquedoorstrainedach.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(DatabaseConnection.dbs)!)
            print("failure binding \(String(describing: uniquedoorstrainedach)): \(errmsg)")
            return
        }
        
        print("\(String(describing: uniquedoorstrainedach))")
        
        if sqlite3_bind_text(stmt, 8, topdoorstrainedach.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(DatabaseConnection.dbs)!)
            print("failure binding \(String(describing: topdoorstrainedach)): \(errmsg)")
            return
        }
        
        print("\(String(describing: topdoorstrainedach))")
        
        if sqlite3_bind_text(stmt, 9, insalon.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(DatabaseConnection.dbs)!)
            print("failure binding \(String(describing: insalon)): \(errmsg)")
            return
        }
        
        print("\(String(describing: insalon))")
        
        if sqlite3_bind_text(stmt, 10, virtualtraining.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(DatabaseConnection.dbs)!)
            print("failure binding \(String(describing: virtualtraining)): \(errmsg)")
            return
        }
        
        print("\(String(describing: virtualtraining))")
        
        if sqlite3_bind_text(stmt, 11, workshop.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(DatabaseConnection.dbs)!)
            print("failure binding \(String(describing: workshop)): \(errmsg)")
            return
        }
        
        print("\(String(describing: workshop))")
        if sqlite3_step(stmt) != SQLITE_DONE {
            let errmsg = String(cString: sqlite3_errmsg(DatabaseConnection.dbs)!)
            print("failure inserting dsu data: \(errmsg)")
            return
        }
        i=i+1
        print("data saved successfully \(i)")
    }
    public func deletetraininglinechart (){
        let deltable = "DELETE FROM traininglinechart"
        
        if sqlite3_exec(DatabaseConnection.dbs, deltable, nil, nil, nil) != SQLITE_OK{
            print("Error Deleting Table: traininglinechart")
            return
        }
        print("traininglinechart table deleted")
    }
    public func deletestylistlinechart (){
        let deltable = "DELETE FROM stylistlinechart"
        
        if sqlite3_exec(DatabaseConnection.dbs, deltable, nil, nil, nil) != SQLITE_OK{
            print("Error Deleting Table: stylistlinechart")
            return
        }
        print("stylistlinechart table deleted")
    }
    public func deletepiechart (){
        let deltable = "DELETE FROM piechartdata"
        
        if sqlite3_exec(DatabaseConnection.dbs, deltable, nil, nil, nil) != SQLITE_OK{
            print("Error Deleting Table: piechartdata")
            return
        }
        print("piechartdata table deleted")
    }
    
    public func insertTrainingLineChart (trainingmonth: String?,trainingconducted: String? ) {
        
        var stmt3: OpaquePointer? = nil
        let trainingmonth: NSString = String(trainingmonth!) as NSString
        let trainingconducted: NSString = String(trainingconducted!) as NSString
        
        let query = "INSERT INTO traininglinechart (trainingmonth ,trainingconducted ) VALUES (?,?)"
        if sqlite3_prepare_v2(DatabaseConnection.dbs, query, -1, &stmt3, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(DatabaseConnection.dbs)!)
            print("error preparing insert: \(errmsg)")
            return
        }
        
        // binding the parameters
        if sqlite3_bind_text(stmt3, 1, trainingmonth.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(DatabaseConnection.dbs)!)
            print("failure binding \(String(describing: trainingmonth)): \(errmsg)")
            return
        }
        print("\(String(describing: trainingmonth))")
        if sqlite3_bind_text(stmt3, 2, trainingconducted.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(DatabaseConnection.dbs)!)
            print("failure binding \(String(describing: trainingconducted)): \(errmsg)")
            return
        }
        print("\(String(describing: trainingconducted))")
        if sqlite3_step(stmt3) != SQLITE_DONE {
            let errmsg = String(cString: sqlite3_errmsg(DatabaseConnection.dbs)!)
            print("failure inserting traininglinechart data: \(errmsg)")
            return
        }
        print("data saved successfully in traininglinechart Table")
    }
    
    public func insertStylistLineChart (trainingmonth: String?,participantcount: String? ) {
        
        var stmt3: OpaquePointer? = nil
        let trainingmonth: NSString = String(trainingmonth!) as NSString
        let participantcount: NSString = String(participantcount!) as NSString
        
        let query = "INSERT INTO stylistlinechart (trainingmonth ,participantcount ) VALUES (?,?)"
        if sqlite3_prepare_v2(DatabaseConnection.dbs, query, -1, &stmt3, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(DatabaseConnection.dbs)!)
            print("error preparing insert: \(errmsg)")
            return
        }
        
        // binding the parameters
        if sqlite3_bind_text(stmt3, 1, trainingmonth.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(DatabaseConnection.dbs)!)
            print("failure binding \(String(describing: trainingmonth)): \(errmsg)")
            return
        }
        print("\(String(describing: trainingmonth))")
        if sqlite3_bind_text(stmt3, 2, participantcount.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(DatabaseConnection.dbs)!)
            print("failure binding \(String(describing: participantcount)): \(errmsg)")
            return
        }
        print("\(String(describing: participantcount))")
        
        if sqlite3_step(stmt3) != SQLITE_DONE {
            let errmsg = String(cString: sqlite3_errmsg(DatabaseConnection.dbs)!)
            print("failure inserting stylistlinechart data: \(errmsg)")
            return
        }
        print("data saved successfully in stylistlinechart Table")
    }
    
    public func insertPieChart (trainingname: String?,counttrainingcode: String? ) {
        
        var stmt3: OpaquePointer? = nil
        let trainingname: NSString = String(trainingname!) as NSString
        let counttrainingcode: NSString = String(counttrainingcode!) as NSString
        
        let query = "INSERT INTO piechartdata (trainingname ,counttrainingcode ) VALUES (?,?)"
        if sqlite3_prepare_v2(DatabaseConnection.dbs, query, -1, &stmt3, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(DatabaseConnection.dbs)!)
            print("error preparing insert: \(errmsg)")
            return
        }
        
        // binding the parameters
        if sqlite3_bind_text(stmt3, 1, trainingname.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(DatabaseConnection.dbs)!)
            print("failure binding \(String(describing: trainingname)): \(errmsg)")
            return
        }
        print("\(String(describing: trainingname))")
        if sqlite3_bind_text(stmt3, 2, counttrainingcode.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(DatabaseConnection.dbs)!)
            print("failure binding \(String(describing: counttrainingcode)): \(errmsg)")
            return
        }
        print("\(String(describing: counttrainingcode))")
        
        if sqlite3_step(stmt3) != SQLITE_DONE {
            let errmsg = String(cString: sqlite3_errmsg(DatabaseConnection.dbs)!)
            print("failure inserting piechartdata data: \(errmsg)")
            return
        }
        print("data saved successfully in piechartdata Table")
    }
    public func deletsalontrackingtabledata (){
        let deltable = "DELETE FROM salontrackingdata"
        
        if sqlite3_exec(DatabaseConnection.dbs, deltable, nil, nil, nil) != SQLITE_OK{
            print("Error Deleting Table: salontrackingdata")
            return
        }
        print("salontrackingdata table deleted")
    }
    public func insertsalontrackingdata(entity: String?, l2msales: String?, mtdly: String?, mtdty: String?, ytdly: String?, ytdty: String?, type: String?){
        
        var stmt4: OpaquePointer? = nil
        //        let Getsalontrackingdata = "CREATE TABLE IF NOT EXISTS salontrackingdata(brand text,l2msales text,mtdly text,mtdty text,ytdly text,ytdty text,type text)"
        
        let entity: NSString = String(entity!) as NSString
        let l2msales: NSString = String(l2msales!) as NSString
        let mtdly: NSString = String(mtdly!) as NSString
        let mtdty: NSString = String(mtdty!) as NSString
        let ytdly: NSString = String(ytdly!) as NSString
        let ytdty: NSString = String(ytdty!) as NSString
        let type: NSString = String(type!) as NSString
        
        
        let query = "INSERT INTO salontrackingdata  (brand,l2msales,mtdly,mtdty,ytdly,ytdty,type) VALUES (?,?,?,?,?,?,?)"
        
        if sqlite3_prepare_v2(DatabaseConnection.dbs, query, -1, &stmt4, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(DatabaseConnection.dbs)!)
            print("error preparing insert: \(errmsg)")
            return
        }
        
        // binding the parameters
        if sqlite3_bind_text(stmt4, 1, entity.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(DatabaseConnection.dbs)!)
            print("failure binding \(String(describing: entity)): \(errmsg)")
            return
        }
        print("\(String(describing: entity))")
        
        if sqlite3_bind_text(stmt4, 2, l2msales.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(DatabaseConnection.dbs)!)
            print("failure binding \(String(describing: l2msales)): \(errmsg)")
            return
        }
        
        print("\(String(describing: l2msales))")
        
        if sqlite3_bind_text(stmt4, 3, mtdly.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(DatabaseConnection.dbs)!)
            print("failure binding \(String(describing: mtdly)): \(errmsg)")
            return
        }
        
        print("\(String(describing: mtdly))")
        
        if sqlite3_bind_text(stmt4, 4, mtdty.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(DatabaseConnection.dbs)!)
            print("failure binding \(String(describing: mtdty)): \(errmsg)")
            return
        }
        
        print("\(String(describing: mtdty))")
        //        //        let Getsalontrackingdata = "CREATE TABLE IF NOT EXISTS salontrackingdata(brand text,l2msales text,mtdly text,mtdty text,ytdly text,ytdty text,type text)"
        
        if sqlite3_bind_text(stmt4, 5, ytdly.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(DatabaseConnection.dbs)!)
            print("failure binding \(String(describing: ytdly)): \(errmsg)")
            return
        }
        
        print("\(String(describing: ytdly))")
        
        if sqlite3_bind_text(stmt4, 6, ytdty.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(DatabaseConnection.dbs)!)
            print("failure binding \(String(describing: ytdty)): \(errmsg)")
            return
        }
        print("\(String(describing: ytdty))")
        
        if sqlite3_bind_text(stmt4, 7, type.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(DatabaseConnection.dbs)!)
            print("failure binding \(String(describing: type)): \(errmsg)")
            return
        }
        print("\(String(describing: type))")
        
        
        if sqlite3_step(stmt4) != SQLITE_DONE {
            let errmsg = String(cString: sqlite3_errmsg(DatabaseConnection.dbs)!)
            print("failure inserting Brand data: \(errmsg)")
            return
        }
        i=i+1
        print("data saved successfully in salon tracking \(i)")
    }
    public func deleteSalonTable (){
        let deltable = "DELETE FROM salon"
        
        if sqlite3_exec(DatabaseConnection.dbs, deltable, nil, nil, nil) != SQLITE_OK{
            print("Error Deleting branch Table: salon")
            return
        }
        print("salon table deleted")
    }
    public func insertSalonData (saloncode: String?, salonname: String?, salonaddress: String? , sitecode: String?, psrcode: String?) {
        var stmt: OpaquePointer? = nil
        
        let saloncode: NSString = String(saloncode!) as NSString
        let salonname: NSString = String(salonname!) as NSString
        let salonaddress: NSString = String(salonaddress!) as NSString
        let sitecode: NSString = String(sitecode!) as NSString
        let psrcode: NSString = String(psrcode!) as NSString

        
        
        let query = "INSERT INTO salon (saloncode, salonname, salonaddress, sitecode, psrcode) VALUES (?,?,?,?,?)"
        
        if sqlite3_prepare_v2(DatabaseConnection.dbs, query, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(DatabaseConnection.dbs)!)
            print("error preparing insert: \(errmsg)")
            return
        }
        if sqlite3_bind_text(stmt, 1, saloncode.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(DatabaseConnection.dbs)!)
            print("failure binding \(String(describing: saloncode)): \(errmsg)")
            return
        }
        print("saloncode============>\(String(describing: saloncode))")
        
        if sqlite3_bind_text(stmt, 2, salonname.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(DatabaseConnection.dbs)!)
            print("failure binding \(String(describing: salonname)): \(errmsg)")
            return
        }
        print("salonname============>\(String(describing: salonname))")
        
        if sqlite3_bind_text(stmt, 3, salonaddress.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(DatabaseConnection.dbs)!)
            print("failure binding \(String(describing: salonaddress)): \(errmsg)")
            return
        }
        print("salonaddress============>\(String(describing: salonaddress))")
        
        if sqlite3_bind_text(stmt, 4, sitecode.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(DatabaseConnection.dbs)!)
            print("failure binding \(String(describing: sitecode)): \(errmsg)")
            return
        }
        print("sitecode============>\(String(describing: sitecode))")

        if sqlite3_bind_text(stmt, 5, psrcode.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(DatabaseConnection.dbs)!)
            print("failure binding \(String(describing: psrcode)): \(errmsg)")
            return
        }
        print("psrcode============>\(String(describing: psrcode))")

        
        if sqlite3_step(stmt) != SQLITE_DONE {
            let errmsg = String(cString: sqlite3_errmsg(DatabaseConnection.dbs)!)
            print("failure inserting salon data: \(errmsg)")
            return
        }
        else {
            print("\(sqlite3_step(stmt))")
        }
        j=j+1
        print("\n salon table data inserted successfully \(j) ")
    }
    public func deleteCityMaster (){
        let deltable = "DELETE FROM citymaster"
        
        if sqlite3_exec(DatabaseConnection.dbs, deltable, nil, nil, nil) != SQLITE_OK{
            print("Error Deleting Table: citymaster")
            return
        }
        print("citymaster table deleted")
    }
    public func insertCityMaster (cityid: String?, cityname: String?, statename: String?) {
        var stmt: OpaquePointer? = nil
        
        let cityid: NSString = String(cityid!) as NSString
        let cityname: NSString = String(cityname!) as NSString
        let statename: NSString = String(statename!) as NSString
        
        
        let query = "INSERT INTO citymaster (cityid, cityname, statename) VALUES (?,?,?)"
        
        if sqlite3_prepare_v2(DatabaseConnection.dbs, query, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(DatabaseConnection.dbs)!)
            print("error preparing insert: \(errmsg)")
            return
        }
        if sqlite3_bind_text(stmt, 1, cityid.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(DatabaseConnection.dbs)!)
            print("failure binding \(String(describing: cityid)): \(errmsg)")
            return
        }
        print("cityid============>\(String(describing: cityid))")
        
        if sqlite3_bind_text(stmt, 2, cityname.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(DatabaseConnection.dbs)!)
            print("failure binding \(String(describing: cityname)): \(errmsg)")
            return
        }
        print("cityname============>\(String(describing: cityname))")
        
        if sqlite3_bind_text(stmt, 3, statename.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(DatabaseConnection.dbs)!)
            print("failure binding \(String(describing: statename)): \(errmsg)")
            return
        }
        print("statename============>\(String(describing: statename))")
        
        if sqlite3_step(stmt) != SQLITE_DONE {
            let errmsg = String(cString: sqlite3_errmsg(DatabaseConnection.dbs)!)
            print("failure inserting citymaster data: \(errmsg)")
            return
        }
        else {
            print("\(sqlite3_step(stmt))")
        }
        j=j+1
        print("\n citymaster table data inserted successfully \(j) ")
    }
    public func insertAddStylistPost (id: String? ,  stylistname: String?, sitecode: String?, saloncode: String?, contact: String?, email: String?, salonaddress: String?, lat: String?, long: String?, usercode: String?, gender: String?, city: String?, dob: String?, anniversary: String?, colorlevel: String?){
        
        var stmt5: OpaquePointer? = nil
        let stylistname1: NSString = String (stylistname!) as NSString
        let sitecode1: NSString = String (sitecode!) as NSString
        let saloncode1: NSString = String (saloncode!) as NSString
        let contact1: NSString = String (contact!) as NSString
        let email1: NSString = String (email!) as NSString
        let address1: NSString = String (salonaddress!) as NSString
        let lat1: NSString = String (lat!) as NSString
        let long1: NSString = String (long!) as NSString
        let usercode1: NSString = String (usercode!) as NSString
        let gender1: NSString = String (gender!) as NSString
         let city1: NSString = String (city!) as NSString
        let dob1: NSString = String (dob!) as NSString
        let anniversary1: NSString = String (anniversary!) as NSString
        let colorlevel1: NSString = String (colorlevel!) as NSString
        let id1: NSString = String (id!)as NSString
        let post: NSString = "1"
        let verified: NSString = "1"
        
        let query = "INSERT INTO AddStylistPost (stylistname,sitecode,saloncode,contact,email,address,lat,long ,usercode,gender,city,dob ,anniversary,colorlevel,trnappid,verified,post) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)"
        if sqlite3_prepare_v2(DatabaseConnection.dbs, query, -1, &stmt5, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(DatabaseConnection.dbs)!)
            print("error preparing insert: \(errmsg)")
            return
        }
        
        //  let PostAddStylist = "CREATE TABLE IF NOT EXISTS AddStylistPost( trnappid text, stylistname text,sitecode text,saloncode text,contact text,email text,address text,lat text,long text,usercode text,gender text,city text,dob text ,anniversary text,colorlevel text,verified text,post text)"
        
        
        // binding the parameters
        if sqlite3_bind_text(stmt5, 1, stylistname1.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(DatabaseConnection.dbs)!)
            print("failure binding \(String(describing: stylistname1)): \(errmsg)")
            return
        }
        print("\(String(describing: stylistname1))")
        if sqlite3_bind_text(stmt5, 2, sitecode1.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(DatabaseConnection.dbs)!)
            print("failure binding \(String(describing: sitecode1)): \(errmsg)")
            return
        }
        print("\(String(describing: sitecode1))")
        if sqlite3_bind_text(stmt5, 3, saloncode1.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(DatabaseConnection.dbs)!)
            print("failure binding \(String(describing: saloncode1)): \(errmsg)")
            return
        }
        print("\(String(describing: saloncode1))")
        if sqlite3_bind_text(stmt5, 4, contact1.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(DatabaseConnection.dbs)!)
            print("failure binding \(String(describing: contact1)): \(errmsg)")
            return
        }
        print("\(String(describing: contact1))")
        
        if sqlite3_bind_text(stmt5, 5, email1.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(DatabaseConnection.dbs)!)
            print("failure binding \(String(describing: email1)): \(errmsg)")
            return
        }
        print("\(String(describing: email1))")
        if sqlite3_bind_text(stmt5, 6, address1.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(DatabaseConnection.dbs)!)
            print("failure binding \(String(describing: address1)): \(errmsg)")
            return
        }
        print("\(String(describing: address1))")
        if sqlite3_bind_text(stmt5, 7, lat1.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(DatabaseConnection.dbs)!)
            print("failure binding \(String(describing: lat1)): \(errmsg)")
            return
        }
        print("\(String(describing: lat1))")
        
        if sqlite3_bind_text(stmt5, 8, long1.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(DatabaseConnection.dbs)!)
            print("failure binding \(String(describing: long1)): \(errmsg)")
            return
        }
        print("\(String(describing: long1))")
        if sqlite3_bind_text(stmt5, 9, usercode1.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(DatabaseConnection.dbs)!)
            print("failure binding \(String(describing: usercode1)): \(errmsg)")
            return
        }
        print("\(String(describing: usercode1))")
        if sqlite3_bind_text(stmt5, 10, gender1.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(DatabaseConnection.dbs)!)
            print("failure binding \(String(describing: gender1)): \(errmsg)")
            return
        }
        print("\(String(describing: gender1))")
        if sqlite3_bind_text(stmt5, 11, city1.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(DatabaseConnection.dbs)!)
            print("failure binding \(String(describing: city1)): \(errmsg)")
            return
        }
        print("\(String(describing: city1))")
        if sqlite3_bind_text(stmt5, 12, dob1.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(DatabaseConnection.dbs)!)
            print("failure binding \(String(describing: dob1)): \(errmsg)")
            return
        }
        print("\(String(describing: dob1))")
        if sqlite3_bind_text(stmt5, 13, anniversary1.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(DatabaseConnection.dbs)!)
            print("failure binding \(String(describing: anniversary1)): \(errmsg)")
            return
        }
        if sqlite3_bind_text(stmt5, 14, colorlevel1.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(DatabaseConnection.dbs)!)
            print("failure binding \(String(describing: colorlevel1)): \(errmsg)")
            return
        }
        if sqlite3_bind_text(stmt5, 15, id1.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(DatabaseConnection.dbs)!)
            print("failure binding \(String(describing: id1)): \(errmsg)")
            return
        }
        if sqlite3_bind_text(stmt5, 16, verified.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(DatabaseConnection.dbs)!)
            print("failure binding \(String(describing: verified)): \(errmsg)")
            return
        }
        if sqlite3_bind_text(stmt5, 17, post.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(DatabaseConnection.dbs)!)
            print("failure binding \(String(describing: post)): \(errmsg)")
            return
        }

        if sqlite3_step(stmt5) != SQLITE_DONE {
            let errmsg = String(cString: sqlite3_errmsg(DatabaseConnection.dbs)!)
            print("failure inserting AddStylistPost data: \(errmsg)")
            return
        }
        print("data saved successfully in AddStylistPost Table")
    }
    public func updateAddStylistPost (trnappid: String?) {
        let updateAddStylistPost = "UPDATE AddStylistPost SET post = '2'  WHERE trnappid = '" + trnappid! + "'"
        if sqlite3_exec(DatabaseConnection.dbs, updateAddStylistPost, nil, nil, nil) != SQLITE_OK{
            print("Error updating Table \(updateAddStylistPost)")
            return
        }
        print("\n AddStylistPost table updated for id - \(trnappid!)  SET post = 2")
    }
    public func updateEditStylistPost (trnappid: String?) {
        let updateEditStylistPost = "UPDATE EditStylistPost SET post = '2'  WHERE trnappid = '" + trnappid! + "'"
        if sqlite3_exec(DatabaseConnection.dbs, updateEditStylistPost, nil, nil, nil) != SQLITE_OK{
            print("Error updating Table \(updateEditStylistPost)")
            return
        }
        print("\n EditStylistPost table updated for id - \(trnappid!)  SET post = 2")
    }

    public func insertStylistByContactNo(stylistCode: String? ,stylistName: String? ,siteCode: String? ,siteName: String? ,salonCode: String?,salonName: String? ,contact: String? ,email: String?,address: String?,gender: String? ,city: String? ,anniversary: String? ,colorLevel: String? ,dob: String?,stylistaddress: String?)
    {
        let query = "INSERT INTO StylistbyContactNo (stylistcode,stylistname,sitecode,sitename,saloncode,salonname,contact,email,address,gender,city,anniversary,colorlevel,dob,stylistaddress) VALUES ('\(stylistCode!)','\(stylistName!)','\(siteCode!)','\(siteName!)','\(salonCode!)','\(salonName!)','\(contact!)','\(email!)','\(address!)','\(gender!)','\(city!)','\(anniversary!)','\(colorLevel!)','\(dob!)','\(stylistaddress!)')"

        if sqlite3_exec(DatabaseConnection.dbs, query, nil, nil, nil) != SQLITE_OK{
            print("Error inserting in StylistbyContactNo Table")
            return
        }
        print("data saved successfully in StylistbyContactNo table")
    }

    public func insertEditStylistPost(trnappid: String? ,trainercode: String? ,entrytype: String? ,dateapplied: String? ,stylistcode: String?,dob: String? ,newdob: String? ,saloncode: String?,newsaloncode: String?,address: String? ,newaddress: String? ,city: String? ,newcity: String? ,anniversary: String?,newanniversary: String?,status: String?,post: String?,dataareaid: String?)
    {
        let query = "INSERT INTO EditStylistPost (trnappid,trainercode,entrytype,dateapplied,stylistcode,dob,newdob,saloncode,newsaloncode,address,newaddress,city,newcity,anniversary,newanniversary,status,post,dataareaid) VALUES ('\(trnappid!)','\(trainercode!)','\(entrytype!)','\(dateapplied!)','\(stylistcode!)','\(dob!)','\(newdob!)','\(saloncode!)','\(newsaloncode!)','\(address!)','\(newaddress!)','\(city!)','\(newcity!)','\(anniversary!)','\(newanniversary!)','\(status!)','\(post!)','\(dataareaid!)')"

        if sqlite3_exec(DatabaseConnection.dbs, query, nil, nil, nil) != SQLITE_OK{
            print("Error inserting in EditStylistPost Table")
            return
        }
        print("data saved successfully in EditStylistPost table")
    }
    public func deletEditStylistPost (){
        let deltable = "DELETE FROM EditStylistPost"
        
        if sqlite3_exec(DatabaseConnection.dbs, deltable, nil, nil, nil) != SQLITE_OK{
            print("Error Deleting Table: EditStylistPost")
            return
        }
        print("EditStylistPost table deleted")
    }
    public func deletStylistbyContactNo (){
        let deltable = "DELETE FROM StylistbyContactNo"
        
        if sqlite3_exec(DatabaseConnection.dbs, deltable, nil, nil, nil) != SQLITE_OK{
            print("Error Deleting Table: StylistbyContactNo")
            return
        }
        print("StylistbyContactNo table deleted")
    }
    public func deletAddStylistPost (){
        let deltable = "DELETE FROM AddStylistPost"
        
        if sqlite3_exec(DatabaseConnection.dbs, deltable, nil, nil, nil) != SQLITE_OK{
            print("Error Deleting Table: AddStylistPost")
            return
        }
        print("AddStylistPost table deleted")
    }

    public func insertHotDayPost(trainercode: String? ,saloncode: String? ,salonaddress: String? ,trnappid: String? ,salonname: String?,lat: String? ,long: String? ,trainingdate: String?,sitecode: String?,sellercode: String? ,trainingtype: String? ,post: String?)
     {
         let query = "INSERT INTO hotdaymarketvisit (trainercode,saloncode,salonaddress,trnappid,salonname,lat,long,trainingdate,sitecode,sellercode,trainingtype,post) VALUES ('\(trainercode!)','\(saloncode!)','\(salonaddress!)','\(trnappid!)','\(salonname!)','\(lat!)','\(long!)','\(trainingdate!)','\(sitecode!)','\(sellercode!)','\(trainingtype!)','\(post!)')"

         if sqlite3_exec(DatabaseConnection.dbs, query, nil, nil, nil) != SQLITE_OK{
             print("Error inserting in hotdaymarketvisit Table")
             return
         }
         print("data saved successfully in hotdaymarketvisit table")
     }
    //hotdaymarketvisit
    public func delethotdaymarketvisitPost() {
        let deltable = "DELETE FROM hotdaymarketvisit"
        
        if sqlite3_exec(DatabaseConnection.dbs, deltable, nil, nil, nil) != SQLITE_OK{
            print("Error Deleting Table: hotdaymarketvisit")
            return
        }
        print("hotdaymarketvisit table deleted")
    }
    
    public func updatehotdaymarketvisit (trnappid: String?) {
        let updatehotdaymarketvisit = "UPDATE hotdaymarketvisit SET post = '2'  WHERE trnappid = '" + trnappid! + "'"
        if sqlite3_exec(DatabaseConnection.dbs, updatehotdaymarketvisit, nil, nil, nil) != SQLITE_OK{
            print("Error updating Table \(updatehotdaymarketvisit)")
            return
        }
        print("\n hotdaymarketvisit table updated for id - \(trnappid!)  SET post = 2")
    }
    
    public func delethotdaymarketvisitPostTableData (saloncode : String?){
        let deltable = "DELETE FROM hotdaymarketvisit WHERE saloncode = '" + saloncode! + "'"
        
        if sqlite3_exec(DatabaseConnection.dbs, deltable, nil, nil, nil) != SQLITE_OK{
            print("Error Deleting Table: hotdaymarketvisit")
            return
        }
        print("hotdaymarketvisit table deleted")
    }

    public func insertAddLeavePost(trnappid: String? ,trainingtype: String? ,trainercode: String? ,lat: String? ,long: String?,trainingdate: String? ,post: String?)
     {
         let query = "INSERT INTO addleave (trnappid,trainingtype,trainercode,lat,long,trainingdate,post) VALUES ('\(trnappid!)','\(trainingtype!)','\(trainercode!)','\(lat!)','\(long!)','\(trainingdate!)','\(post!)')"

         if sqlite3_exec(DatabaseConnection.dbs, query, nil, nil, nil) != SQLITE_OK{
             print("Error inserting in addleave Table")
             return
         }
         print("data saved successfully in addleave table")
     }
    public func deletaddleavePost (){
        let deltable = "DELETE FROM addleave"
        
        if sqlite3_exec(DatabaseConnection.dbs, deltable, nil, nil, nil) != SQLITE_OK{
            print("Error Deleting Table: addleave")
            return
        }
        print("addleave table deleted")
    }
    
    public func updateaddleavePost (trnappid: String?) {
        let updateaddleave = "UPDATE addleave SET post = '2'  WHERE trnappid = '" + trnappid! + "'"
        if sqlite3_exec(DatabaseConnection.dbs, updateaddleave, nil, nil, nil) != SQLITE_OK{
            print("Error updating Table \(updateaddleave)")
            return
        }
        print("\n addleave table updated for id - \(trnappid!)  SET post = 2")
    }
//        let PostInternalOtherTraining = "CREATE TABLE IF NOT EXISTS internalotherpost(trnappid text,trainingtype text,trainercode text,lat text,long text,trainingdate text,remark text ,post text)"
    
    public func insertinternalotherPost(trnappid: String? ,trainingtype: String? ,trainercode: String? ,lat: String? ,long: String?,trainingdate: String?,remark : String? ,post: String?)
     {
         let query = "INSERT INTO internalotherpost (trnappid,trainingtype,trainercode,lat,long,trainingdate,remark,post) VALUES ('\(trnappid!)','\(trainingtype!)','\(trainercode!)','\(lat!)','\(long!)','\(trainingdate!)','\(remark!)','\(post!)')"

         if sqlite3_exec(DatabaseConnection.dbs, query, nil, nil, nil) != SQLITE_OK{
             print("Error inserting in internalotherpost Table")
             return
         }
         print("data saved successfully in internalotherpost table")
     }
    public func deletinternalotherpostPost (){
        let deltable = "DELETE FROM internalotherpost"
        
        if sqlite3_exec(DatabaseConnection.dbs, deltable, nil, nil, nil) != SQLITE_OK{
            print("Error Deleting Table: internalotherpost")
            return
        }
        print("internalotherpost table deleted")
    }
    
    public func updateinternalotherpostPost (trnappid: String?) {
        let updateinternalotherpost = "UPDATE internalotherpost SET post = '2'  WHERE trnappid = '" + trnappid! + "'"
        if sqlite3_exec(DatabaseConnection.dbs, updateinternalotherpost, nil, nil, nil) != SQLITE_OK{
            print("Error updating Table \(updateinternalotherpost)")
            return
        }
        print("\n internalotherpost table updated for id - \(trnappid!)  SET post = 2")
    }
    
    public func updateinternalotherpostRemark (remark: String?,trainingtype : String?) {
        let updateinternalotherpost = "UPDATE internalotherpost SET remark =  '" + remark! + "'  WHERE  trainingtype = '" + trainingtype! + "'   "
        if sqlite3_exec(DatabaseConnection.dbs, updateinternalotherpost, nil, nil, nil) != SQLITE_OK{
            print("Error updating Table \(updateinternalotherpost)")
            return
        }
        
    }


    public func insertHeaderInsalonWorkShop(trnappid: String? ,trainingtype: String? ,trainingcode: String? ,trainercode: String? ,sitecode: String?,sellercode: String? ,Lat: String?,Long: String?,trainingdate: String?,remark: String?,enddate: String?,saloncode: String?,isedit: String?,post: String?,nop: String?,colorcode: String?,salonname: String?,subject: String?)
     {
         let query = "INSERT INTO SalonWorkshopHeadar (TRNAPPID,TRAININGTYPE,TRAININGCODE,TRAINERCODE,SITECODE,SELLERCODE,Lat,Long,TRAININGDATE,REMARK,ENDDATE,SALONCODE,isEdit,Post,nop,colorcode,salonname,subject) VALUES ('\(trnappid!)','\(trainingtype!)','\(trainingcode!)','\(trainercode!)','\(sitecode!)','\(sellercode!)','\(Lat!)','\(Long!)','\(trainingdate!)','\(remark!)','\(enddate!)','\(saloncode!)','\(isedit!)','\(post!)','\(nop!)','\(colorcode!)','\(salonname!)','\(subject!)')"

         if sqlite3_exec(DatabaseConnection.dbs, query, nil, nil, nil) != SQLITE_OK{
             print("Error inserting in SalonWorkshopHeadar Table")
             return
         }
         print("data saved successfully in SalonWorkshopHeadar table")
     }
    public func deletaSalonWorkshopHeadarPost (){
        let deltable = "DELETE FROM SalonWorkshopHeadar"
        
        if sqlite3_exec(DatabaseConnection.dbs, deltable, nil, nil, nil) != SQLITE_OK{
            print("Error Deleting Table: SalonWorkshopHeadar")
            return
        }
        print("SalonWorkshopHeadar table deleted")
    }
    
    public func updateSalonWorkshopHeadarPost (trnappid: String?) {
        let updateSalonWorkshopHeadar = "UPDATE SalonWorkshopHeadar SET Post = '2'  WHERE TRNAPPID = '" + trnappid! + "'"
        if sqlite3_exec(DatabaseConnection.dbs, updateSalonWorkshopHeadar, nil, nil, nil) != SQLITE_OK{
            print("Error updating Table \(updateSalonWorkshopHeadar)")
            return
        }
        print("\n SalonWorkshopHeadar table updated for id - \(trnappid!)  SET post = 2")
    }

    public func insertLineInsalon(trnappid: String? ,saloncode: String? ,trainingdate: String? ,datetime: String? ,stylistname: String?,stylistnumber: String? ,salonname: String?,stylistcode: String?,isedit: String?,salonremark: String?,colorcode: String?,post:String?)
     {
         let query = "INSERT INTO InSalonDetail (TRNAPPID,salonecodes,trainingdate,datetime,stylistname,stylistmobileno,salonname,STYLISTCODE,isEdit,salonremark,colorcode,post) VALUES ('\(trnappid!)','\(saloncode!)','\(trainingdate!)','\(datetime!)','\(stylistname!)','\(stylistnumber!)','\(salonname!)','\(stylistcode!)','\(isedit!)','\(salonremark!)','\(colorcode!)','\(post!)')"

         if sqlite3_exec(DatabaseConnection.dbs, query, nil, nil, nil) != SQLITE_OK{
             print("Error inserting in InSalonDetail Table")
             return
         }
         print("data saved successfully in InSalonDetail table")
     }
    public func deletaInSalonDetailPost (){
        let deltable = "DELETE FROM InSalonDetail"
        
        if sqlite3_exec(DatabaseConnection.dbs, deltable, nil, nil, nil) != SQLITE_OK{
            print("Error Deleting Table: InSalonDetail")
            return
        }
        print("InSalonDetail table deleted")
    }
    
    public func updateInSalonDetailPost (trnappid: String?) {
        let updateInSalonDetail = "UPDATE InSalonDetail SET post = '2'  WHERE TRNAPPID = '" + trnappid! + "'"
        if sqlite3_exec(DatabaseConnection.dbs, updateInSalonDetail, nil, nil, nil) != SQLITE_OK{
            print("Error updating Table \(updateInSalonDetail)")
            return
        }
        print("\n InSalonDetail table updated for id - \(trnappid!)  SET post = 2")
    }
    //        let GetStylistData = "CREATE TABLE IF NOT EXISTS stylist(stylistname text, stylistcode text, contact text , salonname text, saloncode text)"

    public func insertStylistData(stylistname: String? ,stylistcode: String? ,contact: String? ,salonname: String? ,saloncode: String?)
     {
         let query = "INSERT INTO stylist (stylistname,stylistcode,contact,salonname,saloncode) VALUES ('\(stylistname!)','\(stylistcode!)','\(contact!)','\(salonname!)','\(saloncode!)')"

         if sqlite3_exec(DatabaseConnection.dbs, query, nil, nil, nil) != SQLITE_OK{
             print("Error inserting in stylist Table")
             return
         }
         print("data saved successfully in stylist table")
     }
    public func deletStylistData (){
        let deltable = "DELETE FROM stylist"
        
        if sqlite3_exec(DatabaseConnection.dbs, deltable, nil, nil, nil) != SQLITE_OK{
            print("Error Deleting Table: stylist")
            return
        }
        print("stylist table deleted")
    }
    
    public func deletSalonWorkshopHeadarPostTableDataTRNAPPID (saloncode : String?){
        let deltable = "DELETE FROM SalonWorkshopHeadar WHERE SALONCODE = '" + saloncode! + "'"
        
        if sqlite3_exec(DatabaseConnection.dbs, deltable, nil, nil, nil) != SQLITE_OK{
            print("Error Deleting Table: SalonWorkshopHeadar")
            return
        }
        print("SalonWorkshopHeadar table deleted")
    }
    
    
    public func deletSalonWorkshopHeadarsaloncodePostTableData (saloncode : String?,trnappid :String?){
        let deltable = "DELETE FROM SalonWorkshopHeadar WHERE TRNAPPID = '" + trnappid! + " and SALONCODE = '" + saloncode! + "'"
        
        if sqlite3_exec(DatabaseConnection.dbs, deltable, nil, nil, nil) != SQLITE_OK{
            print("Error Deleting Table: SalonWorkshopHeadar")
            return
        }
        print("SalonWorkshopHeadar table deleted")
    }
    
    public func deletSalonWorkshopHeadartrnappidPostTableData (trnappid :String?){
        let deltable = "DELETE FROM SalonWorkshopHeadar WHERE TRNAPPID = '" + trnappid! + "'"
        
        if sqlite3_exec(DatabaseConnection.dbs, deltable, nil, nil, nil) != SQLITE_OK{
            print("Error Deleting Table: SalonWorkshopHeadar")
            return
        }
        print("SalonWorkshopHeadar table deleted")
    }


    
    public func deletSalonWorkshopHeadarPostTableData (saloncode : String?){
        let deltable = "DELETE FROM SalonWorkshopHeadar WHERE SALONCODE = '" + saloncode! + "'"
        
        if sqlite3_exec(DatabaseConnection.dbs, deltable, nil, nil, nil) != SQLITE_OK{
            print("Error Deleting Table: SalonWorkshopHeadar")
            return
        }
        print("SalonWorkshopHeadar table deleted")
    }
    
    public func deleteInSalonDetailPostTableData (trnappid : String?){
        let deltable = "DELETE FROM InSalonDetail WHERE TRNAPPID = '" + trnappid! + "'"
        
        if sqlite3_exec(DatabaseConnection.dbs, deltable, nil, nil, nil) != SQLITE_OK{
            print("Error Deleting Table: InSalonDetail")
            return
        }
        print("InSalonDetail table deleted")
    }
    
    
    public func deleteInSalonDetailStylistCodePostTableData (stylistcode : String? , trnappid : String?){
        let deltable = "DELETE FROM InSalonDetail WHERE  TRNAPPID = '" + trnappid! + "' and STYLISTCODE = '" + stylistcode! + "'"
        
        if sqlite3_exec(DatabaseConnection.dbs, deltable, nil, nil, nil) != SQLITE_OK{
            print("Error Deleting Table: InSalonDetail")
            return
        }
        print("InSalonDetail table deleted")
    }
    public func updateSalonWorkshopHeadarNOPINC (trnappid: String?) {
        let updateSalonWorkshopHeadar = "UPDATE SalonWorkshopHeadar SET nop = nop + 1  WHERE TRNAPPID = '" + trnappid! + "'"
        if sqlite3_exec(DatabaseConnection.dbs, updateSalonWorkshopHeadar, nil, nil, nil) != SQLITE_OK{
            print("Error updating Table \(updateSalonWorkshopHeadar)")
            return
        }
        print("\n SalonWorkshopHeadar table updated for id - \(trnappid!)  ")
    }
    
    public func updateSalonWorkshopHeadarNOPDEC (trnappid: String?) {
        let updateSalonWorkshopHeadar = "UPDATE SalonWorkshopHeadar SET nop = nop - 1  WHERE TRNAPPID = '" + trnappid! + "'"
        if sqlite3_exec(DatabaseConnection.dbs, updateSalonWorkshopHeadar, nil, nil, nil) != SQLITE_OK{
            print("Error updating Table \(updateSalonWorkshopHeadar)")
            return
        }
        print("\n SalonWorkshopHeadar table updated for id - \(trnappid!)" )
    }

    public func insertLineVirtualTraining(trnappid: String? ,trainingdate: String? ,stylistcode: String? ,stylistname: String? ,stylistnumber: String?,saloncode: String? ,salonremark: String?,traininingsubject: String?,isedit: String?,colorcode: String?,post:String?)
     {
         let query = "INSERT INTO VirtualTrainingUpdate (TRNAPPID,TRAININGDATE,STYLISTCODE,STYLISTNAME,STYLISTMOBILENO,SALONCODE,SALONREMARK,TRAININGSUBJECT,isEdit,colorcode,post) VALUES ('\(trnappid!)','\(trainingdate!)','\(stylistcode!)','\(stylistname!)','\(stylistnumber!)','\(saloncode!)','\(salonremark!)','\(traininingsubject!)','\(isedit!)','\(colorcode!)','\(post!)')"

         if sqlite3_exec(DatabaseConnection.dbs, query, nil, nil, nil) != SQLITE_OK{
             print("Error inserting in VirtualTrainingUpdate Table")
             return
         }
         print("data saved successfully in VirtualTrainingUpdate table")
     }
    
    public func deletaIVirtualTrainingPost (){
        let deltable = "DELETE FROM VirtualTrainingUpdate"
        
        if sqlite3_exec(DatabaseConnection.dbs, deltable, nil, nil, nil) != SQLITE_OK{
            print("Error Deleting Table: VirtualTrainingUpdate")
            return
        }
        print("VirtualTrainingUpdate table deleted")
    }
    
    public func updateVirtualTrainingPost (trnappid: String?) {
        let updateVirtualTrainingUpdate = "UPDATE VirtualTrainingUpdate SET post = '2'  WHERE TRNAPPID = '" + trnappid! + "'"
        if sqlite3_exec(DatabaseConnection.dbs, updateVirtualTrainingUpdate, nil, nil, nil) != SQLITE_OK{
            print("Error updating Table \(updateVirtualTrainingUpdate)")
            return
        }
        print("\n VirtualTrainingUpdate table updated for id - \(trnappid!)  SET post = 2")
    }
//        let GetStylistData = "CREATE TABLE IF NOT EXISTS stylist(stylistname text,stylistcode text, contact text,salonname text,saloncode text)"
    public func deletaVirtualTrainingUpdatePost (){
        let deltable = "DELETE FROM VirtualTrainingUpdate"
        
        if sqlite3_exec(DatabaseConnection.dbs, deltable, nil, nil, nil) != SQLITE_OK{
            print("Error Deleting Table: VirtualTrainingUpdate")
            return
        }
        print("VirtualTrainingUpdate table deleted")
    }
    
    public func deleteVirtualTrainingLineUpdatePostTableDataWithStylistCOde (trnappid : String?, stylistcode : String?){
        let deltable = "DELETE FROM VirtualTrainingUpdate WHERE STYLISTCODE = '" + stylistcode! + "' and  TRNAPPID = '" + trnappid! + "'  "
        
        if sqlite3_exec(DatabaseConnection.dbs, deltable, nil, nil, nil) != SQLITE_OK{
            print("Error Deleting Table: VirtualTrainingUpdate")
            return
        }
        print("VirtualTrainingUpdate table deleted")
    }

    
    public func deleteVirtualTrainingLineUpdatePostTableData (trnappid : String?){
        let deltable = "DELETE FROM VirtualTrainingUpdate WHERE  TRNAPPID = '" + trnappid! + "'  "
        
        if sqlite3_exec(DatabaseConnection.dbs, deltable, nil, nil, nil) != SQLITE_OK{
            print("Error Deleting Table: VirtualTrainingUpdate")
            return
        }
        print("VirtualTrainingUpdate table deleted")
    }
    public func deleteVirtualTrainingUpdatePostTableData (trnappid : String?){
        let deltable = "DELETE FROM SalonWorkshopHeadar WHERE TRNAPPID = '" + trnappid! + "'"
        
        if sqlite3_exec(DatabaseConnection.dbs, deltable, nil, nil, nil) != SQLITE_OK{
            print("Error Deleting Table: SalonWorkshopHeadar")
            return
        }
        print("SalonWorkshopHeadar table deleted")
    }
    public func deleteVirtualTrainingUpdateStylistCodePostTableData (stylistcode : String?){
        let deltable = "DELETE FROM VirtualTrainingUpdate WHERE STYLISTCODE = '" + stylistcode! + "'"
        
        if sqlite3_exec(DatabaseConnection.dbs, deltable, nil, nil, nil) != SQLITE_OK{
            print("Error Deleting Table: InSalonDetail")
            return
        }
        print("InSalonDetail table deleted")
    }
    public func deletSalonWorkshopHeadarPostTableDataVirtual (trnappid : String?){
        let deltable = "DELETE FROM SalonWorkshopHeadar WHERE TRNAPPID = '" + trnappid! + "'"
        
        if sqlite3_exec(DatabaseConnection.dbs, deltable, nil, nil, nil) != SQLITE_OK{
            print("Error Deleting Table: SalonWorkshopHeadar")
            return
        }
        print("SalonWorkshopHeadar table deleted")
    }
    //         let query = "INSERT INTO SalonWorkshopHeadar (TRNAPPID,TRAININGTYPE,TRAININGCODE,TRAINERCODE,SITECODE,SELLERCODE,Lat,Long,TRAININGDATE,REMARK,ENDDATE,SALONCODE,isEdit,Post,nop,colorcode,salonname,subject) VALUES
    
//    public func updateSalonWorkshopHeadarDetailsUpdate(trnappid : String? , saloncode: String?,sellercode: String?, sitecode: String? ) {
//        let updateSalonWorkshopHeadar = "UPDATE SalonWorkshopHeadar SET SALONCODE = '" + saloncode! + "' , SELLERCODE = '" + sellercode! + "' , SITECODE = '" + sitecode! + "' WHERE TRNAPPID = '" + trnappid! + "'"
//        if sqlite3_exec(DatabaseConnection.dbs, updateSalonWorkshopHeadar, nil, nil, nil) != SQLITE_OK{
//            print("Error updating Table \(updateSalonWorkshopHeadar)")
//            return
//        }
//        print("\n SalonWorkshopHeadar table updated for id - \(trnappid!)  ")
//    }
    
    
    public func updateSalonWorkshopHeadarDetailsUpdate(trnappid : String? , saloncode: String?,sellercode: String?, sitecode: String? ) {
        let updateSalonWorkshopHeadar = "UPDATE SalonWorkshopHeadar SET  SELLERCODE = '" + sellercode! + "' , SITECODE = '" + sitecode! + "' WHERE TRNAPPID = '" + trnappid! + "'"
        if sqlite3_exec(DatabaseConnection.dbs, updateSalonWorkshopHeadar, nil, nil, nil) != SQLITE_OK{
            print("Error updating Table \(updateSalonWorkshopHeadar)")
            return
        }
        print("\n SalonWorkshopHeadar table updated for id - \(trnappid!)  ")
    }
    
    
    
    //let POSTWorkshopHeaderUpdatedtable = "CREATE TABLE IF NOT EXISTS WorkshopHeaderUpdated (TRNAPPID text,TRAININGTYPE text,TRAININGCODE text,TRAINERCODE text, SITECODE text , SELLERCODE text , Lat text , Long text , TRAININGDATE text , REMARK text,Post text,WORKSHOPDAY2DATE text,WORKSHOPDAY3DATE text,ISMULTIDAYWORKSHOP text,isEdit text,LOCATION text)"
    
    
    
    public func insertWorkshopHeaderUpdated(trnappid: String? ,trainingtype: String? ,trainingcode: String? ,trainercode: String? ,sitecode: String?,sellercode: String? ,Lat: String?,Long: String?,trainingdate: String?,remark: String?,post: String?,workshopday2date: String?,workshopday3date: String?,ismultidayworkshop: String?,isEdit: String?,location: String?)
     {
         let query = "INSERT INTO WorkshopHeaderUpdated (TRNAPPID,TRAININGTYPE,TRAININGCODE,TRAINERCODE,SITECODE,SELLERCODE,Lat,Long,TRAININGDATE,REMARK,Post,WORKSHOPDAY2DATE,WORKSHOPDAY3DATE,ISMULTIDAYWORKSHOP,isEdit,LOCATION) VALUES ('\(trnappid!)','\(trainingtype!)','\(trainingcode!)','\(trainercode!)','\(sitecode!)','\(sellercode!)','\(Lat!)','\(Long!)','\(trainingdate!)','\(remark!)','\(post!)','\(workshopday2date!)','\(workshopday3date!)','\(ismultidayworkshop!)','\(isEdit!)','\(location!)')"

         if sqlite3_exec(DatabaseConnection.dbs, query, nil, nil, nil) != SQLITE_OK{
             print("Error inserting in WorkshopHeaderUpdated Table")
             return
         }
         print("data saved successfully in WorkshopHeaderUpdated table")
     }
    public func deletaWorkshopHeaderUpdatedPost (){
        let deltable = "DELETE FROM WorkshopHeaderUpdated"
        
        if sqlite3_exec(DatabaseConnection.dbs, deltable, nil, nil, nil) != SQLITE_OK{
            print("Error Deleting Table: WorkshopHeaderUpdated")
            return
        }
        print("WorkshopHeaderUpdated table deleted")
    }
    
    public func updateWorkshopHeaderUpdatedPost (trnappid: String?) {
        let updateWorkshopHeaderUpdated = "UPDATE WorkshopHeaderUpdated SET Post = '2'  WHERE TRNAPPID = '" + trnappid! + "'"
        if sqlite3_exec(DatabaseConnection.dbs, updateWorkshopHeaderUpdated, nil, nil, nil) != SQLITE_OK{
            print("Error updating Table \(updateWorkshopHeaderUpdated)")
            return
        }
        print("\n WorkshopHeaderUpdated table updated for id - \(trnappid!)  SET Post = 2")
    }
    
    public func updateWorkshopHeaderUpdatedLocation (trnappid: String?,location :String?) {
        let updateWorkshopHeaderUpdated = "UPDATE WorkshopHeaderUpdated SET LOCATION = '" + location! + "'  WHERE TRNAPPID = '" + trnappid! + "'"
        if sqlite3_exec(DatabaseConnection.dbs, updateWorkshopHeaderUpdated, nil, nil, nil) != SQLITE_OK{
            print("Error updating Table \(updateWorkshopHeaderUpdated)")
            return
        }
        print("\n WorkshopHeaderUpdated table updated for id - \(trnappid!)  SET Post = 2")
    }

    
    public func insertLineInsertWorkshop(trnappid: String? ,trainingdate: String? ,stylistcode: String? ,stylistname: String?,stylistnumber: String? ,saloncode: String?,salonname: String?,salonremark: String?,isedit: String?,post: String?)
     {
         let query = "INSERT INTO InsertWorkshop (TRNAPPID,date,stylistcode,stylistname,stylistmobileno,saloncodes,salonname,remark,isEdit,post) VALUES ('\(trnappid!)','\(trainingdate!)','\(stylistcode!)','\(stylistname!)','\(stylistnumber!)','\(saloncode!)','\(salonname!)','\(salonremark!)','\(isedit!)','\(post!)')"

         if sqlite3_exec(DatabaseConnection.dbs, query, nil, nil, nil) != SQLITE_OK{
             print("Error inserting in InsertWorkshop Table")
             return
         }
         print("data saved successfully in InsertWorkshop table")
     }
    public func deletaInsertWorkshopPost (){
        let deltable = "DELETE FROM InsertWorkshop"
        
        if sqlite3_exec(DatabaseConnection.dbs, deltable, nil, nil, nil) != SQLITE_OK{
            print("Error Deleting Table: InsertWorkshop")
            return
        }
        print("InsertWorkshop table deleted")
    }
    
    public func updateInsertWorkshopPost (trnappid: String?) {
        let updateInsertWorkshop = "UPDATE InsertWorkshop SET post = '2'  WHERE TRNAPPID = '" + trnappid! + "'"
        if sqlite3_exec(DatabaseConnection.dbs, updateInsertWorkshop, nil, nil, nil) != SQLITE_OK{
            print("Error updating Table \(updateInsertWorkshop)")
            return
        }
        print("\n InsertWorkshop table updated for id - \(trnappid!)  SET post = 2")
    }
    
    public func deletInsertWorkshopPostTableData (stylistcode : String?){
        let deltable = "DELETE FROM InsertWorkshop WHERE stylistcode = '" + stylistcode! + "'"
        
        if sqlite3_exec(DatabaseConnection.dbs, deltable, nil, nil, nil) != SQLITE_OK{
            print("Error Deleting Table: InsertWorkshop")
            return
        }
        print("InsertWorkshop table deleted")
    }
    public func deleteInsertWorkshopdata (){
        let deltable = "DELETE FROM InsertWorkshop"
        
        if sqlite3_exec(DatabaseConnection.dbs, deltable, nil, nil, nil) != SQLITE_OK{
            print("Error Deleting Table: InsertWorkshop")
            return
        }
        print("InsertWorkshop table deleted")
    }
    public func deleteWorkshopHeaderUpdated (){
        let deltable = "DELETE FROM WorkshopHeaderUpdated"
        
        if sqlite3_exec(DatabaseConnection.dbs, deltable, nil, nil, nil) != SQLITE_OK{
            print("Error Deleting Table: WorkshopHeaderUpdated")
            return
        }
        print("WorkshopHeaderUpdated table deleted")
    }
    public func deleteHomeProd (){
        let deltable = "DELETE FROM HomeProd"
        if sqlite3_exec(DatabaseConnection.dbs, deltable, nil, nil, nil) != SQLITE_OK{
            print("Error Deleting Table: HomeProd")
            return
        }
        print("HomeProd table deleted")
    }
    public func deleteHomeProd_UnProd (){
        let deltable = "DELETE FROM HomeProd_UnProd"
        if sqlite3_exec(DatabaseConnection.dbs, deltable, nil, nil, nil) != SQLITE_OK{
            print("Error Deleting Table: HomeProd_UnProd")
            return
        }
        print("HomeProd_UnProd table deleted")
    }
    public func deleteColorLevel (){
        let deltable = "DELETE FROM ColorLevel"
        if sqlite3_exec(DatabaseConnection.dbs, deltable, nil, nil, nil) != SQLITE_OK{
            print("Error Deleting Table: ColorLevel")
            return
        }
        print("ColorLevel table deleted")
    }
    
    //private static  final String create_table_HomeProd="CREATE TABLE IF NOT EXISTS HomeProd(productivecount text,totalproductivecount text,productivecountlm text,totalfycount text,prodper text);";
    
    public func insertHomeProd(productivecount: String? ,totalproductivecount: String? ,productivecountlm: String? ,totalfycount: String? ,prodper: String?)
     {
         let query = "INSERT INTO HomeProd (productivecount,totalproductivecount,productivecountlm,totalfycount,prodper) VALUES ('\(productivecount!)','\(totalproductivecount!)','\(productivecountlm!)','\(totalfycount!)','\(prodper!)')"

         if sqlite3_exec(DatabaseConnection.dbs, query, nil, nil, nil) != SQLITE_OK{
             print("Error inserting in HomeProd Table")
             return
         }
         print("data saved successfully in HomeProd table")
     }
    
    public func insertHomeProd_UnProd(typecustomer: String? ,customeR_CODE: String?)
     {
         let query = "INSERT INTO HomeProd_UnProd (typecustomer,customeR_CODE) VALUES ('\(typecustomer!)','\(customeR_CODE!)')"

         if sqlite3_exec(DatabaseConnection.dbs, query, nil, nil, nil) != SQLITE_OK{
             print("Error inserting in HomeProd_UnProd Table")
             return
         }
         print("data saved successfully in HomeProd_UnProd table")
     }
    
    public func insertColorLevel(trainingname: String? ,level: String?)
     {
         let query = "INSERT INTO ColorLevel (trainingname,level) VALUES ('\(trainingname!)','\(level!)')"

         if sqlite3_exec(DatabaseConnection.dbs, query, nil, nil, nil) != SQLITE_OK{
             print("Error inserting in ColorLevel Table")
             return
         }
         print("data saved successfully in ColorLevel table")
     }

    public func insertUserProfileNew(trainercode: String? ,trainername: String? ,contactno: String? ,email: String?,reportinGMANAGER: String? ,stylisTTRAINEDYTD: String?,uniquedoorSTRAINEDYTD: String?,traininGCONDUCTEDYTD: String?,toPDOORSTRAINEDYTD: String?)
     {
         let query = "INSERT INTO UserProfileNew (trainercode,trainername,contactno,email,reportinGMANAGER,stylisTTRAINEDYTD,uniquedoorSTRAINEDYTD,traininGCONDUCTEDYTD,toPDOORSTRAINEDYTD) VALUES ('\(trainercode!)','\(trainername!)','\(contactno!)','\(email!)','\(reportinGMANAGER!)','\(stylisTTRAINEDYTD!)','\(uniquedoorSTRAINEDYTD!)','\(traininGCONDUCTEDYTD!)','\(toPDOORSTRAINEDYTD!)')"

         if sqlite3_exec(DatabaseConnection.dbs, query, nil, nil, nil) != SQLITE_OK{
             print("Error inserting in UserProfileNew Table")
             return
         }
         print("data saved successfully in UserProfileNew table")
     }
    public func deleteUserProfileNew (){
        let deltable = "DELETE FROM UserProfileNew"
        
        if sqlite3_exec(DatabaseConnection.dbs, deltable, nil, nil, nil) != SQLITE_OK{
            print("Error Deleting UserProfileNew Table: UserProfileNew")
            return
        }
        print("UserProfileNew table deleted")
    }
    //(trnappid: trnappid,saloncode: saloncode,salonaddress: salonaddress,salonname: salonname )
    public func updatehotdaymarketvisitDetails (trnappid: String?,saloncode: String?,salonaddress: String?,salonname: String?) {
        let updatehotdaymarketvisitDetails = "UPDATE hotdaymarketvisit SET salonname = '" + salonname! + "' , salonaddress = '" + salonaddress! + "' , saloncode = '" + saloncode! + "'  WHERE trnappid = '" + trnappid! + "'"
        
        if sqlite3_exec(DatabaseConnection.dbs, updatehotdaymarketvisitDetails, nil, nil, nil) != SQLITE_OK{
            print("Error updating Table \(updatehotdaymarketvisitDetails)")
            return
        }
        print("\n hotdaymarketvisit table updated for id - \(trnappid!)  SET post = 2")
    }

    public func insertGetAllowTrainingTypeMaster(primarY_DESCRIPTION: String? ,secondarY_DESCRIPTION: String?)
     {
         let query = "INSERT INTO GetAllowTrainingTypeMaster (primarY_DESCRIPTION,secondarY_DESCRIPTION) VALUES ('\(primarY_DESCRIPTION!)','\(secondarY_DESCRIPTION!)')"

         if sqlite3_exec(DatabaseConnection.dbs, query, nil, nil, nil) != SQLITE_OK{
             print("Error inserting in GetAllowTrainingTypeMaster Table")
             return
         }
         print("data saved successfully in GetAllowTrainingTypeMaster table")
     }
    public func deleteGetAllowTrainingTypeMaster (){
        let deltable = "DELETE FROM GetAllowTrainingTypeMaster"
        
        if sqlite3_exec(DatabaseConnection.dbs, deltable, nil, nil, nil) != SQLITE_OK{
            print("Error Deleting Table: GetAllowTrainingTypeMaster")
            return
        }
        print("GetAllowTrainingTypeMaster table deleted")
    }
//
//    let PostCalender = "CREATE TABLE IF NOT EXISTS  PostCalender (ENTRY_TYPE text,TRAINER_CODE text,IMPACT_DATE text,PLANNED_ACTIVITY text,CHANGE_REQUESTED text,DATE_APPLIED text,STATUS text ,CREATEDDATETIME text,CREATEDBY text,DATAAREAID text, TRNAPPID text, Post text,INSALON_1_CODE text,NEW_INSALON_1_CODE text,INSALON_1_SUBJECT text,NEW_INSALON_1_SUBJECT text,INSALON_2_CODE text,NEW_INSALON_2_CODE text,INSALON_2_SUBJECT text,NEW_INSALON_2_SUBJECT text,ACTIVITY_SUBJECT text,NEW_ACTIVITY_SUBJECT text)"
//
//    let GetCalenderPending = "CREATE TABLE IF NOT EXISTS GetCalenderPending (date text, changE_REQUESTED text,traineR_CODE text, impacT_DATE text,datE_APPLIED text,neW_INSALON_1_SUBJECT text,neW_INSALON_2_SUBJECT text,shorT_DESC text,neW_SALONNAME1 text,neW_SALONCODE1 text,neW_SALONNAME2 text,neW_SALONCODE2 text,neW_ACTIVITY_SUBJECT text)"

    public func insertCalenderPending(date: String? ,changE_REQUESTED: String? ,traineR_CODE: String? ,impacT_DATE: String? ,datE_APPLIED: String?,neW_INSALON_1_SUBJECT: String? ,neW_INSALON_2_SUBJECT: String?,shorT_DESC: String? ,neW_SALONNAME1: String? ,neW_SALONCODE1: String? ,neW_SALONNAME2: String?,neW_SALONCODE2: String?,neW_ACTIVITY_SUBJECT: String?)
     {
         let query = "INSERT INTO GetCalenderPending (date,changE_REQUESTED,traineR_CODE,impacT_DATE,datE_APPLIED,neW_INSALON_1_SUBJECT,neW_INSALON_2_SUBJECT,shorT_DESC,neW_SALONNAME1,neW_SALONCODE1,neW_SALONNAME2,neW_SALONCODE2,neW_ACTIVITY_SUBJECT) VALUES ('\(date!)','\(changE_REQUESTED!)','\(traineR_CODE!)','\(impacT_DATE!)','\(datE_APPLIED!)','\(neW_INSALON_1_SUBJECT!)','\(neW_INSALON_2_SUBJECT!)','\(shorT_DESC!)','\(neW_SALONNAME1!)','\(neW_SALONCODE1!)','\(neW_SALONNAME2!)','\(neW_SALONCODE2!)','\(neW_ACTIVITY_SUBJECT!)')"

         if sqlite3_exec(DatabaseConnection.dbs, query, nil, nil, nil) != SQLITE_OK{
             print("Error inserting in Calender Table")
             return
         }
         print("data saved successfully in Calender table")
     }
    public func deleteGetCalenderPending(){
        let deltable = "DELETE FROM GetCalenderPending"
        
        if sqlite3_exec(DatabaseConnection.dbs, deltable, nil, nil, nil) != SQLITE_OK{
            print("Error Deleting Table: GetCalenderPending")
            return
        }
        print("Calender table GetCalenderPending")
    }
    //    let GETCalender = "CREATE TABLE IF NOT EXISTS Calender (date text,activitY_NAME text,trainercode text,activitY_SUBJECT text,insaloN_1_CODE text,insaloN_1_SUBJECT text,insaloN_2_CODE text,insaloN_2_SUBJECT text,salonnamE1 text,salonnamE2 text,shorT_DESC text,status text,isblock text,blocK_REASON text,approveD_ACTIVITY_NAME text,approveD_ACTIVITY_SUBJECT text,approveD_INSALON_1_CODE text,approveD_INSALON_1_SUBJECT text,approveD_INSALON_2_CODE text,approveD_INSALON_2_SUBJECT text,apP_SALONNAME1 text,apP_SALONNAME2 text)"

    public func insertCalender(date: String? ,activitY_NAME: String? ,trainercode: String? ,activitY_SUBJECT: String? ,insaloN_1_CODE: String?,insaloN_1_SUBJECT: String? ,insaloN_2_CODE: String?,insaloN_2_SUBJECT: String?,salonnamE1: String?,salonnamE2: String? ,shorT_DESC: String? ,status: String? ,isblock: String? ,blocK_REASON: String?,approveD_ACTIVITY_NAME: String? ,approveD_ACTIVITY_SUBJECT: String?,approveD_INSALON_1_CODE: String?,approveD_INSALON_1_SUBJECT: String? ,approveD_INSALON_2_CODE: String?,approveD_INSALON_2_SUBJECT: String?,apP_SALONNAME1: String?,apP_SALONNAME2: String?)
     {
         let query = "INSERT INTO Calender (date,activitY_NAME,trainercode,activitY_SUBJECT,insaloN_1_CODE ,insaloN_1_SUBJECT ,insaloN_2_CODE,insaloN_2_SUBJECT,salonnamE1 ,salonnamE2 ,shorT_DESC ,status ,isblock ,blocK_REASON ,approveD_ACTIVITY_NAME ,approveD_ACTIVITY_SUBJECT ,approveD_INSALON_1_CODE ,approveD_INSALON_1_SUBJECT ,approveD_INSALON_2_CODE ,approveD_INSALON_2_SUBJECT ,apP_SALONNAME1 ,apP_SALONNAME2) VALUES ('\(date!)','\(activitY_NAME!)','\(trainercode!)','\(activitY_SUBJECT!)','\(insaloN_1_CODE!)','\(insaloN_1_SUBJECT!)','\(insaloN_2_CODE!)','\(insaloN_2_SUBJECT!)','\(salonnamE1!)','\(salonnamE2!)','\(shorT_DESC!)','\(status!)','\(isblock!)','\(blocK_REASON!)','\(approveD_ACTIVITY_NAME!)','\(approveD_ACTIVITY_SUBJECT!)','\(approveD_INSALON_1_CODE!)','\(approveD_INSALON_1_SUBJECT!)','\(approveD_INSALON_2_CODE!)','\(approveD_INSALON_2_SUBJECT!)','\(apP_SALONNAME1!)','\(apP_SALONNAME2!)')"

         if sqlite3_exec(DatabaseConnection.dbs, query, nil, nil, nil) != SQLITE_OK{
             print("Error inserting in Calender Table")
             return
         }
         print("data saved successfully in Calender table")
     }
    public func deleteCalender(){
        let deltable = "DELETE FROM Calender"
        
        if sqlite3_exec(DatabaseConnection.dbs, deltable, nil, nil, nil) != SQLITE_OK{
            print("Error Deleting Table: Calender")
            return
        }
        print("Calender table deleted")
    }
    
    //let PostDeleteData = "CREATE  TABLE IF NOT EXISTS  PostDeleteData (TRNAPPID text,TRAINERCODE text,DATAAREAID text,Post text,ActivityType text)"

    public func deletePostDeleteData(){
           let deltable = "DELETE FROM PostDeleteData"
           
           if sqlite3_exec(DatabaseConnection.dbs, deltable, nil, nil, nil) != SQLITE_OK{
               print("Error Deleting Table: PostDeleteData")
               return
           }
           print("PostDeleteData table deleted")
       }
    public func insertPostDeleteData(TRNAPPID: String? ,TRAINERCODE: String?,DATAAREAID: String? ,Post: String?,ActivityType: String?)
     {
         let query = "INSERT INTO PostDeleteData (TRNAPPID,TRAINERCODE,DATAAREAID,Post,ActivityType) VALUES ('\(TRNAPPID!)','\(TRAINERCODE!)','\(DATAAREAID!)','\(Post!)','\(ActivityType!)')"

         if sqlite3_exec(DatabaseConnection.dbs, query, nil, nil, nil) != SQLITE_OK{
             print("Error inserting in PostDeleteData Table")
             return
         }
         print("data saved successfully in PostDeleteData table")
     }
    public func updatePostDeleteData (trnappid: String?) {
        let updatePostDeleteData = "UPDATE PostDeleteData SET post = '2'  WHERE TRNAPPID = '" + trnappid! + "'"
        if sqlite3_exec(DatabaseConnection.dbs, updatePostDeleteData, nil, nil, nil) != SQLITE_OK{
            print("Error updating Table \(updatePostDeleteData)")
            return
        }
        print("\n PostDeleteData table updated for id - \(trnappid!)  SET post = 2")
    }
    //        let PostCalender = "CREATE TABLE IF NOT EXISTS  PostCalender (ENTRY_TYPE text,TRAINER_CODE text,IMPACT_DATE text,PLANNED_ACTIVITY text,CHANGE_REQUESTED text,DATE_APPLIED text,STATUS text ,CREATEDDATETIME text,CREATEDBY text,DATAAREAID text, TRNAPPID text, Post text,INSALON_1_CODE text,NEW_INSALON_1_CODE text,INSALON_1_SUBJECT text,NEW_INSALON_1_SUBJECT text,INSALON_2_CODE text,NEW_INSALON_2_CODE text,INSALON_2_SUBJECT text,NEW_INSALON_2_SUBJECT text,ACTIVITY_SUBJECT text,NEW_ACTIVITY_SUBJECT text)"
////        databaseConnection.insertCalenderPostForInSal_Wrksp_VT(getID(), "1", trainercode, trainingdate, plannedActivity, activityID, appDate, "0",
//                trainingdate, trainercode, "7200","","","",""
//                ,"","","","","","");

    public func insertPostCalender(TRNAPPID: String? ,ENTRY_TYPE: String? ,TRAINER_CODE: String? ,IMPACT_DATE: String? ,PLANNED_ACTIVITY: String?,CHANGE_REQUESTED: String? ,DATE_APPLIED: String?,STATUS: String?,CREATEDDATETIME: String?,CREATEDBY: String? ,DATAAREAID: String? ,Post: String? ,INSALON_1_CODE: String? ,NEW_INSALON_1_CODE: String?,INSALON_1_SUBJECT: String? ,NEW_INSALON_1_SUBJECT: String?,INSALON_2_CODE: String?,NEW_INSALON_2_CODE: String? ,INSALON_2_SUBJECT: String?,NEW_INSALON_2_SUBJECT: String?,ACTIVITY_SUBJECT: String?,NEW_ACTIVITY_SUBJECT: String?)
     {
         let query = "INSERT INTO PostCalender (TRNAPPID,ENTRY_TYPE,TRAINER_CODE,IMPACT_DATE,PLANNED_ACTIVITY ,CHANGE_REQUESTED ,DATE_APPLIED,STATUS,CREATEDDATETIME ,CREATEDBY ,DATAAREAID ,Post ,INSALON_1_CODE ,NEW_INSALON_1_CODE ,INSALON_1_SUBJECT ,NEW_INSALON_1_SUBJECT ,INSALON_2_CODE ,NEW_INSALON_2_CODE ,INSALON_2_SUBJECT ,NEW_INSALON_2_SUBJECT ,ACTIVITY_SUBJECT ,NEW_ACTIVITY_SUBJECT) VALUES ('\(TRNAPPID!)','\(ENTRY_TYPE!)','\(TRAINER_CODE!)','\(IMPACT_DATE!)','\(PLANNED_ACTIVITY!)','\(CHANGE_REQUESTED!)','\(DATE_APPLIED!)','\(STATUS!)','\(CREATEDDATETIME!)','\(CREATEDBY!)','\(DATAAREAID!)','\(Post!)','\(INSALON_1_CODE!)','\(NEW_INSALON_1_CODE!)','\(INSALON_1_SUBJECT!)','\(NEW_INSALON_1_SUBJECT!)','\(INSALON_2_CODE!)','\(NEW_INSALON_2_CODE!)','\(INSALON_2_SUBJECT!)','\(NEW_INSALON_2_SUBJECT!)','\(ACTIVITY_SUBJECT!)','\(NEW_ACTIVITY_SUBJECT!)')"

         if sqlite3_exec(DatabaseConnection.dbs, query, nil, nil, nil) != SQLITE_OK{
             print("Error inserting in PostCalender Table")
             return
         }
         print("data saved successfully in PostCalender table")
     }
    public func deletePostCalender(){
        let deltable = "DELETE FROM PostCalender"
        
        if sqlite3_exec(DatabaseConnection.dbs, deltable, nil, nil, nil) != SQLITE_OK{
            print("Error Deleting Table: PostCalender")
            return
        }
        print("PostCalender table deleted")
    }
    public func updatePostCalenderPost (trnappid: String?) {
        let updateEPostCalenderPost = "UPDATE PostCalender SET post = '2'  WHERE TRNAPPID = '" + trnappid! + "'"
        if sqlite3_exec(DatabaseConnection.dbs, updateEPostCalenderPost, nil, nil, nil) != SQLITE_OK{
            print("Error updating Table \(updateEPostCalenderPost)")
            return
        }
        print("\n PostCalender table updated for id - \(trnappid!)  SET post = 2")
    }

    public func deletetrainingData (){
           let deltable = "DELETE FROM TrainingMaster"
           
           if sqlite3_exec(DatabaseConnection.dbs, deltable, nil, nil, nil) != SQLITE_OK{
               print("Error Deleting Table: TrainingMaster")
               return
           }
           print("TrainingMaster table deleted")
       }
    
    public func updatehotdaymarketvisitremark (remark: String? , trainingType : String?) {
        let updatehotdaymarketvisit = "UPDATE hotdaymarketvisit SET remark  = '" + remark! + "' where trainingtype = '" + trainingType! + "'  "
        if sqlite3_exec(DatabaseConnection.dbs, updatehotdaymarketvisit, nil, nil, nil) != SQLITE_OK{
            print("Error updating Table \(updatehotdaymarketvisit)")
            return
        }
        print(" hotdaymarketvisit table remark updated successfully")
    }
    
}

