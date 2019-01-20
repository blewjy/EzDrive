//
//  ChatViewController.swift
//  EzDrive
//
//  Created by Bryan Lew on 3/7/18.
//  Copyright © 2018 Bryan Lew. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class ChatViewController: UICollectionViewController {
    
    let cellId = "cellId"
    
    var post: Post?
    
    var user1: User?
    
    var user2: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.hideKeyboardWhenTappedAround()
        
        collectionView?.backgroundColor = .white
        collectionView?.alwaysBounceVertical = true
        collectionView?.keyboardDismissMode = .interactive
        collectionView?.register(ChatCell.self, forCellWithReuseIdentifier: cellId)
        fetchMessages()
        
        setupChatPostView()
    }
    
    func setupChatPostView() {
        
        guard let post = self.post else { return }
        
        let chatPostView = ChatPostView()
        
        view.addSubview(chatPostView)
        
        chatPostView.anchor(top: collectionView?.topAnchor, left: collectionView?.leftAnchor, bottom: nil, right: collectionView?.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 80)
        
        chatPostView.postImageView.loadImage(urlString: post.imageUrl)
        
        let attributedString = NSMutableAttributedString(string: post.title, attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 14)])
        attributedString.append(NSAttributedString(string: "\n$\(post.price)", attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 14), NSAttributedStringKey.foregroundColor: UIColor.red]))
        
        chatPostView.postLabel.attributedText = attributedString
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleSelectPost))
        chatPostView.addGestureRecognizer(tapGesture)
        chatPostView.isUserInteractionEnabled = true
    }
    
    @objc func handleSelectPost() {
        print("Select")
        
        let vc = postVC(collectionViewLayout: UICollectionViewFlowLayout())

        guard let post = post else { return }
        
        vc.post = post
        
        Database.fetchUserWithUID(uid: post.uid) { (user) in
            vc.user = user
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
    var messages = [Message]()
    
    
    func fetchMessages() {
        
        let chatroomRef = Database.database().reference().child("chatrooms").child(self.chatroomId)
        
        chatroomRef.observe(.childAdded, with: { (snapshot) in
            guard let dictionary = snapshot.value as? [String: Any] else { return }

            let message = Message(dictionary: dictionary)
            
            self.messages.append(message)
                    
            self.collectionView?.reloadData()
        }) { (error) in
            print("Failed to observe chatroom messages: ", error)

        }
        

    }
    
    
    lazy var chatroomId: String = {
        guard let post = self.post else { return "" }
        guard let user1 = self.user1 else { return "" }
        guard let user2 = self.user2 else { return "" }
        
        if user1.uid < user2.uid {
            return "\(post.postId)_\(user1.uid)_\(user2.uid)"
        } else {
            return "\(post.postId)_\(user2.uid)_\(user1.uid)"
        }
    }()

    override func dismissKeyboard() {
        self.commentTextField.resignFirstResponder()
    }
  
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        
        // Seems that only the height value of the containerView's frame is important, the rest of the values will not affect the look of the view
        view.frame = CGRect(x: 999, y: 777, width: -123, height: 50)
        
        
        let textViewBubble = UIView()
        textViewBubble.backgroundColor = UIColor.rgb(r: 230, g: 230, b: 230)
        textViewBubble.layer.cornerRadius = 17
        textViewBubble.layer.masksToBounds = true
        
        let submitButton = UIButton(type: .system)
        submitButton.setTitle("Send", for: .normal)
        submitButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        submitButton.addTarget(self, action: #selector(handleSubmit), for: .touchUpInside)

        let separatorView = UIView()
        separatorView.backgroundColor = UIColor.rgb(r: 230, g: 230, b: 230)
        
        view.addSubview(textViewBubble)
        view.addSubview(submitButton)
        view.addSubview(self.commentTextField)
        view.addSubview(separatorView)
        
        textViewBubble.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: submitButton.leftAnchor, paddingTop: 8, paddingLeft: 8, paddingBottom: 8, paddingRight: 8, width: 0, height: 0)
        submitButton.anchor(top: view.topAnchor, left: nil, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 12, width: 50, height: 0)
        self.commentTextField.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: submitButton.leftAnchor, paddingTop: 4, paddingLeft: 22, paddingBottom: 4, paddingRight: 16, width: 0, height: 0)
        separatorView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 1)
        
        return view
    }()
    
    lazy var commentTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter Message"
        return textField
    }()
    
    @objc func handleSubmit() {
        
        guard let message = commentTextField.text, message.count > 0 else { return }
        
        guard let fromId = Auth.auth().currentUser?.uid else { return }
        
        guard let user1Uid = self.user1?.uid else { return }
        
        guard let user2Uid = self.user2?.uid else { return }
        
        var toId: String
        
        if user1Uid == fromId {
            toId = user2Uid
        } else {
            assert(user2Uid == fromId)
            toId = user1Uid
        }
        
        
        let chatroomRef = Database.database().reference().child("chatrooms").child(self.chatroomId).childByAutoId()
        
        let values = ["fromId": fromId,
                      "toId": toId,
                      "message": message,
                      "timestamp": Date().timeIntervalSince1970] as [String: Any]
    
        chatroomRef.updateChildValues(values) { (error, reference) in
            if let error = error {
                print("Failed to upload chat data to firebase: ", error)
                return
            }
            
            print("Successfully uploaded chat data into firebase.")
            self.commentTextField.resignFirstResponder()
            self.commentTextField.text = ""
        }
        
    }
    
    // Every page inside of an iOS app has an accessoryView which allows you to type in some text. If you build your own custom view to hold the UITextField and the button, you will have to manage how the keyboard changes its position and animation when it shows/hides. Using this inputAccessoryView, you let UIKit do the work for you.
    override var inputAccessoryView: UIView? {
        get {
            return containerView
        }
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ChatCell
        cell.message = self.messages[indexPath.item]

        return cell
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.messages.count
    }
    
}

extension ChatViewController: UICollectionViewDelegateFlowLayout {
   
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 86, left: 6, bottom: 6, right: 6)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 50)
        let dummyCell = ChatCell(frame: frame)
        dummyCell.message = self.messages[indexPath.item]
        dummyCell.layoutIfNeeded()
        
        let targetSize = CGSize(width: view.frame.width, height: 100)
        let estimatedSize = dummyCell.systemLayoutSizeFitting(targetSize)
        let height = estimatedSize.height
        
        return CGSize(width: view.frame.width - 12, height: height)
    }
    
}












