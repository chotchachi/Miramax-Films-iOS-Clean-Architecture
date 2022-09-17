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
    
    private var sectionHeaderView: SectionHeaderView!
    private var movieCollectionView: UICollectionView!
    private var loadingIndicatorView: UIActivityIndicatorView!
    private var btnRetry: PrimaryButton!
    
    // MARK: - Properties
    
    public weak var delegate: MovieHorizontalListDelegate?
    private var movieItems: [Movie] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .clear
        
        // section header view
        
        sectionHeaderView = SectionHeaderView()
        sectionHeaderView.translatesAutoresizingMaskIntoConstraints = false
        sectionHeaderView.delegate = self
        
        // collection view
        
        let collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.scrollDirection = .horizontal
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
        
        btnRetry = PrimaryButton()
        btnRetry.titleText = "Retry"
        btnRetry.addTarget(self, action: #selector(btnRetryTapped), for: .touchUpInside)
        
        // constraint layout
        
        contentView.addSubview(sectionHeaderView)
        sectionHeaderView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.equalTo(24.0)
        }
        
        contentView.addSubview(movieCollectionView)
        movieCollectionView.snp.makeConstraints { make in
            make.top.equalTo(sectionHeaderView.snp.bottom).offset(12.0)
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
    
    func bind(_ viewState: ViewState<Movie>, headerTitle: String) {
        sectionHeaderView.setHeaderTitle(headerTitle)
        
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
        return movieItems.count
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

// MARK: - UICollectionViewDelegateFlowLayout

extension MovieHorizontalListCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemHeight = collectionView.frame.height
        let itemWidth = itemHeight * Constants.posterRatio
        return .init(width: itemWidth, height: itemHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 0, left: 16.0, bottom: 0.0, right: 16.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 4.0
    }
}

// MARK: - SectionHeaderViewDelegate

extension MovieHorizontalListCell: SectionHeaderViewDelegate {
    func sectionHeaderView(onSeeMoreButtonTapped button: UIButton) {
        delegate?.movieHorizontalListSeeMoreButtonTapped()
    }
}
