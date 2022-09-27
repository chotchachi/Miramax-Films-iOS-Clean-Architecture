//
//  GenresViewController.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 25/09/2022.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import SwifterSwift

class GenresViewController: BaseViewController<GenresViewModel> {

    // MARK: - Outlets
    
    @IBOutlet weak var appToolbar: AppToolbar!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var errorView: UIView!
    @IBOutlet weak var lblError: UILabel!
    @IBOutlet weak var btnRetry: PrimaryButton!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    private var btnSearch: UIButton!
    
    // MARK: - Properties
    
    private let genreSelectTriggerS = PublishRelay<Genre>()
    
    // MARK: - Lifecycle
    
    override func configView() {
        super.configView()
     
        configureAppToolbar()
        configureCollectionView()
        configureErrorView()
    }
    
    override func bindViewModel() {
        super.bindViewModel()
        
        let input = GenresViewModel.Input(
            toSearchTrigger: btnSearch.rx.tap.asDriver(),
            retryTrigger: btnRetry.rx.tap.asDriver(),
            genreSelectTrigger: genreSelectTriggerS.asDriverOnErrorJustComplete()
        )
        let output = viewModel.transform(input: input)
        
        let genreDataSource = RxCollectionViewSectionedReloadDataSource<SectionModel<String, Genre>> { dataSource, collectionView, indexPath, item in
            let cell = collectionView.dequeueReusableCell(withClass: GenreCell.self, for: indexPath)
            cell.bind(item)
            return cell
        }
        
        output.genres
            .map { [SectionModel(model: "", items: $0)] }
            .drive(collectionView.rx.items(dataSource: genreDataSource))
            .disposed(by: rx.disposeBag)
        
        viewModel.loading
            .drive(onNext: { [weak self] isLoading in
                guard let self = self else { return }
                if isLoading {
                    self.errorView.isHidden = true
                    self.loadingIndicator.startAnimating()
                } else {
                    self.loadingIndicator.stopAnimating()
                }
            })
            .disposed(by: rx.disposeBag)
        
        viewModel.error
            .drive(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.errorView.isHidden = false
            })
            .disposed(by: rx.disposeBag)
    }
}

// MARK: - Private functions

extension GenresViewController {
    private func configureAppToolbar() {
        btnSearch = UIButton(type: .system)
        btnSearch.translatesAutoresizingMaskIntoConstraints = false
        btnSearch.setImage(UIImage(named: "ic_toolbar_search"), for: .normal)
        
        appToolbar.title = "movie_genres".localized
        appToolbar.showBackButton = false
        appToolbar.rightButtons = [btnSearch]
    }
    
    private func configureCollectionView() {
        let gridCollectionViewLayout = GridCollectionViewLayout()
        gridCollectionViewLayout.rowSpacing = 16.0
        gridCollectionViewLayout.columnSpacing = 16.0
        gridCollectionViewLayout.delegate = self
        collectionView.collectionViewLayout = gridCollectionViewLayout
        collectionView.contentInset = .init(top: 16.0, left: 16.0, bottom: 16.0, right: 16.0)
        collectionView.register(cellWithClass: GenreCell.self)
        collectionView.rx.modelSelected(Genre.self)
            .bind(to: genreSelectTriggerS)
            .disposed(by: rx.disposeBag)
    }
    
    private func configureErrorView() {
        lblError.text = "an_error_occurred".localized
        lblError.textColor = AppColors.textColorSecondary
        lblError.font = AppFonts.caption1
        
        btnRetry.titleText = "retry".localized
    }
}

// MARK: - GridCollectionViewLayoutDelegate

extension GenresViewController: GridCollectionViewLayoutDelegate {
    func numberOfColumns(_ collectionView: UICollectionView) -> Int {
        3
    }
    
    func collectionView(_ collectionView: UICollectionView, columnSpanForItemAt index: GridIndex, indexPath: IndexPath) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, heightForItemAt index: GridIndex, indexPath: IndexPath) -> CGFloat {
        DimensionConstants.genreCellHeight
    }
    
    func collectionView(_ collectionView: UICollectionView, heightForRow row: Int, inSection section: Int) -> GridCollectionViewLayout.RowHeight {
        .maxItemHeight
    }
    
    func collectionView(_ collectionView: UICollectionView, heightForSupplementaryView kind: GridCollectionViewLayout.ElementKind, at section: Int) -> CGFloat? {
        nil
    }
    
    func collectionView(_ collectionView: UICollectionView, alignmentForSection section: Int) -> GridCollectionViewLayout.Alignment {
        .center
    }
}
