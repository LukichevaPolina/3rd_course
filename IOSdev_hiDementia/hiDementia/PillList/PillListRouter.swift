//
//  PillListRouter.swift
//  hiDementia
//
//  Created by xcode on 29.11.2021.
//

import UIKit


 final class PillListRouter {

     weak var view: (PillListDisplayLogic & UIViewController)?

     init() {}
 }

 // MARK: - Routing Logic

 extension PillListRouter: PillListRoutingLogic {
     func routeToFillItem(defaultItem: PillListItem?, callback: @escaping (PillListItem) -> Void) {
         let vc = AddItemVC(defaultItem, callback)
         vc.modalPresentationStyle = .fullScreen
         view?.present(vc, animated: true)
     }
 }
