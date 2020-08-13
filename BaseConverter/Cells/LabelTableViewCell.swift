//
//  LabelTableViewCell.swift
//  BaseConverter
//
//  Created by Nathan FALLET on 13/08/2020.
//  Copyright © 2020 Nathan FALLET. All rights reserved.
//

import UIKit

class LabelTableViewCell: UITableViewCell {

    let label = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(label)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor).isActive = true
        label.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor).isActive = true
        label.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor).isActive = true
        label.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor).isActive = true
        label.adjustsFontSizeToFitWidth = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func with(text: String, accessory: UITableViewCell.AccessoryType = .none) -> LabelTableViewCell {
        label.text = text
        accessoryType = accessory
        selectionStyle = accessory == .disclosureIndicator ? .default : .none
        
        return self
    }

}
