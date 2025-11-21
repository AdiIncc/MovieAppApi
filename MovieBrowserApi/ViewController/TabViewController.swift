//
//  TabViewController.swift
//  MovieBrowserApi
//
//  Created by Adrian Inculet on 19.11.2025.
//

import UIKit

final class TabViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBarController()
        setupNavigationBarAppearance()
        setupTabBarAppearance()
    }
    
    private func setupTabBarController() {
        let vc1 = UINavigationController(rootViewController: MovieViewController())
        vc1.tabBarItem = UITabBarItem(title: "Movies", image: UIImage(systemName: "film"),selectedImage: UIImage(systemName: "film.fill"))
        let vc2 = UINavigationController(rootViewController: SearchViewController())
        vc2.tabBarItem = UITabBarItem(title: "Search", image: UIImage(systemName: "magnifyingglass"), selectedImage: UIImage(systemName: "magnifyingglass.circle.fill"))
        let vc3 = UINavigationController(rootViewController: SettingsViewController())
        vc3.tabBarItem = UITabBarItem(title: "Settings", image: UIImage(systemName: "gearshape"), selectedImage: UIImage(systemName: "gearshape.fill"))
        viewControllers = [vc1, vc2, vc3]
    }
    
    private func setupNavigationBarAppearance() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithDefaultBackground()
        appearance.titleTextAttributes = [.foregroundColor: UIColor.label, .font: UIFont.systemFont(ofSize: 25, weight: .bold)]
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
    }
    
    private func setupTabBarAppearance() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .secondarySystemBackground
        let normalColor = UIColor(red: 0.75, green: 0.65, blue: 0.40, alpha: 0.6)
        appearance.stackedLayoutAppearance.normal.iconColor = normalColor
        let selectedColor = UIColor(red: 1, green: 0.55, blue: 0.00, alpha: 1.0)
        appearance.stackedLayoutAppearance.selected.iconColor = selectedColor
        let goldColorNormal = UIColor(red: 1.0, green: 0.843, blue: 0, alpha: 0.6)
        let goldColorSelected = UIColor(red: 1.0, green: 0.843, blue: 0, alpha: 1.0)
        let textFont = UIFont.systemFont(ofSize: 15, weight: .bold)
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [.font: textFont, .foregroundColor: goldColorNormal]
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [.font: textFont, .foregroundColor: goldColorSelected]
        tabBar.tintColor = goldColorSelected
        tabBar.unselectedItemTintColor = goldColorNormal
        tabBar.standardAppearance = appearance
        tabBar.scrollEdgeAppearance = appearance
    }
    
}
