//
//  ThemeModel.swift
//  MovieBrowserApi
//
//  Created by Adrian Inculet on 20.11.2025.
//

import Foundation
import UIKit

enum AppTheme: String, Equatable {
    case system = "system"
    case light = "light"
    case dark = "dark"
    
    var userInterfaceStyle: UIUserInterfaceStyle {
        switch self {
        case .system :
            return .unspecified
        case .light :
            return .light
        case .dark :
            return .dark
        }
    }
    
    var iconImage: UIImage? {
        switch self {
        case .system :
            return UIImage(systemName: "circle.lefthalf.filled")
        case .light :
            return UIImage(systemName: "sun.max")
        case .dark :
            return UIImage(systemName: "moon.fill")
        }
    }
}
