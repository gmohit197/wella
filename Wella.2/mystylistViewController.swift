//
//  mystylistViewController.swift
//  Wella.2
//
//  Created by Acxiom on 02/09/18.
//  Copyright © 2018 Acxiom. All rights reserved.
//

import UIKit
import Alamofire
import SQLite3

class mystylistViewController: ExecuteApi, UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mystylistdata.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "mystylistcell", for  : indexPath) as! MyStylistCell
        let list: MyStylistlistview
        list = mystylistdata[indexPath.row]
        
        cell.count.text = list.count
        cell.salon.text = list.salon
        cell.seller.text = list.seller
        cell.stylist.text = list.stylist
        cell.contact.text = list.contact
        return cell
    }
    
    
    var menuvc : menuViewController!
    
   var mystylistdata = [MyStylistlistview]()
    @IBOutlet weak var fromdate: UITextField!
    
    @IBOutlet weak var todate: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    public var datePicker: UIDatePicker?
    public var datePicker2 : UIDatePicker?
    let date = Date()
    let formatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        AppDelegate.menubool = true

        tableView.separatorColor = UIColor(white: 0.95, alpha: 1)
        tableView.dataSource = self
        tableView.delegate = self
        UserDefaults.standard.removeObject(forKey: "mystylistfromdate")
        UserDefaults.standard.removeObject(forKey: "mystylisttodate")
        menuvc = self.storyboard?.instantiateViewController(withIdentifier: "menuViewController") as! menuViewController
        
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
        
        datePicker?.addTarget(self, action: #selector(mystylistViewController.dateChanged(datePicker:)), for: .valueChanged)
        datePicker2?.addTarget(self, action: #selector(mystylistViewController.dateChanged(datePicker2:)), for: .valueChanged)
        
        fromdate.inputView = datePicker
        todate.inputView = datePicker2
        
        formatter.dateFormat = "dd-MMM-yyyy"
        let result = formatter.string(from: date)
        
        fromdate.text = result
        todate.text = result
    }
    
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 1
//    }
//
    @objc func singleTapped() {
        // do something here
        view.endEditing(true)
    }
    
    @objc func dateChanged(datePicker: UIDatePicker) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MMM-yyyy"
        fromdate.text = dateFormatter.string(from: datePicker.date)
    }
    
    @objc func dateChanged(datePicker2: UIDatePicker) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MMM-yyyy"
        todate.text = dateFormatter.string(from: datePicker2.date)
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
            self.menuvc.view.backgroundColor = UIColor.black.withAlphaComponent(0.0 )
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
    
    @IBAction func viewbtn(_ sender: UIButton) {
        self.checknet()
         if AppDelegate.ntwrk > 0 {
        UserDefaults.standard.set(fromdate.text, forKey: "mystylistfromdate")
        UserDefaults.standard.set(todate.text, forKey: "mystylisttodate")
        self.view.isUserInteractionEnabled = false
        print("mystylist data request")
        let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
        activityIndicator.center = CGPoint(x: view.bounds.size.width/2, y: view.bounds.size.height/2)
        activityIndicator.color = UIColor.black
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        print("loader activated")
        
        DispatchQueue.global(qos: .userInitiated).async {
        Alamofire.request(Constants.BASE_URL+Constants.URL_GetMyStylist + self.fromdate.text! + "&todate=" + self.todate.text! ).validate().responseJSON {
            response in
            switch response.result {
            case .success(let value): print("success======> \(value)")
            if  let json = response.result.value{
                let listarray : NSArray = json as! NSArray
                 if listarray.count > 0 {
                for i in 0..<listarray.count{
                    let seller = String (((listarray[i] as AnyObject).value(forKey:"seller") as? String)!)
                    let contact = String (((listarray[i] as AnyObject).value(forKey:"contact") as? String)!)
                    let salon = String (((listarray[i] as AnyObject).value(forKey:"salon") as? String)!)
                    let stylist = String (((listarray[i] as AnyObject).value(forKey:"stylist") as? String)!)
                    let count = String(((listarray[i] as AnyObject).value(forKey:"slno") as? Int32)!)
              print("data inserted ===== \(i) >>> \(count)  \(contact) \(salon) \(stylist) \(seller)")
                    self.insertmystylist(slno: count, stylist: stylist, contact: contact, salon: salon, seller: seller)
                }
                self.setmystylist()
                self.deletemystylisttable()
            }
                activityIndicator.stopAnimating()
                self.view.isUserInteractionEnabled = true
                print("loader deactivated")
                self.deletemystylisttable()
                print("got data")
            }
            else {
                self.showtoast(controller: self, message: "Data not available...", seconds: 1.5)
            }
                break
            case .failure(let error): print("error======> \(error)")
                break
            }}
//            DispatchQueue.main.async {
//                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
//
//                    activityIndicator.stopAnimating()
//                    self.view.isUserInteractionEnabled = true
//                    print("loader deactivated")
//                    self.deletemystylisttable()
//                    print("got data")
//                }}
            
            }
         }
         else
         {
            self.showtoast(controller: self, message: "Please Check Your Internet", seconds: 2.0)
        }
        }
    
    func setmystylist()  {
        self.mystylistdata.removeAll()
        
        var stmt1: OpaquePointer? = nil
        let query = "SELECT * FROM MystylistList"
        UserDefaults.standard.removeObject(forKey: "mystylistfromdate")
        UserDefaults.standard.removeObject(forKey: "mystylisttodate")
        
        if sqlite3_prepare_v2(DatabaseConnection.dbs, query, -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(DatabaseConnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return
        }
        while(sqlite3_step(stmt1) == SQLITE_ROW){
            //String(cString: sqlite3_column_text(stmt, 1))
            let slno = String(cString: sqlite3_column_text(stmt1, 0))
            let stylist = String(cString: sqlite3_column_text(stmt1, 1))
            let contact = String(cString: sqlite3_column_text(stmt1, 2))
            let salon = String(cString: sqlite3_column_text(stmt1, 3))
            let seller = String(cString: sqlite3_column_text(stmt1, 4))
            self.mystylistdata.append(MyStylistlistview(seller: seller, contact: contact, salon: salon, Stylist: stylist, count: slno))
            print("\n \(slno) \(stylist) \(contact) \(salon) \(seller)")
        }
        self.tableView.reloadData()
     
        
        self.view.isUserInteractionEnabled = true
        print("set data")
        }
    }

