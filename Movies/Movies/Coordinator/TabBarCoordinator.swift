//
//  TabBarCoordinator.swift
//  Movies
//
//  Created by Olga Sabadina on 05.01.2024.
//

import UIKit

enum TabBarPage {
    case home
    case search
    case create
    case profile
    
    init?(index: Int) {
        switch index {
        case 0:
            self = .home
        case 1:
            self = .search
        case 2:
            self = .create
        case 3:
            self = .profile
        default:
            return nil
        }
    }
    
    var title: String {
        switch self {
        case .home:
            return "Home"
        case .search:
            return "Search"
        case .create:
            return "Create"
        case .profile:
            return "Profile"
        }
    }
    
    func pageOrderNumber() -> Int {
        switch self {
        case .home:
            return 0
        case .search:
            return 1
        case .create:
            return 2
        case .profile:
            return 3
        }
    }
    
    var icons: UIImage? {
        switch self {
        case .home:
            return ImageConstants.home
        case .search:
            return ImageConstants.search
        case .create:
            return ImageConstants.create
        case .profile:
            return .getPersonImage()?.prepareImageToTabBar()
        }
    }
}

class TabCoordinator: BaseCoordinator {
    
    weak var appCoordinator: AppCoordinator?
    
    var tabBarController = UITabBarController()
    
    override func start() {
        let pages: [TabBarPage] = [.home, .search, .create, .profile]
            .sorted(by: { $0.pageOrderNumber() < $1.pageOrderNumber() })
        
        let controllers: [UINavigationController] = pages.map({ getTabController($0) })
        
        prepareTabBarController(withTabControllers: controllers)
    }
    
    private func prepareTabBarController(withTabControllers tabControllers: [UIViewController]) {
        
        tabBarController.setViewControllers(tabControllers, animated: true)
        
        tabBarController.selectedIndex = TabBarPage.home.pageOrderNumber()
        
        tabBarController.tabBar.isTranslucent = true
        tabBarController.tabBar.backgroundColor = .secondarySystemBackground
        tabBarController.tabBar.tintColor = ColorConstans.selectedTabBar
        tabBarController.tabBar.unselectedItemTintColor = ColorConstans.tintTabBar
       
        navigationController.pushViewController(tabBarController, animated: true)
    }
    
    private func getTabController(_ page: TabBarPage) -> UINavigationController {
        let navController = UINavigationController()
        navController.setNavigationBarHidden(false, animated: false)
        
        navController.tabBarItem = UITabBarItem.init(title: page.title,
                                                     image: page.icons,
                                                     tag: page.pageOrderNumber())
        
        switch page {
        case .home:
            let homeVC = HomeViewController()
            homeVC.didSendEventClosure = { [weak self] event in
                switch event {
                case .home:
                    self?.selectPage(.search)
                default: break
                }
            }
            navController.pushViewController(homeVC, animated: true)
            
        case .search:
            let searchVC = SearchViewController()
            searchVC.title = page.title
            navController.pushViewController(searchVC, animated: true)
            
        case .create:
            let createVC = CreateViewController()
            createVC.didSendEventClosure = { [weak self] event in
                switch event {
                case .profile:
                    self?.finish()
                default: break
                }
            }
            createVC.title = page.title
            navController.pushViewController(createVC, animated: true)
            
        case .profile:
            let profileVC = ProfileViewController()
            navController.pushViewController(profileVC, animated: true)
        }
        return navController
    }
    
    func currentPage() -> TabBarPage? {
        TabBarPage.init(index: tabBarController.selectedIndex)
    }
    
    func selectPage(_ page: TabBarPage) {
        tabBarController.selectedIndex = page.pageOrderNumber()
    }
    
    func setSelectedIndex(_ index: Int) {
        guard let page = TabBarPage.init(index: index) else { return }
        tabBarController.selectedIndex = page.pageOrderNumber()
    }
}
