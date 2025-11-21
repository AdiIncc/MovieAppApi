//
//  SettingsUserDefaults.swift
//  MovieBrowserApi
//
//  Created by Adrian Inculet on 20.11.2025.
//

import Foundation
import UIKit

final class ThemeManager {
    static let shared = ThemeManager()
    private let key = "selectedTheme"

    private init() {}

    func saveTheme(_ theme: AppTheme) {
        UserDefaults.standard.set(theme.rawValue, forKey: key)
    }

    func loadTheme() -> AppTheme {
        let value = UserDefaults.standard.string(forKey: key)
        return AppTheme(rawValue: value ?? "") ?? .system
    }
}
