//
//  SectionData.swift
//  hiDementia
//
//  Created by xcode on 01.12.2021.
//

struct SectionData {
     let title: String
     let data : [String]

     var numberOfItems: Int {
         return data.count
     }

     subscript(index: Int) -> String {
         return data[index]
     }

     init(title: String, data: String...) {
         self.title = title
         self.data  = data
     }
 }
