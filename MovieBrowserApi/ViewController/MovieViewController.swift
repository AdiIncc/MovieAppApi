//
//  ViewController.swift
//  MovieBrowserApi
//
//  Created by Adrian Inculet on 18.11.2025.
//

//https://imdb.iamidiotareyoutoo.com/search?q=Spiderman

import UIKit

class MovieViewController: UIViewController {
    private let numberOfItemsPerRow: CGFloat = 2
    private let horizontalSpacing: CGFloat = 10.0
    private let sectionInsets = UIEdgeInsets(top: 10.0, left: 0, bottom: 10.0, right: 0)
    private var photoCollectionView: PhotoCollectionView!
    
    private let movieDetailsView = MovieDetailsView()
    
    private var movies: [MovieListItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Movies"
        view.backgroundColor = .systemBackground
        initCollectionView()
        setupUI()
        fetchData()
    }
    
    private func fetchData() {
        Task {
            do {
                let response = try await ApiService.shared.fetchMovies(searchTerm: "SpiderMan")
                self.movies = response.description
                self.photoCollectionView.reloadData()
            }
            catch {
                print(error.localizedDescription)
            }
        }
    }
    
    private func initCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        photoCollectionView = PhotoCollectionView(frame: .zero, collectionViewLayout: layout)
    }
    
    private func setupUI() {
        view.addSubview(photoCollectionView)
        
        photoCollectionView.delegate = self
        photoCollectionView.dataSource = self
        
        photoCollectionView.translatesAutoresizingMaskIntoConstraints = false
      
        photoCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        photoCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        photoCollectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        photoCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
}
// MARK: UICollectionViewDataSource
extension MovieViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCollectionViewCell.reuseIdentifier, for: indexPath) as? PhotoCollectionViewCell else {
            return UICollectionViewCell()
        }
        let newIndex = movies[indexPath.row]
        cell.configure(with: newIndex)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedMovie = movies[indexPath.row]
        presentMoviePopup(movieDetailsView: movieDetailsView) {
            movieDetailsView.delegate = self
            movieDetailsView.configure(with: selectedMovie)
        }
    }
}

extension MovieViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let totalWidth = collectionView.bounds.width
        let totalSpacing = horizontalSpacing * (numberOfItemsPerRow - 1)
        let totalInsets = sectionInsets.left + sectionInsets.right
        let cellWidth = (totalWidth - totalSpacing - totalInsets) / numberOfItemsPerRow
        let cellHeight = cellWidth * CGFloat(1.5)
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return horizontalSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return horizontalSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
   
}

extension MovieViewController: MovieDetailsViewDelegate {
    func didTapExitButton() {
        self.dismissMoviePopup(movieDetailsView: movieDetailsView)
    }
    
    
}




