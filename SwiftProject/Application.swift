//
//  Application.swift
//  SwiftProject
//
//  Created by 梓源 on 2024/12/24.
//

import UIKit

class Application: NSObject {
    static let shared = Application()
    
    var window: UIWindow?
    
    let navigator: Navigator

    private override init() {
        navigator = Navigator.default
        super.init()
    }
    
    func presentScreen(in window: UIWindow?) {
        guard let window = window else { return }
        self.window = window

//        presentTestScreen(in: window)
//        return

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            if !AppConfig.shared.guideStatus && AppConfig.shared.showGuide {
                self?.navigator.show(segue: .guide, sender: nil, transition: .root(in: window))
            } else {
                let viewModel = TabBarViewModel()
                self?.navigator.show(segue: .tabs(viewModel: viewModel), sender: nil, transition: .root(in: window))
            }
        }
    }
    
    func presentTestScreen(in window: UIWindow?) {
        guard let window = window else { return }
        navigator.show(segue: .test, sender: nil, transition: .root(in: window))
    }
    
    
}
