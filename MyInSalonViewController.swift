//  MyInSalonViewController.swift
//  Wella.2
//
//  Created by Acxiom Consulting on 09/03/21.
//  Copyright © 2021 Acxiom. All rights reserved.


//MARK:- IMPORTS
import UIKit
import Dropdowns
import SQLite3
import Alamofire
import SystemConfiguration
import SwiftEventBus
import CoreLocation

class MyInSalonViewController:  ExecuteApi , CLLocationManagerDelegate ,  UITableViewDelegate, UITableViewDataSource
{
    @IBOutlet weak var saveBtn: UIButton!
    //MARK:-OUTLETS
    @IBOutlet weak var noplabel: UILabel!
    @IBOutlet weak var InSalonLineTableView: UITableView!
    @IBOutlet weak var InSalonHeaderTableView: UITableView!
    @IBOutlet weak var subjectlabel: UILabel!
    @IBOutlet weak var myInsalonLineView: UIView!
    @IBOutlet weak var stylistContactDropDown: DropDown!
    @IBOutlet weak var stylistCodeDropDown: DropDown!
    @IBOutlet weak var stylistNameDropDown: DropDown!
    @IBOutlet weak var myInsalonLineName: UILabel!
    
    @IBAction func addSalonLineBtnClick(_ sender: Any) {
        ADDSALONLINECLICK()
    }
    @IBAction func addSalonHeaderBtnClick(_ sender: Any) {
        ADDSALONHEADERCLICK()
    }
    @IBOutlet weak var salonCodeLineLabel: UILabel!
    @IBAction func saveBtnClick(_ sender: UIButton) {
        SAVEBTNCLICKINSERTDATA()
    }
    @IBOutlet weak var activitySubjectDropDown: DropDown!
    @IBOutlet weak var salonCodeDropDown: DropDown!
    @IBOutlet weak var salonNameLineLabel: UILabel!
    @IBOutlet weak var salonNameDropDown: DropDown!
    @IBOutlet weak var stylistNameLabel: UILabel!
    @IBOutlet weak var stylistCodeLabel: UILabel!
    @IBOutlet weak var salonNameLabel: UILabel!
    @IBOutlet weak var salonCodeLabel: UILabel!
    @IBAction func addSalonBtn(_ sender: UIButton) {
        SHOWPOPUP()
    }
    
    
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var myinsalonHeaderView: UIView!
    
    //MARK:- VARIBALE DECLARATION
    var menuvc: menuViewController!
    var insalonheaderlistdata = [InSalonWorkshopHeaderAdapter]()
    var insalonlinelistdata = [InSalonLineAdapter]()
    
    var salonCode : String! = ""
    var salonName : String! = ""
    var salonAddress : String! = ""
    var salonPsrCode : String! = ""
    var salonSiteCode : String! = ""
    var subjectName : String! = ""
    var subjectCode : String! = ""
    var stylistName : String! = ""
    var stylistCode : String! = ""
    var stylistNumber : String! = ""
    var stylistSalonName : String! = ""
    var stylistSalonCode : String! = ""
    var colorCode : String! = ""
    
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
    var subjectNamearray : [String]! = []
    var subjectCodearray : [String]! = []
    var stylistNamearray : [String]! = []
    var stylistCodearray : [String]! = []
    var stylistNumberarray : [String]! = []
    var stylistsalonCodearray : [String]! = []
    var stylistsalonnamearray : [String]! = []
    var TRNAPPID : String! = ""
    var salonCodeSelectedarray : [String]! = []
    var stylistCodeSelectedarray : [String]! = []
    var trnappidSelectedarray : [String]! = []
    var trnappidLineSelectedarray : [String]! = []
    var colorcodeLine : String! = ""
    
