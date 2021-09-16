//  MyVirtualTrainingViewController.swift
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

class MyVirtualTrainingViewController:  ExecuteApi , CLLocationManagerDelegate ,  UITableViewDelegate, UITableViewDataSource
{
    //MARK:-OUTLETS
    @IBOutlet weak var activitySubjectDropDown: DropDown!
    @IBOutlet weak var noplabel: UILabel!
    @IBOutlet weak var VirtualLineTableView: UITableView!
    @IBOutlet weak var VirtualHeaderTableView: UITableView!
    @IBOutlet weak var subjectlabel: UILabel!
    @IBOutlet weak var stylistContactDropDown: DropDown!
    @IBOutlet weak var stylistCodeDropDown: DropDown!
    @IBOutlet weak var stylistNameDropDown: DropDown!
    @IBOutlet weak var myInsalonLineName: UILabel!
    @IBOutlet weak var salonNameLineLabel: UILabel!
    @IBAction func addVirtualLineBtnClick(_ sender: Any) {
        ADDSALONLINECLICK()
    }
    @IBAction func addVirtualHeaderBtnClick(_ sender: Any) {
        ADDVIRTUALHEADERCLICK()
    }
    @IBAction func saveBtnClick(_ sender: UIButton) {
        SAVEBTNCLICKINSERTDATA()
    }
    @IBOutlet weak var stylistNameLabel: UILabel!
    @IBOutlet weak var stylistCodeLabel: UILabel!
    @IBOutlet weak var subjectLabel: UILabel!
    @IBOutlet weak var salonCodeLabel: UILabel!
    @IBAction func addVirtualBtn(_ sender: UIButton) {
        SHOWPOPUP()
    }
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var myVirtualHeaderView: UIView!
    @IBOutlet weak var myVirtualLineView: UIView!

    @IBAction func cancelBtnClick(_ sender: UIButton) {
        HIDELINEVIEW()
    }
    @IBAction func cancelHedaerBtnClick(_ sender: UIButton) {
        HIDEHEDAERVIEW()
    }
    //MARK:- VARIBALE DECLARATION
    var menuvc: menuViewController!
    
    var virtualHeaderAdapter = [VirtualHeaderAdapter]()
    var virtualLineAdapter = [VirtualLineAdapter]()

    
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
    var stylistSubjectCode : String! = ""

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
    var trainingDate : String! = ""
    
