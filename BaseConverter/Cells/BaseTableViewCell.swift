//
//  BaseTableViewCell.swift
//  BaseConverter
//
//  Created by Nathan FALLET on 10/12/2018.
//  Copyright © 2018 Nathan FALLET. All rights reserved.
//

import UIKit

class BaseTableViewCell: UITableViewCell, UITextFieldDelegate {
    
    let label = UILabel()
    let field = UITextField()
    var base: Base?
    weak var delegate: InputChangedDelegate?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        
        contentView.addSubview(label)
        contentView.addSubview(field)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor).isActive = true
        label.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor).isActive = true
        label.bottomAnchor.constraint(lessThanOrEqualTo: contentView.layoutMarginsGuide.bottomAnchor).isActive = true
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        label.setContentHuggingPriority(.required, for: .horizontal)
        label.adjustsFontSizeToFitWidth = true
        label.font = UIFont(name: "Courier", size: 17)
        
        field.translatesAutoresizingMaskIntoConstraints = false
        field.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor).isActive = true
        field.leadingAnchor.constraint(equalTo: label.trailingAnchor, constant: 4).isActive = true
        field.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor).isActive = true
        field.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor).isActive = true
        field.setContentCompressionResistancePriority(.required, for: .horizontal)
        field.font = UIFont(name: "Courier", size: 17)
        field.autocapitalizationType = .none
        field.returnKeyType = .done
        field.delegate = self
        field.addTarget(self, action: #selector(editingChanged), for: .editingChanged)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @discardableResult
    func with(base: Base, value: Int64?, delegate: InputChangedDelegate) -> BaseTableViewCell {
        self.base = base
        self.delegate = delegate
        
        label.text = "\(base.name):"
        
        if let value = value {
            field.text = String(value, radix: base.value, uppercase: true)
        } else {
            field.text = ""
        }
        
        return self
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        if selected {
            field.becomeFirstResponder()
        }
    }
    
    @objc func editingChanged(_ sender: Any) {
        guard let base = base, let input = field.text else { return }
        delegate?.inputChanged(input, for: base)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        field.endEditing(true)
        return false
    }
    
}

protocol InputChangedDelegate: class {
    
    func inputChanged(_ value: String, for base: Base)
    
}
