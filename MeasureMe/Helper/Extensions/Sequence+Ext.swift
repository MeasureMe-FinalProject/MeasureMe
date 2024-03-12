//
//  Sequence+Ext.swift
//  MeasureMe
//
//  Created by Diki Dwi Diro on 12/03/24.
//

import Foundation

extension Sequence where Element: Hashable {
    func uniqued() -> [Element] {
        var set = Set<Element>()
        return filter { set.insert($0).inserted }
    }
}
