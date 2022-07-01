//
//  QuantityPicker.swift
//  hiDementia
//
//  Created by xcode on 11.12.2021.
//

import UIKit

class QuantityPickerView: UIPickerView, UIPickerViewDataSource, UIPickerViewDelegate {
    
    var myDataSource = [1, 2, 3, 4, 5]
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return myDataSource.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print(component)
        print(row)
    }

    internal func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(myDataSource[row])"
    }
    
    func setDefault(raw: Int) {
        super.selectRow(raw, inComponent: 0, animated: false)
    }
    
}
