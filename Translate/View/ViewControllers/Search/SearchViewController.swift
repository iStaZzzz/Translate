//
//  SearchViewController.swift
//  Translate
//
//  Created by Stanislav Ivanov on 29.03.2020.
//  Copyright © 2020 Stanislav Ivanov. All rights reserved.
//

import UIKit

final class SearchViewController: BaseViewController {
    
    // MARK: Properties
    private let appConsts = AppConsts()
    private var searchService: ISearchService = SearchService.shared
    private var presenters: [SearchResultCellPresenter] = []
    
    private weak var searchBar: UISearchBar?
    private weak var tableView: SearchTableView?
    private weak var emptyView: EmptyView?

    // MARK: Lifecycle

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        let frame = self.realFrame()
        
        let searchBarHeight: CGFloat = 44
        self.searchBar?.frame = CGRect(x: frame.origin.x,
                                       y: frame.origin.y,
                                       width: frame.size.width,
                                       height: searchBarHeight)
        
        let tableViewY: CGFloat = frame.origin.y + searchBarHeight
        var tableViewHeight: CGFloat = frame.size.height - searchBarHeight
        if self.keyboardHeight > 0 {
            tableViewHeight -= self.keyboardHeight
            tableViewHeight += self.view.safeAreaInsets.bottom
        }
        self.tableView?.frame = CGRect(x: frame.origin.x,
                                       y: tableViewY,
                                       width: frame.size.width,
                                       height: tableViewHeight)
        
        self.emptyView?.frame = self.tableView?.frame ?? CGRect.zero
    }
}

// MARK: - Override
extension SearchViewController {
    
    override func willUpdateKeyboardHeight() {
        super.willUpdateKeyboardHeight()
        
        self.view.setNeedsLayout()
        self.view.layoutIfNeeded()
    }
    
    override func addSubviews() {
        super.addSubviews()
        
        if nil == self.searchBar {
            let view = UISearchBar()
            self.view.addSubview(view)
            self.searchBar = view
            
            view.delegate = self
        }
        
        if nil == self.tableView {
            let view = SearchTableView()
            self.view.addSubview(view)
            self.tableView = view
            view.searchDelegate = self
        }
        
        if nil == self.emptyView {
            let view = EmptyView()
            self.view.addSubview(view)
            self.emptyView = view
            
            view.state = .noResultForSearch
            view.isHidden = true
        }
    }
}

// MARK: - Search
extension SearchViewController {
    
    @objc private func search() {
        let text = self.searchBar?.text ?? ""
        self.searchService.search(word: text) { [weak self] (searchedText: String, words: [Word], error: Error?) in
            DispatchQueue.main.async {
                if self?.searchBar?.text == searchedText {
                    self?.searchCompleted(words: words, error: error)
                }
            }
        }
    }
    
    private func searchCompleted(words: [Word], error: Error?) {
        if let error = error {
            self.showAlert(error: error)
            return
        }
        
        if let text = self.searchBar?.text, !text.isEmpty, words.isEmpty {
            self.emptyView?.isHidden = false
        } else {
            self.emptyView?.isHidden = true
        }
        
        self.reloadSearchResult(words: words)
        self.tableView?.reloadData()
    }
    
    func reloadSearchResult(words: [Word]) {
        var presenters: [SearchResultCellPresenter] = []
        for word in words {
            let wordPresenter = SearchResultCellPresenter(word: word)
            presenters.append(wordPresenter)
        }
        self.presenters = presenters
        self.tableView?.presenters = presenters
    }
}

// MARK: - UISearchBarDelegate
extension SearchViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let selector = #selector(search)
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: selector, object: nil)
        perform(selector, with: nil, afterDelay: self.appConsts.searhDelay())
    }
}

// MARK: - SearchTableViewDelegate
extension SearchViewController: SearchTableViewDelegate {
    
    func didSelect(meaningPresenter: ISearchResultCellPresenter) {
        guard let presenter = meaningPresenter as? SearchResultCellPresenter  else {
            return
        }
        
        guard let meaning = presenter.meaning else {
            return
        }
        
        self.router.openMeaning(word: presenter.word, meaning: meaning)
    }
    
    func didSelect(wordPresenter: ISearchResultCellPresenter) {
        guard let presenter = wordPresenter as? SearchResultCellPresenter  else {
            return
        }

        var presenters: [SearchResultCellPresenter] = self.presenters
        
        if presenter.isExpanded() {
            presenter.isWordExpanded = false
            let meanings = presenter.word.meanings
            presenters = presenters.compactMap({
                if let meaning = $0.meaning, meanings.contains(meaning) { return nil }
                return $0
            })
        } else if var index = presenters.firstIndex(where: {$0 == presenter}) {
            presenter.isWordExpanded = true
            for meaning in presenter.word.meanings {
                index += 1
                let meaningPresenter = SearchResultCellPresenter(word: presenter.word, meaning: meaning)
                presenters.insert(meaningPresenter, at: index)
            }
        }
        
        self.presenters = presenters
        self.tableView?.presenters = presenters
    }
}
