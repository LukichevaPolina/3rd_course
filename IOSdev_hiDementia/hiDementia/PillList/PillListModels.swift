//
//  PillListModels.swift
//  hiDementia
//
//  Created by xcode on 29.11.2021.
//

enum PillListModels {
    
    enum ItemAction {
        case all
        case add
        case delete
        case edit

    }
    
    enum Error {
          struct Request {}
          struct Response {
              //let type: ErrorType
              let title: String
          }
          struct ViewModel {
              //let type: ErrorType
              let title: String
          }
      }
    
    enum ErrorType {

     }
    
    enum Load {
         struct Request {}
         struct Response {
             let show: Bool
         }
         struct ViewModel {
             let show: Bool
         }
     }
    
    enum UpdateItems {
         struct Request {}
         struct Response {
             let item: PillListItem
         }
         struct ViewModel{
             let item: PillListItem
         }
     }

     enum FetchItems {
         struct Request {
             let item: PillListItem?
             let action: ItemAction

             init(_ item: PillListItem? = nil, _ action: ItemAction) {
                 self.action = action
                 self.item = item
             }
         }
         struct Response {
             let items: [PillListItem]
         }
         struct ViewModel {
             let items: [PillListItem]
         }
        }

}
