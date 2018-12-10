//
//  TableViewCell.swift
//  BaseConverter
//
//  Created by Nathan FALLET on 10/12/2018.
//  Copyright © 2018 Nathan FALLET. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var value: UITextField!
    var tableViewController: TableViewController!
    var power = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func convert(_ sender: Any) {
        var number = 0
        let parse = value.text!
        
        if !parse.isEmpty {
            for i in 1...parse.count {
                let c = Array(parse)[parse.count-i]
                let c2 = min(getValue(for: Character(String(c).uppercased())), power-1)
                number += c2 * NSDecimalNumber(decimal: pow(Decimal(power), i-1)).intValue
            }
        
            tableViewController.apply(number: number)
        }
    }
    
    func getValue(for str: Character) -> Int {
        switch str {
            case "1":
                return 1
            case "2":
                return 2
            case "3":
                return 3
            case "4":
                return 4
            case "5":
                return 5
            case "6":
                return 6
            case "7":
                return 7
            case "8":
                return 8
            case "9":
                return 9
            case "A":
                return 10
            case "B":
                return 11
            case "C":
                return 12
            case "D":
                return 13
            case "E":
                return 14
            case "F":
                return 15
            default:
                return 0
        }
    }
    
}
