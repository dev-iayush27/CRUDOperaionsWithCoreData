//
//  EmployeeDetailsVC.swift
//  CRUDOperaionsWithCoreData
//
//  Created by Shahanshah Manzoor on 23/10/19.
//  Copyright © 2019 Ayush Gupta. All rights reserved.
//

import UIKit

class EmployeeDetailsVC: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var tfName: UITextField!
    @IBOutlet weak var tfDesignation: UITextField!
    @IBOutlet weak var tfMobileNo: UITextField!
    @IBOutlet weak var tfAddress: UITextField!
    @IBOutlet weak var btnSubmit: UIButton!
    @IBOutlet weak var btnEditProfileImg: UIButton!
    
    var profileImageData: Data?
    var employee: EmployeeEntity?
    var isAdd = true
    let arrDesignation = ["iOS Developer", "Android Developer", "Full Stack Developer"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setUpInit()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.imgProfile.layer.cornerRadius = self.imgProfile.bounds.height/2
        self.imgProfile.clipsToBounds = true
        self.imgProfile.layer.borderColor = UIColor.init(hexString: "#0096FF").cgColor
        self.imgProfile.layer.borderWidth = 2.0
        
        self.btnSubmit.layer.cornerRadius = self.btnSubmit.bounds.height/2
        self.btnSubmit.clipsToBounds = true
        
        self.btnEditProfileImg.layer.cornerRadius = self.btnEditProfileImg.bounds.height/2
        self.btnEditProfileImg.clipsToBounds = true
    }
    
    func setUpInit() {
        self.setUpPickerView()
        if self.isAdd {
            self.navigationItem.title = "Add Details"
            self.btnSubmit.setTitle("Submit", for: .normal)
        } else {
            self.navigationItem.title = "Update Details"
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "delete"), style: .plain, target: self, action: #selector(deleteEmployee))
            self.setUpDataForUpdate()
            self.btnSubmit.setTitle("Update", for: .normal)
        }
    }
    
    @objc func deleteEmployee() {
        self.deleteAlert()
    }
    
    func setUpDataForUpdate() {
        self.tfName.text = self.employee?.name
        self.tfDesignation.text = self.employee?.designation
        self.tfMobileNo.text = self.employee?.mobileNumber
        self.tfAddress.text = self.employee?.address
        self.profileImageData = self.employee?.profileImage as Data?
        if let img = self.employee?.profileImage {
            self.imgProfile.image = UIImage(data: img as Data)
        }
    }
    
    func setUpPickerView() {
        let picker = UIPickerView()
        picker.delegate = self
        self.tfDesignation.inputView = picker
    }
    
    @IBAction func tapOnSubmitBtn(_ sender: UIButton) {
        
        if self.tfName.text?.count == 0 {
            self.alert(title: "Name!", message: "Please enter name.")
        } else if self.tfDesignation.text?.count == 0 {
            self.alert(title: "Designation!", message: "Please enter designation.")
        } else if self.tfName.text?.count == 0 {
            self.alert(title: "Mobile Number!", message: "Please enter mobile no.")
        } else if self.tfAddress.text?.count == 0 {
            self.alert(title: "Address!", message: "Please enter address.")
        } else {
            if self.isAdd {
                CoreDataManager.shared.addEmployee(id: String(Date().timeIntervalSince1970), name: self.tfName.text ?? "", address: self.tfAddress.text ?? "", designation: self.tfDesignation.text ?? "", profileImage: self.profileImageData ?? Data(), mobileNumber: self.tfMobileNo.text ?? "")
            } else {
                CoreDataManager.shared.updateEmployee(id: self.employee?.id ?? "", name: self.tfName.text ?? "", address: self.tfAddress.text ?? "", designation: self.tfDesignation.text ?? "", profileImage: self.profileImageData ?? Data(), mobileNumber: self.tfMobileNo.text ?? "")
            }
            NotificationCenter.default.post(name: .isRefresh, object: nil)
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func tapOnEditProfileBtn(_ sender: UIButton) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        present(imagePickerController, animated: true, completion: nil)
    }
    
    func deleteAlert() {
        let alert = UIAlertController(title: "Delete!", message: "Are you sure, you want to remove this employee?", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
        }))
        alert.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { action in
            CoreDataManager.shared.deleteEmployee(id: self.employee?.id ?? "")
            NotificationCenter.default.post(name: .isRefresh, object: nil)
            self.navigationController?.popViewController(animated: true)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func alert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { action in
        }))
        self.present(alert, animated: true, completion: nil)
    }
}

extension EmployeeDetailsVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            self.imgProfile.image = editedImage
            self.profileImageData = editedImage.jpegData(compressionQuality: 0.5)
        } else if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            self.imgProfile.image = originalImage
            self.profileImageData = originalImage.jpegData(compressionQuality: 0.5)
        }
        dismiss(animated: true, completion: nil)
    }
}

extension EmployeeDetailsVC: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.arrDesignation.count
    }
    
    func pickerView( _ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.arrDesignation[row]
    }
    
    func pickerView( _ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.tfDesignation.text = self.arrDesignation[row]
    }
}