    //MARK:- TABLE VIEW METHODS
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (tableView == InSalonHeaderTableView) ?self.insalonheaderlistdata.count : self.insalonlinelistdata.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            if (tableView == InSalonHeaderTableView) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "insalonheader") as! InSalonHeaderTableView
            let list: InSalonWorkshopHeaderAdapter
            list = insalonheaderlistdata[indexPath.row]
            cell.salonCode.text = list.saloncode
            cell.salonName.text = list.salonname
            cell.subject.text = list.subject
            cell.nop.text = list.nop
            if(list.colorcode == "first"){
                cell.backgroundColor = UIColor.gray
            }
            else{
                cell.backgroundColor = UIColor.lightGray
            }
            return cell
         }
        
         if (tableView == InSalonLineTableView) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "insalonline") as! InSalonLineTableViewCell
            let list: InSalonLineAdapter
            list = insalonlinelistdata[indexPath.row]
            cell.salonCode.text = list.saloncode
            cell.salonName.text = list.salonname
            cell.stylistCode.text = list.stylistcode
            cell.stylistName.text = list.stylistname

            if(list.colorcode == "first"){
                cell.backgroundColor = UIColor.gray
            }
            else{
                cell.backgroundColor = UIColor.lightGray
            }
            return cell
           }
        return UITableViewCell()
    }
    
   
    func setDataforLine(indexPath : Int){
        let list: InSalonWorkshopHeaderAdapter
        list = insalonheaderlistdata[indexPath]
        myInsalonLineName.text! = list.salonname!
        self.TRNAPPID = list.trnappid!
        self.stylistSalonCode = list.saloncode
        self.stylistSalonName = list.salonname
        self.colorcodeLine =  list.colorcode
        fillStylistData(saloncode: self.salonCode!)
        if(self.myinsalonHeaderView.isHidden == false){
            self.salonNameDropDown.text! = ""
            self.salonCodeDropDown.text! = ""
            self.activitySubjectDropDown.text! = ""
            self.myinsalonHeaderView.isHidden = true
        }
        self.myInsalonLineView.isHidden = false
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if(editingStyle == .delete){
            self.presentDeletionFailsafe(indexPath: indexPath , tableView: tableView)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (tableView == InSalonHeaderTableView) {
        setDataforLine(indexPath: indexPath.row)
        }
    }
    func presentDeletionFailsafe(indexPath:IndexPath,tableView: UITableView) {
        let alert=UIAlertController(title: nil, message: "Are you sure you'd like to delete this Line", preferredStyle: .alert)
        let yesAction=UIAlertAction(title: "Yes", style: .default) { _ in
            if tableView == self.InSalonHeaderTableView {
                let element = self.salonCodeSelectedarray[indexPath.row]
                let element1 = self.trnappidSelectedarray[indexPath.row]
                self.deletSalonWorkshopHeadartrnappidPostTableData(trnappid: element1)
                self.deleteInSalonDetailPostTableData(trnappid: element1)
                self.setList()
                self.setList2()
            }
            else{
                let element = self.stylistCodeSelectedarray[indexPath.row]
                let element1 = self.trnappidLineSelectedarray[indexPath.row]
                self.deleteInSalonDetailStylistCodePostTableData(stylistcode: element , trnappid: element1 )
                self.updateSalonWorkshopHeadarNOPDEC(trnappid: element1)
                self.setList()
                self.setList2()
            }
        }
        alert.addAction(yesAction)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    

    
    
    //MARK:- VIEW DID LOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(myinsalonHeaderView)
        self.view.addSubview(myInsalonLineView)
        let value = UIInterfaceOrientation.portrait.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
        myinsalonHeaderView.isHidden = true
        myInsalonLineView.isHidden = true
        setDate()
        determineMyCurrentLocation()
        setUpSideBar()
        setupLabels()
        fillDropDownData()
        setupDidSelect()
        setList()
        setList2()
        
    }
    @IBAction func cancelHeaderBtnClick(_ sender: UIButton) {
        HIDEHEDAERVIEW()
    }
    
    @IBAction func cancelLineBtnClick(_ sender: UIButton) {
        HIDELINEVIEW()
    }
    
    fileprivate func HIDEHEDAERVIEW(){
        if(self.myinsalonHeaderView.isHidden == false){
            self.myinsalonHeaderView.isHidden = true
        }
    }

    
    fileprivate func HIDELINEVIEW(){
        if(self.myInsalonLineView.isHidden == false){
           self.myInsalonLineView.isHidden = true
        }
    }
    
    func setDate(){
        let dateNew = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MMM-yyyy"
        let result = formatter.string(from: dateNew)
        dateTextField.text! = result
    }
    
    
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        let touch: UITouch? = touches.first!
//
//        if touch?.view != myinsalonHeaderView {
//            myinsalonHeaderView.isHidden = true
//        }
//        if touch?.view != myInsalonLineView {
//            myInsalonLineView.isHidden = true
//        }
//    }
    
    //MARK:- checkNOP
       func checkNOP(trainingtype : String?) -> Bool
       {
         
           var stmt4:OpaquePointer?
           let queryString = "SELECT * FROM SalonWorkshopHeadar where nop = '0' and  trainingtype  = '" + trainingtype! + "'"
           print("setList"+queryString)
           if sqlite3_prepare_v2(DatabaseConnection.dbs, queryString, -1, &stmt4, nil) != SQLITE_OK{
               let errmsg = String(cString: sqlite3_errmsg(DatabaseConnection.dbs)!)
               print("error preparing get: \(errmsg)")
              
           }
           while(sqlite3_step(stmt4) == SQLITE_ROW){
               self.showtoast(controller: self, message: "Please Add Particpant First", seconds: 1.0)
               return false
           }
           return true
       }
    
    fileprivate func ADDSALONLINECLICK(){
        if(validationLine() && checkListLine(stylistCodeStr: self.stylistCode!, trnappid: TRNAPPID) && validateNetwork()){
            do{
                self.insertLineInsalon(trnappid: TRNAPPID, saloncode: self.stylistSalonCode!, trainingdate: getTodayDateStringYMD(), datetime: getTodayStringNew(), stylistname: self.SetStylistName(stylistNameString : self.stylistName!), stylistnumber: self.stylistNumber!, salonname: self.stylistSalonName!, stylistcode: self.stylistCode!, isedit: "0", salonremark: "",colorcode : self.colorcodeLine! ,post: "1")
                
                //UPDATE NOP ALSO HERE OF HEADER
                self.updateSalonWorkshopHeadarNOPINC(trnappid: TRNAPPID)
                setList()
                setList2()
                self.stylistNameDropDown.text! = ""
                self.stylistCodeDropDown.text! = ""
                self.stylistContactDropDown.text! = ""
                self.stylistName! = ""
                self.stylistCode! = ""
                self.stylistNumber! = ""
                myInsalonLineView.isHidden = true
            }
        }
        
    }
    
    //MARK:- SETLIST
    func setList2()
    {
        self.trnappidLineSelectedarray.removeAll()

        self.stylistCodeSelectedarray.removeAll()
        self.insalonlinelistdata.removeAll()
        self.InSalonLineTableView.isHidden = false
        var stmt4:OpaquePointer?
        let queryString = "SELECT salonecodes,salonname,STYLISTCODE,stylistname,TRNAPPID,colorcode  FROM InSalonDetail  order by colorcode "
        print("setList"+queryString)
        if sqlite3_prepare_v2(DatabaseConnection.dbs, queryString, -1, &stmt4, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(DatabaseConnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return
        }
        while(sqlite3_step(stmt4) == SQLITE_ROW){
            let saloncodeStr = String(cString: sqlite3_column_text(stmt4, 0))
            let salonNameStr = String(cString: sqlite3_column_text(stmt4, 1))
            let stylistcodeStr = String(cString: sqlite3_column_text(stmt4, 2))
            let stylistnameStr = String(cString: sqlite3_column_text(stmt4, 3))
            let trnappidStr = String(cString: sqlite3_column_text(stmt4, 4))
            let colorcodeStr = String(cString: sqlite3_column_text(stmt4, 5))

            self.trnappidLineSelectedarray.append(trnappidStr)
            self.stylistCodeSelectedarray.append(stylistcodeStr)
            self.insalonlinelistdata.append(InSalonLineAdapter(stylistcode: stylistcodeStr, stylistname: stylistnameStr, salonname: salonNameStr, saloncode: saloncodeStr,trnapppid :trnappidStr, colorcode: colorcodeStr))
        }
        self.InSalonLineTableView.reloadData()
    }
    
    
    //MARK:- SETUP DID SELECT
    fileprivate  func setupDidSelect () {
        setupOnClicksalonCode()
        setupOnClickSalonName()
        setupOnClickActivitySubject()
        setupOnClickStylistCode()
        setupOnClickStylistName()
        setupOnClickStylistMobileNumber()
    }
    fileprivate func setupOnClicksalonCode(){
        salonCodeDropDown.didSelect{(selectedText , index ,id) in
            print("Selected String: \(selectedText) \n index: \(index)")
            self.salonName = self.salonNamearray[index]
            self.salonCode = self.salonCodearray[index]
            self.salonAddress = self.salonAddressarray[index]
            self.salonPsrCode = self.salonPsrCodearray[index]
            self.salonSiteCode = self.salonSiteCodearray[index]
            
            self.salonNameDropDown.text! = self.salonName!
            self.salonCodeDropDown.text! = self.salonCode!
        }
    }
    fileprivate func setupOnClickSalonName(){
        salonNameDropDown.didSelect{(selectedText , index ,id) in
            print("Selected String: \(selectedText) \n index: \(index)")
            self.salonName = self.salonNamearray[index]
            self.salonCode = self.salonCodearray[index]
            self.salonAddress = self.salonAddressarray[index]
            self.salonPsrCode = self.salonPsrCodearray[index]
            self.salonSiteCode = self.salonSiteCodearray[index]
            
            self.salonNameDropDown.text! = self.salonName!
            self.salonCodeDropDown.text! = self.salonCode!
        }
        
    }
    
    fileprivate func setupOnClickActivitySubject(){
        activitySubjectDropDown.didSelect{(selectedText , index ,id) in
            print("Selected String: \(selectedText) \n index: \(index)")
            self.subjectName = self.subjectNamearray[index]
            self.subjectCode = self.subjectCodearray[index]
            
            self.activitySubjectDropDown.text! = self.subjectName!
        }
        
    }
    fileprivate func setupOnClickStylistCode(){
        stylistCodeDropDown.didSelect{(selectedText , index ,id) in
            print("Selected String: \(selectedText) \n index: \(index)")
            self.stylistCode = self.stylistCodearray[index]
            self.stylistName = self.stylistNamearray[index]
            self.stylistNumber = self.stylistNumberarray[index]
            self.stylistCodeDropDown.text! = self.stylistCode!
            self.stylistNameDropDown.text! = self.stylistName!
            self.stylistContactDropDown.text! = self.stylistNumber!

        }
        
    }
    fileprivate func setupOnClickStylistName(){
        stylistNameDropDown.didSelect{(selectedText , index ,id) in
            print("Selected String: \(selectedText) \n index: \(index)")
            self.stylistCode = self.stylistCodearray[index]
            self.stylistName = self.stylistNamearray[index]
            self.stylistNumber = self.stylistNumberarray[index]
            self.stylistCodeDropDown.text! = self.stylistCode!
            self.stylistNameDropDown.text! = self.stylistName!
            self.stylistContactDropDown.text! = self.stylistNumber!
        }
        
    }
    fileprivate func setupOnClickStylistMobileNumber(){
        stylistContactDropDown.didSelect{(selectedText , index ,id) in
            print("Selected String: \(selectedText) \n index: \(index)")
            self.stylistCode = self.stylistCodearray[index]
            self.stylistName = self.stylistNamearray[index]
            self.stylistNumber = self.stylistNumberarray[index]
            self.stylistCodeDropDown.text! = self.stylistCode!
            self.stylistNameDropDown.text! = self.stylistName!
            self.stylistContactDropDown.text! = self.stylistNumber!
        }
        
    }
    
    
    
    
    
    //MARK:- FILL DROPDOWN
    fileprivate  func fillDropDownData () {
        fillSalonNameData()
        fillStylistSubjectData()
    }
    
    
    //MARK:- SUBJECT
    fileprivate func fillStylistSubjectData(){
        
        subjectNamearray.removeAll()
        subjectCodearray.removeAll()
        
        activitySubjectDropDown.optionArray.removeAll()
        
        var stmt:OpaquePointer?
        let queryString = "SELECT * FROM TrainingMaster"
        if sqlite3_prepare_v2(DatabaseConnection.dbs, queryString, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(DatabaseConnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return
        }
        while(sqlite3_step(stmt) == SQLITE_ROW){
            let trainingCodeStr = String(cString: sqlite3_column_text(stmt, 0))
            let trainingNameStr = String(cString: sqlite3_column_text(stmt, 1))
            
            activitySubjectDropDown.optionArray.append(trainingNameStr)
            
            subjectNamearray.append(trainingNameStr)
            subjectCodearray.append(trainingCodeStr)
        }
    }
    
    
    //MARK:- STYLIST DATA
    fileprivate func fillStylistData(saloncode: String?){
        
        stylistNamearray.removeAll()
        stylistCodearray.removeAll()
        stylistNumberarray.removeAll()
        
        stylistNameDropDown.optionArray.removeAll()
        stylistCodeDropDown.optionArray.removeAll()
        stylistContactDropDown.optionArray.removeAll()
        
        var stmt:OpaquePointer?
        let queryString = "SELECT stylistname,stylistcode,contact,saloncode,salonname FROM stylist where saloncode like '%" + saloncode! + "%' or  saloncode = '" + saloncode! + "'"
        if sqlite3_prepare_v2(DatabaseConnection.dbs, queryString, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(DatabaseConnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return
        }
        while(sqlite3_step(stmt) == SQLITE_ROW){
            let stylistNameStr = String(cString: sqlite3_column_text(stmt, 0))
            let stylistCodeStr = String(cString: sqlite3_column_text(stmt, 1))
            let stylistContactStr = String(cString: sqlite3_column_text(stmt, 2))
            let stylistSalonCodeStr = String(cString: sqlite3_column_text(stmt, 3))
            let stylistSalonNameStr = String(cString: sqlite3_column_text(stmt, 4))
            
            
            stylistNameDropDown.optionArray.append(stylistNameStr)
            stylistCodeDropDown.optionArray.append(stylistCodeStr)
            stylistContactDropDown.optionArray.append(stylistContactStr)
            
            stylistNamearray.append(stylistNameStr)
            stylistCodearray.append(stylistCodeStr)
            stylistNumberarray.append(stylistContactStr)
            stylistsalonCodearray.append(stylistSalonCodeStr)
            stylistsalonnamearray.append(stylistSalonNameStr)
            
            
        }
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
            salonPsrCodearray.append(salonPsrCodeStr)
            salonSiteCodearray.append(salonSiteCodeStr)
        }
    }
    
    
    @objc
    func dismissOnTapOutSide(){
        self.myinsalonHeaderView.isHidden = true
    }
    
    override func deletePostSuccess() {
        AppDelegate.isIntentDone = "0"
        DispatchQueue.main.async {
            self.POSTSALONHEADERLINE()
        }
    }
    
    //MARK:- SAVE BTN CLICK
    fileprivate func SAVEBTNCLICKINSERTDATA(){
        if(insalonheaderlistdata.count>0 && insalonlinelistdata.count > 0 &&  checkNOP(trainingtype: "InSalon") && validateNetwork()){
            saveBtn.isEnabled = false
            DispatchQueue.main.async {
            self.postDeleteData(ActivityType: "InSalon")
            }
        }
        else if(insalonheaderlistdata.count == 0){
            self.showtoast(controller: self, message: "Please Add Salon First", seconds: 1.0)
        }
        else if(insalonlinelistdata.count == 0){
            self.showtoast(controller: self, message: "Please Add Participant First", seconds: 1.0)
        }
    }
    
    //MARK:- ADD HEADER BTN CLICK
    fileprivate func ADDSALONHEADERCLICK(){
        if(validation() && checkList(saloncodeStr: self.salonCode!, subjectNameStr : self.subjectName!) && validateNetwork()){
            self.TRNAPPID! = UserDefaults.standard.string(forKey: "userid")! + getTodayStringNew()
            do{
               
                self.insertHeaderInsalonWorkShop(trnappid:TRNAPPID,trainingtype: "InSalon", trainingcode: self.subjectCode, trainercode:UserDefaults.standard.string(forKey: "userid")! , sitecode: self.salonSiteCode!, sellercode: self.salonPsrCode!, Lat: lat!, Long: longi!, trainingdate: getTodayDateStringYMD(), remark: "", enddate: "", saloncode: self.salonCode!, isedit: "0", post: "1",nop: "0" ,colorcode: self.colorCode!,salonname: self.salonName!, subject: self.subjectName!)
                self.setList()
                self.salonNameDropDown.text! = ""
                self.salonCodeDropDown.text! = ""
                self.activitySubjectDropDown.text! = ""
                self.myinsalonHeaderView.isHidden = true
            }
        }
    }
    //MARK:- SETLIST
    func setList()
    {
        self.salonCodeSelectedarray.removeAll()
        self.trnappidSelectedarray.removeAll()
        self.insalonheaderlistdata.removeAll()
        self.InSalonHeaderTableView.isHidden = false
        var stmt4:OpaquePointer?
        let queryString = "SELECT saloncode,salonname,subject,nop , TRNAPPID ,colorcode FROM SalonWorkshopHeadar where trainingtype = 'InSalon' order by colorcode"
        print("setList"+queryString)
        if sqlite3_prepare_v2(DatabaseConnection.dbs, queryString, -1, &stmt4, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(DatabaseConnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return
        }
        while(sqlite3_step(stmt4) == SQLITE_ROW){
            let saloncodeStr = String(cString: sqlite3_column_text(stmt4, 0))
            let salonnameStr = String(cString: sqlite3_column_text(stmt4, 1))
            let subjectStr = String(cString: sqlite3_column_text(stmt4, 2))
            let nopStr = String(cString: sqlite3_column_text(stmt4, 3))
            let trnappid = String(cString: sqlite3_column_text(stmt4, 4))
            let colorcodeStr = String(cString: sqlite3_column_text(stmt4, 5))
            
            salonCodeSelectedarray.append(saloncodeStr)

            trnappidSelectedarray.append(trnappid)
            self.insalonheaderlistdata.append(InSalonWorkshopHeaderAdapter(trnappid: trnappid, saloncode: saloncodeStr, salonname: salonnameStr, subject: subjectStr, nop: nopStr, colorcode: colorcodeStr))
        }
        self.InSalonHeaderTableView.reloadData()
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
    
    fileprivate func participantandcountcheck() ->Bool {
        if(insalonheaderlistdata.count == 1 && insalonlinelistdata.count == 0 ) {
            self.showtoast(controller: self, message: "Please Add Particpant First", seconds: 1.0)
            return false;
        }
        else if (insalonheaderlistdata.count == 2){
            self.showtoast(controller: self, message: "Cannot Add More Than Two Salons", seconds: 1.0)
            return false;
        }
        return true ;
    }
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        let value = UIInterfaceOrientation.portrait.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
    }
    //MARK:- VALIDATION
    fileprivate func validation() -> Bool {
        do{
            
            if(salonNameDropDown.text == nil || self.salonName == nil ||     salonNameDropDown.text!.isEmpty || salonNameDropDown.text! == "" || salonNameDropDown.text! == "Select Salon Name" || self.salonName.isEmpty || self.salonName! == ""){
                self.showtoast(controller: self, message: "Please Select Salon Name", seconds: 1.0)
                return false
            }
            else  if(salonCodeDropDown.text!.isEmpty || salonCodeDropDown.text! == "" || salonCodeDropDown.text! == "Select Salon Code" || self.salonCode.isEmpty || self.salonCode! == ""){
                self.showtoast(controller: self, message: "Please Select Salon Code", seconds: 1.0)
                return false
            }
            else  if(activitySubjectDropDown.text!.isEmpty || activitySubjectDropDown.text! == "" || activitySubjectDropDown.text! == "Select Activity Subject" || self.subjectCode.isEmpty || self.subjectCode! == ""){
                self.showtoast(controller: self, message: "Please Select Activity Subject", seconds: 1.0)
                return false
            }
        }
        return true
    }
    
    //MARK:- VALIDATION
    fileprivate func validationLine() -> Bool {
        do{
            
            if(stylistNameDropDown.text == nil || self.stylistName == nil || stylistNameDropDown.text!.isEmpty || stylistNameDropDown.text! == "" || stylistNameDropDown.text! == "Stylist Name" || self.stylistName.isEmpty || self.stylistName! == ""){
                self.showtoast(controller: self, message: "Please Select Stylist Name", seconds: 1.0)
                return false
            }
            else  if(stylistCodeDropDown.text == nil || self.stylistCode == nil || stylistCodeDropDown.text!.isEmpty || stylistCodeDropDown.text! == "" || stylistCodeDropDown.text! == "Stylist Code" || self.stylistCode.isEmpty || self.stylistCode! == ""){
                self.showtoast(controller: self, message: "Please Select Stylist Code", seconds: 1.0)
                return false
            }
            else  if(stylistContactDropDown.text == nil || self.stylistNumber == nil || stylistContactDropDown.text!.isEmpty || stylistContactDropDown.text! == "" || stylistContactDropDown.text! == "Stylist Mobile Number" || self.stylistNumber.isEmpty || self.stylistNumber! == "" ){
                self.showtoast(controller: self, message: "Please Select Stylist Mobile Number", seconds: 1.0)
                return false
            }
        }
        return true
    }

    
    
    //MARK:- ADDSALONBTNCLICK
    fileprivate func  SHOWPOPUP() {
        // view.backgroundColor = UIColor.gray
        if(participantandcountcheck()){
            if(myInsalonLineView.isHidden == false){
                myInsalonLineView.isHidden = true
            }
            myinsalonHeaderView.isHidden = false
        }
    }
    
    //MARK:- SETUPLABELS
    fileprivate func setupLabels(){
        self.salonCodeLabel.text! = "Salon" + "\n" + "Code"
        self.salonNameLabel.text! = "Salon" + "\n" + "Name"
        self.salonCodeLineLabel.text! = "Salon" + "\n" + "Code"
        self.salonNameLineLabel.text! = "Salon" + "\n" + "Name"
        self.stylistNameLabel.text! = "Stylist" + "\n" + "Name"
        self.stylistCodeLabel.text! = "Stylist" + "\n" + "Code"
        self.subjectlabel.text! = "Subject" + "\n" + " "
        self.noplabel.text! = "NOP" + "\n" + "    "
        
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
    
    //MARK:- CHECK LIST
    func checkListLine(stylistCodeStr : String? , trnappid : String?) -> Bool
    {
        var stmt4:OpaquePointer?
        let queryString = "SELECT *  FROM InSalonDetail where TRNAPPID = '" + trnappid! + "'and  STYLISTCODE = '" + stylistCodeStr! + "' "
        print("setList"+queryString)
        if sqlite3_prepare_v2(DatabaseConnection.dbs, queryString, -1, &stmt4, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(DatabaseConnection.dbs)!)
            print("error preparing get: \(errmsg)")
        }
        while(sqlite3_step(stmt4) == SQLITE_ROW){
            self.showtoast(controller: self, message: "Participant Already Added", seconds: 1.0)
            self.stylistContactDropDown.text! = ""
            self.stylistCodeDropDown.text! = ""
            self.stylistNameDropDown.text! = ""

            return false;
        }
        return true
    }

    
    
    
    //MARK:- CHECK LIST
    func checkList(saloncodeStr : String? , subjectNameStr : String?) -> Bool
    {
        var stmt4:OpaquePointer?
        let queryString = "SELECT *  FROM SalonWorkshopHeadar where subject = '" + subjectNameStr! + "' and  SALONCODE = '" + saloncodeStr! + "'"
        print("setList"+queryString)
        if sqlite3_prepare_v2(DatabaseConnection.dbs, queryString, -1, &stmt4, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(DatabaseConnection.dbs)!)
            print("error preparing get: \(errmsg)")
        }
        while(sqlite3_step(stmt4) == SQLITE_ROW){
            self.showtoast(controller: self, message: "Please Select Different Salon", seconds: 1.0)
            self.salonNameDropDown.text! = ""
            self.salonCodeDropDown.text! = ""
            self.activitySubjectDropDown.text! = ""
            return false;
        }
        if(insalonheaderlistdata.count == 0){
            self.colorCode! = "first"
        }
        else if(insalonheaderlistdata.count == 1) {
            self.colorCode! = "second"
        }
        return true
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
        if(AppDelegate.isDebug){
            print("user latitude = \(userLocation.coordinate.latitude)")
            print("user longitude = \(userLocation.coordinate.longitude)")
        }
        lat = String(userLocation.coordinate.latitude)
        longi = String(userLocation.coordinate.longitude)
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    {
        print("Error \(error)")
    }
    
    //MARK:- OVERRIDE
    override func SalonPostSuccess(){
        if(AppDelegate.isIntentDone == "0"){
        self.showtoast(controller: self, message: "Data Submitted Successfully", seconds: 1.0)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.push(vcId: "dashnc", vc: self)
            }
            AppDelegate.isIntentDone = "1"
        }
    }
    
    //MARK:- OVERRIDE
    override func SalonPostFailure(){
        if(AppDelegate.isIntentDone == "0"){
        self.showtoast(controller: self, message: "Data Not Submitted", seconds: 1.0)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.push(vcId: "dashnc", vc: self)
            }
            AppDelegate.isIntentDone = "1"
        }
    }
    
//    override func SalonPostFailure(){
//        self.showtoast(controller: self, message: "Data Not Submitted", seconds: 1.0)
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
//            self.push(vcId: "dashnc", vc: self)
//        }
//    }
    override func SalonPostError(){
        self.showtoast(controller: self, message: "Network Connection Failed , Please Try Again Later! ", seconds: 1.0)
    }
    
}

