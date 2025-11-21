//
//  SettingsViewController.swift
//  MovieBrowserApi
//
//  Created by Adrian Inculet on 19.11.2025.
//

import UIKit

class SettingsViewController: UIViewController {
    
    private lazy var themeSegment: UISegmentedControl = {
        let sc = UISegmentedControl(items: [
            AppTheme.system.iconImage!,
            AppTheme.light.iconImage!,
            AppTheme.dark.iconImage!
        ])
        sc.translatesAutoresizingMaskIntoConstraints = false
        return sc
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupUI()
        loadSelectedTheme()
    }
    
    private func setupUI() {
        view.addSubview(themeSegment)
        
        NSLayoutConstraint.activate([
            themeSegment.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            themeSegment.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            themeSegment.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            themeSegment.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25)
        ])
        themeSegment.addTarget(self, action: #selector(themeChanged), for: .valueChanged)
    }
    
    private func loadSelectedTheme() {
        let saved = ThemeManager.shared.loadTheme()
        
        switch saved {
        case .system: themeSegment.selectedSegmentIndex = 0
        case .light:  themeSegment.selectedSegmentIndex = 1
        case .dark:   themeSegment.selectedSegmentIndex = 2
        }
    }
    
    @objc private func themeChanged() {
        let selected: AppTheme
        
        switch themeSegment.selectedSegmentIndex {
        case 0: selected = .system
        case 1: selected = .light
        case 2: selected = .dark
        default: selected = .system
        }
        ThemeManager.shared.saveTheme(selected)
        applyTheme(selected)
    }
    
    private func applyTheme(_ theme: AppTheme) {
        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = scene.windows.first {
            window.overrideUserInterfaceStyle = theme.userInterfaceStyle
        }
    }
}
