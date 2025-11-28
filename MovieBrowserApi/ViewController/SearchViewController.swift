//
//  SearchViewController.swift
//  MovieBrowserApi
//
//  Created by Adrian Inculet on 19.11.2025.
//

import UIKit

final class SearchViewController: UIViewController {

    private let numberOfItemsPerRow: CGFloat = 2
    private let horizontalSpacing: CGFloat = 10.0
    private let sectionInsets = UIEdgeInsets(top: 10.0, left: 0, bottom: 10.0, right: 0)
    private var photoCollectionView: PhotoCollectionView!
    private let movieDetailsView = MovieDetailsView()
    private var movies: [MovieListItem] = []
    private var searchTask: Task<Void, Never>?
    
    private lazy var searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Search"
        view.backgroundColor = .systemBackground
        initCollectionView()
        setupUI()
        setupSearchController()
    }
    
    private func setupSearchController() {
        navigationItem.searchController = searchController
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Look for a different movie..."
        searchController.searchBar.tintColor = .label
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true
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

extension SearchViewController: UICollectionViewDataSource, UICollectionViewDelegate {
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
        searchController.searchBar.resignFirstResponder()
        presentMoviePopup(movieDetailsView: movieDetailsView) {
            movieDetailsView.delegate = self
            movieDetailsView.configure(with: selectedMovie)
        }
    }
    
}

extension SearchViewController: UICollectionViewDelegateFlowLayout {
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

extension SearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        searchTask?.cancel()
        guard let searchText = searchController.searchBar.text else {
            return
        }
        searchTask = Task {
            do {
                try await Task.sleep(for: .seconds(0.5))
                if !Task.isCancelled {
                    fetchSearchResults(searchTerm: searchText)
                }
            }
            catch {
                print(error.localizedDescription)
            }
        }
        if !isFiltering {
            movies = []
            photoCollectionView.reloadData()
        }
    }
    
    private func fetchSearchResults(searchTerm: String) {
        Task {
            do {
                let result = try await ApiService.shared.fetchMovies(searchTerm: searchTerm)
                self.movies = result.description
                self.photoCollectionView.reloadData()
            }
            catch {
                print(error.localizedDescription)
            }
        }
    }
}

extension SearchViewController {
    var isFiltering: Bool {
        return searchController.isActive && !(searchController.searchBar.text?.isEmpty ?? true)
    }
}

extension SearchViewController: MovieDetailsViewDelegate {
    func didTapExitButton() {
        self.dismissMoviePopup(movieDetailsView: movieDetailsView)
    }
}
