//
//  MealPicker.swift
//  hiDementia
//
//  Created by xcode on 06.12.2021.
//

import UIKit

class MealPickerView: UIPickerView, UIPickerViewDataSource, UIPickerViewDelegate {
    
    var myDataSource = ["Before meal", "During meal", "After meal", "Doesn't matter"]
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return myDataSource.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return myDataSource[row]
    }
    
    func findIndex(value: String) -> Int? {
        for (index, element) in myDataSource.enumerated() {
            if (value == element) {
                return index
            }
        }
        return nil
    }
}
