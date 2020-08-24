//
//  Base.swift
//  BaseConverter
//
//  Created by Nathan FALLET on 13/08/2020.
//  Copyright © 2020 Nathan FALLET. All rights reserved.
//

import Foundation

struct Base {
    
    static let dec = Base(id: 1, name: "DEC", value: 10, cell: .base)
    static let bin = Base(id: 2, name: "BIN", value: 2, cell: .base)
    static let oct = Base(id: 3, name: "OCT", value: 8, cell: .base)
    static let hex = Base(id: 4, name: "HEX", value: 16, cell: .base)
    static let rgb = Base(id: 5, name: "RGB", value: 16, cell: .color)
    static let txt = Base(id: 6, name: "TXT", value: 16, cell: .text)

    let id: Int
    let name: String
    let value: Int
    let cell: CellType
    
}
