//
//  PillListInteractor.swift
//  hiDementia
//
//  Created by xcode on 29.11.2021.
//

final class PillListInteractor {
    private let presenter: PillListPresentationLogic

     private let manager: FirestoreManagerProtocol = FirestoreManager(.pillList)

     init(_ presenter: PillListPresentationLogic) {
         self.presenter = presenter
     }
}

// MARK: - Business Logic

 extension PillListInteractor: PillListBusinessLogic {
     func fetchItems(_ request: PillListModels.FetchItems.Request) {
         presenter.presentLoad(.init(show: true))
         switch request.action {
         case .all:
             manager.read { [weak self] result in
                 self?.presenter.presentLoad(.init(show: false))
                 switch result {
                 case .success(let items):
                     self?.presenter.presentCells(.init(items: items))
                 case .failure(let error):
                     self?.presenter.presentError(.init(title: error.localizedDescription))
                 }
             }
         case .add, .edit:
             manager.addItem(
                 request.item ?? PillListItem.prototype(),
                 merge: (request.action == .edit)) { [weak self] result in
                     self?.presenter.presentLoad(.init(show: false))
                     switch result {
                     case .success(_):
                         guard let item = request.item else { return }
                         if (request.action == .edit) {
                             self?.presenter.presentUpdate(.init(item: item))
                         } else if (request.action == .add) {
                             self?.presenter.presentAdd(.init(item: item))
                         }
                     case .failure(let error):
                         self?.presenter.presentError(.init(title: error.localizedDescription))
                     }
                 }
         case .delete:
             manager.deleteItem(request.item ?? PillListItem.prototype()) { [weak self] result in
                 self?.presenter.presentLoad(.init(show: false))
                 switch result {
                 case .success(_):
                     guard let item = request.item else { return }
                     self?.presenter.presentDelete(.init(item: item))
                 case .failure(let error):
                     self?.presenter.presentError(.init(title: error.localizedDescription))
                 }
             }
         }
     }
 }
