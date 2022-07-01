//
//  AddItemVC.swift
//  hiDementia
//
//  Created by xcode on 01.12.2021.
//

import UIKit

final class AddItemVC: UIViewController {
    
    private lazy var time = String("15:00")
    
    private lazy var blurredView: UIView = {
        let containerView = UIView()
        let blurEffect = UIBlurEffect(style: .light)
        let customBlurEffectView = CustomVisualEffectView(blurEffect, intensity: 0.2)
        customBlurEffectView.frame = self.view.bounds
        let dimmedView = UIView()
        dimmedView.backgroundColor = .black.withAlphaComponent(0.6)
        dimmedView.frame = self.view.bounds
        containerView.addSubview(customBlurEffectView)
        containerView.addSubview(dimmedView)
        return containerView
    }()
    
    private lazy var nameStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            nameLabel,
            nameTextField
        ])
        stack.axis = .vertical
        return stack
    }()
    
    private lazy var quantityStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            quantityLabel,
            quantityPickerView
        ])
        stack.axis = .vertical
        return stack
    }()
    
    private lazy var timeStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            timeTextField,
            timePicker,
        ])
        stack.axis = .horizontal
        stack.distribution = .equalSpacing
        return stack
    }()
    
    private lazy var vStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            nameStackView,
            quantityStackView,
            timeStackView,
            mealPickerView,
            hStackView
        ])
        stack.layoutMargins = UIEdgeInsets(top: 16, left: 16, bottom: 0, right: 16)
        stack.isLayoutMarginsRelativeArrangement = true
        stack.axis = .vertical
        stack.spacing = 4
        stack.distribution = .equalSpacing
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.backgroundColor = .systemBackground
        stack.clipsToBounds = true
        stack.layer.cornerRadius = 16
        stack.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        return stack
    }()
    
    private lazy var hStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            sendButton
        ])
        stack.axis = .horizontal
        stack.distribution = .equalSpacing
        stack.alignment = .center
        stack.spacing = 4
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.text = "Pill's name:"
        return label
    }()
    
    private lazy var nameTextField: UITextField = {
        let textField = UITextField()
        if let item = self.defaultItem {
            textField.text = item.name
        }
        textField.backgroundColor = .secondarySystemBackground
        return textField
    }()
    
    private lazy var quantityLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.text = "Pill's quantity:"
        return label
    }()
    
    private lazy var quantityPickerView: QuantityPickerView = {
        let picker = QuantityPickerView()
        if let item = self.defaultItem {
            picker.selectRow(3, inComponent: 0, animated: false)
            print("SELECTED: ", picker.selectedRow(inComponent: 0))
        }
        picker.frame = CGRect(x: 0, y: 50, width: self.view.frame.width, height: 80)
        return picker
    }()
    
    private lazy var timeTextField: UILabel = {
        let textField = UILabel()
        textField.text = "Time of tacking pill:"
        return textField
    }()
    
    private lazy var timePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .time
        if let item = self.defaultItem {
            time = item.time
        }
        // default value
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        if let date = dateFormatter.date(from: time) {
            picker.date = date
        }
        // set format
        picker.locale = Locale(identifier: "en_GB")
        // UI
        picker.frame = CGRect(x: 0, y: 50, width: self.view.frame.width, height: 80)
        picker.addTarget(self, action: #selector(self.getTimeFromPicker(sender:)), for: UIControl.Event.valueChanged)
        return picker
    }()
    
    @objc
    private func getTimeFromPicker(sender: UIDatePicker) {
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:mm"
        time = timeFormatter.string(from: timePicker.date)
    }
    
    private lazy var mealPickerView: MealPickerView = {
        let picker = MealPickerView()
        if let item = self.defaultItem {
            if let index = picker.findIndex(value: item.meal) {
                picker.selectRow(index, inComponent: 0, animated: false)
            }
        }
        picker.frame = CGRect(x: 0, y: 50, width: self.view.frame.width, height: 80)
        return picker
    }()
    
    private lazy var sendButton: UIButton = {
        let button = UIButton()
        if let item = self.defaultItem {
            button.setTitle("Update pill", for: .normal)
        } else {
            button.setTitle("Add pill", for: .normal)
        }
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 16
        button.setTitleColor(UIColor.white, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(
            self,
            action: #selector(sendBtnPressed),
            for: .touchUpInside
        )
        return button
    }()
    
    private var bottomLayoutConstraint: NSLayoutConstraint?
    
    private let callback: (PillListItem) -> Void
    
    private let defaultItem: PillListItem?
    
    init(_ defaultItem: PillListItem?, _ callback: @escaping (PillListItem) -> Void) {
        self.callback = callback
        self.defaultItem = defaultItem
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameTextField.becomeFirstResponder()
        
        mealPickerView.dataSource = mealPickerView
        mealPickerView.delegate = mealPickerView
        
        quantityPickerView.dataSource = quantityPickerView
        quantityPickerView.delegate = quantityPickerView
        
        setupUI()
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIApplication.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIApplication.keyboardWillHideNotification,
            object: nil
        )
    }
    
    private func setupUI() {
        let tap = UITapGestureRecognizer(
            target: self,
            action: #selector(dismissTap)
        )
        view.addGestureRecognizer(tap)
        
        view.backgroundColor = .clear
        view.addSubview(blurredView)
        view.sendSubviewToBack(blurredView)
        view.addSubview(vStackView)
        NSLayoutConstraint.activate([
            vStackView.rightAnchor.constraint(equalTo: view.rightAnchor),
            vStackView.leftAnchor.constraint(equalTo: view.leftAnchor)
        ])
        bottomLayoutConstraint = vStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        bottomLayoutConstraint?.isActive = true
        hStackView.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
    
    @objc
    private func sendBtnPressed() {
        if (defaultItem == nil){
            let item = PillListItem(
                name: nameTextField.text ?? "Undefined",
                time: time,
                quantity: quantityPickerView.myDataSource[quantityPickerView.selectedRow(inComponent: 0)],
                meal: mealPickerView.myDataSource[mealPickerView.selectedRow(inComponent: 0)]
            )
            self.dismiss(animated: true)
            callback(item)
        } else {
            let item = PillListItem(
                id: defaultItem!.id,
                name: nameTextField.text ?? "Undefined",
                time: time,
                quantity: quantityPickerView.myDataSource[quantityPickerView.selectedRow(inComponent: 0)],
                meal: mealPickerView.myDataSource[mealPickerView.selectedRow(inComponent: 0)]
            )
            self.dismiss(animated: true)
            callback(item)
        }
        
    }
    
    
    
    @objc
    private func dismissTap() {
        dismiss(animated: true)
    }
}

extension AddItemVC {
    
    private func setButtonConstraint(offset: CGFloat) {
        if let constraint = bottomLayoutConstraint {
            view.removeConstraint(constraint)
        }
        bottomLayoutConstraint = vStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -offset)
        bottomLayoutConstraint?.isActive = true
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        guard
            let info = notification.userInfo,
            let keyboardSize = (info[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
        else {
            return
        }
        setButtonConstraint(offset: keyboardSize.height)
        view.layoutIfNeeded()
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        setButtonConstraint(offset: 0)
        view.layoutIfNeeded()
    }
}

