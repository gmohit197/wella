//
//  MyProfileViewController.swift
//  Wella.2
//
//  Created by Acxiom Consulting on 18/03/21.
//  Copyright © 2021 Acxiom. All rights reserved.
//

//MARK:- IMPORTS
import UIKit
import Dropdowns
import SQLite3
import Alamofire
import SystemConfiguration
import SwiftEventBus
import CoreLocation

class MyProfileViewController: UIViewController {
    
    @IBOutlet weak var topdoorcount: UILabel!
    @IBOutlet weak var trainingcount: UILabel!
    @IBOutlet weak var uniquecount: UILabel!
    @IBOutlet weak var stylistcount: UILabel!
    @IBOutlet weak var managername: UILabel!
    @IBOutlet weak var emailid: UILabel!
    @IBOutlet weak var mobno: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var boyImageView: UIImageView!
    
    var menuvc : menuViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let value = UIInterfaceOrientation.portrait.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")

        menuGestures()
        setUpImageView()
        fetchData()
    }
    
//     override var shouldAutorotate: Bool {
//      return false
//    }
//    
//    override var supportedInterfaceOrientations: UIInterfaceOrientationMask{
//        return .portrait
//    }
//    
//    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation{
//    return .portrait
//    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        let value = UIInterfaceOrientation.portrait.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
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

    
    fileprivate func setUpImageView(){
        boyImageView.layer.borderWidth = 3
        boyImageView.layer.masksToBounds = false
        boyImageView.layer.borderColor = #colorLiteral(red: 175/255.0, green: 110/255.0, blue: 150/255.0, alpha: 1)
        boyImageView.layer.cornerRadius = boyImageView.frame.height / 2
        boyImageView.clipsToBounds = true
    }
    
    fileprivate func fetchData(){
        var stmt:OpaquePointer?
        let queryString = "SELECT * FROM UserProfileNew"
        if sqlite3_prepare_v2(DatabaseConnection.dbs, queryString, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(DatabaseConnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return
        }
        while(sqlite3_step(stmt) == SQLITE_ROW){
            self.name.text! = String(cString: sqlite3_column_text(stmt, 1))
            self.mobno.text! = String(cString: sqlite3_column_text(stmt, 2))
            self.emailid.text! = String(cString: sqlite3_column_text(stmt, 3))
            self.managername.text! = String(cString: sqlite3_column_text(stmt, 4))
            self.stylistcount.text! = String(cString: sqlite3_column_text(stmt, 5))
            self.uniquecount.text! = String(cString: sqlite3_column_text(stmt, 6))
            self.trainingcount.text! = String(cString: sqlite3_column_text(stmt, 7))
            self.topdoorcount.text! = String(cString: sqlite3_column_text(stmt, 8))
        }
        
    }
    
}
