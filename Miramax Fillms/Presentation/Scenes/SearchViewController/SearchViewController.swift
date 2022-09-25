//
//  SearchViewController.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 17/09/2022.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import SwifterSwift

class SearchViewController: BaseViewController<SearchViewModel> {

    // MARK: - Outlets + Views
    
    @IBOutlet weak var appToolbar: AppToolbar!
    @IBOutlet weak var tfSearch: UITextField!
    @IBOutlet weak var btnClearSearch: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var loadingIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var viewSearchEmpty: UIView!
    @IBOutlet weak var lblEmptyMessage: UILabel!
    
    private var btnCancel: UIButton!
    
    // MARK: - Properties
    
    private var searchViewDataItems: [SearchViewData] = []
    
    private let searchTriggerS = PublishRelay<String?>()
    private let retryTriggerS = PublishRelay<Void>()
    private let personSelectTriggerS = PublishRelay<Person>()
    private let entertainmentSelectTriggerS = PublishRelay<EntertainmentModelType>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        
    }

    override func configView() {
        super.configView()
        
        appToolbar.title = "search".localized
        appToolbar.showBackButton = false
        
        let collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.scrollDirection = .vertical
        collectionView.collectionViewLayout = collectionViewLayout
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.contentInset = .init(top: 32.0, left: 0.0, bottom: 32.0, right: 0.0)
        collectionView.register(cellWithClass: MovieHorizontalListCell.self)
        collectionView.register(cellWithClass: PersonHorizontalListCell.self)
        
        btnCancel = UIButton(type: .system)
        btnCancel.setTitle("cancel".localized, for: .normal)
        btnCancel.setTitleColor(AppColors.colorAccent, for: .normal)
        btnCancel.titleLabel?.font = AppFonts.caption1
        view.addSubview(btnCancel)
        btnCancel.snp.makeConstraints { make in
            make.centerY.equalTo(appToolbar.snp.centerY)
            make.trailing.equalToSuperview().offset(-16.0)
        }
        
        tfSearch.delegate = self
        tfSearch.returnKeyType = .search
        tfSearch.clearButtonMode = .never
        tfSearch.textColor = AppColors.textColorPrimary
        tfSearch.attributedPlaceholder = NSAttributedString(
            string: "search_bar_placeholder".localized,
            attributes: [NSAttributedString.Key.foregroundColor: AppColors.textColorPrimary.withAlphaComponent(0.5)]
        )
        tfSearch.addTarget(self, action: #selector(searchTextFieldDidChange(_:)), for: .editingChanged)
        
        btnClearSearch.isHidden = true
        btnClearSearch.addTarget(self, action: #selector(clearSearchButtonTapped(_:)), for: .touchUpInside)
        
        lblEmptyMessage.font = AppFonts.caption1SemiBold
        lblEmptyMessage.textColor = AppColors.textColorPrimary
    }
    
    override func bindViewModel() {
        super.bindViewModel()
        
        let input = SearchViewModel.Input(
            searchTrigger: searchTriggerS.asDriverOnErrorJustComplete(),
            cancelTrigger: btnCancel.rx.tap.asDriver(),
            personSelectTrigger: personSelectTriggerS.asDriverOnErrorJustComplete(),
            entertainmentSelectTrigger: entertainmentSelectTriggerS.asDriverOnErrorJustComplete()
        )
        let output = viewModel.transform(input: input)
        
        output.searchViewDataItems
            .drive(onNext: { [weak self] items in
                guard let self = self else { return }
                self.searchViewDataItems = items
                self.collectionView.reloadData()
                self.collectionView.isHidden = items.isEmpty
                self.viewSearchEmpty.isHidden = !items.isEmpty
                if items.isEmpty {
                    self.lblEmptyMessage.text = "\("search_result_empty".localized) “\(self.tfSearch.text ?? "")”"
                }
            })
            .disposed(by: rx.disposeBag)
        
        viewModel.loading
            .drive(onNext: { [weak self] isLoading in
                guard let self = self else { return }
                isLoading ? self.loadingIndicatorView.startAnimating() : self.loadingIndicatorView.stopAnimating()
            })
            .disposed(by: rx.disposeBag)
    }
    
    @objc private func clearSearchButtonTapped(_ sender: UIButton) {
        tfSearch.text = ""
        tfSearch.resignFirstResponder()
        searchTriggerS.accept(nil)
    }
    
    @objc private func searchTextFieldDidChange(_ sender: UITextField) {
        btnClearSearch.isHidden = sender.text?.isEmpty ?? true
    }
}

// MARK: - UITextFieldDelegate

extension SearchViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let query = textField.text, !query.isEmpty && !query.isBlank else { return false }
        collectionView.isHidden = true
        viewSearchEmpty.isHidden = true
        searchTriggerS.accept(query)
        tfSearch.resignFirstResponder()
        return true
    }
}

// MARK: - UICollectionViewDataSource

extension SearchViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return searchViewDataItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = searchViewDataItems[indexPath.row]
        switch item {
        case .recent(items: let items):
            let cell = collectionView.dequeueReusableCell(withClass: MovieHorizontalListCell.self, for: indexPath)
            cell.bind(.populated(items), headerTitle: "recent".localized)
            cell.delegate = self
            return cell
        case .movie(items: let items):
            let cell = collectionView.dequeueReusableCell(withClass: MovieHorizontalListCell.self, for: indexPath)
            cell.bind(.populated(items), headerTitle: "movies".localized)
            cell.delegate = self
            return cell
        case .tvShow(items: let items):
            let cell = collectionView.dequeueReusableCell(withClass: MovieHorizontalListCell.self, for: indexPath)
            cell.bind(.populated(items), headerTitle: "tvshows".localized)
            cell.delegate = self
            return cell
        case .actor(items: let items):
            let cell = collectionView.dequeueReusableCell(withClass: PersonHorizontalListCell.self, for: indexPath)
            cell.bind(.populated(items), headerTitle: "actors".localized)
            cell.delegate = self
            return cell
        }
    }
    
}

// MARK: - UICollectionViewDelegateFlowLayout

extension SearchViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 32.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var itemHeight: CGFloat!
        let item = searchViewDataItems[indexPath.row]
        switch item {
        case .actor:
            itemHeight = 150.0
        default:
            itemHeight = 200.0
        }
        let itemWidth = collectionView.frame.width
        return .init(width: itemWidth, height: itemHeight)
    }
}

// MARK: - MovieHorizontalListCellDelegate

extension SearchViewController: MovieHorizontalListCellDelegate {
    func movieHorizontalListRetryButtonTapped() {
        
    }
    
    func movieHorizontalList(onItemTapped item: EntertainmentModelType) {
        entertainmentSelectTriggerS.accept(item)
    }
    
    func movieHorizontalListSeeMoreButtonTapped() {
        
    }
    
}

// MARK: - PersonHorizontalListCellDelegate

extension SearchViewController: PersonHorizontalListCellDelegate {
    func personHorizontalListRetryButtonTapped() {
        
    }
    
    func personHorizontalList(onItemTapped person: Person) {
        personSelectTriggerS.accept(person)
    }
    
    func personHorizontalListSeeMoreButtonTapped() {
        
    }
    
}
