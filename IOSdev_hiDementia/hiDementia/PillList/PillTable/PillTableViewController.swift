//
//  PillTableViewController.swift
//  hiDementia
//
//  Created by Сапожников Андрей Михайлович on 22.12.2021.
//

import Foundation
import UIKit

class PillTableViewController: UITableViewController {

    var items: [PillListItem] {
        didSet {
            items = items.sorted(by: {left, right in
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "HH:mm"
                let dateLeft: Date? = dateFormatter.date(from: left.time)
                let dateRight: Date? = dateFormatter.date(from: right.time)
                if (dateLeft != nil && dateRight != nil) {
                    return dateLeft! < dateRight!
                } else {
                    return false
                }
            })
        }
    }
    private let interactor: PillListBusinessLogic
    private let router: PillListRoutingLogic
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
         let view = UIActivityIndicatorView(style: .large)
         return view
     }()
    
    let colorGreen = UIColor(rgb: 0x1AAF5A)

    init(
        _ interactor: PillListBusinessLogic,
        router: PillListRoutingLogic,
        _ items: [PillListItem]
    ) {
        self.interactor = interactor
        self.router = router
        self.items = items
        super.init(style: .plain)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
         super.viewDidLoad()

         interactor.fetchItems(.init(nil, .all))
         setupTableView()
     }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationItem.rightBarButtonItems = setupNavButtons()
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "hiDementia"
        navigationItem.titleView?.tintColor = UIColor.systemOrange
    }
    
    @objc
    private func refreshData() {
        interactor.fetchItems(.init(nil, .all))
    }
    
    @objc
    private func plusButtonTapped() {
        router.routeToFillItem(defaultItem: nil) { [weak self] item in
            self?.interactor.fetchItems(.init(item, .add))
         }
     }
    
    private func editButtonTapped(item: PillListItem) {
        router.routeToFillItem(defaultItem: item) { [weak self] item in
            self?.interactor.fetchItems(.init(item, .edit))
         }
    }
    
    private func setupNavButtons() -> [UIBarButtonItem] {
         let plusButton = UIBarButtonItem(
             barButtonSystemItem: .add,
             target: self,
             action: #selector(plusButtonTapped))
         return [plusButton]
     }
    
    func setupTableView() {
        view.addSubview(activityIndicator)
        activityIndicator.center = view.center
        tableView.backgroundColor = .systemBackground
        tableView.separatorStyle = .none
        NSLayoutConstraint.activate([
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

extension PillTableViewController {

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("PillTableViewCell", owner: self, options: nil)?.first as! PillTableViewCell
        let item = items[indexPath.row]
        cell.pillLabel.text = item.name
        cell.timeLabel.text = item.time
        cell.numberLabel.text = "\(String(describing: item.quantity))".replacingOccurrences(of: "[^\\.\\d+]", with: "", options: [.regularExpression]) + " pills"
        cell.mealLabel.text = item.meal
        cell.setTaken(item.taken)
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        // Action on tap
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
         1
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
            true
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let editAction = UIContextualAction(style: .normal, title: "Edit") { [weak self] (action, view, completion) in
            if let self = self {
                self.editButtonTapped(item: self.items[indexPath.row])
                completion(true)
            } else {
                completion(false)
            }
        }
        
        let deleteAction = UIContextualAction(style: .normal, title: "Delete") { [weak self] (action, view, completion) in
            self?.interactor.fetchItems(.init(self?.items[indexPath.row], .delete))
            completion(true)
        }
        
        // images
        let delIcon = UIImage(systemName: "trash.fill")
        deleteAction.image = delIcon
        let editIcon = UIImage(systemName: "pencil")
        editAction.image = editIcon
        // colors
        deleteAction.backgroundColor = UIColor.red
        editAction.backgroundColor = UIColor.orange
        
        return UISwipeActionsConfiguration(actions: [deleteAction, editAction])
    }
    
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let okAction = UIContextualAction(style: .normal, title: "Take") { [weak self] (action, view, completion) in
            if var item = self?.items[indexPath.row] {
                item.taken = !item.taken
                self?.interactor.fetchItems(.init(item, .edit))
                completion(true)
            } else {
                completion(false)
            }
        }

        let okIcon = UIImage(systemName: "checkmark.circle")
        okAction.image = okIcon
        // colors
        okAction.backgroundColor = colorGreen
        
        return UISwipeActionsConfiguration(actions: [okAction])
    }
}

extension PillTableViewController: PillListDisplayLogic {
    func displayLoad(_ viewModel: PillListModels.Load.ViewModel) {
          viewModel.show ? activityIndicator.startAnimating() : activityIndicator.stopAnimating()
    }
    
    func displayAddItem(_ viewModel: PillListModels.UpdateItems.ViewModel) {
        tableView.refreshControl?.endRefreshing()
        items.append(viewModel.item)
        tableView.reloadData()
    }
    
    func displayUpdateItem(_ viewModel: PillListModels.UpdateItems.ViewModel) {
        tableView.refreshControl?.endRefreshing()
        let updatedItem = viewModel.item
        if let itemOffset = items.firstIndex(where: {$0.id == updatedItem.id}) {
            items[itemOffset] = updatedItem
        } else {
            print("OOPS; DID NOT FOUND FOR UPDATE")
        }
        tableView.reloadData()
    }
    
    func displayDeleteItem(_ viewModel: PillListModels.UpdateItems.ViewModel) {
        tableView.refreshControl?.endRefreshing()
        let deletedItem = viewModel.item
        if let itemOffset = items.firstIndex(where: {$0.id == deletedItem.id}) {
            let index: Int = items.distance(from: items.startIndex, to: itemOffset)
            let indexPath = IndexPath(item: index, section: 0)
            items.remove(at: itemOffset)
            tableView.beginUpdates()
            tableView.deleteRows(at: [indexPath], with: .middle)
            tableView.endUpdates()
        } else {
            print("OOPS; DID NOT FOUND FOR DELETE")
        }
    }

    func displayCells(_ viewModel: PillListModels.FetchItems.ViewModel) {
        tableView.refreshControl?.endRefreshing()
        items = viewModel.items
        tableView.reloadData()
    }

    func displayError(_ viewModel: PillListModels.Error.ViewModel) {
    }
}
