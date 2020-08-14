//
//  ColorTableViewCell.swift
//  BaseConverter
//
//  Created by Nathan FALLET on 14/08/2020.
//  Copyright © 2020 Nathan FALLET. All rights reserved.
//

import UIKit

class ColorTableViewCell: UITableViewCell, UITextFieldDelegate, BaseCell {
    
    let red = InputView()
    let green = InputView()
    let blue = InputView()
    let preview = UIView()
    var base: Base?
    weak var delegate: InputChangedDelegate?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        
        let stackview = UIStackView()
        stackview.distribution = .fillEqually
        stackview.addArrangedSubview(red)
        stackview.addArrangedSubview(green)
        stackview.addArrangedSubview(blue)
        
        contentView.addSubview(stackview)
        contentView.addSubview(preview)
        
        stackview.translatesAutoresizingMaskIntoConstraints = false
        stackview.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor).isActive = true
        stackview.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor).isActive = true
        stackview.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor).isActive = true
        
        preview.translatesAutoresizingMaskIntoConstraints = false
        preview.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor).isActive = true
        preview.leadingAnchor.constraint(equalTo: stackview.trailingAnchor, constant: 4).isActive = true
        preview.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor).isActive = true
        preview.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor).isActive = true
        preview.widthAnchor.constraint(equalToConstant: 17).isActive = true
        preview.heightAnchor.constraint(equalToConstant: 17).isActive = true
        preview.layer.cornerRadius = 3
        
        red.label.text = "R:"
        green.label.text = "G:"
        blue.label.text = "B:"
        
        red.addTargetForEditingChanged(self, action: #selector(editingChanged))
        green.addTargetForEditingChanged(self, action: #selector(editingChanged))
        blue.addTargetForEditingChanged(self, action: #selector(editingChanged))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @discardableResult
    func with(base: Base, values: [Int64], source: Source, delegate: InputChangedDelegate) -> UITableViewCell {
        self.base = base
        self.delegate = delegate
        
        // Check validity of input
        if let first = values.first, values.count == 1, source.base.name == "HEX", first >= 0, source.string.count == 3 || source.string.count == 6 {
            // Extract colors
            let r: Int64
            let g: Int64
            let b: Int64
            
            // Check source length
            if source.string.count == 6 {
                // Read directly
                r = (first & 0xFF0000) >> 16
                g = (first & 0xFF00) >> 8
                b = (first & 0xFF)
            } else {
                // Read components and double them
                let rc = (first & 0xF00) >> 8
                let gc = (first & 0xF0) >> 4
                let bc = (first & 0xF)
                r = rc << 4 | rc
                g = gc << 4 | gc
                b = bc << 4 | bc
            }
            
            // Set texts
            red.field.text = String(r)
            green.field.text = String(g)
            blue.field.text = String(b)
            
            // Set preview color
            setColor(red: r, green: g, blue: b)
        } else {
            // Not valid, empty values
            red.field.text = ""
            green.field.text = ""
            blue.field.text = ""
            
            // Set preview color
            setInvalidColor()
        }
        
        return self
    }
    
    func setColor(red: Int64, green: Int64, blue: Int64) {
        preview.backgroundColor = UIColor(red: CGFloat(red) / 255, green: CGFloat(green) / 255, blue: CGFloat(blue) / 255, alpha: 1)
    }
    
    func setInvalidColor() {
        preview.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        if selected {
            red.becomeFirstResponder()
        }
    }
    
    @objc func editingChanged(_ sender: Any) {
        // Get base and values
        guard let base = base, let rtext = red.field.text, let gtext = green.field.text, let btext = blue.field.text else { return }
        
        // Check values
        if let r = Int64(rtext), let g = Int64(gtext), let b = Int64(btext), r >= 0, g >= 0, b >= 0, r <= 255, g <= 255, b <= 255 {
            // Update preview
            setColor(red: r, green: g, blue: b)
            
            // Create value
            let value = r << 16 | g << 8 | b
            
            // Update delegate
            delegate?.inputChanged([value], for: base, source: String(value, radix: 16))
        } else {
            // Set invalid color
            setInvalidColor()
            
            // Invalid values
            delegate?.inputChanged("", for: base)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return false
    }
    
}
