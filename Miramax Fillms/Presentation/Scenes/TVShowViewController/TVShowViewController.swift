//
//  TVShowViewController.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 18/09/2022.
//

import UIKit
import RxSwift
import RxCocoa
import SwifterSwift

class TVShowViewController: BaseViewController<TVShowViewModel> {

    // MARK: - Outlets + Views
    
    @IBOutlet weak var appToolbar: AppToolbar!
    @IBOutlet weak var collectionView: UICollectionView!
    
    private var btnSearch: UIButton!

    // MARK: - Properties
    
    private var tvShowViewDataItems: [TVShowViewData] = []
    
    private let retryGenreViewTriggerS = PublishRelay<Void>()
    private let retryAiringTodayTriggerS = PublishRelay<Void>()
    private let retryUpComingViewTriggerS = PublishRelay<Void>()
    private let tvShowSelectTriggerS = PublishRelay<TVShow>()

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func configView() {
        super.configView()
        
        btnSearch = UIButton(type: .system)
        btnSearch.translatesAutoresizingMaskIntoConstraints = false
        btnSearch.setImage(UIImage(named: "ic_toolbar_search"), for: .normal)
        
        appToolbar.title = "tvshow".localized
        appToolbar.showBackButton = false
        appToolbar.rightButtons = [btnSearch]
        
        let gridCollectionViewLayout = GridCollectionViewLayout()
        gridCollectionViewLayout.rowSpacing = 12.0
        gridCollectionViewLayout.delegate = self
        collectionView.collectionViewLayout = gridCollectionViewLayout
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.contentInset = .init(top: 16.0, left: 0.0, bottom: 16.0, right: 0.0)
        collectionView.register(cellWithClass: GenreHorizontalListCell.self)
        collectionView.register(nibWithCellClass: AiringTodayCell.self)
        collectionView.register(cellWithClass: MovieHorizontalListCell.self)
        collectionView.register(cellWithClass: TabSelectionCell.self)
    }
    
    override func bindViewModel() {
        super.bindViewModel()
        
        let input = TVShowViewModel.Input(
            toSearchTrigger: btnSearch.rx.tap.asDriver(),
            retryGenreTrigger: retryGenreViewTriggerS.asDriverOnErrorJustComplete(),
            retryAiringTodayTrigger: retryAiringTodayTriggerS.asDriverOnErrorJustComplete(),
            retryUpComingTrigger: retryUpComingViewTriggerS.asDriverOnErrorJustComplete(),
            tvShowSelectTrigger: tvShowSelectTriggerS.asDriverOnErrorJustComplete()
        )
        let output = viewModel.transform(input: input)
        
        output.tvShowViewDataItems
            .drive(onNext: { [weak self] items in
                guard let self = self else { return }
                self.tvShowViewDataItems = items
                self.collectionView.reloadData()
            })
            .disposed(by: rx.disposeBag)
    }
}

// MARK: - UICollectionViewDataSource

extension TVShowViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        tvShowViewDataItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let tvShowViewData = tvShowViewDataItems[indexPath.row]
        switch tvShowViewData {
        case .genreViewState(viewState: let viewState):
            let cell = collectionView.dequeueReusableCell(withClass: GenreHorizontalListCell.self, for: indexPath)
            cell.bind(viewState)
            cell.delegate = self
            return cell
        case .airingTodayViewState(viewStatte: let viewState):
            let cell = collectionView.dequeueReusableCell(withClass: AiringTodayCell.self, for: indexPath)
            cell.bind(viewState)
            return cell
        case .onTheAirViewState(viewState: let viewState):
            let cell = collectionView.dequeueReusableCell(withClass: MovieHorizontalListCell.self, for: indexPath)
            cell.bind(viewState, headerTitle: "on_the_air".localized)
            cell.delegate = self
            return cell
        case .tabSelection:
            let cell = collectionView.dequeueReusableCell(withClass: TabSelectionCell.self, for: indexPath)
            cell.bind(["top_rating".localized, "news".localized, "trending".localized], selectIndex: 1)
            return cell
        }
    }
    
}

// MARK: - UICollectionViewDelegate

extension TVShowViewController: UICollectionViewDelegate {
    
}

// MARK: - GridCollectionViewLayoutDelegate

extension TVShowViewController: GridCollectionViewLayoutDelegate {
    func numberOfColumns(_ collectionView: UICollectionView) -> Int {
        2
    }
    
    func collectionView(_ collectionView: UICollectionView, columnSpanForItemAt index: GridIndex, indexPath: IndexPath) -> Int {
        let tvShowViewData = tvShowViewDataItems[indexPath.row]
        switch tvShowViewData {
        case .genreViewState, .airingTodayViewState, .onTheAirViewState, .tabSelection:
            return 2
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, heightForItemAt index: GridIndex, indexPath: IndexPath) -> CGFloat {
        let tvShowViewData = tvShowViewDataItems[indexPath.row]
        switch tvShowViewData {
        case .genreViewState:
            return 50.0
        case .airingTodayViewState:
            return collectionView.frame.width * DimensionConstants.airingTodayCellRatio
        case .onTheAirViewState:
            return 200.0
        case .tabSelection:
            return 40.0
        }
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

// MARK: - MovieGenreListCellDelegate

extension TVShowViewController: GenreHorizontalListCellDelegate {
    func genreHorizontalListRetryButtonTapped() {
        retryGenreViewTriggerS.accept(())
    }
    
    func genreHorizontalList(onItemTapped genre: Genre) {
        
    }
    
}

// MARK: - AiringTodayCellDelegate

extension TVShowViewController: AiringTodayCellDelegate {
    func airingTodayCell(didTapPlayButton item: EntertainmentModelType) {
        if let tvShow = item as? TVShow {
            tvShowSelectTriggerS.accept(tvShow)
        }
    }
    
    func airingTodayCellRetryButtonTapped() {
        retryAiringTodayTriggerS.accept(())
    }
}

// MARK: - MovieHorizontalListCellDelegate

extension TVShowViewController: MovieHorizontalListCellDelegate {
    func movieHorizontalListRetryButtonTapped() {
        retryUpComingViewTriggerS.accept(())
    }
    
    func movieHorizontalList(onItemTapped item: EntertainmentModelType) {
        if let tvShow = item as? TVShow {
            tvShowSelectTriggerS.accept(tvShow)
        }
    }
    
    func movieHorizontalListSeeMoreButtonTapped() {
        
    }
}

// MARK: - TabSelectionCellDelegate

extension TVShowViewController: TabSelectionCellDelegate {
    func tabSelectionCell(onTabSelected index: Int) {
        
    }
}
