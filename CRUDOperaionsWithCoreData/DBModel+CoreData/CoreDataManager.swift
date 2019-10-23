//
//  CoreDataManager.swift
//  CallDocAssignment
//
//  Created by Ayush Gupta on 19/10/19.
//  Copyright © 2019 Ayush Gupta. All rights reserved.
//

import CoreData

struct CoreDataManager {
    
    static let shared = CoreDataManager()
    
    let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "EmployeeDataModel")
        container.loadPersistentStores { (storeDescription, error) in
            if let err = error {
                fatalError("Loading of store failed: \(err)")
            }
        }
        return container
    }()
    
    // MARK :- Create/Add employee details
    func addEmployee(id: String, name: String, address: String, designation: String, profileImage: Data, mobileNumber: String) {
        
        let context = persistentContainer.viewContext
        let employee = NSEntityDescription.insertNewObject(forEntityName: "EmployeeEntity", into: context) as! EmployeeEntity
        
        employee.setValue(id, forKey: "id")
        employee.setValue(name, forKey: "name")
        employee.setValue(address, forKey: "address")
        employee.setValue(designation, forKey: "designation")
        employee.setValue(profileImage, forKey: "profileImage")
        employee.setValue(mobileNumber, forKey: "mobileNumber")
        
        do {
            try context.save()
        } catch let err {
            print("Failed to create employee: ", err)
        }
    }
    
    // MARK :- Fetch/read/get employee list
    func fetchEmployeeList() -> [EmployeeEntity] {
        
        let context = persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<EmployeeEntity>(entityName: "EmployeeEntity")
        let sortByDate = NSSortDescriptor.init(key: "id", ascending: false)
        fetchRequest.sortDescriptors = [sortByDate]
        do {
            let event = try context.fetch(fetchRequest)
            return event
        } catch let fetchErr {
            print("Failed to fetch employee list: ", fetchErr)
            return []
        }
    }
    
    // MARK :- Fetch/read/get employee list by designation
    func fetchEmployeeListByDesignation(designation: String) -> [EmployeeEntity] {
        
        let context = persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<EmployeeEntity>(entityName: "EmployeeEntity")
        fetchRequest.predicate = NSPredicate(format: "designation == %@", designation)
        let sortByDate = NSSortDescriptor.init(key: "id", ascending: false)
        fetchRequest.sortDescriptors = [sortByDate]
        do {
            let event = try context.fetch(fetchRequest)
            return event
        } catch let fetchErr {
            print("Failed to fetch employee list: ", fetchErr)
            return []
        }
    }
    
    // MARK :- Update/Edit perticular employee details
    func updateEmployee(id: String, name: String, address: String, designation: String, profileImage: Data, mobileNumber: String) {
        
        let managedContext = persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<EmployeeEntity>(entityName: "EmployeeEntity")
        fetchRequest.predicate = NSPredicate(format: "id = %@", id)
        do {
            let fetch = try managedContext.fetch(fetchRequest)
            let employee = fetch[0] as NSManagedObject
            employee.setValue(name, forKey: "name")
            employee.setValue(address, forKey: "address")
            employee.setValue(designation, forKey: "designation")
            employee.setValue(profileImage, forKey: "profileImage")
            employee.setValue(mobileNumber, forKey: "mobileNumber")
            do {
                try managedContext.save()
            } catch {
                print(error)
            }
        } catch {
            print(error)
        }
    }
    
    // MARK :- Delete perticular employee
    func deleteEmployee(id: String) {
        
        let fetchRequest: NSFetchRequest<EmployeeEntity> = EmployeeEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id = %@", "\(id)")
        let context = persistentContainer.viewContext
        let employee = try? context.fetch(fetchRequest)
        employee?.forEach { (employee) in
            context.delete(employee)
        }
        try? context.save()
    }
}
