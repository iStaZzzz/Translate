//
//  SearchTableView.swift
//  Translate
//
//  Created by Stanislav Ivanov on 29.03.2020.
//  Copyright © 2020 Stanislav Ivanov. All rights reserved.
//

import UIKit


protocol ISearchResultCellPresenter {
    func text() -> String
    func isMeaning() -> Bool
    func isExpanded() -> Bool
}

protocol SearchTableViewDelegate: class {
    func didSelect(meaningPresenter: ISearchResultCellPresenter)
    func didSelect(wordPresenter: ISearchResultCellPresenter)
}


final class SearchTableView: UITableView {
    
    weak var searchDelegate: SearchTableViewDelegate? = nil
    
    var presenters: [ISearchResultCellPresenter] = [] {
        didSet {
            self.reloadData()
        }
    }

    // MARK: Init
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        self.customInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func customInit() {
        self.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
        self.delegate = self
        self.dataSource = self
        self.allowsSelection = true
    }

}

// MARK: - UITableViewDelegate
extension SearchTableView: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let presenter = self.presenters[indexPath.row]
        if presenter.isMeaning() {
            self.searchDelegate?.didSelect(meaningPresenter: presenter)
        } else {
            self.searchDelegate?.didSelect(wordPresenter: presenter)
        }
    }
}

// MARK: - UITableViewDataSource
extension SearchTableView: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.presenters.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
        
        let presenter = self.presenters[indexPath.row]
        cell.textLabel?.text = presenter.text()
        if presenter.isMeaning() {
            cell.textLabel?.font = UIFont.systemFont(ofSize: 15, weight: .light)
            cell.indentationLevel = 2
        } else {
            cell.textLabel?.font = UIFont.systemFont(ofSize: 17, weight: .medium)
            cell.indentationLevel = 0
        }
        
        return cell
    }
}
