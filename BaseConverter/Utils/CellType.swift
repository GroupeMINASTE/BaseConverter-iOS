//
//  CellType.swift
//  BaseConverter
//
//  Created by Nathan FALLET on 24/08/2020.
//  Copyright © 2020 Nathan FALLET. All rights reserved.
//

import Foundation

struct CellType {
    
    static let base = CellType(id: "baseCell", processor: { base, values, source in
        // Calculate values
        var value = values.map({ String($0, radix: base.value, uppercase: true) }).joined(separator: " ")
        
        // Some checks
        if base.id == 4 && source.base.id == 5 {
            // Add 0 while lenght is not ok
            while value.count < 6 {
                value = "0\(value)"
            }
        }
        
        // Return it
        return [value]
    })
    
    static let color = CellType(id: "colorCell", processor: { base, values, source in
        if let first = values.first, values.count == 1, source.base.id == 4, first >= 0, source.string.count == 3 || source.string.count == 6 {
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
            return [String(r), String(g), String(b)]
        }
        
        // Not valid, empty values
        return []
    })
    
    static let text = CellType(id: "textCell", processor: { base, values, source in
        // Map bytes to text
        return [String(bytes: values.filter({ $0 > 0 && $0 <= UInt8.max }).map({ UInt8($0) }), encoding: .utf8) ?? ""]
    })
    
    let id: String
    let processor: (_ base: Base, _ values: [Int64], _ source: Source) -> [String]
    
}
