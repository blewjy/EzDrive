//
//  ShareViewController.swift
//  EzDrive
//
//  Created by Bryan Lew on 23/6/18.
//  Copyright © 2018 Bryan Lew. All rights reserved.
//



import UIKit
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase


class ShareViewController: UICollectionViewController {
    
    
    let imagePickerCellId = "imagePickerCellId"
    let detailsCellId = "detailsCellId"
    let descriptionCellId = "descriptionCellId"
    let headerId = "headerId"
    
    
    var selectedLocation = 5 {
        didSet {
            let locationCell = self.collectionView?.cellForItem(at: IndexPath(item: 3, section: 1)) as! ShareTextFieldCell
            locationCell.cellTextField.text = SelectLocationViewController.locationLabels[selectedLocation]
        }
    }
    
    var selectedModel = 8 {
        didSet {
            let carModelCell = self.collectionView?.cellForItem(at: IndexPath(item: 2, section: 1)) as! ShareTextFieldCell
            carModelCell.cellTextField.text = SelectCarModelViewController.carLabels[selectedModel]
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()

        
        collectionView?.backgroundColor = UIColor.rgb(r: 232, g: 236, b: 241)
        
        collectionView?.register(ShareImagePickerCell.self, forCellWithReuseIdentifier: imagePickerCellId)
        collectionView?.register(ShareTextFieldCell.self, forCellWithReuseIdentifier: detailsCellId)
        collectionView?.register(ShareDescriptionCell.self, forCellWithReuseIdentifier: descriptionCellId)
        collectionView?.register(ShareHeaderCell.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerId)
        
        collectionView?.alwaysBounceVertical = true
        collectionView?.delaysContentTouches = false
        
        setupNavBarItems()
        setupViews()
    }
    
    func setupViews() {
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: imagePickerCellId, for: indexPath) as! ShareImagePickerCell
            cell.shareViewController = self
            cell.selectedImage = nil
            return cell
            
        } else if indexPath.section == 1{
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: detailsCellId, for: indexPath) as! ShareTextFieldCell
            
            cell.iconImage = cell.iconsArray[indexPath.item]
            cell.cellLabelText = cell.cellLabelArray[indexPath.item]
            
            if indexPath.item == 2 || indexPath.item == 3 {
                cell.cellTextField.isEnabled = false
            }
            
            cell.placeholderText = cell.placeholdersArray[indexPath.item]
            cell.cellTextField.text = ""
        
