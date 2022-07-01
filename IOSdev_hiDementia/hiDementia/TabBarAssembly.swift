//
//  ViewController.swift
//  hiDementia
//
//  Created by xcode on 27.11.2021.
//

import UIKit

class TestViewController : UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
    }
}

enum MainTabBarAssembly {
     static func assembly() -> UITabBarController {
         // Main table
         let pillListVC = PillListAssembly.assembly()
         pillListVC.title = "Home"
         let pillListItem = UITabBarItem()
         pillListItem.title = "Home"
         pillListItem.image = UIImage(systemName: "house")
         let pillListNavVC = UINavigationController(rootViewController: pillListVC)
         pillListNavVC.tabBarItem = pillListItem
         // Map
         let mapVC = MapViewController()
         mapVC.title = "Map"
         let mapListItem = UITabBarItem()
         mapListItem.title = "Map"
         mapListItem.image = UIImage(systemName: "map")
         mapVC.tabBarItem = mapListItem
         // Settings
         let settingsVC = SettingsViewController()
         settingsVC.title = "Settings"
         let settingsItem = UITabBarItem()
         settingsItem.title = "Settings"
         settingsItem.image = UIImage(systemName: "gearshape")
         settingsVC.tabBarItem = settingsItem
         // Tab Bar controller
         let tabBarController = UITabBarController()
         tabBarController.viewControllers = [pillListNavVC, mapVC, settingsVC]
         tabBarController.selectedIndex = 0
         
         if #available(iOS 15.0, *) {
             let appearance = UITabBarAppearance()
             appearance.configureWithOpaqueBackground()
             appearance.backgroundColor = .systemBackground
             tabBarController.tabBar.standardAppearance = appearance
             tabBarController.tabBar.scrollEdgeAppearance = appearance
         }
         
         return tabBarController
     }
 }
