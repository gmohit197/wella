//
//  Notification.swift
//  Wella.2
//
//  Created by Acxiom Consulting on 24/10/18.
//  Copyright © 2018 Acxiom. All rights reserved.
//

import UIKit

class NotificationController: BaseActivity {
    
    var menuvc : menuViewController!


    override func viewDidLoad() {
        super.viewDidLoad()
        
        menuvc = (self.storyboard?.instantiateViewController(withIdentifier: "menuViewController") as! menuViewController)
        let swiperyt = UISwipeGestureRecognizer(target: self, action: #selector(self.gesturerecognise))
        swiperyt.direction = UISwipeGestureRecognizerDirection.right

        let swipelft = UISwipeGestureRecognizer(target: self, action: #selector(self.gesturerecognise))
        swipelft.direction = UISwipeGestureRecognizerDirection.left
        
        self.view.addGestureRecognizer(swiperyt)
        self.view.addGestureRecognizer(swipelft)
        
        NotificationCenter.default.addObserver(self, selector: #selector(rotated), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)

    }
    
    @objc func rotated() {
        if UIDevice.current.orientation.isLandscape {
            print("Landscape") //when the user taps the button this is being printed.
        } else {
            print("Portrait") //when the user rotates back to portrait this is NOT being printed.
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
}
