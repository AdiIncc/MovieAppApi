//
//  Extention+ViewController.swift
//  MovieBrowserApi
//
//  Created by Adrian Inculet on 21.11.2025.
//

import Foundation
import UIKit

extension UIViewController {
    func presentMoviePopup(movieDetailsView: UIView, configurationHandler: () -> Void) {
        movieDetailsView.frame = self.view.bounds
        movieDetailsView.alpha = 0.0
        movieDetailsView.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        self.view.addSubview(movieDetailsView)
        configurationHandler()
        
        UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.2, options: [.curveEaseOut]) {
            movieDetailsView.alpha = 1.0
            movieDetailsView.transform = .identity
        }
    }
    
    func dismissMoviePopup(movieDetailsView: UIView, completion: (() -> Void)? = nil) {
        UIView.animate(withDuration: 0.4, animations: {
            movieDetailsView.alpha = 0.0
            movieDetailsView.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        }) { _ in
            movieDetailsView.removeFromSuperview()
            movieDetailsView.transform = .identity
            completion?()
        }
    }
}
