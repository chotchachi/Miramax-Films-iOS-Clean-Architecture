//
//  MovieViewController.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 12/09/2022.
//

import UIKit
import RxSwift
import RxCocoa
import SwifterSwift

class MovieViewController: BaseViewController<MovieViewModel> {
    
    // MARK: - Outlets
    
    @IBOutlet weak var appToolbar: AppToolbar!
    @IBOutlet weak var collectionView: UICollectionView!

    // MARK: - Properties
    
    private var movieViewDataItems: [MovieViewData] = []
    
    private let retryGenreViewTriggerS = PublishRelay<Void>()
    private let retryUpComingViewTriggerS = PublishRelay<Void>()

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func configView() {
        super.configView()
        
        appToolbar.delegate = self
        
        let gridCollectionViewLayout = GridCollectionViewLayout()
        gridCollectionViewLayout.rowSpacing = 16.0
        gridCollectionViewLayout.delegate = self
        collectionView.collectionViewLayout = gridCollectionViewLayout
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.contentInset = .init(top: 16.0, left: 0.0, bottom: 16.0, right: 0.0)
        collectionView.register(cellWithClass: GenreHorizontalListCell.self)
        collectionView.register(cellWithClass: MovieHorizontalListCell.self)
        collectionView.register(cellWithClass: SelfieWithMovieCell.self)
    }
    
    override func bindViewModel() {
        super.bindViewModel()
        
        let input = MovieViewModel.Input(
            retryGenreTrigger: retryGenreViewTriggerS.asDriverOnErrorJustComplete(),
            retryUpComingTrigger: retryUpComingViewTriggerS.asDriverOnErrorJustComplete()
        )
        let output = viewModel.transform(input: input)
        
        output.movieViewDataItems
            .drive(onNext: { [weak self] items in
                guard let self = self else { return }
                self.movieViewDataItems = items
                self.collectionView.reloadData()
            })
            .disposed(by: rx.disposeBag)
    }
    
    private func handleGenreViewState(_ state: ViewState<Genre>) {
        switch state {
        case .initial:
            break
        case .paging:
            break
        case .populated(let array):
            print(array)
        case .empty:
            break
        case .error(let error):
            print(error.localizedDescription)
        }
    }
}

// MARK: - AppToolbarDelegate

extension MovieViewController: AppToolbarDelegate {
    func appToolbar(onBackButtonTapped button: UIButton) {
        
    }
}

// MARK: - UICollectionViewDataSource

extension MovieViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        movieViewDataItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let movieViewData = movieViewDataItems[indexPath.row]
        switch movieViewData {
        case .genreViewState(viewState: let viewState):
            let cell = collectionView.dequeueReusableCell(withClass: GenreHorizontalListCell.self, for: indexPath)
            cell.bind(viewState)
            cell.delegate = self
            return cell
        case .upComingViewState(viewState: let viewState):
            let cell = collectionView.dequeueReusableCell(withClass: MovieHorizontalListCell.self, for: indexPath)
            cell.bind(viewState, headerTitle: "Upcoming")
            cell.delegate = self
            return cell
        case .selfieWithMovie:
            let cell = collectionView.dequeueReusableCell(withClass: SelfieWithMovieCell.self, for: indexPath)
            cell.delegate = self
            return cell
        }
    }
    
}

// MARK: - UICollectionViewDelegate

extension MovieViewController: UICollectionViewDelegate {
    
}

// MARK: - GridCollectionViewLayoutDelegate

extension MovieViewController: GridCollectionViewLayoutDelegate {
    func numberOfColumns(_ collectionView: UICollectionView) -> Int {
        2
    }
    
    func collectionView(_ collectionView: UICollectionView, columnSpanForItemAt index: GridIndex, indexPath: IndexPath) -> Int {
        let movieViewData = movieViewDataItems[indexPath.row]
        switch movieViewData {
        case .genreViewState, .upComingViewState, .selfieWithMovie:
            return 2
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, heightForItemAt index: GridIndex, indexPath: IndexPath) -> CGFloat {
        let movieViewData = movieViewDataItems[indexPath.row]
        switch movieViewData {
        case .genreViewState:
            return 50.0
        case .upComingViewState, .selfieWithMovie:
            return 200.0
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

extension MovieViewController: GenreHorizontalListCellDelegate {
    func genreHorizontalListRetryButtonTapped() {
        retryGenreViewTriggerS.accept(())
    }
    
    func genreHorizontalList(onItemTapped genre: Genre) {
        
    }
    
}

// MARK: - MovieHorizontalListDelegate

extension MovieViewController: MovieHorizontalListDelegate {
    func movieHorizontalListRetryButtonTapped() {
        retryUpComingViewTriggerS.accept(())
    }
    
    func movieHorizontalList(onItemTapped movie: Movie) {
        
    }
    
    func movieHorizontalListSeeMoreButtonTapped() {
        
    }
}

// MARK: - SelfieWithMovieCellDelegate

extension MovieViewController: SelfieWithMovieCellDelegate {
    func selfieWithMovieCellChooseFrameButtonTapped() {
        
    }
}
