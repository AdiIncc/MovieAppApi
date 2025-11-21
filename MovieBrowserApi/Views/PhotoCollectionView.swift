//
//  PhotoCollectionViewController.swift
//  MovieBrowserApi
//
//  Created by Adrian Inculet on 19.11.2025.
//

import UIKit

final class PhotoCollectionView: UICollectionView {
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
            super.init(frame: frame, collectionViewLayout: layout)
            commonInit()
        }
    
    convenience init(collectionViewLayout layout: UICollectionViewLayout) {
        self.init(frame: .zero, collectionViewLayout: layout)
        commonInit()
    }
    
    private func commonInit() {
            self.register(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: PhotoCollectionViewCell.reuseIdentifier)
            self.backgroundColor = .systemBackground
        }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
