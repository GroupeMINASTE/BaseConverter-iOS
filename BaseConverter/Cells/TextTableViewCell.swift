//
//  TextTableViewCell.swift
//  BaseConverter
//
//  Created by Nathan FALLET on 14/08/2020.
//  Copyright © 2020 Nathan FALLET. All rights reserved.
//

import UIKit

class TextTableViewCell: UITableViewCell, BaseCell {
    
    let input = InputView()
    var base: Base?
    weak var delegate: InputChangedDelegate?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        
        contentView.addSubview(input)
        
        input.translatesAutoresizingMaskIntoConstraints = false
        input.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor).isActive = true
        input.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor).isActive = true
        input.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor).isActive = true
        input.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor).isActive = true
        input.addTargetForEditingChanged(self, action: #selector(editingChanged))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @discardableResult
    func with(base: Base, values: [Int64], source: Source, delegate: InputChangedDelegate) -> UITableViewCell {
        self.base = base
        self.delegate = delegate
        
        input.label.text = "\(base.name):"
        input.field.text = String(bytes: values.filter({ $0 > 0 && $0 <= UInt8.max }).map({ UInt8($0) }), encoding: .utf8)
        
        return self
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        if selected {
            input.field.becomeFirstResponder()
        }
    }
    
    @objc func editingChanged(_ sender: Any) {
        guard let base = base, let text = input.field.text, let input = text.data(using: .utf8) else { return }
        delegate?.inputChanged(input.map({ Int64($0) }), for: base, source: text)
    }
    
}
