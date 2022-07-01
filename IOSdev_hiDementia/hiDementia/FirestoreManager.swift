//
//  FirestoreManager.swift
//  hiDementia
//
//  Created by xcode on 27.11.2021.
//

import FirebaseFirestore

protocol FirestoreManagerProtocol: AnyObject {
    func read(completion: @escaping (Result<[PillListItem], Error>) -> Void)
    func addItem(
        _ item: PillListItem,
        merge: Bool,
        completion: @escaping (Result<Bool, Error>) -> Void
    )
    func deleteItem(
        _ item: PillListItem,
        completion: @escaping (Result<Bool, Error>) -> Void
    )
}

final class FirestoreManager: FirestoreManagerProtocol {

    enum Collection: String {
        case pillList = "PillList"
    }

    private let db = Firestore.firestore()
    private let collection: Collection

    init(_ collection: Collection) {
        self.collection = collection
    }

    func read(completion: @escaping (Result<[PillListItem], Error>) -> Void) {
//        if let items = UserDefaults.standard.value(forKey: collection.rawValue) as? [ToDoListItem] {
//            completion(.success(items))
//        }
        db.collection(collection.rawValue).getDocuments { [weak self] snapshot, error in
            if let error = error {
                DispatchQueue.main.async { completion(.failure(error)) }
            }
            let items = snapshot?.documents.compactMap { document -> PillListItem? in
                try? document.data(as: PillListItem.self)
            }
            //UserDefaults.standard.set(items, forKey: self?.collection.rawValue ?? "")
            DispatchQueue.main.async { completion(.success(items ?? [])) }
        }
    }

    func addItem(_ item: PillListItem, merge: Bool, completion: @escaping (Result<Bool, Error>) -> Void) {
        do {
            try db.collection(collection.rawValue).document(item.id ?? "").setData(from: item, merge: merge) { error in
                if let error = error {
                    DispatchQueue.main.async { completion(.failure(error)) }
                }
                DispatchQueue.main.async { completion(.success(true)) }
            }
        } catch let error {
            DispatchQueue.main.async { completion(.failure(error)) }
        }
    }

    func deleteItem(_ item: PillListItem, completion: @escaping (Result<Bool, Error>) -> Void) {
        db.collection(collection.rawValue).document(item.id ?? "").delete() { error in
            if let error = error {
                DispatchQueue.main.async { completion(.failure(error)) }
            }
            DispatchQueue.main.async { completion(.success(true)) }
        }
    }
}
