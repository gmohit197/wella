//
//  DTRViewController.swift
//  Wella.2
//
//  Created by Acxiom on 01/09/18.
//  Copyright © 2018 Acxiom. All rights reserved.
//

import UIKit
import Dropdowns
import Alamofire
import SQLite3
import SystemConfiguration
import SwiftEventBus
import Foundation

class DTRViewController: ExecuteApi, UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView.tag == 100{
            return dtrlistdata.count
        }else{
            return insidedtrdata.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView.tag == 100{
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "dtrcell", for: indexPath) as! Dtrlistcell
            let list: Dtrlistview
            list = dtrlistdata[indexPath.row]
            
            cell.date.text = list.date
            cell.salon.text = list.salon
            cell.stylist.text = list.stylist
            cell.training.text = list.training
            cell.type.text = list.type
            
            return cell
        }
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "insidecell", for: indexPath) as! Dtrcell
            
            let list: insideDtradapte
            list = insidedtrdata[indexPath.row]
            
            cell.stylistname.text = list.stylistname
            cell.stylistno.text = list.stylistno
            
            return cell
        }
    }
    
    
    @IBOutlet weak var dtrlistview: UITableView!
    @IBOutlet weak var subdtrview: UITableView!
    
    var menuvc : menuViewController!
    var stylistcount: Int!
    
    var dtrlistdata = [Dtrlistview]()
    var insidedtrdata = [insideDtradapte]()
    var arr: [[String]] = []

    @IBOutlet weak var fromdate: UITextField!
    @IBOutlet weak var todate: UITextField!
    @IBOutlet weak var blurview: UIView!
    
    @IBOutlet weak var viewbtn: UIButton!
    @IBOutlet weak var dtrspinner: DropDown!
    
    @IBOutlet weak var search: UITextField!
    @IBOutlet weak var DtrReportView: UIView!
    
    public var datePicker: UIDatePicker?
    public var datePicker2 : UIDatePicker?
    let date = Date()
    let formatter = DateFormatter()
    var dtrspinnerstr: String?
    var spinnerselection: String?
    
    var trainingdoc: String?
    var salon: String?
    var salontext: String?
    var trainingdocarr = [String]()
    var salonarr = [String]()
    var stylistname: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        AppDelegate.menubool = true
        viewbtn.isEnabled = false
        trainingdocarr = []
        salonarr = []
       
        search.isUserInteractionEnabled = false
        self.DtrReportView.isHidden = true
        self.DtrReportView.backgroundColor = UIColor(patternImage: UIImage(named: "internal_background.png")!)
        self.blurview.isHidden = true
        
        DtrReportView.layer.shadowColor = UIColor.black.cgColor
        DtrReportView.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        DtrReportView.layer.shadowOpacity = 2.0
        if #available(iOS 11.0, *){
            DtrReportView.clipsToBounds = false
            DtrReportView.layer.cornerRadius = 15
            DtrReportView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        }else{
            let rectShape = CAShapeLayer()
            rectShape.bounds = DtrReportView.frame
            rectShape.position = DtrReportView.center
            rectShape.path = UIBezierPath(roundedRect: DtrReportView.bounds,    byRoundingCorners: [.topLeft , .topRight], cornerRadii: CGSize(width: 30, height: 30)).cgPath
            DtrReportView.layer.backgroundColor = UIColor.green.cgColor
            DtrReportView.layer.mask = rectShape
        }
        
        dtrspinner.optionArray = ["All", "Workshop", "In Salon", "Market Visit", "Hot Day"]
        dtrspinner.didSelect { (selectedText, index, id) in
           print("Selected String: \(selectedText) \n index: \(index)")
            self.spinnerselection = selectedText
            self.viewbtn.isEnabled = true
        }
        menuvc = self.storyboard?.instantiateViewController(withIdentifier: "menuViewController") as! menuViewController
        
        let tapeno = UITapGestureRecognizer(target: self, action: #selector(clicksalon))
        tapeno.numberOfTapsRequired=1
        tapeno.delegate = self as? UIGestureRecognizerDelegate
        self.dtrlistview.addGestureRecognizer(tapeno)

        let tap = UITapGestureRecognizer(target: self, action: #selector(singleTapped))
        tap.numberOfTapsRequired = 2
        view.addGestureRecognizer(tap)
        
        let swiperyt = UISwipeGestureRecognizer(target: self, action: #selector(self.gesturerecognise))
        swiperyt.direction = UISwipeGestureRecognizerDirection.right
        
        let swipelft = UISwipeGestureRecognizer(target: self, action: #selector(self.gesturerecognise))
        swipelft.direction = UISwipeGestureRecognizerDirection.left
        
        self.view.addGestureRecognizer(swiperyt)
        self.view.addGestureRecognizer(swipelft)
        
        datePicker = UIDatePicker()
        datePicker?.datePickerMode = .date
        
        datePicker2 = UIDatePicker()
        datePicker2?.datePickerMode = .date
        
        datePicker?.addTarget(self, action: #selector(DTRViewController.dateChanged(datePicker:)), for: .valueChanged)
        datePicker2?.addTarget(self, action: #selector(DTRViewController.dateChanged(datePicker2:)), for: .valueChanged)
        
        dtrlistview.dataSource = self
        dtrlistview.delegate = self
        
        fromdate.inputView = datePicker
        todate.inputView = datePicker2
        
        formatter.dateFormat = "dd-MMM-yyyy"
        let result = formatter.string(from: date)
        
        fromdate.text = result
        todate.text = result
    }
    
    @objc func singleTapped() {
        // do something here
      view.endEditing(true)
    }
    
    @objc func clicksalon(_ gestureRecognizer: UIGestureRecognizer){
     
            let touchPoint = gestureRecognizer.location(in: self.dtrlistview)
            if let indexPath = dtrlistview.indexPathForRow(at: touchPoint) {
                let index = indexPath.row
                self.DtrReportView.isHidden = false
                self.blurview.isHidden = false
                self.setinsidedtrdata(trainingDoc: trainingdocarr[index], salon: salonarr[index])
    }
}
    
    @objc func dateChanged(datePicker: UIDatePicker) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MMM-YYYY"
        fromdate.text = dateFormatter.string(from: datePicker.date)
    }
    
    @objc func dateChanged(datePicker2: UIDatePicker) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MMM-YYYY"
        todate.text = dateFormatter.string(from: datePicker2.date)
    }
    
    @IBAction func search(_ sender: UITextField) {
        
            salontext = sender.text
            self.setdtrlist(query: self.salontext)
            
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
    
    @IBAction func cancelbtn(_ sender: Any) {
        self.DtrReportView.isHidden = true
        self.blurview.isHidden = true
    }
    
    func setinsidedtrdata(trainingDoc: String?,salon: String?)
    {
        self.insidedtrdata.removeAll()
        var stmt1: OpaquePointer?
        
        UserDefaults.standard.removeObject(forKey: "dtrfromdate")
        UserDefaults.standard.removeObject(forKey: "dtrtodate")

        //stylistname TEXT,stylistmobileno TEXT,trainingdoc TEXT
        let query = "select distinct stylistname,stylistmobileno from Dtrlisttable where trainingdoc ='\(trainingDoc!)' and saloncode = '\(salon!)'"
        
        if sqlite3_prepare_v2(DatabaseConnection.dbs, query, -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(DatabaseConnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return
        }
        
        while(sqlite3_step(stmt1) == SQLITE_ROW)
        {
            stylistname = String(cString: sqlite3_column_text(stmt1, 0))
            let stylistmobno = String(cString: sqlite3_column_text(stmt1, 1))
        
            self.insidedtrdata.append(insideDtradapte(stylistname: stylistname, stylistno: stylistmobno))
        }
        self.stylistcount = self.insidedtrdata.count
        if (stylistname!.isEmpty){
            self.blurview.isHidden = true
            self.DtrReportView.isHidden = true
        }
        self.subdtrview.reloadData()
    }
    
    func setdtrlist (query:String?)
    {
        self.dtrlistdata.removeAll()
        self.trainingdocarr.removeAll()
        self.salonarr.removeAll()
        var stmt1:OpaquePointer?
        UserDefaults.standard.removeObject(forKey: "dtrfromdate")
        UserDefaults.standard.removeObject(forKey: "dtrtodate")
        let query = "SELECT distinct date,training,trainingtype,stylist,salon,trainingdoc,saloncode FROM Dtrlisttable where salon like '%" + query! + "%'"
        
        if sqlite3_prepare_v2(DatabaseConnection.dbs, query, -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(DatabaseConnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return
        }
        
        while(sqlite3_step(stmt1) == SQLITE_ROW){
            //String(cString: sqlite3_column_text(stmt, 1))
            let date1 = String(cString: sqlite3_column_text(stmt1, 0))
            let training1 = String(cString: sqlite3_column_text(stmt1, 1))
            let salon1 = String(cString: sqlite3_column_text(stmt1, 4))
            var stylist1 = String(cString: sqlite3_column_text(stmt1, 3))
            let trainingtype1 = String(cString: sqlite3_column_text(stmt1, 2))
            
            salon = String(cString: sqlite3_column_text(stmt1, 6))
            trainingdoc = String(cString: sqlite3_column_text(stmt1, 5))
            
            self.trainingdocarr.append(trainingdoc!)
            self.salonarr.append(salon!)
            
            self.setinsidedtrdata(trainingDoc: trainingdoc, salon: salon)
            if (stylistname!.isEmpty){
                self.dtrlistdata.append(Dtrlistview(date: date1, stylist: stylist1, salon: salon1, type: trainingtype1, training: training1, trainingdoc: trainingdoc))
            }
            else{
                stylist1 = String(self.stylistcount)
                self.dtrlistdata.append(Dtrlistview(date: date1, stylist: stylist1, salon: salon1, type: trainingtype1, training: training1, trainingdoc: trainingdoc))
            }
        }
        self.dtrlistview.reloadData()
        search.isUserInteractionEnabled = true
        self.view.isUserInteractionEnabled = true
        print("got data")
    }
    
    @IBAction func viewbtn(_ sender: UIButton) {
        
        self.checknet()
        if AppDelegate.ntwrk > 0 {
            
            print("\(String(describing: self.spinnerselection!))")
            //UserDefaults.standard.set(self.spinnerselection, forKey: "dtrspinnerselection")
            UserDefaults.standard.set(fromdate.text, forKey: "dtrfromdate")
            UserDefaults.standard.set(todate.text, forKey: "dtrtodate")
            self.view.isUserInteractionEnabled = false
            print("sending request")
            
            let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
            activityIndicator.center = CGPoint(x: view.bounds.size.width/2, y: view.bounds.size.height/2)
            activityIndicator.color = UIColor.black
            view.addSubview(activityIndicator)
            activityIndicator.startAnimating()
            print("loader activated")
            //        let url = Constants.BASE_URL+Constants.URL_GetDtrlist + self.fromdate.text! + "&todate=" + self.todate.text +  "&TRAININGTYPE="+ self.spinnerselection!.replacingOccurrences(of: " ",with:"%20")
            
            let fromdateurl = self.fromdate.text! + "&todate=" + self.todate.text!
            Alamofire.request(Constants.BASE_URL+Constants.URL_GetDtrlist + fromdateurl +  "&TRAININGTYPE=" + self.spinnerselection!.replacingOccurrences(of: " ", with: "%20")).validate().responseJSON {
                response in
                self.deletedtrlisttable()
                switch response.result {
                case .success(let value): print("success======> \(value)")
                if  let json = response.result.value{
                    let listarray : NSArray = json as! NSArray
                    if listarray.count > 0 {
                        for i in 0..<listarray.count{
                            let date = String (((listarray[i] as AnyObject).value(forKey:"date") as? String)!)
                            let training = String (((listarray[i] as AnyObject).value(forKey:"training") as? String)!)
                            let trainingtype = String (((listarray[i] as AnyObject).value(forKey:"trainingtype") as? String)!)
                            let salon = String (((listarray[i] as AnyObject).value(forKey:"salon") as? String)!)
                            let stylist = String(((listarray[i] as AnyObject).value(forKey:"stylist") as? Int32)!)
                            let stylistname = String (((listarray[i] as AnyObject).value(forKey:"stylistname") as? String)!)
                            let stylistmobno = String (((listarray[i] as AnyObject).value(forKey:"stylistmobileno") as? String)!)
                            let trainingdoc = String (((listarray[i] as AnyObject).value(forKey:"trainingdoc") as? String)!)
                            let saloncode = String (((listarray[i] as AnyObject).value(forKey:"saloncode") as? String)!)
                            //self.dtrlistdata.append(Dtrlistview(date: date, stylist: stylist, salon: salon, type: trainingtype, training: training))
                            print("data inserted ===== \(i) >>> \(date)  \(training) \(trainingtype) \(salon) \(stylist)")
                            self.insertdtrlist(saloncode: saloncode,date: date, training: training, trainingtype: trainingtype, salon: salon, stylist: stylist, stylistname: stylistname, stylistmobileno: stylistmobno, trainingdoc: trainingdoc)
                        }}
                    else {
                        self.showtoast(controller: self, message: "Data not available...", seconds: 1.5)
                    }}
                activityIndicator.stopAnimating()
                self.view.isUserInteractionEnabled = true
                print("loader deactivated")
                
                self.setdtrlist(query: "")
                
                print("\(String(describing: self.spinnerselection!))")
                    break
                case .failure(let error): print("error======> \(error)")
                activityIndicator.stopAnimating()
                self.view.isUserInteractionEnabled = true
                print("loader deactivated")
                
                self.setdtrlist(query: "")
                
                print("\(String(describing: self.spinnerselection!))")
                    break
                }}
        }
            
        else
        {
            self.showtoast(controller: self, message: "Please Check Your Internet", seconds: 2.0)
        }
    }
}
