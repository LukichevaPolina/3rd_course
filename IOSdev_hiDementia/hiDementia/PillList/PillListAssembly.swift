//
//  PillListAssembly.swift
//  hiDementia
//
//  Created by xcode on 29.11.2021.
//

enum PillListAssembly {
     static func assembly() -> PillTableViewController {
         let router = PillListRouter()
         let presenter = PillListPresenter()
         let interactor = PillListInteractor(presenter)
         let viewController = PillTableViewController(interactor, router: router, [])

         presenter.view = viewController
         router.view = viewController
         return viewController
     }
 }
