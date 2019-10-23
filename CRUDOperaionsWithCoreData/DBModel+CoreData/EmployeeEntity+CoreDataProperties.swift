//
//  EmployeeEntity+CoreDataProperties.swift
//  CRUDOperaionsWithCoreData
//
//  Created by Shahanshah Manzoor on 23/10/19.
//  Copyright © 2019 Ayush Gupta. All rights reserved.
//
//

import Foundation
import CoreData


extension EmployeeEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<EmployeeEntity> {
        return NSFetchRequest<EmployeeEntity>(entityName: "EmployeeEntity")
    }

    @NSManaged public var address: String?
    @NSManaged public var designation: String?
    @NSManaged public var id: String?
    @NSManaged public var name: String?
    @NSManaged public var profileImage: NSData?
    @NSManaged public var mobileNumber: String?
}
