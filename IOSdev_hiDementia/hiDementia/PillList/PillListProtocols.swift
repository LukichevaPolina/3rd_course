//
//  PillListProtocol.swift
//  hiDementia
//
//  Created by xcode on 29.11.2021.
//

protocol PillListDisplayLogic: AnyObject {
    func displayCells(_ viewModel: PillListModels.FetchItems.ViewModel)
    func displayUpdateItem(_ viewModel: PillListModels.UpdateItems.ViewModel)
    func displayAddItem(_ viewModel: PillListModels.UpdateItems.ViewModel)
    func displayDeleteItem(_ viewModel: PillListModels.UpdateItems.ViewModel)
    func displayError(_ viewModel: PillListModels.Error.ViewModel)
    func displayLoad(_ viewModel: PillListModels.Load.ViewModel)
}

protocol PillListBusinessLogic: AnyObject {
    func fetchItems(_ request: PillListModels.FetchItems.Request)
}

protocol PillListPresentationLogic: AnyObject {
    func presentLoad(_ response: PillListModels.Load.Response)
    func presentError(_ response: PillListModels.Error.Response)
    func presentCells(_ response: PillListModels.FetchItems.Response)
    func presentUpdate( _ response: PillListModels.UpdateItems.Response)
    func presentAdd(_ response: PillListModels.UpdateItems.Response)
    func presentDelete(_ response: PillListModels.UpdateItems.Response)
}

protocol PillListRoutingLogic: AnyObject {
    func routeToFillItem(defaultItem: PillListItem?, callback: @escaping (PillListItem) -> Void)
 }

protocol PillListWorkerProtocol: AnyObject {
    func fetchItems(
        parameter: String,
        action: PillListModels.ItemAction,
        completion: @escaping (Result<[PillListItem], Error>) -> Void
    )
}
