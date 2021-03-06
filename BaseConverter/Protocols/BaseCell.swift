//
//  BaseCell.swift
//  BaseConverter
//
//  Created by Nathan FALLET on 14/08/2020.
//  Copyright © 2020 Nathan FALLET. All rights reserved.
//

import UIKit

protocol BaseCell: AnyObject {
    
    var base: Base? { get }
    
    @discardableResult
    func with(base: Base, values: [Int64], source: Source, delegate: InputChangedDelegate) -> UITableViewCell
    
}
