//
//  SignUpViewControllerNew.swift
//  EzDrive
//
//  Created by Bryan Lew on 26/6/18.
//  Copyright © 2018 Bryan Lew. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

class SignUpViewController: UICollectionViewController {
    
    let profileImageCellId = "profileImageCellId"
    let cellId = "cellId"
    let headerId = "headerId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()

        
        collectionView?.register(SignUpProfileImageCell.self, forCellWithReuseIdentifier: profileImageCellId)
        collectionView?.register(SignUpTextFieldCell.self, forCellWithReuseIdentifier: cellId)
        collectionView?.register(SignUpHeaderCell.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerId)
        collectionView?.backgroundColor = UIColor.rgb(r: 232, g: 236, b: 241)

        
        setupNavBarItems()
        
    }
    
    lazy var backButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(handleDismiss))
        return button
    }()
    
    lazy var signUpButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "Sign Up", style: .plain, target: self, action: #selector(handleSignUp))
        return button
    }()
    
    func setupNavBarItems() {
        self.navigationItem.leftBarButtonItem = backButton
        self.navigationItem.rightBarButtonItem = signUpButton
    }

    @objc func handleDismiss() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func handleSignUp() {
        self.view.endEditing(true)
        
        print("Sign Up")
        
        // Grab the text at each of the cells, if any of them is empty, just return and print empty cell message
        let nameCell = collectionView?.cellForItem(at: IndexPath(item: 0, section: 1)) as! SignUpTextFieldCell
        let name = nameCell.cellTextField.text
        if name == "" {
            print("Name cell is empty")
            return
        }
        
        let emailCell = collectionView?.cellForItem(at: IndexPath(item: 0, section: 2)) as! SignUpTextFieldCell
        let email = emailCell.cellTextField.text
        if email == "" {
            print("Email cell is empty")
            return
        }
        
        let passwordCell = collectionView?.cellForItem(at: IndexPath(item: 0, section: 3)) as! SignUpTextFieldCell
            let password = passwordCell.cellTextField.text
            if password == "" {
            print("Password cell is empty")
            return
        }
        
        let cfmPasswordCell = collectionView?.cellForItem(at: IndexPath(item: 1, section: 3)) as! SignUpTextFieldCell
        let cfmPassword = cfmPasswordCell.cellTextField.text
        if cfmPassword == "" {
            print("Confirm password cell is empty")
            return
        }
        
        let handleCell = collectionView?.cellForItem(at: IndexPath(item: 0, section: 4)) as! SignUpTextFieldCell
        guard let handleText = handleCell.cellTextField.text else { return }
        var handle = ""
        if handleText == "" {
            print("Handle cell is empty")
            return
        } else {
            handle = "@\(handleText)"
        }
        
        let locationCell = collectionView?.cellForItem(at: IndexPath(item: 0, section: 5)) as! SignUpTextFieldCell
        let location = locationCell.cellTextField.text
        if location == "" {
            print("Location cell is empty")
            return
        }
        
        // If passwords do not match, return and print passwords do not match message
        if password != cfmPassword {
            print("Passwords do not match")
            return
        }
        
        // Grab the profile image chosen, if any
        let profileImageCell = collectionView?.cellForItem(at: IndexPath(item: 0, section: 0)) as! SignUpProfileImageCell
        let selectedProfileImage = profileImageCell.selectedProfileImage
        
        // get the current date and time
        let currentDateTime = Date()
        
        // initialize the date formatter and set the style
        let formatter = DateFormatter()
        formatter.timeStyle = .medium
        formatter.dateStyle = .long
        
        // get the date time String from the date object
        let memberSince = formatter.string(from: currentDateTime)
        
        // Register this boi
        Auth.auth().createUser(withEmail: email!, password: password!) { (authResult, error) in
            // If there's an error, print it and return
            if let err = error {
                print("Sign up unsuccessful")
                print(err)
                return
            }
            
            // If there is an authResult, it means the sign up is successful
            if let authResult = authResult {
                // Put the user info into database
                let usersRef = Database.database().reference().child("users")
                let uid = authResult.user.uid
                let newUserRef = usersRef.child(uid)
                
                // If there is a profile image selected, then put it into storage
                if let profilePhoto = selectedProfileImage, let imageData = UIImageJPEGRepresentation(profilePhoto, 0.1) {
                    
                    // Name of the data (the photo) inside the storage
                    let photoIDString = NSUUID().uuidString
                    
                    // Reference to the root location of the Firebase storage for our app
                    let storageRef = Storage.storage().reference()
                    
                    // Store the photo in the a child node called 'Users', under the respective photoIDString
                    let photoStorageRef = storageRef.child("users").child(photoIDString)
                    
                    // Put the photo in the storage
                    photoStorageRef.putData(imageData, metadata: nil) { (metadata, error) in
                        // Print the error message, if any
                        if let error = error {
                            print(error)
                            return
                        }
                        
                        // Now that the photo is in the storage, get all the users info into the database
                        
                        // Extract the download URL, then send it to database
                        photoStorageRef.downloadURL(completion: { (url, err) in
                            if let profileImgURL = url?.absoluteString {
                                newUserRef.setValue(["email": email!, "name": name!, "handle": handle, "location": location!, "profileImageUrl": profileImgURL, "memberSince": memberSince])
                            }
                        })
                    }
                } else {
                    // No image was selected, so send user's data to database with empty profileImgURL string
                    print("No image was selected")
                    newUserRef.setValue(["email": email!, "name": name!, "handle": handle, "location": location!, "profileImageUrl": "", "memberSince": memberSince])
                }
            
                print("Sign up successful")
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
}

extension SignUpViewController {
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 6
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: profileImageCellId, for: indexPath) as! SignUpProfileImageCell
            cell.signUpViewController = self
            return cell
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! SignUpTextFieldCell
        switch indexPath.section {
            case 1:
                cell.placeholderText = "Enter your name"
            case 2:
                cell.placeholderText = "Enter a valid email"
            case 3:
                if indexPath.item == 0 {
                    cell.placeholderText = "Password"
                    cell.cellTextField.isSecureTextEntry = true
                } else {
                    cell.placeholderText = "Confirm Password"
                    cell.cellTextField.isSecureTextEntry = true
                }
            case 4:
                cell.placeholderText = "Enter your preferred username"
            case 5:
                cell.placeholderText = "Choose your location"
            default:
                cell.placeholderText = "Enter text"
        }
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 3 {
            return 2
        }
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerId, for: indexPath) as! SignUpHeaderCell
        switch indexPath.section {
            case 1:
                header.headerLabelText = "Name"
            case 2:
                header.headerLabelText = "Email"
            case 3:
                header.headerLabelText = "Password"
            case 4:
                header.headerLabelText = "Username"
            case 5:
                header.headerLabelText = "Location"
            default:
                header.headerLabelText = "Header"
        }
        
        return header
    }
    
}

extension SignUpViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 0 {
            return CGSize(width: view.frame.width, height: 180)
        }
        return CGSize(width: view.frame.width, height: 40)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section == 0 {
            return .zero
        }
        return CGSize(width: view.frame.width, height: 40)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.5
    }
}
















