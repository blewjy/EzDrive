//
//  ReviewViewController.swift
//  EzDrive
//
//  Created by Bryan Lew on 19/7/18.
//  Copyright © 2018 Bryan Lew. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class ReviewViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.rgb(r: 232, g: 236, b: 241)
        
        title = "Review"
        
        setupNavBarItems()
        setupViews()
        
    }
    
    var userReviewedUid: String?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    lazy var submitButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "Submit", style: .plain, target: self, action: #selector(handleSubmit))
        return button
    }()
    
    @objc func handleSubmit() {
        print("Submitting review")
        
        guard let userReviewedUid = self.userReviewedUid else { return }
        guard let currentUserUid = Auth.auth().currentUser?.uid else { return }
        
        let ref = Database.database().reference().child("reviews").child(userReviewedUid).childByAutoId()
        
        let values = ["uid": currentUserUid, "rating": ratingControl.selectedSegmentIndex, "message": messageTextView.text, "timestamp": Date().timeIntervalSince1970] as [String: Any]
        
        ref.updateChildValues(values) { (error, ref) in
            if let error = error {
                print("Failed to get review into database: ", error)
                return
            }
            
            print("Successfully added review to database")
            
            self.navigationController?.popViewController(animated: true)
        }
        
    }
    
    func setupNavBarItems() {
        self.navigationItem.rightBarButtonItem = submitButton
    }
    
    let ratingLabel: UILabel = {
        let label = UILabel()
        label.text = "Rate your experience"
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textAlignment = .center
        return label
    }()
    
    let ratingControl: UISegmentedControl = {
        let control = UISegmentedControl()
        control.insertSegment(withTitle: "Positive", at: 0, animated: false)
        control.insertSegment(withTitle: "Negative", at: 1, animated: false)
        control.tintColor = UIColor.rgb(r: 255, g: 111, b: 0)
        control.selectedSegmentIndex = 0
        return control
    }()
    
    let messageLabel: UILabel = {
        let label = UILabel()
        label.text = "Leave a message"
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textAlignment = .center
        return label
    }()
    
    let messageTextView: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = .white
        textView.textContainerInset = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
        return textView
    }()
    
    func setupViews() {
        view.addSubview(ratingLabel)
        view.addSubview(ratingControl)
        view.addSubview(messageLabel)
        view.addSubview(messageTextView)
        
        ratingLabel.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 8, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 30)
        ratingControl.anchor(top: ratingLabel.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 8, paddingLeft: 50, paddingBottom: 0, paddingRight: 50, width: 0, height: 30)
        messageLabel.anchor(top: ratingControl.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 8, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 30)
        messageTextView.anchor(top: messageLabel.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 8, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 150)
        
    }
    
}
