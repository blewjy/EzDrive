//
//  LocationViewController.swift
//  EzDrive
//
//  Created by Bryan Lew on 16/7/18.
//  Copyright © 2018 Bryan Lew. All rights reserved.
//

import UIKit

class LocationViewController: UICollectionViewController {
    
    let cellId = "cellId"
    
    static let locations = ["Singapore (All)", "North", "South", "East", "West", "Central"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.backgroundColor = UIColor.rgb(r: 232, g: 236, b: 241)
        collectionView?.register(UICollectionViewCell.self, forCellWithReuseIdentifier: cellId)
        
        
        setupNavBarItems()
        setupViews()
    }
    
    var browseViewController: BrowseViewController?
    
    var selectedLocation = 0
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        selectCell(indexPath: IndexPath(item: selectedLocation, section: 0))
    }
    
    func selectCell(indexPath: IndexPath) {
        let cell = collectionView?.cellForItem(at: indexPath)
        cell?.backgroundColor = .lightGray
    }
    
    func deselectCell(indexPath: IndexPath) {
        let cell = collectionView?.cellForItem(at: indexPath)
        cell?.backgroundColor = .white
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let prevSelection = IndexPath(item: self.selectedLocation, section: 0)
        deselectCell(indexPath: prevSelection)
        selectCell(indexPath: indexPath)
        self.selectedLocation = indexPath.item
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return LocationViewController.locations.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath)
        cell.backgroundColor = .white
        
        let label = UILabel()
        label.text = LocationViewController.locations[indexPath.item]
        label.font = UIFont.systemFont(ofSize: 14)
        
        cell.addSubview(label)
        label.anchor(top: cell.topAnchor, left: cell.leftAnchor, bottom: cell.bottomAnchor, right: cell.rightAnchor, paddingTop: 0, paddingLeft: 12, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        return cell
    }
    
    
    lazy var cancelButton: UIBarButtonItem = {
        let barButton = UIBarButtonItem(image: #imageLiteral(resourceName: "ezdrive_clearpost"), style: .plain, target: self, action: #selector(handleCancel))
        return barButton
    }()
    
    @objc func handleCancel() {
        print("Dismiss")
        self.dismiss(animated: true, completion: nil)
    }
    
    lazy var resetButton: UIBarButtonItem = {
        let barButton = UIBarButtonItem(title: "Reset", style: .plain, target: self, action: #selector(handleReset))
        return barButton
    }()
    
    @objc func handleReset() {
        print("Reset")
        
        // Deselect all rows, select first row
        deselectCell(indexPath: IndexPath(item: self.selectedLocation, section: 0))
        selectCell(indexPath: IndexPath(item: 0, section: 0))
        self.selectedLocation = 0
    }
    
    func setupNavBarItems() {
        self.navigationItem.leftBarButtonItem = cancelButton
        self.navigationItem.rightBarButtonItem = resetButton
    }
    
    let applyButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Apply", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor.rgb(r: 29, g: 161, b: 242)
        button.layer.cornerRadius = 25.0
        button.clipsToBounds = true
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.addTarget(self, action: #selector(handleApply), for: .touchUpInside)
        return button
    }()
    
    @objc func handleApply() {
        print("Apply")
        self.browseViewController?.activeLocationFilter = self.selectedLocation
        self.dismiss(animated: true, completion: nil)
    }
    
    func setupViews() {
        view.addSubview(applyButton)
        
        applyButton.anchor(top: nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 16, paddingBottom: 16, paddingRight: 16, width: 0, height: 50)
    }
    
}

extension LocationViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 40)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
}










