//MARK:- IMPORTS
import UIKit
import Dropdowns
import SQLite3
import Alamofire
import SystemConfiguration
import SwiftEventBus
import CoreLocation


//MARK:- BEGIN
class MyActivity: ExecuteApi,  CLLocationManagerDelegate, UINavigationControllerDelegate, UITextViewDelegate {
    //MARK:- OULETS
    @IBOutlet weak var date : UITextField!
    @IBOutlet weak var myactivityView : UIView!
    @IBOutlet weak var activityLabel : UILabel!
    @IBOutlet weak var remarkText : UITextView!
    @IBOutlet weak var inSalonStackView: UIStackView!
    @IBOutlet weak var workshopStackView: UIStackView!
    @IBOutlet weak var hotdayStackView: UIStackView!
    @IBOutlet weak var marketVisitStackView: UIStackView!
    @IBOutlet weak var internalStackView: UIStackView!
    @IBOutlet weak var virtualStackView: UIStackView!
    @IBOutlet weak var otherStackView: UIStackView!
    @IBOutlet weak var leaveStackView: UIStackView!
    @IBOutlet weak var insalonEditIcon: UIImageView!
    @IBOutlet weak var workshopEditIcon: UIImageView!
    @IBOutlet weak var hotDayEditIcon: UIImageView!
    @IBOutlet weak var marketVisitEditIcon: UIImageView!
    @IBOutlet weak var internalTrainingEditIcon: UIImageView!
    @IBOutlet weak var virtualtrainingEditIcon: UIImageView!
    @IBOutlet weak var otherEditIcon: UIImageView!
    @IBOutlet weak var leaveEditIcon: UIImageView!
    
    //MARK:- VARIABLE DECALRATION
    var menuvc : menuViewController!
    var spinnerselection: String?
    var locationManager:CLLocationManager!
    var lat: String! = ""
    var longi: String! = ""
    var isEditCheck: Bool = false
    var primaryactivityStr : String! = ""
    var primaryactivityarray : [String]! = []
    var totalcount : Int! = 0
    var currActivity: String! = ""
    var insaloncount : Int! = 0
    var workshopcount : Int! = 0
    var virtualcount : Int! = 0
    var internalcount : Int! = 0
    var othercount : Int! = 0
    var leavecount : Int! = 0
    var marketvisitcount : Int! = 0
    var hotdaycount : Int! = 0
    var isCountCalled : Bool = false
    
