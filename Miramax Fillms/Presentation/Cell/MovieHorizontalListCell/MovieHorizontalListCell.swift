//
//  MovieHorizontalListCell.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 15/09/2022.
//

import UIKit
import SnapKit
import SwifterSwift

class MovieHorizontalListCell: UICollectionViewCell {
    
    // MARK: - Views
    
    private var movieCollectionView: UICollectionView!
    private var loadingIndicatorView: UIActivityIndicatorView!
    private var btnRetry: UIButton!
    
    // MARK: - Properties
    
    public weak var delegate: MovieHorizontalListDelegate?
    private var movieItems: [Movie] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .clear
        
        // collection view
        
        let collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.scrollDirection = .horizontal
        collectionViewLayout.itemSize = .init(width: 96.0, height: 48.0)
        collectionViewLayout.sectionInset = .init(top: 1.0, left: 16.0, bottom: 1.0, right: 16.0)
        collectionViewLayout.minimumLineSpacing = 12.0
        movieCollectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        movieCollectionView.translatesAutoresizingMaskIntoConstraints = false
        movieCollectionView.backgroundColor = .clear
        movieCollectionView.register(cellWithClass: MovieHorizontalCell.self)
        movieCollectionView.dataSource = self
        movieCollectionView.delegate = self
        movieCollectionView.showsHorizontalScrollIndicator = false
        
        // loading indicator
        
        loadingIndicatorView = UIActivityIndicatorView(style: .white)
        loadingIndicatorView.hidesWhenStopped = true
        loadingIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        
        // retry button
        
        btnRetry = UIButton(type: .system)
        btnRetry.setTitle("Retry", for: .normal)
        btnRetry.addTarget(self, action: #selector(btnRetryTapped), for: .touchUpInside)
        
        // constraint layout
        
        contentView.addSubview(movieCollectionView)
        movieCollectionView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.trailing.equalToSuperview()
            make.leading.equalToSuperview()
        }
        
        contentView.addSubview(loadingIndicatorView)
        loadingIndicatorView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.trailing.equalToSuperview()
            make.leading.equalToSuperview()
        }
        
        contentView.addSubview(btnRetry)
        btnRetry.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.trailing.equalToSuperview()
            make.leading.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(_ viewState: ViewState<Movie>) {
        switch viewState {
        case .initial:
            loadingIndicatorView.startAnimating()
            movieCollectionView.isHidden = true
            btnRetry.isHidden = true
        case .paging:
            break
        case .populated(let array):
            loadingIndicatorView.stopAnimating()
            movieCollectionView.isHidden = false
            btnRetry.isHidden = true
            // set data
            movieItems = array
            movieCollectionView.reloadData()
        case .empty:
            break
        case .error:
            loadingIndicatorView.stopAnimating()
            movieCollectionView.isHidden = true
            btnRetry.isHidden = false
        }
    }
    
    @objc private func btnRetryTapped() {
        loadingIndicatorView.startAnimating()
        movieCollectionView.isHidden = true
        btnRetry.isHidden = true
        delegate?.movieHorizontalListRetryButtonTapped()
    }
}

// MARK: - UICollectionViewDataSource

extension MovieHorizontalListCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        movieItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let movie = movieItems[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withClass: MovieHorizontalCell.self, for: indexPath)
        cell.bind(movie)
        return cell
    }
    
}

// MARK: - UICollectionViewDelegate

extension MovieHorizontalListCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let movie = movieItems[indexPath.row]
        delegate?.movieHorizontalList(onItemTapped: movie)
    }
    
}
