//
//  InputChangedDelegate.swift
//  BaseConverter
//
//  Created by Nathan FALLET on 14/08/2020.
//  Copyright © 2020 Nathan FALLET. All rights reserved.
//

import Foundation

protocol InputChangedDelegate: class {
    
    func inputChanged(_ value: String, for base: Base)
    
    func inputChanged(_ values: [Int64], for base: Base, source: String)
    
}