    //MARK:- VIEW DID LOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        let value = UIInterfaceOrientation.portrait.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
        self.view.addSubview(myactivityView)
        self.view.backgroundColor = UIColor(patternImage:UIImage(named: "internal_background.png")!)
        self.determineMyCurrentLocation()
        self.menuGestures()
        self.setDate()
        self.StackViewSetUp()
        self.editIconVisiblityInitially()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        let value = UIInterfaceOrientation.portrait.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
    }
    
    fileprivate func GetData(){
        self.checknet()
        if(AppDelegate.ntwrk > 0){
            self.showSyncloader(title: "Loading....Please Wait")
            self.executeTodayActivity()
            self.executeTODAYWORKSHINSALONVIRTUAL()
            self.executeGETTODAYMULTIWORKSHOP()
            self.executeURL_GETALLOWTRAININGTYPEMASTER()
        }
        else {
            self.showNetworkAlert()
        }
    }
    
    //MARK:-  ALERT
       func showNetworkAlert(){
           let alert = UIAlertController(title: "", message: "Please Check Your Internet Connection", preferredStyle: UIAlertControllerStyle.alert)
           alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: { (action) in
               alert.dismiss(animated: true, completion: nil)
               self.push(vcId: "dashnc", vc: self)
           }))
           self.present(alert, animated: true)
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
    
    
    override func viewDidAppear(_ animated: Bool) {
        self.GetData()
        self.hideSyncloader()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        SwiftEventBus.onMainThread(self, name: "desc") { (result) in
            DispatchQueue.main.asyncAfter(deadline: .now()+0.5) {
                self.activityCount()
            }
        }
    }
    
    fileprivate func editIconVisiblityInitially(){
        insalonEditIcon.isHidden = true
        workshopEditIcon.isHidden = true
        hotDayEditIcon.isHidden = true
        marketVisitEditIcon.isHidden = true
        internalTrainingEditIcon.isHidden = true
        virtualtrainingEditIcon.isHidden = true
        otherEditIcon.isHidden = true
        leaveEditIcon.isHidden = true
        
        //     insalonEditIcon.isHidden = false
        //     workshopEditIcon.isHidden = false
        //     hotDayEditIcon.isHidden = false
        //     marketVisitEditIcon.isHidden = false
        //     internalTrainingEditIcon.isHidden = false
        //     virtualtrainingEditIcon.isHidden = false
        //     otherEditIcon.isHidden = false
        //     leaveEditIcon.isHidden = false
    }
    
    //MARK:- ACTIVITY COUNT
    fileprivate func activityCount()
    {
        if(!isCountCalled){
            self.activityCountInsalon()
            self.activityCountLeave()
            self.activityCountOther()
            self.activityCountHotDay()
            self.activityCountInternal()
            self.activityCountWorkshop()
            self.activityCountMarketVisit()
            self.activityCountVirtualTraining()
            isCountCalled = true
        }
        print("PRIMARYACTIVITYSTR======================================================")
        print(primaryactivityStr!)
    }
    
    fileprivate func validation(trainingtype : String! , currentactivity : String! , trainingtypeCount : Int!) -> Bool {
        if(trainingtypeCount>0){
            return true
        }
        else
        {
            if (totalcount >= 2){
                self.showtoast(controller: self, message: "More than two Activities are not permissible", seconds: 1.0)
                return false
            }
            else {
                if(self.getAccessCount(trainingtype: trainingtype)>0){
                    if(trainingtypeCount > 0){
                        return true
                    }
                    else if (totalcount == 1){
                           if(getTypeCount(currActivity: currentactivity, primaryStr: primaryactivityStr)>0){
                            return true
                        }
                        else {
                            self.showtoast(controller: self, message: "Not Permissible", seconds: 1.0)
                            return false
                        }
                    }
                    else {
                        return true
                    }
                }
                else {
                    self.showtoast(controller: self, message: "Not Permissible", seconds: 1.0)
                    return false
                }
            }
        }
        return false
    }
    
    
    //MARK:- COUNT TYPE
    func getTypeCount(currActivity: String! , primaryStr: String!) -> Int
    {
        var typeCount : Int! = 0
        var stmt4:OpaquePointer?
        let queryString = "select * from GetAllowTrainingTypeMaster where secondarY_DESCRIPTION = '" + currActivity! + "' and primarY_DESCRIPTION  = '" + primaryStr! + "' "
        if sqlite3_prepare_v2(DatabaseConnection.dbs, queryString, -1, &stmt4, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(DatabaseConnection.dbs)!)
            print("error preparing get: \(errmsg)")
        }
        while(sqlite3_step(stmt4) == SQLITE_ROW){
            typeCount = typeCount + 1
        }
        return typeCount
    }
    
    
    //MARK:- COUNT ACCESS
    func getAccessCount(trainingtype: String!) -> Int
    {
        var accessCount : Int! = 0
        var stmt4:OpaquePointer?
        let queryString = "select distinct primarY_DESCRIPTION from GetAllowTrainingTypeMaster where primarY_DESCRIPTION  = '" + trainingtype! + "'"
        print(queryString)
        if sqlite3_prepare_v2(DatabaseConnection.dbs, queryString, -1, &stmt4, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(DatabaseConnection.dbs)!)
            print("error preparing get: \(errmsg)")
        }
        while(sqlite3_step(stmt4) == SQLITE_ROW){
            accessCount = accessCount + 1
        }
        return accessCount
    }
    
    
    //MARK:- COUNT InSalon
    func activityCountInsalon()
    {
        var stmt4:OpaquePointer?
        let queryString = "Select distinct TRAININGTYPE from SalonWorkshopHeadar where TRAININGTYPE = 'InSalon' "
        print(queryString)
        if sqlite3_prepare_v2(DatabaseConnection.dbs, queryString, -1, &stmt4, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(DatabaseConnection.dbs)!)
            print("error preparing get: \(errmsg)")
        }
        while(sqlite3_step(stmt4) == SQLITE_ROW){
            primaryactivityStr = String(cString: sqlite3_column_text(stmt4, 0))
            insaloncount = insaloncount + 1
            totalcount = totalcount + 1
            insalonEditIcon.isHidden = false
        }
    }
    
    //MARK:- COUNT HotDay
    func activityCountHotDay()
    {
        var stmt4:OpaquePointer?
        let queryString = "Select distinct trainingtype from HotDayMarketVisit where trainingtype = 'Hot Day' "
        if sqlite3_prepare_v2(DatabaseConnection.dbs, queryString, -1, &stmt4, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(DatabaseConnection.dbs)!)
            print("error preparing get: \(errmsg)")
        }
        while(sqlite3_step(stmt4) == SQLITE_ROW){
            primaryactivityStr = String(cString: sqlite3_column_text(stmt4, 0))
            hotdaycount = hotdaycount + 1
            totalcount = totalcount + 1
            hotDayEditIcon.isHidden = false
        }
    }
    
    //MARK:- COUNT MarketVisit
    func activityCountMarketVisit()
    {
        var stmt4:OpaquePointer?
        let queryString = "Select distinct trainingtype from HotDayMarketVisit where trainingtype = 'Market Visit' "
        if sqlite3_prepare_v2(DatabaseConnection.dbs, queryString, -1, &stmt4, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(DatabaseConnection.dbs)!)
            print("error preparing get: \(errmsg)")
        }
        while(sqlite3_step(stmt4) == SQLITE_ROW){
            primaryactivityStr = String(cString: sqlite3_column_text(stmt4, 0))
            marketvisitcount = marketvisitcount + 1
            totalcount = totalcount + 1
            marketVisitEditIcon.isHidden = false
        }
    }
    //MARK:- COUNT VirtualTraining
    func activityCountVirtualTraining()
    {
        var stmt4:OpaquePointer?
        let queryString = "Select distinct TRAININGTYPE from SalonWorkshopHeadar where TRAININGTYPE = 'Virtual Training' "
        
        if sqlite3_prepare_v2(DatabaseConnection.dbs, queryString, -1, &stmt4, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(DatabaseConnection.dbs)!)
            print("error preparing get: \(errmsg)")
        }
        while(sqlite3_step(stmt4) == SQLITE_ROW){
            primaryactivityStr = String(cString: sqlite3_column_text(stmt4, 0))
            virtualcount = virtualcount + 1
            totalcount = totalcount + 1
            virtualtrainingEditIcon.isHidden = false
        }
    }
    //MARK:- COUNT LEAVE
    func activityCountLeave()
    {
        var stmt4:OpaquePointer?
        let queryString = "Select distinct trainingtype from AddLeave where trainingtype = 'Leave'"
        
        if sqlite3_prepare_v2(DatabaseConnection.dbs, queryString, -1, &stmt4, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(DatabaseConnection.dbs)!)
            print("error preparing get: \(errmsg)")
        }
        while(sqlite3_step(stmt4) == SQLITE_ROW){
            primaryactivityStr = String(cString: sqlite3_column_text(stmt4, 0))
            leavecount = leavecount + 1
            totalcount = totalcount + 1
            leaveEditIcon.isHidden = false
        }
    }
    //MARK:- COUNT Other
    func activityCountOther()
    {
        var stmt4:OpaquePointer?
        let queryString = "Select distinct trainingtype from InternalOtherPost where trainingtype = 'Other'"
        
        if sqlite3_prepare_v2(DatabaseConnection.dbs, queryString, -1, &stmt4, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(DatabaseConnection.dbs)!)
            print("error preparing get: \(errmsg)")
        }
        while(sqlite3_step(stmt4) == SQLITE_ROW){
            primaryactivityStr = String(cString: sqlite3_column_text(stmt4, 0))
            othercount = othercount + 1
            totalcount = totalcount + 1
            otherEditIcon.isHidden = false
        }
    }
    //MARK:- COUNT Internal
    func activityCountInternal()
    {
        var stmt4:OpaquePointer?
        let queryString = "Select distinct trainingtype from InternalOtherPost where trainingtype = 'Internal Training'"
        
        if sqlite3_prepare_v2(DatabaseConnection.dbs, queryString, -1, &stmt4, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(DatabaseConnection.dbs)!)
            print("error preparing get: \(errmsg)")
        }
        while(sqlite3_step(stmt4) == SQLITE_ROW){
            primaryactivityStr = String(cString: sqlite3_column_text(stmt4, 0))
            internalcount = internalcount + 1
            totalcount = totalcount + 1
            internalTrainingEditIcon.isHidden = false
        }
    }
    //MARK:- COUNT WORKSHOP
    func activityCountWorkshop()
    {
        var stmt4:OpaquePointer?
        let queryString = "select distinct TRAININGTYPE from WorkshopHeaderUpdated where TRAININGTYPE = 'WorkShop' and isEdit='1' "
        
        if sqlite3_prepare_v2(DatabaseConnection.dbs, queryString, -1, &stmt4, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(DatabaseConnection.dbs)!)
            print("error preparing get: \(errmsg)")
        }
        while(sqlite3_step(stmt4) == SQLITE_ROW){
            primaryactivityStr = String(cString: sqlite3_column_text(stmt4, 0))
            workshopcount = workshopcount + 1
            totalcount = totalcount + 1
            workshopEditIcon.isHidden = false
        }
    }
    //MARK:- SETP PREFILLED DATA
    func setUpPrefilledData(activityLabel : String?)
    {
        var stmt4:OpaquePointer?
        let queryString = "SELECT remark FROM internalotherpost where  trainingtype = '" + activityLabel! + "'"
        if sqlite3_prepare_v2(DatabaseConnection.dbs, queryString, -1, &stmt4, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(DatabaseConnection.dbs)!)
            print("error preparing get: \(errmsg)")
        }
        if(sqlite3_step(stmt4) == SQLITE_ROW){
            let remarkTextStr = String(cString: sqlite3_column_text(stmt4, 0))
            self.remarkText.text = remarkTextStr
            self.isEditCheck = true
        }
        else {
            self.remarkText.text = "Enter Remark........"
            self.remarkText.textColor = UIColor.lightGray
            self.isEditCheck = false
        }
    }
    
    //MARK:- SET DATE
    func setDate(){
        let dateNew = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MMM-yyyy"
        let result = formatter.string(from: dateNew)
        date.text = result
    }
    //MARK:- STACKVIEW SETUP
    fileprivate func StackViewSetUp(){
        inSalonStackView.isUserInteractionEnabled = true
        workshopStackView.isUserInteractionEnabled = true
        hotdayStackView.isUserInteractionEnabled = true
        marketVisitStackView.isUserInteractionEnabled = true
        internalStackView.isUserInteractionEnabled = true
        virtualStackView.isUserInteractionEnabled = true
        otherStackView.isUserInteractionEnabled = true
        leaveStackView.isUserInteractionEnabled = true
        
        let tapinSalonStackView = UITapGestureRecognizer(target: self, action: #selector(clickinSalonStackView))
        tapinSalonStackView.numberOfTapsRequired=1
        inSalonStackView.addGestureRecognizer(tapinSalonStackView)
        
        let tapworkshopStackView = UITapGestureRecognizer(target: self, action: #selector(clickworkshopStackView))
        tapworkshopStackView.numberOfTapsRequired=1
        workshopStackView.addGestureRecognizer(tapworkshopStackView)
        
        let taphotdayStackView = UITapGestureRecognizer(target: self, action: #selector(clickhotdayStackView))
        tapworkshopStackView.numberOfTapsRequired=1
        hotdayStackView.addGestureRecognizer(taphotdayStackView)
        
        let tapmarketVisitStackView = UITapGestureRecognizer(target: self, action: #selector(clickmarketVisitStackView))
        tapmarketVisitStackView.numberOfTapsRequired=1
        marketVisitStackView.addGestureRecognizer(tapmarketVisitStackView)
        
        let tapinternalStackView = UITapGestureRecognizer(target: self, action: #selector(clickinternalStackView))
        tapinternalStackView.numberOfTapsRequired=1
        internalStackView.addGestureRecognizer(tapinternalStackView)
        
        let tapvirtualStackView = UITapGestureRecognizer(target: self, action: #selector(clickvirtualStackView))
        tapvirtualStackView.numberOfTapsRequired=1
        virtualStackView.addGestureRecognizer(tapvirtualStackView)
        
        let tapotherStackView = UITapGestureRecognizer(target: self, action: #selector(clickotherStackView))
        tapvirtualStackView.numberOfTapsRequired=1
        otherStackView.addGestureRecognizer(tapotherStackView)
        
        let tapleaveStackView = UITapGestureRecognizer(target: self, action: #selector(clickleaveStackView))
        tapvirtualStackView.numberOfTapsRequired=1
        leaveStackView.addGestureRecognizer(tapleaveStackView)
    }
    
    fileprivate func leaveValidation() ->Bool{
        if(leavecount>0){
            self.showtoast(controller: self, message: "Your Leave has been already registered for today", seconds: 1.0)
            return false
        }
        return true
    }
    
    @objc func clickleaveStackView(){
        if(validation(trainingtype: "Leave",currentactivity : "Leave",trainingtypeCount: leavecount) && leaveValidation()){
            self.showLeaveAlert()
        }
    }
    @objc func clickotherStackView(){
        if(validation(trainingtype: "Other",currentactivity : "Other",trainingtypeCount: othercount)){
            self.showView(myActivity: "Other")
        }
    }
    @objc func clickvirtualStackView(){
        if(validation(trainingtype: "Virtual Training",currentactivity : "Virtual Training",trainingtypeCount: virtualcount)){
            self.pushnext(identifier: "MyVirtualTrainingViewController", controller: self)
        }
    }
    @objc func clickinternalStackView(){
        if(validation(trainingtype: "Internal Training",currentactivity : "Internal Training", trainingtypeCount: internalcount)){
            self.showView(myActivity: "Internal Training")
        }
    }
    @objc func clickmarketVisitStackView(){
        if(validation(trainingtype: "Market Visit",currentactivity : "Market Visit", trainingtypeCount: marketvisitcount)){
            self.pushnext(identifier: "MarketVisitViewController", controller: self)
        }
    }
    @objc func clickhotdayStackView(){
        if(validation(trainingtype: "Hot Day",currentactivity : "Hot Day", trainingtypeCount: hotdaycount)){
            self.pushnext(identifier: "HotDayViewController", controller: self)
        }
    }
    @objc func clickworkshopStackView(){
        if(validation(trainingtype: "WorkShop",currentactivity : "WorkShop", trainingtypeCount: workshopcount)){
            self.pushnext(identifier: "MyWorkshopViewController", controller: self)
        }
    }
    @objc func clickinSalonStackView(){
        if(validation(trainingtype: "InSalon",currentactivity : "InSalon", trainingtypeCount: insaloncount)){
            self.pushnext(identifier: "MyInSalonViewController", controller: self)
        }
    }
    
    //MARK:- SHOW VIEW
    func showView(myActivity : String!){
        self.view.backgroundColor = UIColor.gray
        self.myactivityView.isHidden = false
        self.activityLabel.text = myActivity
        let myUITextView = UITextView.init()
        myUITextView.delegate = self
        self.setUpPrefilledData(activityLabel: myActivity)
    }
    //MARK:- TEXTVIEW NIL
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    //MARK:- OK BTN CLICK
    @IBAction func OKBtnclick(_ sender : UIButton){
        if !(remarkText.text! == "" || remarkText.text! == "Enter Remark........" ){
            self.myactivityView.isHidden = true
            let trnappid = UserDefaults.standard.string(forKey: "userid")! + getTodayStringNew()
            if(!isEditCheck){
                self.insertinternalotherPost(trnappid:trnappid , trainingtype: self.activityLabel.text!, trainercode: UserDefaults.standard.string(forKey: "userid")!, lat: lat, long: longi, trainingdate: date.text!, remark: remarkText.text!, post: "0")
            }
            else{
                self.updateinternalotherpostRemark(remark: remarkText.text!, trainingtype: self.activityLabel.text!)
            }
            
            if(validateNetwork()){
                self.postDeleteData(ActivityType: self.activityLabel.text!)
            }
        }
        else{
            self.showtoast(controller: self, message: "Please Enter Remark", seconds: 1.0)
        }
    }
    
    override func deletePostSuccess(){
        if(self.activityLabel.text == "Internal Training"){
            self.postInternalTrainingData()
        }
        else if(self.activityLabel.text == "Other"){
            self.postOtherData()
        }
        else {
            self.postAddLeaveData()
        }
    }
    
    
    @IBAction func CancelBtnclick(_ sender : UIButton){
        self.myactivityView.isHidden = true
    }
    //MARK:- LEAVE ALERT
    func showLeaveAlert(){
        let alert = UIAlertController(title: "Leave", message: "Are you sure you want to add Leave?", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: { (action) in
            self.deletaddleavePost()
            self.adddetailonLeaveOkBtn()
            alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true)
    }
    
    fileprivate func adddetailonLeaveOkBtn(){
        self.insertAddLeavePost(trnappid: UserDefaults.standard.string(forKey: "userid")! + getTodayStringNew(), trainingtype: "Leave", trainercode: UserDefaults.standard.string(forKey: "userid")!, lat: lat, long: longi, trainingdate: date.text!, post: "0")
        
        if(validateNetwork()){
            self.postDeleteData(ActivityType: "Leave")
        }
    }
    //MARK:- SIDE BAR
    func menuGestures(){
        menuvc = (self.storyboard?.instantiateViewController(withIdentifier: "menuViewController") as! menuViewController)
        let swiperyt = UISwipeGestureRecognizer(target: self, action: #selector(self.gesturerecognise))
        swiperyt.direction = UISwipeGestureRecognizerDirection.right
        let swipelft = UISwipeGestureRecognizer(target: self, action: #selector(self.gesturerecognise))
        swipelft.direction = UISwipeGestureRecognizerDirection.left
        self.view.addGestureRecognizer(swiperyt)
        self.view.addGestureRecognizer(swipelft)
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
    @objc
    func gesturerecognise (gesture : UISwipeGestureRecognizer)
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
        
        print("user latitude = \(userLocation.coordinate.latitude)")
        print("user longitude = \(userLocation.coordinate.longitude)")
        lat = String(userLocation.coordinate.latitude)
        longi = String(userLocation.coordinate.longitude)
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    {
        print("Error \(error)")
    }
    //MARK:- LEAVE OVERRIDE
    override func addLeavePostSuccess(){
        self.showtoast(controller: self, message: "Data Submitted Successfully", seconds: 1.0)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.push(vcId: "dashnc", vc: self)
        }
    }
    override func addLeaveFailure(){
        self.showtoast(controller: self, message: "Data Not Submitted", seconds: 1.0)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.push(vcId: "dashnc", vc: self)
        }
    }
    
    //MARK:- INTERNAL OVERRIDE
    override func internalTrainingPostSuccess(){
        self.showtoast(controller: self, message: "Data Submitted Successfully", seconds: 1.0)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.push(vcId: "dashnc", vc: self)
        }
    }
    override func internalTrainingPostFailure(){
        self.showtoast(controller: self, message: "Data Not Submitted", seconds: 1.0)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.push(vcId: "dashnc", vc: self)
        }
    }
    
    //MARK:- OTHER OVERRIDE
    override func otherPostSuccess(){
        self.showtoast(controller: self, message: "Data Submitted Successfully", seconds: 1.0)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.push(vcId: "dashnc", vc: self)
        }
    }
    override func otherPostFailure(){
        self.showtoast(controller: self, message: "Data Not Submitted", seconds: 1.0)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.push(vcId: "dashnc", vc: self)
        }
    }
}
