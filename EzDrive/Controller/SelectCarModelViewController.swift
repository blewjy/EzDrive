//
//  SelectCarModelViewController.swift
//  EzDrive
//
//  Created by Bryan Lew on 16/7/18.
//  Copyright © 2018 Bryan Lew. All rights reserved.
//

import UIKit

class SelectCarModelViewController: UICollectionViewController {
    
    let cellId = "cellId"
    
    static let carLabels = ["Nissan", "Toyota", "Hyundai", "Honda", "BMW", "Mercedes", "Audi", "Porsche", ""]
    
    var shareViewController: ShareViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Select Car Model"
        
        collectionView?.backgroundColor = UIColor.rgb(r: 232, g: 236, b: 241)
        collectionView?.register(UICollectionViewCell.self, forCellWithReuseIdentifier: cellId)
        
        setupViews()
    }
    
    
    let selectButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Select", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor.rgb(r: 29, g: 161, b: 242)
        button.layer.cornerRadius = 25.0
        button.clipsToBounds = true
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.addTarget(self, action: #selector(handleSelect), for: .touchUpInside)
        return button
    }()
    
    @objc func handleSelect() {
        print("Select")
        self.shareViewController?.selectedModel = self.selectedModel
        self.navigationController?.popViewController(animated: true)
    }
    
    func setupViews() {
        view.addSubview(selectButton)
        
        
        
        selectButton.anchor(top: nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 16, paddingBottom: 16 + (tabBarController?.tabBar.frame.height)!, paddingRight: 16, width: 0, height: 50)
    }
    
    
    func selectCell(indexPath: IndexPath) {
        let cell = collectionView?.cellForItem(at: indexPath)
        cell?.backgroundColor = .lightGray
    }
    
    func deselectCell(indexPath: IndexPath) {
        let cell = collectionView?.cellForItem(at: indexPath)
        cell?.backgroundColor = .white
    }
    
    var selectedModel = 8
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if selectedModel != 8 {
            let selectedIndexPath = IndexPath(item: selectedModel, section: 0)
            selectCell(indexPath: selectedIndexPath)
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath)
        
        let prevSelection = selectedModel
        
        if prevSelection == 8 {
            selectCell(indexPath: indexPath)
            selectedModel = indexPath.item
        } else {
            let previousIndexPath = IndexPath(item: prevSelection, section: 0)
            deselectCell(indexPath: previousIndexPath)
            selectedModel = 8
            if previousIndexPath != indexPath {
                selectCell(indexPath: indexPath)
                selectedModel = indexPath.item
            }
        }
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return SelectCarModelViewController.carLabels.count - 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath)
        cell.backgroundColor = .white
        
        let label = UILabel()
        label.text = SelectCarModelViewController.carLabels[indexPath.item]
        label.font = UIFont.systemFont(ofSize: 14)
        
        cell.addSubview(label)
        label.anchor(top: cell.topAnchor, left: cell.leftAnchor, bottom: cell.bottomAnchor, right: cell.rightAnchor, paddingTop: 0, paddingLeft: 12, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        return cell
    }
    
}

extension SelectCarModelViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 40)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    
}
