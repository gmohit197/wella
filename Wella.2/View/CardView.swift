//
//  Cardview.swift
//  tynorios
//
//  Created by Acxiom Consulting on 22/10/18.
//  Copyright © 2018 Acxiom. All rights reserved.
//

import UIKit

@IBDesignable
class CardView: UIView {
    
    @IBInspectable var cornerRadius: CGFloat = 2
    
    @IBInspectable var shadowOffsetWidth: Int = 0
    @IBInspectable var shadowOffsetHeight: Int = 3
    @IBInspectable var shadowColor: UIColor? = UIColor.black
    @IBInspectable var shadowOpacity: Float = 0.5
    
    override func layoutSubviews() {
        layer.cornerRadius = cornerRadius
        let shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
        
        layer.masksToBounds = false
        layer.shadowColor = shadowColor?.cgColor
        layer.shadowOffset = CGSize(width: shadowOffsetWidth, height: shadowOffsetHeight);
        layer.shadowOpacity = shadowOpacity
        layer.shadowPath = shadowPath.cgPath
    }
}
//{
//   "date": "Mon - 01 Mar - Workshop",
//   "isblock": false,
//   "blocK_REASON": "",
//   "activitY_NAME": "Workshop",
//   "activitY_SUBJECT": "",
//   "insaloN_1_CODE": "",
//   "insaloN_1_SUBJECT": "",
//   "insaloN_2_CODE": "",
//   "insaloN_2_SUBJECT": "",
//   "approveD_ACTIVITY_NAME": "",
//   "approveD_ACTIVITY_SUBJECT": "",
//   "approveD_INSALON_1_CODE": "",
//   "approveD_INSALON_1_SUBJECT": "",
//   "approveD_INSALON_2_CODE": "",
//   "approveD_INSALON_2_SUBJECT": "",
//   "trainercode": "TRN001",
//   "shorT_DESC": "W_SHP",
//   "salonnamE1": "",
//   "salonnamE2": "",
//   "apP_SALONNAME1": "",
//   "apP_SALONNAME2": "",
//   "status": 3
// },
