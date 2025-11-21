//
//  MovieDetailsView.swift
//  MovieBrowserApi
//
//  Created by Adrian Inculet on 19.11.2025.
//

import UIKit

protocol MovieDetailsViewDelegate: AnyObject {
    func didTapExitButton()
}

class MovieDetailsView: UIView {
    
    private lazy var mainView = UIView()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.text = "Title"
        label.font = UIFont.systemFont(ofSize: 25, weight: .bold)
        label.numberOfLines = 2
        label.textAlignment = .center
        return label
    }()
    
    private lazy var posterImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(systemName: "person")
        iv.tintColor = .systemYellow
        iv.contentMode = .scaleToFill
        return iv
    }()
    
    private lazy var ratingImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(systemName: "star.fill")
        iv.tintColor = .systemYellow
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    private lazy var ratingLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.text = "10/10"
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        label.numberOfLines = 1
        label.textAlignment = .left
        return label
    }()
    
    private let stackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.spacing = 5
        sv.alignment = .center
        return sv
    }()
    
    private lazy var yearLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.text = "2010"
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        label.numberOfLines = 1
        label.textAlignment = .right
        return label
    }()
    
    lazy var exitButton: UIButton = {
        let button = UIButton()
        let config = UIImage.SymbolConfiguration(pointSize: 25, weight: .semibold)
        button.setImage(UIImage(systemName: "xmark.circle", withConfiguration: config), for: .normal)
        button.tintColor = .label
        button.addTarget(self, action: #selector(exitButtonTapped), for: .touchUpInside)
        return button
    }()
    
    weak var delegate: MovieDetailsViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        mainView.layer.cornerRadius = 8
    }
    
    @objc func exitButtonTapped() {
        delegate?.didTapExitButton()
    }
    
    private func setupLayout() {
        addSubview(mainView)
        mainView.backgroundColor = .secondarySystemBackground
        mainView.addSubview(posterImageView)
        mainView.addSubview(exitButton)
        mainView.addSubview(titleLabel)
        stackView.addArrangedSubview(ratingImageView)
        stackView.addArrangedSubview(ratingLabel)
        mainView.addSubview(stackView)
        mainView.addSubview(yearLabel)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        mainView.translatesAutoresizingMaskIntoConstraints = false
        exitButton.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        posterImageView.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        yearLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            mainView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 50),
            mainView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 25),
            mainView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -25),
            mainView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -50),
            
            exitButton.topAnchor.constraint(equalTo: mainView.topAnchor, constant: 10),
            exitButton.trailingAnchor.constraint(equalTo: mainView.trailingAnchor, constant: -10),
            exitButton.heightAnchor.constraint(equalToConstant: 35),
            exitButton.widthAnchor.constraint(equalToConstant: 35),
            
            posterImageView.topAnchor.constraint(equalTo: exitButton.bottomAnchor, constant: 5),
            posterImageView.leadingAnchor.constraint(equalTo: mainView.leadingAnchor),
            posterImageView.trailingAnchor.constraint(equalTo: mainView.trailingAnchor),
            posterImageView.heightAnchor.constraint(equalTo: posterImageView.widthAnchor, multiplier: 4/3),
            posterImageView.heightAnchor.constraint(equalTo: mainView.heightAnchor, multiplier: 0.7),
            
            titleLabel.topAnchor.constraint(equalTo: posterImageView.bottomAnchor, constant: 25),
            titleLabel.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: 15),
            titleLabel.trailingAnchor.constraint(equalTo: mainView.trailingAnchor, constant: -15),
            
            stackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 25),
            stackView.bottomAnchor.constraint(lessThanOrEqualTo: mainView.bottomAnchor, constant: -15),
            stackView.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: 15),
            stackView.trailingAnchor.constraint(equalTo: yearLabel.leadingAnchor, constant: 5),
            
            yearLabel.centerYAnchor.constraint(equalTo: ratingLabel.centerYAnchor),
            yearLabel.trailingAnchor.constraint(equalTo: mainView.trailingAnchor, constant: -15)
        ])
    }
    
    public func configure(with movie: MovieListItem) {
        titleLabel.text = movie.title
        yearLabel.text = String(movie.year)
        ratingLabel.text = "\(movie.rank)"
        
        Task {
            do {
                let image = try await ImageCacheManager.shared.downloadImage(from: movie.posterURL)
                await MainActor.run {
                    posterImageView.image = image
                    mainView.layoutIfNeeded()
                }
               
            }
            catch {
                posterImageView.image = UIImage(systemName: "person")
            }
        }
    }
    
}
