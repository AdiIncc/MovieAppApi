//
//  PhotoCollectionViewCell.swift
//  MovieBrowserApi
//
//  Created by Adrian Inculet on 19.11.2025.
//

import UIKit
import SDWebImage

final class PhotoCollectionViewCell: UICollectionViewCell {
    
    static let reuseIdentifier = "movieCell"
    
    lazy var cellBackgroundView = UIView()
    lazy var posterImageView = UIImageView()
    lazy var movieTitle: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        label.textColor = .label
        label.numberOfLines = 2
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(cellBackgroundView)
        cellBackgroundView.addSubview(posterImageView)
        cellBackgroundView.addSubview(movieTitle)
        setupUI()
    }
    
    override func layoutSubviews() {
        cellBackgroundView.layer.cornerRadius = 8
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        posterImageView.image = nil
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        cellBackgroundView.backgroundColor = .secondarySystemBackground
        cellBackgroundView.clipsToBounds = true
        
        posterImageView.clipsToBounds = true
        posterImageView.contentMode = .scaleToFill
        
        cellBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        posterImageView.translatesAutoresizingMaskIntoConstraints = false
        movieTitle.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            cellBackgroundView.topAnchor.constraint(equalTo: contentView.topAnchor),
            cellBackgroundView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            cellBackgroundView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            cellBackgroundView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            posterImageView.topAnchor.constraint(equalTo: cellBackgroundView.topAnchor),
            posterImageView.leadingAnchor.constraint(equalTo: cellBackgroundView.leadingAnchor),
            posterImageView.trailingAnchor.constraint(equalTo: cellBackgroundView.trailingAnchor),
            posterImageView.heightAnchor.constraint(equalTo: cellBackgroundView.heightAnchor, multiplier: 0.8),
            
            movieTitle.topAnchor.constraint(equalTo: posterImageView.bottomAnchor, constant: 15),
            movieTitle.leadingAnchor.constraint(equalTo: posterImageView.leadingAnchor, constant: 2),
            movieTitle.trailingAnchor.constraint(equalTo: posterImageView.trailingAnchor, constant: 2)
        ])
    }
    
    
    func configure(with movies: MovieListItem) {
        movieTitle.text = movies.title
        guard let url = URL(string: movies.posterURL) else {
            posterImageView.image = UIImage(systemName: "photo.fill")
            return
        }
        posterImageView.sd_setImage(with: url, placeholderImage: UIImage(systemName: "photo.fill")?.withTintColor(.secondarySystemBackground, renderingMode: .alwaysOriginal), options: [.highPriority, .scaleDownLargeImages]) { [weak self] image, error, cacheType, url in
            guard let self = self else { return }
            if let error = error {
                print(error.localizedDescription)
                self.posterImageView.image = UIImage(systemName: "xmark.octagon.fill")
            }
        }
        posterImageView.sd_imageTransition = .fade(duration: 0.35)
    }
}
