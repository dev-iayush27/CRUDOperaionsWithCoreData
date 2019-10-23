//
//  EmployeeListVC.swift
//  CRUDOperaionsWithCoreData
//
//  Created by Ayush Gupta on 23/10/19.
//  Copyright © 2019 Ayush Gupta. All rights reserved.
//

import UIKit

extension Notification.Name {
    static let isRefresh = Notification.Name("isRefresh")
}

class EmployeeListVC: UIViewController {
    
    @IBOutlet weak var collectionViewEmployee: UICollectionView! {
        didSet {
            collectionViewEmployee.register(UINib(nibName: "EmployeeCVCell", bundle: nil), forCellWithReuseIdentifier: "EmployeeCVCell")
        }
    }
    
    var arrEmployee = [EmployeeEntity]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setUpInit()
    }
    
    func setUpInit() {
        self.navigationItem.title = "Employees"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "add"), style: .plain, target: self, action: #selector(addEmployee))
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "filter"), style: .plain, target: self, action: #selector(filter))
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.collectionViewEmployee.delegate = self
        self.collectionViewEmployee.dataSource = self
        NotificationCenter.default.addObserver(self, selector: #selector(refresh(notification:)), name: .isRefresh, object: nil)
        self.fetchEmployeeList()
    }
    
    func fetchEmployeeList() {
        self.arrEmployee.removeAll()
        self.arrEmployee = CoreDataManager.shared.fetchEmployeeList()
        DispatchQueue.main.async {
            self.collectionViewEmployee.reloadData()
        }
    }
    
    func fetchEmployeeListByDesignation(designation: String) {
        self.arrEmployee.removeAll()
        self.arrEmployee = CoreDataManager.shared.fetchEmployeeListByDesignation(designation: designation)
        DispatchQueue.main.async {
            self.collectionViewEmployee.reloadData()
        }
    }
    
    @objc func addEmployee() {
        let vc = EmployeeDetailsVC(nibName: "EmployeeDetailsVC", bundle: nil)
        vc.isAdd = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func filter() {
        
        let alert = UIAlertController(title: "Filter Employees by designation", message: "Please Select an Option", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Reset", style: .default , handler:{ (UIAlertAction)in
            self.fetchEmployeeList()
        }))
        
        alert.addAction(UIAlertAction(title: "iOS Developer", style: .default , handler:{ (UIAlertAction)in
            self.fetchEmployeeListByDesignation(designation: "iOS Developer")
        }))
        
        alert.addAction(UIAlertAction(title: "Android Developer", style: .default , handler:{ (UIAlertAction)in
            self.fetchEmployeeListByDesignation(designation: "Android Developer")
        }))
        
        alert.addAction(UIAlertAction(title: "Full Stack Developer", style: .default , handler:{ (UIAlertAction)in
            self.fetchEmployeeListByDesignation(designation: "Full Stack Developer")
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler:{ (UIAlertAction)in
            print("User click Cancel button")
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func refresh(notification: Notification) {
        self.fetchEmployeeList()
        NotificationCenter.default.removeObserver(self, name: .isRefresh, object: nil)
    }
}

extension EmployeeListVC: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.arrEmployee.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EmployeeCVCell", for: indexPath) as? EmployeeCVCell else {
            fatalError("Cell not found.")
        }
        cell.refreshData(employee: self.arrEmployee[indexPath.row]) 
        return cell
    }
}

extension EmployeeListVC: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = EmployeeDetailsVC(nibName: "EmployeeDetailsVC", bundle: nil)
        vc.employee = self.arrEmployee[indexPath.row]
        vc.isAdd = false
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = Int(collectionView.frame.width)/2
        return CGSize(width: width, height: 165)
    }
}
