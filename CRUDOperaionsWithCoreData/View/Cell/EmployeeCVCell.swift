//
//  EmployeeCVCell.swift
//  CRUDOperaionsWithCoreData
//
//  Created by Shahanshah Manzoor on 23/10/19.
//  Copyright © 2019 Ayush Gupta. All rights reserved.
//

import UIKit

class EmployeeCVCell: UICollectionViewCell {
    
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblDesignation: UILabel!
    
    func refreshData(employee: EmployeeEntity?) {
        self.lblName.text = employee?.name
        self.lblDesignation.text = employee?.designation
        if let img = employee?.profileImage {
            self.imgProfile.image = UIImage(data: img as Data)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.imgProfile.layer.borderColor = UIColor.init(hexString: "#0096FF").cgColor
        self.imgProfile.layer.borderWidth = 2.0
        self.imgProfile.layer.cornerRadius = self.imgProfile.bounds.height/2
        self.imgProfile.clipsToBounds = true
    }
}
