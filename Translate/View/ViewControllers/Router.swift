//
//  Router.swift
//  Translate
//
//  Created by Stanislav Ivanov on 29.03.2020.
//  Copyright © 2020 Stanislav Ivanov. All rights reserved.
//

import UIKit

protocol IRouter {
    func rootViewController() -> UIViewController
    
    func openMeaning(word: Word, meaning: Meaning)
}

// MARK: - Router
final class Router {
    static let shared = Router()
    
    // MARK: Private
    
    private let rootNavigationControler: UINavigationController
    
    private init() {
        let searchViewController = SearchViewController()
        self.rootNavigationControler = UINavigationController(rootViewController: searchViewController)
    }
}

extension Router: IRouter {
    
    func rootViewController() -> UIViewController {
        return self.rootNavigationControler
    }
    
    func openMeaning(word: Word, meaning: Meaning) {
        let viewController = MeaningViewController(word: word, meaning: meaning)
        self.rootNavigationControler.pushViewController(viewController, animated: true)
    }
}
