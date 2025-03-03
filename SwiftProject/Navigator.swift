//
//  Navigator.swift
//  SwiftProject
//
//  Created by 梓源 on 2024/12/24.
//

import Foundation
import UIKit


protocol Navigatable {
    var navigator: Navigator! { get set }
}

class Navigator {
    static var `default` = Navigator()
    
    // MARK: - segues list, all app scenes
    enum Scene {
        case tabs(viewModel: TabBarViewModel)
        case guide
        case test
//        case search(viewModel: SearchViewModel)
//        case languages(viewModel: LanguagesViewModel)
//        case users(viewModel: UsersViewModel)
//        case userDetails(viewModel: UserViewModel)
//        case theme(viewModel: ThemeViewModel)
//        case language(viewModel: LanguageViewModel)
//        case acknowledgements
//        case whatsNew(block: WhatsNewBlock)
//        case webController(URL)
    }
    
    enum Transition {
        case root(in: UIWindow)
        case navigation
        case modal
        case detail
        case alert
        case custom
    }
    
    // MARK: - get a single VC
    func get(segue: Scene) -> UIViewController? {
        switch segue {
        case .tabs(let viewModel):
            let rootVC = TabBarController(viewModel, navigator: self)
            return rootVC
        case .test:
            let testVC = TestViewController()
            return testVC
        case .guide:
            let guideVC = GuideViewController()
            return guideVC
        }
    }
    
    // MARK: - invoke a single segue
    func show(segue: Scene, sender: UIViewController?, transition: Transition = .navigation) {
        if let target = get(segue: segue) {
            show(target: target, sender: sender, transition: transition)
        }
    }
    
    private func show(target: UIViewController, sender: UIViewController?, transition: Transition) {
        switch transition {
            case .root(in: let window):
                UIView.transition(with: window, duration: 0.5, options: .transitionFlipFromLeft, animations: {
                    window.rootViewController = target
                    window.makeKeyAndVisible()
                }, completion: nil)
                return
            case .custom: return
            default: break
        }

        guard let sender = sender else {
            fatalError("You need to pass in a sender for .navigation or .modal transitions")
        }

        if let nav = sender as? UINavigationController {
            // push root controller on navigation stack
            nav.pushViewController(target, animated: false)
            return
        }

        switch transition {
            case .navigation:
                if let nav = sender.navigationController {
                    // push controller to navigation stack
                    //nav.hero.navigationAnimationType = .autoReverse(presenting: type)
                    nav.pushViewController(target, animated: true)
                }
//           case .customModal(let type):
//                // present modally with cumakeKeyAndVisiblestom animation
//                DispatchQueue.main.async {
//                    let nav = NavigationController(rootViewController: target)
//                    nav.hero.modalAnimationType = .autoReverse(presenting: type)
//                    sender.present(nav, animated: true, completion: nil)
//                }
            case .modal:
                // present modally
                DispatchQueue.main.async {
                    let nav = BaseNavigationController(rootViewController: target)
                    sender.present(nav, animated: true, completion: nil)
                }
            case .detail:
                DispatchQueue.main.async {
                    let nav = BaseNavigationController(rootViewController: target)
                    sender.showDetailViewController(nav, sender: nil)
                }
            case .alert:
                DispatchQueue.main.async {
                    sender.present(target, animated: true, completion: nil)
                }
            default: break
        }
    }
    
}
