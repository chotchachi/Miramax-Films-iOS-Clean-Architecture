//
//  GenreHorizontalListCell.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 15/09/2022.
//

import UIKit
import SnapKit
import SwifterSwift

class GenreHorizontalListCell: UICollectionViewCell {
    
    // MARK: - Views
    
    private var genreCollectionView: UICollectionView!
    private var loadingIndicatorView: UIActivityIndicatorView!
    private var btnRetry: PrimaryButton!
    
    // MARK: - Properties
    
    public weak var delegate: GenreHorizontalListCellDelegate?
    private var genreItems: [Genre] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .clear
        
        // collection view
        
        let collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.scrollDirection = .horizontal
        collectionViewLayout.itemSize = .init(width: 96.0, height: 48.0)
        collectionViewLayout.sectionInset = .init(top: 1.0, left: 16.0, bottom: 1.0, right: 16.0)
        collectionViewLayout.minimumLineSpacing = 12.0
        genreCollectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        genreCollectionView.translatesAutoresizingMaskIntoConstraints = false
        genreCollectionView.backgroundColor = .clear
        genreCollectionView.register(cellWithClass: GenreCell.self)
        genreCollectionView.dataSource = self
        genreCollectionView.delegate = self
        genreCollectionView.showsHorizontalScrollIndicator = false
        
        // loading indicator
        
        loadingIndicatorView = UIActivityIndicatorView(style: .white)
        loadingIndicatorView.hidesWhenStopped = true
        loadingIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        
        // retry button
        
        btnRetry = PrimaryButton()
        btnRetry.titleText = "Retry"
        btnRetry.addTarget(self, action: #selector(btnRetryTapped), for: .touchUpInside)
        
        // constraint layout
        
        contentView.addSubview(genreCollectionView)
        genreCollectionView.snp.makeConstraints { make in
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
    
    func bind(_ viewState: ViewState<Genre>) {
        switch viewState {
        case .initial:
            loadingIndicatorView.startAnimating()
            genreCollectionView.isHidden = true
            btnRetry.isHidden = true
        case .paging:
            break
        case .populated(let array):
            loadingIndicatorView.stopAnimating()
            genreCollectionView.isHidden = false
            btnRetry.isHidden = true
            // set data
            genreItems = array
            genreCollectionView.reloadData()
        case .empty:
            break
        case .error:
            loadingIndicatorView.stopAnimating()
            genreCollectionView.isHidden = true
            btnRetry.isHidden = false
        }
    }
    
    @objc private func btnRetryTapped() {
        loadingIndicatorView.startAnimating()
        genreCollectionView.isHidden = true
        btnRetry.isHidden = true
        delegate?.genreHorizontalListRetryButtonTapped()
    }
}

// MARK: - UICollectionViewDataSource

extension GenreHorizontalListCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        genreItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let genre = genreItems[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withClass: GenreCell.self, for: indexPath)
        cell.bind(genre)
        return cell
    }
    
}

// MARK: - UICollectionViewDelegate

extension GenreHorizontalListCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let genre = genreItems[indexPath.row]
        delegate?.genreHorizontalList(onItemTapped: genre)
    }
    
}
