//
//  PillListDTO.swift
//  hiDementia
//
//  Created by xcode on 29.11.2021.
//

import FirebaseFirestore
import FirebaseFirestoreSwift

struct PillListItem: Codable {
    @DocumentID var id: String? = UUID().uuidString
    let name: String
    let time: String
    let quantity: Int
    let meal: String
    var taken: Bool = false
}

extension PillListItem {
    static func prototype() -> PillListItem {
        PillListItem(
            id: nil,
            name: "",
            time: "",
            quantity: 0,
            meal: "",
            taken: false
        )
    }
}
