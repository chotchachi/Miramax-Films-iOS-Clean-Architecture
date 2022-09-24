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

class SeasonDetailsViewController: BaseViewController<SeasonDetailsViewModel> {

    // MARK: - Outlets + Views
    
    @IBOutlet weak var appToolbar: AppToolbar!
    @IBOutlet weak var tblEpisodes: UITableView!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    // MARK: - Properties
    
    private let popViewTriggerS = PublishRelay<Void>()
    private let retryTriggerS = PublishRelay<Void>()
    private let episodeSelectTriggerS = PublishRelay<Episode>()
    
    override func configView() {
        super.configView()
        
        // Toolbar
        appToolbar.title = "episodes".localized
        appToolbar.rx.backButtonTap
            .bind(to: popViewTriggerS)
            .disposed(by: rx.disposeBag)
        
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
            popViewTrigger: popViewTriggerS.asDriverOnErrorJustComplete(),
            retryTrigger: retryTriggerS.asDriverOnErrorJustComplete(),
            episodeSelectTrigger: episodeSelectTriggerS.asDriverOnErrorJustComplete()
        )
        let output = viewModel.transform(input: input)
        
        let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, Episode>> { dataSource, tableView, indexPath, item in
            let cell = tableView.dequeueReusableCell(withClass: EpisodeCell.self)
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
                guard let self = self else { return }
                isLoading ? self.loadingIndicator.startAnimating() : self.loadingIndicator.stopAnimating()
            })
            .disposed(by: rx.disposeBag)
        
        viewModel.error
            .drive(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.showAlert(
                    title: "error".localized,
                    message: "an_error_occurred".localized,
                    buttonTitles: ["cancel".localized, "try_again".localized]) { buttonIndex in
                        if buttonIndex == 1 {
                            self.retryTriggerS.accept(())
                        } else {
                            self.popViewTriggerS.accept(())
                        }
                    }
            })
            .disposed(by: rx.disposeBag)
    }
}
