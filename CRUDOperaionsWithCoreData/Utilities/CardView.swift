//
//  CardView.swift
//  Simpliv
//
//  Created by Netzealous on 22/08/18.
//  Copyright © 2018 Stanislav Makushov. All rights reserved.
//

import UIKit

@IBDesignable class CardView: UIView {
    
    @IBInspectable var corneRadius: CGFloat = 5.0
    @IBInspectable var shadowOffSetWidth: CGFloat = 0.7
    @IBInspectable var shadowOffSetHeight: CGFloat = 0.7
    @IBInspectable var shadowColor: UIColor = UIColor.darkGray
    @IBInspectable var shadowOpacity: CGFloat = 0.3
    @IBInspectable var shadowRadiusNo: CGFloat = 2.0
    
    override func layoutSubviews() {
        layer.cornerRadius = corneRadius
        layer.shadowColor = shadowColor.cgColor
        layer.shadowRadius = shadowRadiusNo
        layer.shadowOffset = CGSize(width: shadowOffSetWidth, height: shadowOffSetHeight)
        let shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: corneRadius)
        layer.shadowPath = shadowPath.cgPath
        layer.shadowOpacity = Float(shadowOpacity)
    }
}

extension UIImageView {
    
    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
}

extension UIView {
    
    func viewRoundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
}

extension UILabel {
    
    func labelRoundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
}
