//
//  ShareImagePickerCell.swift
//  EzDrive
//
//  Created by Bryan Lew on 27/6/18.
//  Copyright © 2018 Bryan Lew. All rights reserved.
//

import UIKit

class ShareImagePickerCell: UICollectionViewCell {
    
    let imageCellId = "imageCellId"
        
    var shareViewController: ShareViewController?
    
    var selectedImage: UIImage? {
        didSet {
            imageCollectionView.reloadData()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        imageCollectionView.register(ImageCell.self, forCellWithReuseIdentifier: imageCellId)
        imageCollectionView.delegate = self
        imageCollectionView.dataSource = self
        
        
        setupViews()
    }
    
    let imageCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.alwaysBounceHorizontal = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    let coverPhotoLabel: UILabel = {
        let label = UILabel()
        label.text = "Cover Photo"
        label.backgroundColor = .clear
        label.font = UIFont.systemFont(ofSize: 11)
        label.textAlignment = .center
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    func setupViews() {
        backgroundColor = .clear
        
        addSubview(imageCollectionView)
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": imageCollectionView]))
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": imageCollectionView]))
        
    }
}

extension ShareImagePickerCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: imageCellId, for: indexPath) as! ImageCell
        if indexPath.item == 0 {
            cell.addSubview(coverPhotoLabel)
            coverPhotoLabel.bottomAnchor.constraint(equalTo: cell.bottomAnchor).isActive = true
            coverPhotoLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
            coverPhotoLabel.widthAnchor.constraint(equalTo: cell.widthAnchor).isActive = true
            coverPhotoLabel.centerXAnchor.constraint(equalTo: cell.centerXAnchor).isActive = true
        }
        cell.shareImagePickerCell = self
        cell.selectedImage = self.selectedImage
        return cell
    }
    

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
}

extension ShareImagePickerCell: UICollectionViewDelegate {
}

extension ShareImagePickerCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 106, height: 126)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 14
    }
}

class ImageCell: UICollectionViewCell {
    
    var shareImagePickerCell: ShareImagePickerCell?
    
    var selectedImage: UIImage? {
        didSet {
            if let image = selectedImage {
                print("There was an image selected")
                imagePickerImageView.image = image
            } else {
                print("No image was selected")
                imagePickerImageView.image = #imageLiteral(resourceName: "ezdrive_placeholderimg")
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        setupViews()
    }
    
    let imagePickerImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .white
        imageView.image = #imageLiteral(resourceName: "ezdrive_placeholderimg")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    @objc func handleSelectPhoto() {
        print("Photo selected")
        
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = shareImagePickerCell
        imagePickerController.allowsEditing = true
        shareImagePickerCell?.shareViewController?.navigationController?.present(imagePickerController, animated: true, completion: nil)
    }
    
    func setupViews() {
        addSubview(imagePickerImageView)
        
        imagePickerImageView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        imagePickerImageView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        imagePickerImageView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        imagePickerImageView.heightAnchor.constraint(equalTo: imagePickerImageView.widthAnchor, multiplier: 1.0).isActive = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleSelectPhoto))
        imagePickerImageView.addGestureRecognizer(tapGesture)
        imagePickerImageView.isUserInteractionEnabled = true
    }
    
}

extension ShareImagePickerCell: UINavigationControllerDelegate {
    
}


extension ShareImagePickerCell: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            self.selectedImage = editedImage
            
        } else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            self.selectedImage = originalImage
        }
        
        
        
        shareViewController?.navigationController?.dismiss(animated: true, completion: nil)
    }
}



