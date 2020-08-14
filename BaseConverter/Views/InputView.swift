//
//  InputView.swift
//  BaseConverter
//
//  Created by Nathan FALLET on 14/08/2020.
//  Copyright © 2020 Nathan FALLET. All rights reserved.
//

import UIKit

class InputView: UIView, UITextFieldDelegate {
    
    let label = UILabel()
    let field = UITextField()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(label)
        addSubview(field)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.topAnchor.constraint(equalTo: topAnchor).isActive = true
        label.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        label.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor).isActive = true
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        label.setContentHuggingPriority(.required, for: .horizontal)
        label.adjustsFontSizeToFitWidth = true
        label.font = UIFont(name: "Courier", size: 17)
        
        field.translatesAutoresizingMaskIntoConstraints = false
        field.topAnchor.constraint(equalTo: topAnchor).isActive = true
        field.leadingAnchor.constraint(equalTo: label.trailingAnchor, constant: 4).isActive = true
        field.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        field.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        field.setContentCompressionResistancePriority(.required, for: .horizontal)
        field.font = UIFont(name: "Courier", size: 17)
        field.autocapitalizationType = .none
        field.returnKeyType = .done
        field.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addTargetForEditingChanged(_ target: Any?, action: Selector) {
        field.addTarget(target, action: action, for: .editingChanged)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return false
    }
    
}
