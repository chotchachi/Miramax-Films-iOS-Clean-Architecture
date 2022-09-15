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
    
    @IBOutlet weak var collectionView: UICollectionView!

    
    // MARK: - Properties
    
    private var movieViewDataItems: [MovieViewData] = []
    
    private let retryGenreViewTriggerS = PublishRelay<Void>()
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func configView() {
        super.configView()
        
        let gridCollectionViewLayout = GridCollectionViewLayout()
        gridCollectionViewLayout.delegate = self
        collectionView.collectionViewLayout = gridCollectionViewLayout
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(cellWithClass: MovieGenreListCell.self)
    }
    
    override func bindViewModel() {
        super.bindViewModel()
        
        let input = MovieViewModel.Input(
            retryGenreTrigger: retryGenreViewTriggerS.asDriverOnErrorJustComplete()
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

// MARK: - UICollectionViewDataSource

extension MovieViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        movieViewDataItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let movieViewData = movieViewDataItems[indexPath.row]
        switch movieViewData {
        case .genreViewState(viewState: let viewState):
            let cell = collectionView.dequeueReusableCell(withClass: MovieGenreListCell.self, for: indexPath)
            cell.bind(viewState)
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
        case .genreViewState:
            return 2
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, heightForItemAt index: GridIndex, indexPath: IndexPath) -> CGFloat {
        let movieViewData = movieViewDataItems[indexPath.row]
        switch movieViewData {
        case .genreViewState:
            return 50.0
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

extension MovieViewController: MovieGenreListCellDelegate {
    func onRetryButtonTap() {
        retryGenreViewTriggerS.accept(())
    }
    
    func onGenreItemTap(genre: Genre) {
        print(genre.name)
    }
    
}
