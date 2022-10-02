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
import Domain

class GenresViewController: BaseViewController<GenresViewModel>, LoadingDisplayable, ErrorRetryable, Searchable {

    // MARK: - Outlets
    
    @IBOutlet weak var appToolbar: AppToolbar!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var btnSearch: SearchButton = SearchButton()
    var loaderView: LoadingView = LoadingView()
    var errorRetryView: ErrorRetryView = ErrorRetryView()
    
    // MARK: - Properties
    
    private let genreSelectTriggerS = PublishRelay<Genre>()
    
    // MARK: - Lifecycle
    
    override func configView() {
        super.configView()
     
        configureAppToolbar()
        configureCollectionView()
    }
    
    override func bindViewModel() {
        super.bindViewModel()
        
        let input = GenresViewModel.Input(
            toSearchTrigger: btnSearch.rx.tap.asDriver(),
            retryTrigger: errorRetryView.rx.retryTapped.asDriver(),
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
                isLoading ? self?.showLoader() : self?.hideLoader()
            })
            .disposed(by: rx.disposeBag)
        
        viewModel.error
            .drive(onNext: { [weak self] _ in
                self?.presentErrorRetryView()
            })
            .disposed(by: rx.disposeBag)
    }
}

// MARK: - Private functions

extension GenresViewController {
    private func configureAppToolbar() {
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
}

// MARK: - GridCollectionViewLayoutDelegate

extension GenresViewController: GridCollectionViewLayoutDelegate {
    func numberOfColumns(_ collectionView: UICollectionView) -> Int {
        UIDevice.current.userInterfaceIdiom == .pad ? 5 : 3
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
