//
//  BaseActivity.swift
//  Wella.2
//
//  Created by Acxiom Consulting on 17/09/18.
//  Copyright © 2018 Acxiom. All rights reserved.
//
import UIKit
import Foundation

public class BaseActivity: DatabaseConnection  {
    var loader = UIAlertController()
 //  public var userID : String? = UserDefaults.standard.string(forKey: "userid")!
    public func showtoast(controller: UIViewController, message: String, seconds: Double){
        let alert = UIAlertController(title: nil, message: message,  preferredStyle: .alert)
        alert.view.backgroundColor = UIColor.black
        
        alert.view.alpha = 0.6
        alert.view.layer.cornerRadius = 15
        
        controller.present(alert, animated: true)
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + seconds){
            alert.dismiss(animated : true)
        }
    }
    
    func showloader(title: String){
        let alert = UIAlertController(title: nil, message: title, preferredStyle: .alert)
        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        loadingIndicator.startAnimating();
        alert.view.addSubview(loadingIndicator)
        present(alert, animated: true, completion: nil)
    }
    func showSyncloader(title: String){
        loader = UIAlertController(title: nil, message: title, preferredStyle: .alert)
        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        loadingIndicator.startAnimating();
        
        loader.view.addSubview(loadingIndicator)
        present(loader, animated: true, completion: nil)
    }
    
    func hideSyncloader(){
        DispatchQueue.main.async {
            self.loader.dismiss(animated: true, completion: nil)
        }
    }
    
    func hideMyActivitySyncloader(){
        DispatchQueue.main.async {
            self.loader.dismiss(animated: false, completion: nil)
        }
    }


    func checknet(){
        guard let status = Network.reachability?.status else { return }
        switch status {
        case .unreachable:
            if UIDevice.modelName.contains("Simulator"){
                AppDelegate.ntwrk = 1;
            }
            else {
                AppDelegate.ntwrk = 0;
            }
            break
        case .wifi:
            AppDelegate.ntwrk = 1;
            break
            
        case .wwan:
            AppDelegate.ntwrk = 1;
            break
        }
        print("Reachability Summary")
        print("Status:", status)
        print("HostName:", Network.reachability?.hostname ?? "nil")
        print("Reachable:", Network.reachability?.isReachable ?? "nil")
        print("Wifi:", Network.reachability?.isReachableViaWiFi ?? "nil")

    }
    func json(from object:Any) -> String? {
        guard let data = try? JSONSerialization.data(withJSONObject: object, options: []) else {
            return nil
        }
        return String(data: data, encoding: String.Encoding.utf8)
    }
    func appversion() -> String {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
    }
    public func getdate () -> String {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let currdate = formatter.string(from: date)
        
        return currdate
    }
    func datetime() -> String
    {
        let date = Date()
        let calender = Calendar.current
        let components = calender.dateComponents([.year,.month,.day,.hour,.minute,.second], from: date)
        
        let year = components.year
        let month = components.month
        let day = components.day
        let hour = components.hour
        let minute = components.minute
        let second = components.second
        
        let today_string = "\(String(year!))-\(String(month!))-\(String(day!)) \(String(hour!)):\(String(minute!)):\(String(second!))"
        
        return today_string
   
    }
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tapGesture = UITapGestureRecognizer(target: self,
                                                action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func hideKeyboard() {
        view.endEditing(true)
    }

}

extension UIViewController {
    
    func textFieldDidBeginEditing(textField: UITextField) {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardwillChange(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector:  #selector(keyboardwillChange(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardwillChange(notification:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
        
    }
    
    @objc func keyboardwillChange(notification: NSNotification) {
        
        guard let keyboardRect = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            
            return
        }
        
        
        if notification.name == Notification.Name.UIKeyboardWillShow || notification.name == Notification.Name.UIKeyboardWillChangeFrame
        {
            view.frame.origin.y = -keyboardRect.height
        }
        else
        {
            view.frame.origin.y = 0
        }
        
    }
    func pushnext(identifier: String,controller: UIViewController){
          let forgot = (controller.storyboard?.instantiateViewController(withIdentifier: identifier))!
          print(" \(identifier) - \(controller.navigationController)")
             controller.navigationController?.pushViewController(forgot, animated: true)
      }
    
    public func push(vcId: String, vc: BaseActivity ){
              let storyboard = UIStoryboard(name: "Main", bundle: nil)
              let registrationVC = storyboard.instantiateViewController(withIdentifier: vcId) as! UINavigationController
              navigationController?.pushViewController(registrationVC.topViewController!, animated: true)
          }
    
    public func pushHome(vcId: String, vc: BaseActivity ){
              let storyboard = UIStoryboard(name: "Main", bundle: nil)
              let registrationVC = storyboard.instantiateViewController(withIdentifier: vcId) as! UINavigationController
              navigationController?.pushViewController(registrationVC.topViewController!, animated: false)
          }

    public func SetStylistName(stylistNameString : String) -> String{
        var stylistarray : [String]! = []
        stylistarray = stylistNameString.components(separatedBy: "-")
        return stylistarray[0]
    }

    public  func getTodayStringNew() -> String{
        
        let date = Date()
        let calender = Calendar.current
        let components = calender.dateComponents([.year,.month,.day,.hour,.minute,.second,.nanosecond], from: date)
        
        let year = components.year
        let month = components.month
        let day = components.day
        let hour = components.hour
        let minute = components.minute
        let second = components.second
        let nanosecond = components.nanosecond
        
        let today_string = String(day!) + String(month!) + String(year!) + String(hour!)  + String(minute!) +  String(second!) +  String(nanosecond!)
        
        return today_string
        
    }
    
    public  func getTodayDateString() -> String{
          
          let date = Date()
          let calender = Calendar.current
          let components = calender.dateComponents([.year,.month,.day,.hour,.minute,.second], from: date)
          
          let year = components.year
          let month = components.month
          let day = components.day
          
          let today_string = String(day!) + "-" + String(month!) + "-" + String(year!)
          
          return today_string
          
      }
    
    public  func getTodayDateStringYMD() -> String{
          
          let date = Date()
          let calender = Calendar.current
          let components = calender.dateComponents([.year,.month,.day,.hour,.minute,.second], from: date)
          
          let year = components.year
          let month = components.month
          let day = components.day
          
        //  let today_string = String(day!) + "-" + String(month!) + "-" + String(year!)
        let today_string =  String(year!) + "-" + String(month!) + "-" + String(day!) 


          return today_string
          
      }



}


