//
//  profileViewController.swift
//  Wella.2
//
//  Created by Acxiom on 31/08/18.
//  Copyright © 2018 Acxiom. All rights reserved.
//

import UIKit
import Foundation
import Alamofire
import SQLite3

class profileViewController: BaseActivity, UINavigationControllerDelegate {
    var menuvc : menuViewController!
    var levelname: String!
    var levelcode: String!
    var database: DatabaseConnection?
    
    @IBOutlet weak var usernamelbl: UILabel!
    @IBOutlet weak var phnnumlbl: UILabel!
    @IBOutlet weak var emaillbl: UILabel!
    @IBOutlet weak var categorylbl: UILabel!
    @IBOutlet weak var doblbl: UILabel!
    @IBOutlet weak var myImageView: UIImageView!
    
    static let shared = addStylist()
    
    fileprivate var currentVC: UIViewController!

    //MARK: Internal Properties
    var imagePickedBlock: ((UIImage) -> Void)?
    
    @IBAction func importImage(_ sender: Any) {
        showActionSheet(vc: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        AppDelegate.menubool = true
        myImageView.autoresizingMask = UIViewAutoresizing(rawValue: UIViewAutoresizing.flexibleBottomMargin.rawValue | UIViewAutoresizing.flexibleHeight.rawValue | UIViewAutoresizing.flexibleRightMargin.rawValue | UIViewAutoresizing.flexibleLeftMargin.rawValue | UIViewAutoresizing.flexibleTopMargin.rawValue | UIViewAutoresizing.flexibleWidth.rawValue)
        myImageView.contentMode = UIViewContentMode.scaleAspectFit
        
        userdetail()
        
        let profileImage = self.getProfileImage()
        
        if profileImage != ""
        {
            let dataDecoded:Data = Data(base64Encoded:profileImage,options:Data.Base64DecodingOptions.ignoreUnknownCharacters)!
            let decodedimage:UIImage = UIImage(data: dataDecoded as Data)!
            myImageView.image=decodedimage
        }
        
        menuvc = (self.storyboard?.instantiateViewController(withIdentifier: "menuViewController") as! menuViewController)
        let swiperyt = UISwipeGestureRecognizer(target: self, action: #selector(self.gesturerecognise))
        swiperyt.direction = UISwipeGestureRecognizerDirection.right
        
        let swipelft = UISwipeGestureRecognizer(target: self, action: #selector(self.gesturerecognise))
        swipelft.direction = UISwipeGestureRecognizerDirection.left
        
        self.view.addGestureRecognizer(swiperyt)
        self.view.addGestureRecognizer(swipelft)
        setupCorners()
    }
    
    fileprivate func setupCorners(){
        myImageView.layer.borderWidth = 1.0
        myImageView.layer.masksToBounds = false
        myImageView.layer.cornerRadius = myImageView.frame.size.height/2
//        myImageView.layer.borderColor = UIColor.white.cgColor
    }
    func userdetail()
    {
        var prof:OpaquePointer?
        let queryString = "SELECT * FROM User_Profile"
        
        if sqlite3_prepare_v2(DatabaseConnection.dbs, queryString, -1, &prof, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(DatabaseConnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return
        }
        
        while(sqlite3_step(prof) == SQLITE_ROW){
            
            
            let trainername = String(cString: sqlite3_column_text(prof, 6))
            let contactno = String(cString: sqlite3_column_text(prof, 10))
            let email = String(cString: sqlite3_column_text(prof, 11))
            let levelcode = String(cString: sqlite3_column_text(prof, 13))
            let levelname = String(cString: sqlite3_column_text(prof, 14))
            let doj = String(cString: sqlite3_column_text(prof, 15))
            //let designation = String(cString: sqlite3_column_text(prof, 16))
            
            self.categorylbl.text = levelcode + "-" + levelname
            self.doblbl.text = doj
            self.emaillbl.text = email
            self.phnnumlbl.text = contactno
            self.usernamelbl.text = trainername
            
            
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
    
    func camera()
    {
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            let myPickerController = UIImagePickerController()
            myPickerController.delegate = self;
            myPickerController.sourceType = .camera
            currentVC.present(myPickerController, animated: true, completion: nil)
        }
        
    }
    
    func photoLibrary()
    {
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            let myPickerController = UIImagePickerController()
            myPickerController.delegate = self;
            myPickerController.sourceType = .photoLibrary
            currentVC.present(myPickerController, animated: true, completion: nil)
        }
        
    }
    
    func showActionSheet(vc: UIViewController) {
        currentVC = vc
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (alert:UIAlertAction!) -> Void in
            self.camera()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { (alert:UIAlertAction!) -> Void in
            self.photoLibrary()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        vc.present(actionSheet, animated: true, completion: nil)
    }
    
  
}


extension profileViewController: UIImagePickerControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        currentVC.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            
            self.imagePickedBlock?(image)
            myImageView.image=image
            let imageData:NSData = UIImagePNGRepresentation(image)! as NSData
            let strBase64 = imageData.base64EncodedString(options: .lineLength64Characters)
            self.insertProfileImage(userimage: strBase64)
            
        }else{
            print("Something went wrong")
        }
        currentVC.dismiss(animated: true, completion: nil)
    }
    
   
    
}


