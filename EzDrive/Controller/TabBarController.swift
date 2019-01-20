//
//  TabBarController.swift
//  EzDrive
//
//  Created by Bryan Lew on 23/6/0.
//  Copyright © 00 Bryan Lew. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class TabBarController: UITabBarController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let browseViewController = BrowseViewController()
        let browseNavController = UINavigationController(rootViewController: browseViewController)
        browseViewController.title = "Browse"
        browseNavController.tabBarItem.image = #imageLiteral(resourceName: "ezdrive_browse")
        browseNavController.tabBarItem.imageInsets = UIEdgeInsets(top: 2, left: 0, bottom: -2, right: 0)
        
        let searchViewController = SearchViewController(collectionViewLayout: UICollectionViewFlowLayout())
        let searchNavController = UINavigationController(rootViewController: searchViewController)
        searchNavController.title = "Search"
        searchNavController.tabBarItem.image = #imageLiteral(resourceName: "ezdrive_search")
        searchNavController.tabBarItem.imageInsets = UIEdgeInsets(top: 2, left: 0, bottom: -2, right: 0)

        
        let shareViewController = ShareViewController(collectionViewLayout: UICollectionViewFlowLayout())
        let shareNavController = UINavigationController(rootViewController: shareViewController)
        shareViewController.title = "Share"
        shareNavController.tabBarItem.image = #imageLiteral(resourceName: "ezdrive_share")
        shareNavController.tabBarItem.imageInsets = UIEdgeInsets(top: 2, left: 0, bottom: -2, right: 0)
        
        
        let inboxViewController = InboxViewController(collectionViewLayout: UICollectionViewFlowLayout())
        let inboxNavController = UINavigationController(rootViewController: inboxViewController)
        inboxViewController.title = "Inbox"
        inboxNavController.tabBarItem.image = #imageLiteral(resourceName: "ezdrive_inbox")
        inboxNavController.tabBarItem.imageInsets = UIEdgeInsets(top: 2, left: 0, bottom: -2, right: 0)

        
        
        
        
        let profileCollectionViewLayout = UICollectionViewFlowLayout()
        profileCollectionViewLayout.scrollDirection = .horizontal
        
        let profileViewController = ProfileViewController(collectionViewLayout: profileCollectionViewLayout)
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        profileViewController.currentUserUid = uid
        let profileNavController = UINavigationController(rootViewController: profileViewController)
        profileNavController.title = "Profile"
        profileNavController.tabBarItem.image = #imageLiteral(resourceName: "ezdrive_profile")
        profileNavController.tabBarItem.imageInsets = UIEdgeInsets(top: 2, left: 0, bottom: -2, right: 0)
        
        viewControllers = [browseNavController, searchNavController, shareNavController, inboxNavController, profileNavController]
        
    }
}