            return cell
            
        } else {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: descriptionCellId, for: indexPath) as! ShareDescriptionCell
            cell.descriptionTextView.text = "Add description here"
            cell.descriptionTextView.textColor = .gray

            return cell
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 || section == 2 {
            return 1
        }
        return 5
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    
    // Ability to highlight and click to choose Car Model and Location
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        if indexPath.section == 1 && (indexPath.item == 2 || indexPath.item == 3) {
            return true
        }
        return false
    }
    
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        if indexPath.section == 1 && (indexPath.item == 2 || indexPath.item == 3) {
            return true
        }
        return false
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if indexPath.item == 2 {
            let selectCarModelViewController = SelectCarModelViewController(collectionViewLayout: UICollectionViewFlowLayout())
            selectCarModelViewController.shareViewController = self
            selectCarModelViewController.selectedModel = self.selectedModel
            self.navigationController?.pushViewController(selectCarModelViewController, animated: true)
        } else {
            let selectLocationViewController = SelectLocationViewController(collectionViewLayout: UICollectionViewFlowLayout())
            selectLocationViewController.shareViewController = self
            selectLocationViewController.selectedLocation = self.selectedLocation
            self.navigationController?.pushViewController(selectLocationViewController, animated: true)
        }
        
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerCell = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerId, for: indexPath) as! ShareHeaderCell
        switch indexPath.section {
            case 0:
                headerCell.headerLabelText = headerCell.photosHeaderLabelText
            case 1:
                headerCell.headerLabelText = headerCell.detailsHeaderLabelText
            case 2:
                headerCell.headerLabelText = headerCell.descriptionHeaderLabelText
            default:
                print("Default header")
        }
        return headerCell
    }

    lazy var finishButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "Finish", style: .plain, target: self, action: #selector(handleFinish))
        return button
    }()
    
    lazy var clearButton: UIBarButtonItem = {
        let button = UIBarButtonItem(image: #imageLiteral(resourceName: "ezdrive_clearpost"), style: .plain, target: self, action: #selector(handleClear))
        return button
    }()
    
    @objc func handleFinish() {
        print("Finish button clicked, attempting to upload post now...")
        self.view.endEditing(true)
        
        let licenseTextFieldCell = collectionView?.cellForItem(at: IndexPath(item: 4, section: 1)) as! ShareTextFieldCell
        guard let license = licenseTextFieldCell.cellTextField.text else { return }
        
        guard checkSum(license) else { self.view.makeToast("License plate is invalid!"); return }
        
        let shareImageCell = collectionView?.cellForItem(at: IndexPath(item: 0, section: 0)) as! ShareImagePickerCell
        
        guard let selectedImage = shareImageCell.selectedImage else { return }
        
        guard let uploadData = UIImageJPEGRepresentation(selectedImage, 0.5) else { return }

        self.navigationItem.rightBarButtonItem?.isEnabled = false

        let filename = NSUUID().uuidString
        
        let imageStorageRef = Storage.storage().reference().child("posts").child(filename)
        
        imageStorageRef.putData(uploadData, metadata: nil) { (metadata, error) in
            if let error = error {
                print("Error while storing image: ", error)
                self.navigationItem.rightBarButtonItem?.isEnabled = true
                return
            }
            
            print("Successfully uploaded post image, now attempting to download url")
            
            imageStorageRef.downloadURL(completion: { (url, error) in
                if let error = error {
                    print("Error downloading image url: ", error)
                    self.navigationItem.rightBarButtonItem?.isEnabled = true
                    return
                }
                
                guard let urlString = url?.absoluteString else { return }
                print("Successfully downloaded image url")
                
                // Put data in database bruh
                self.saveToDatabaseWithImageUrl(imageUrl: urlString)
            })
            
        }
        
        
    }
    
    fileprivate func saveToDatabaseWithImageUrl(imageUrl: String) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let userPostRef = Database.database().reference().child("posts").child(uid).childByAutoId()
        
        // Get all the details from the cells
        let titleTextFieldCell = collectionView?.cellForItem(at: IndexPath(item: 0, section: 1)) as! ShareTextFieldCell
        guard let title = titleTextFieldCell.cellTextField.text else { return }
        
        let priceTextFieldCell = collectionView?.cellForItem(at: IndexPath(item: 1, section: 1)) as! ShareTextFieldCell
        guard let price = priceTextFieldCell.cellTextField.text else { return }
        
        let modelTextFieldCell = collectionView?.cellForItem(at: IndexPath(item: 2, section: 1)) as! ShareTextFieldCell
        guard let model = modelTextFieldCell.cellTextField.text else { return }
        
        let locationTextFieldCell = collectionView?.cellForItem(at: IndexPath(item: 3, section: 1)) as! ShareTextFieldCell
        guard let location = locationTextFieldCell.cellTextField.text else { return }
        
        let licenseTextFieldCell = collectionView?.cellForItem(at: IndexPath(item: 4, section: 1)) as! ShareTextFieldCell
        guard let license = licenseTextFieldCell.cellTextField.text else { return }
        
        let descriptionCell = collectionView?.cellForItem(at: IndexPath(item: 0, section: 2)) as! ShareDescriptionCell
        guard let description = descriptionCell.descriptionTextView.text else { return }
        
    
        let values = ["imageUrl": imageUrl,
                      "title": title,
                      "price": Double(price) ?? 0,
                      "carModel": model,
                      "location": location,
                      "licensePlateNo": license,
                      "description": description,
                      "timestamp": Date().timeIntervalSince1970] as [String: Any]
        
        userPostRef.updateChildValues(values) { (error, ref) in
            if let error = error {
                print("Error updating child values: ", error)
                return
            }
            print("Successfully saved post to database")
            self.navigationItem.rightBarButtonItem?.isEnabled = true
            self.tabBarController?.selectedIndex = 0
            self.collectionView?.reloadData()
            self.viewDidLoad()
            
            // This will post a notification to the whole application, and wherever there is an observer that listens out for this notification, will then be able to trigger some action
            NotificationCenter.default.post(name: ShareViewController.updateFeedNotificationName, object: nil)
            
        }
        
        
      
    }
    
    static let updateFeedNotificationName = NSNotification.Name(rawValue: "UpdateFeed")
    
    
    @objc func handleClear() {
        print("Clear")
        collectionView?.reloadData()
    }
    
    func setupNavBarItems() {
        self.navigationItem.rightBarButtonItem = finishButton
        self.navigationItem.leftBarButtonItem = clearButton
    }
    
    func checkSum(_ num:String) -> Bool {
        let arr:[UInt8] = Array(num.utf8)
        let size = arr.count
        var check = [Int](repeating:0, count: 6)
        var counter = 0
        var sum = 0
        // If the string has more than 8 letters or less than 3 letters, invalid
        if (size > 8 || size < 3) {
            return false
        }
        // Reads the prefixes
        while(counter <= size && arr[counter] >= 65 && arr[counter] <= 90) {
            check[0] = check[1]
            check[1] = Int(arr[counter]) - 64
            counter += 1
        }
        // Reads the numerals
        while(counter <= size && arr[counter] >= 48 && arr[counter] <= 57) {
            check[2] = check[3]
            check[3] = check[4]
            check[4] = check[5]
            check[5] = Int(arr[counter]) - 48
            counter += 1 }
        // Multiplies by the designated numbers and get the remainder from dividing by 19
        sum = check[0] * 9
            + check[1] * 4
            + check[2] * 5
            + check[3] * 4
            + check[4] * 3
            + check[5] * 2
        sum = sum % 19
        var last:Int = 0
        // Compare with the last letter
        switch(sum) {
        case 0: // A
            last = 65
        case 1: // Z
            last = 90
        case 2: // Y
            last = 89
        case 3: // X
            last = 88
        case 4: // U
            last = 85
        case 5: // T
            last = 84
        case 6: // S
            last = 83
        case 7: // R
            last = 82
        case 8: // P
            last = 80
        case 9: // M
            last = 77
        case 10: // L
            last = 77
        case 11: // K
            last = 75
        case 12: // J
            last = 74
        case 13: // H
            last = 72
        case 14: // G
            last = 71
        case 15: // E
            last = 69
        case 16: // D
            last = 68
        case 17: // C
            last = 67
        case 18: // B
            last = 66
        default:
            last = 0
        }
        if(last == Int(arr[size - 1])) {
            return true
        } else {
            return false
        } }

    
    
}

extension ShareViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 0 {
            return CGSize(width: view.frame.width, height: 150)
        } else if indexPath.section == 1 {
            return CGSize(width: view.frame.width, height: 44)
        } else {
            return CGSize(width: view.frame.width, height: 100)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 40)
    }
    
}



