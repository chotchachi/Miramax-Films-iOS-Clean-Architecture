//
//  SeasonDetailsViewController.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 22/09/2022.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import SwifterSwift
import Domain

class SeasonDetailsViewController: BaseViewController<SeasonDetailsViewModel>, LoadingDisplayable, ErrorRetryable {

    // MARK: - Outlets + Views
    
    @IBOutlet weak var appToolbar: AppToolbar!
    @IBOutlet weak var tblEpisodes: UITableView!
    
    var loaderView: LoadingView = LoadingView()
    var errorRetryView: ErrorRetryView = ErrorRetryView()
    
    // MARK: - Properties
    
    private let episodeSelectTriggerS = PublishRelay<Episode>()
    
    override func configView() {
        super.configView()
        
        // Toolbar
        appToolbar.title = "episodes".localized
        
        // Seasons table view
        tblEpisodes.separatorStyle = .none
        tblEpisodes.register(cellWithClass: EpisodeCell.self)
        tblEpisodes.rx.modelSelected(Episode.self)
            .bind(to: episodeSelectTriggerS)
            .disposed(by: rx.disposeBag)
    }
    
    override func bindViewModel() {
        super.bindViewModel()
        
        let input = SeasonDetailsViewModel.Input(
            popViewTrigger: appToolbar.rx.backButtonTap.asDriver(),
            retryTrigger: errorRetryView.rx.retryTapped.asDriver(),
            episodeSelectTrigger: episodeSelectTriggerS.asDriverOnErrorJustComplete()
        )
        let output = viewModel.transform(input: input)
        
        let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, Episode>> { dataSource, tableView, indexPath, item in
            let cell = tableView.dequeueReusableCell(withClass: EpisodeCell.self, for: indexPath)
            cell.bind(item)
            cell.onLayoutChangeNeeded = { [weak self] in
                guard let self = self else { return }
                self.tblEpisodes.beginUpdates()
                self.tblEpisodes.endUpdates()
            }
            return cell
        }
        
        output.episodesData
            .map { [SectionModel(model: "", items: $0)] }
            .drive(tblEpisodes.rx.items(dataSource: dataSource))
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
