//
//  EmptyView.swift
//  Translate
//
//  Created by Stanislav Ivanov on 29.03.2020.
//  Copyright © 2020 Stanislav Ivanov. All rights reserved.
//

import UIKit

enum EmptyViewState {
    case noResultForSearch
    
    func text() -> String {
        switch self {
        case .noResultForSearch:
            return "Nothing was found..."
        }
    }
}

final class EmptyView: UIView {
    
    var state: EmptyViewState = .noResultForSearch {
        didSet {
            self.update()
        }
    }
    
    func update() {
        self.textLabel?.text = self.state.text()
    }
    
    // MARK: Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.customInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func customInit() {
        self.addSubviews()
    }
    
    // MARK: Layout
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.textLabel?.frame = self.bounds
    }
    
    // MARK: Subviews

    private var textLabel: UILabel?
    
    private func addSubviews() {
        if nil == self.textLabel {
            let view = UILabel()
            self.addSubview(view)
            self.textLabel = view
            
            view.textAlignment = .center
            view.numberOfLines = 0
        }
        
        self.update()
    }
}