    //MARK:- TABLE VIEW METHODS
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (tableView == VirtualHeaderTableView) ?self.virtualHeaderAdapter.count : self.virtualLineAdapter.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            if (tableView == VirtualHeaderTableView) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "virtualheadercell") as! VirtualHeaderTableViewCell
            let list: VirtualHeaderAdapter
            list = virtualHeaderAdapter[indexPath.row]
            cell.subject.text = list.subject
            cell.nop.text = list.nop
            if(list.colorcode == "first"){
                cell.backgroundColor = UIColor.systemGray
            }
            else if(list.colorcode == "second") {
                cell.backgroundColor = UIColor.gray
            }
            else if (list.colorcode == "third") {
                cell.backgroundColor = UIColor.lightGray
            }
            return cell
                    }
        
         if (tableView == VirtualLineTableView) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "virtualinecell") as! VirtualLineTableViewCell
            let list: VirtualLineAdapter
            list = virtualLineAdapter[indexPath.row]
            cell.stylistcode.text = list.stylistcode
            cell.stylistname.text = list.stylistname
            cell.saloncode.text = list.saloncode
            cell.subject.text = list.subject
            
            if(list.colorcode == "first"){
                cell.backgroundColor = UIColor.systemGray
            }
            else if(list.colorcode == "second") {
                cell.backgroundColor = UIColor.gray
            }
            else if (list.colorcode == "third") {
                cell.backgroundColor = UIColor.lightGray
            }
            return cell
        }
        return UITableViewCell()
    }

    func setDataforLine(indexPath : Int){
        let list: VirtualHeaderAdapter
        list = virtualHeaderAdapter[indexPath]
        myInsalonLineName.text! = list.subject!
        self.TRNAPPID = list.trnappid!
        self.stylistSalonCode = list.saloncode
        self.stylistSalonName = list.salonname
        self.colorcodeLine =  list.colorcode
        self.stylistSubjectCode = list.subject
     //   fillStylistData(saloncode: self.salonCode!)
        if(self.myVirtualHeaderView.isHidden == false){
            myVirtualHeaderView.isHidden = true
        }
        
        self.stylistContactDropDown.text! = ""
        self.stylistCodeDropDown.text! = ""
        self.stylistNameDropDown.text! = ""
        self.salonNameLineLabel.text! = "Salon"
        self.myVirtualLineView.isHidden = false
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if(editingStyle == .delete){
            self.presentDeletionFailsafe(indexPath: indexPath , tableView: tableView )
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         if (tableView == VirtualHeaderTableView) {
          setDataforLine(indexPath: indexPath.row)
        }
    }
    
    func presentDeletionFailsafe(indexPath:IndexPath,tableView: UITableView) {
        let alert=UIAlertController(title: nil, message: "Are you sure you'd like to delete this Line", preferredStyle: .alert)
        let yesAction=UIAlertAction(title: "Yes", style: .default) { _ in
            if tableView == self.VirtualHeaderTableView {
                let element = self.trnappidSelectedarray[indexPath.row]
             //   let element1 = self.trnappidLineSelectedarray[indexPath.row]
                self.deletSalonWorkshopHeadarPostTableDataVirtual(trnappid: element)
                self.deleteVirtualTrainingLineUpdatePostTableData(trnappid: element)
                self.setList()
                self.setList2()
            }
            else{
                //stylistCodeSelectedarray

                //let element = self.trnappidSelectedarray[indexPath.row]
                let element1 = self.trnappidLineSelectedarray[indexPath.row]
                let stylistcode = self.stylistCodeSelectedarray[indexPath.row]

                self.deleteVirtualTrainingLineUpdatePostTableDataWithStylistCOde(trnappid: element1,stylistcode:stylistcode)
                self.updateSalonWorkshopHeadarNOPDEC(trnappid: element1)
                self.setList()
                self.setList2()
            }
        }
        alert.addAction(yesAction)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    fileprivate func HIDEHEDAERVIEW(){
        if(self.myVirtualHeaderView.isHidden == false){
            self.myVirtualHeaderView.isHidden = true
        }
    }

    
    fileprivate func HIDELINEVIEW(){
        if(self.myVirtualLineView.isHidden == false){
           self.myVirtualLineView.isHidden = true
        }
    }
    
    //MARK:- VIEW DID LOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        let value = UIInterfaceOrientation.portrait.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
        self.view.addSubview(myVirtualHeaderView)
        self.view.addSubview(myVirtualLineView)
        
        myVirtualHeaderView.isHidden = true
        myVirtualLineView.isHidden = true
        
     //   self.deletaSalonWorkshopHeadarPost()
      //  self.deletaVirtualTrainingUpdatePost()
        setDate()
        determineMyCurrentLocation()
        setUpSideBar()
        setupLabels()
        fillDropDownData()
        setupDidSelect()
        setList()
        setList2()
    }
    func setDate(){
        let dateNew = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MMM-yyyy"
        let result = formatter.string(from: dateNew)
        dateTextField.text! = result
        self.trainingDate = result
    }
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//           let touch: UITouch? = touches.first!
//
//           if touch?.view != myVirtualHeaderView {
//               myVirtualHeaderView.isHidden = true
//           }
//           if touch?.view != myVirtualLineView {
//               myVirtualLineView.isHidden = true
//           }
//       }
    
    fileprivate func ADDSALONLINECLICK(){
        if(validationLine() && checkListLine(stylistCodeStr: self.stylistCode!, subject: self.stylistSubjectCode!) && validateNetwork()){
            do{
                self.insertLineVirtualTraining(trnappid: TRNAPPID, trainingdate: self.trainingDate!, stylistcode: self.stylistCode!, stylistname: self.SetStylistName(stylistNameString : self.stylistName!), stylistnumber: self.stylistNumber!, saloncode: self.salonCode! , salonremark: "", traininingsubject: self.stylistSubjectCode!, isedit: "0", colorcode: self.colorcodeLine!, post: "1")
                self.updateSalonWorkshopHeadarNOPINC(trnappid: TRNAPPID)
                self.GetSiteCodeandPsrCodeForHeader(saloncode: self.salonCode!)
                self.updateSalonWorkshopHeadarDetailsUpdate(trnappid: TRNAPPID, saloncode: self.salonCode!, sellercode: self.salonPsrCode!, sitecode: self.salonSiteCode!)

                setList()
                setList2()
                self.stylistNameDropDown.text! = ""
                self.stylistCodeDropDown.text! = ""
                self.stylistContactDropDown.text! = ""
                self.stylistName! = ""
                self.stylistCode! = ""
                self.stylistNumber! = ""
                self.salonNameLineLabel.text! = ""
                myVirtualLineView.isHidden = true
            }
        }
        
    }
    
    
    
    
    //MARK:- CHECK LIST
    fileprivate  func checkListLine(stylistCodeStr : String? , subject : String?) -> Bool
    {
        var stmt4:OpaquePointer?
        let queryString = "SELECT *  FROM VirtualTrainingUpdate where  TRAININGSUBJECT = '" + subject! + "' and  STYLISTCODE = '" + stylistCodeStr! + "' "
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
            self.salonNameLineLabel.text! = "Salon"
            return false;
        }
        return true
    }
    
    //MARK:- CHECK LIST
    fileprivate  func checkParticpantCount(stylistCodeStr : String?) -> Bool
    {
        var stmt4:OpaquePointer?
        let queryString = "SELECT *  FROM VirtualTrainingUpdate where  STYLISTCODE = '" + stylistCodeStr! + "' "
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
            self.salonNameLineLabel.text! = "Salon"
            return false;
        }
        return true
    }
    

    
    
    //MARK:- SETLIST
    func setList2()
    {
        self.trnappidLineSelectedarray.removeAll()

        self.stylistCodeSelectedarray.removeAll()
        self.virtualLineAdapter.removeAll()
        self.VirtualLineTableView.isHidden = false
        var stmt4:OpaquePointer?
        //// let POSTVirtualTrainingtable = "CREATE TABLE IF NOT EXISTS VirtualTrainingUpdate(TRNAPPID text,TRAININGDATE,STYLISTCODE text,STYLISTNAME text,STYLISTMOBILENO text,SALONCODE text,SALONREMARK text,TRAININGSUBJECT text,post text,isEdit text,colorcode text)"

        
        let queryString = "SELECT SALONCODE,STYLISTCODE,STYLISTNAME,TRNAPPID,colorcode ,TRAININGSUBJECT  FROM VirtualTrainingUpdate order by colorcode"
        
        print("setList"+queryString)
        if sqlite3_prepare_v2(DatabaseConnection.dbs, queryString, -1, &stmt4, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(DatabaseConnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return
        }
        while(sqlite3_step(stmt4) == SQLITE_ROW){
            let saloncodeStr = String(cString: sqlite3_column_text(stmt4, 0))
            let stylistcodeStr = String(cString: sqlite3_column_text(stmt4, 1))
            let stylistnameStr = String(cString: sqlite3_column_text(stmt4, 2))
            let trnappidStr = String(cString: sqlite3_column_text(stmt4, 3))
            let colorcodeStr = String(cString: sqlite3_column_text(stmt4, 4))
            let subjectStr = String(cString: sqlite3_column_text(stmt4, 5))

            self.trnappidLineSelectedarray.append(trnappidStr)
            self.stylistCodeSelectedarray.append(stylistcodeStr)
            self.virtualLineAdapter.append(VirtualLineAdapter(stylistcode: stylistcodeStr, stylistname: stylistnameStr,saloncode: saloncodeStr,trnapppid :trnappidStr, colorcode: colorcodeStr, subject: subjectStr))
        }
        self.VirtualLineTableView.reloadData()
    }
    
    
    //MARK:- SETUP DID SELECT
    fileprivate  func setupDidSelect () {
        setupOnClickActivitySubject()
        setupOnClickStylistCode()
        setupOnClickStylistName()
        setupOnClickStylistMobileNumber()
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
            self.salonName = self.stylistsalonnamearray[index]
            self.salonCode = self.stylistsalonCodearray[index]

            self.stylistNameDropDown.text! = self.stylistName!
            self.stylistCodeDropDown.text! = self.stylistCode!
            self.stylistContactDropDown.text! = self.stylistNumber!
            self.salonNameLineLabel.text! = self.salonName!
        }
        
    }
    fileprivate func setupOnClickStylistName(){
        stylistNameDropDown.didSelect{(selectedText , index ,id) in
            print("Selected String: \(selectedText) \n index: \(index)")
            self.stylistCode = self.stylistCodearray[index]
            self.stylistName = self.stylistNamearray[index]
            self.stylistNumber = self.stylistNumberarray[index]
            self.salonName = self.stylistsalonnamearray[index]
            self.salonCode = self.stylistsalonCodearray[index]

            self.stylistNameDropDown.text! = self.stylistName!
            self.stylistCodeDropDown.text! = self.stylistCode!
            self.stylistContactDropDown.text! = self.stylistNumber!
            self.salonNameLineLabel.text! = self.salonName!

        }
        
    }
    fileprivate func setupOnClickStylistMobileNumber(){
        stylistContactDropDown.didSelect{(selectedText , index ,id) in
            print("Selected String: \(selectedText) \n index: \(index)")
            self.stylistCode = self.stylistCodearray[index]
            self.stylistName = self.stylistNamearray[index]
            self.stylistNumber = self.stylistNumberarray[index]
            self.salonName = self.stylistsalonnamearray[index]
            self.salonCode = self.stylistsalonCodearray[index]


            self.stylistNameDropDown.text! = self.stylistName!
            self.stylistCodeDropDown.text! = self.stylistCode!
            self.stylistContactDropDown.text! = self.stylistNumber!
            self.salonNameLineLabel.text! = self.salonName!

        }
    }
    
    //MARK:- FILL DROPDOWN
    fileprivate  func fillDropDownData () {
        fillStylistSubjectData()
        fillStylistData()
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
    fileprivate func fillStylistData(){
        
        stylistNamearray.removeAll()
        stylistCodearray.removeAll()
        stylistNumberarray.removeAll()
        
        stylistNameDropDown.optionArray.removeAll()
        stylistCodeDropDown.optionArray.removeAll()
        stylistContactDropDown.optionArray.removeAll()
        
        var stmt:OpaquePointer?
        let queryString = "SELECT stylistname,stylistcode,contact,saloncode,salonname FROM stylist"
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
    @objc
    func dismissOnTapOutSide(){
        self.myVirtualHeaderView.isHidden = true
    }
    @IBOutlet weak var saveBtn: UIButton!
    
    //MARK:- SAVE BTN CLICK
    fileprivate func SAVEBTNCLICKINSERTDATA(){
        if(virtualHeaderAdapter.count>0 && virtualLineAdapter.count > 0 && checkNOP(trainingtype: "Virtual Training") && self.validateNetwork()){
            saveBtn.isEnabled = false
            DispatchQueue.main.async {
                self.postDeleteData(ActivityType: "Virtual Training")
            }
        }
        else if(virtualHeaderAdapter.count == 0){
            self.showtoast(controller: self, message: "Please Add Virtual Training  First", seconds: 1.0)
        }
        else if(virtualLineAdapter.count == 0){
            self.showtoast(controller: self, message: "Please Add Participant First", seconds: 1.0)
        }
    }
    //MARK:- ADD HEADER BTN CLICK
    fileprivate func ADDVIRTUALHEADERCLICK(){
        if(validation() && checkList(subjectNameStr: self.subjectName!) && validateNetwork()){
            self.TRNAPPID! = UserDefaults.standard.string(forKey: "userid")! + getTodayStringNew()
            do{
//                self.insertHeaderInsalonWorkShop(trnappid:TRNAPPID,trainingtype: "Virtual Training", trainingcode: self.subjectCode!, trainercode:UserDefaults.standard.string(forKey: "userid")! , sitecode: self.salonSiteCode!, sellercode: self.salonPsrCode!, Lat: lat!, Long: longi!, trainingdate: self.trainingDate!, remark: "", enddate: "", saloncode: self.salonCode!, isedit: "0", post: "1",nop: "0" ,colorcode: self.colorCode!,salonname: self.salonName!, subject: self.subjectName!)
                
                self.insertHeaderInsalonWorkShop(trnappid:TRNAPPID,trainingtype: "Virtual Training", trainingcode: self.subjectCode!, trainercode:UserDefaults.standard.string(forKey: "userid")! , sitecode: self.salonSiteCode!, sellercode: self.salonPsrCode!, Lat: lat!, Long: longi!, trainingdate: self.trainingDate!, remark: "", enddate: "", saloncode: "", isedit: "0", post: "1",nop: "0" ,colorcode: self.colorCode!,salonname: self.salonName!, subject: self.subjectName!)
                
                self.setList()
                self.activitySubjectDropDown.text! = ""
                self.myVirtualHeaderView.isHidden = true
            }
        }
    }
    
    override func deletePostSuccess() {
       AppDelegate.isIntentDone = "0"
       AppDelegate.isRetryDone = "0"
        DispatchQueue.main.async {
             self.POSTVIRTUALHEADERLINE()
        }
    }
    
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
    
    
    //MARK:- SETLIST
    func setList()
    {
        self.trnappidSelectedarray.removeAll()
        self.virtualHeaderAdapter.removeAll()
        self.VirtualHeaderTableView.isHidden = false
        var stmt4:OpaquePointer?
        let queryString = "SELECT saloncode,salonname,subject,nop , TRNAPPID ,colorcode FROM SalonWorkshopHeadar where trainingtype = 'Virtual Training'  order by colorcode"
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

            trnappidSelectedarray.append(trnappid)

            self.virtualHeaderAdapter.append(VirtualHeaderAdapter(trnappid: trnappid, saloncode: saloncodeStr, salonname: salonnameStr, subject: subjectStr, nop: nopStr, colorcode: colorcodeStr))
        }
        self.VirtualHeaderTableView.reloadData()
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
        if(virtualHeaderAdapter.count == 1 && virtualLineAdapter.count == 0 ) {
            self.showtoast(controller: self, message: "Please Add Particpant First", seconds: 1.0)
            return false;
        }
        else if (virtualHeaderAdapter.count == 3){
            self.showtoast(controller: self, message: "Cannot Add More Than Three Virtual Trainings", seconds: 1.0)
            return false;
        }
        return true ;
    }
    
    //MARK:- VALIDATION
    fileprivate func validation() -> Bool {
        do{
            if(activitySubjectDropDown.text!.isEmpty || activitySubjectDropDown.text! == "" || activitySubjectDropDown.text! == "Select Activity Subject" || self.subjectCode.isEmpty || self.subjectCode! == ""){
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
            if(self.myVirtualLineView.isHidden == false){
                myVirtualLineView.isHidden = true
            }
            self.activitySubjectDropDown.text! = ""
            myVirtualHeaderView.isHidden = false
        }
    }
    
    //MARK:- SETUPLABELS
    fileprivate func setupLabels(){
        self.salonCodeLabel.text! = "Salon" + "\n" + "Code"
        self.salonNameLineLabel.text! = "Salon" + "\n" + "Name"
        self.stylistNameLabel.text! = "Stylist" + "\n" + "Name"
        self.stylistCodeLabel.text! = "Stylist" + "\n" + "Code"
        self.subjectlabel.text! = "Virtual Training" + "\n" + "Subject"
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
    func checkList(subjectNameStr : String?) -> Bool
    {
        var stmt4:OpaquePointer?
        let queryString = "SELECT *  FROM SalonWorkshopHeadar where TRAININGTYPE = 'Virtual Training'  and  subject = '" + subjectNameStr! + "'"
        print("setList"+queryString)
        if sqlite3_prepare_v2(DatabaseConnection.dbs, queryString, -1, &stmt4, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(DatabaseConnection.dbs)!)
            print("error preparing get: \(errmsg)")
        }
        while(sqlite3_step(stmt4) == SQLITE_ROW){
//            self.showtoast(controller: self, message: "Please Select Different Subject", seconds: 1.0)
//            self.activitySubjectDropDown.text! = ""
//            return false;
        }
        if(virtualHeaderAdapter.count == 0){
            self.colorCode! = "first"
        }
        else if(virtualHeaderAdapter.count == 1) {
            self.colorCode! = "second"
        }
        else if(virtualHeaderAdapter.count == 2) {
            self.colorCode! = "third"
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
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation:CLLocation = locations[0] as CLLocation
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
       override func VirtualPostSuccess(){
           if(AppDelegate.isIntentDone == "0"){
           self.showtoast(controller: self, message: "Data Submitted Successfully", seconds: 1.0)
           DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                   self.push(vcId: "dashnc", vc: self)
               }
               AppDelegate.isIntentDone = "1"
           }
       }
    //MARK:- OVERRIDE
    override func VirtualPostFailure(){
        if(AppDelegate.isIntentDone == "0"){
            self.showtoast(controller: self, message: "Data Not Submitted", seconds: 1.0)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.push(vcId: "dashnc", vc: self)
            }
            AppDelegate.isIntentDone = "1"
            
        }
    }
    override func VirtualPostError(){
        self.showtoast(controller: self, message: "Network Connection Failed , Please Try Again Later! ", seconds: 1.0)
    }
    fileprivate func GetSiteCodeandPsrCodeForHeader(saloncode : String?){
        var stmt:OpaquePointer?
        let queryString = "SELECT sitecode, psrcode  FROM salon where  saloncode = '" + saloncode! + "'"
        if sqlite3_prepare_v2(DatabaseConnection.dbs, queryString, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(DatabaseConnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return
        }
        while(sqlite3_step(stmt) == SQLITE_ROW){
            let siteCodeStr = String(cString: sqlite3_column_text(stmt, 0))
            let psrcodeStr = String(cString: sqlite3_column_text(stmt, 1))
            
            self.salonSiteCode! = siteCodeStr
            self.salonPsrCode! = psrcodeStr
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        let value = UIInterfaceOrientation.portrait.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
    }
}

