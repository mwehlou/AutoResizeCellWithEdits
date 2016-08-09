//
//  StringRange.swift
//  tftest
//
//  Created by mw on 2016-07-24.
//  Copyright © 2016 mw. All rights reserved.
//

import UIKit

extension String {
    func rangeFromNSRange(_ nsRange: NSRange) -> Range<String.Index>? {
        
        guard
            let from16 = utf16.index(utf16.startIndex, offsetBy: nsRange.location, limitedBy: utf16.endIndex),
            let to16 = utf16.index(from16, offsetBy: nsRange.length, limitedBy: utf16.endIndex),
            let from = String.Index(from16, within: self),
            let to = String.Index(to16, within: self)
        else {
            return nil
        }
        return from ..< to
    }
    
    func NSRangeFromRange(_ range: Range<String.Index>) -> NSRange {
        let utf16view = self.utf16
        let from = range.lowerBound.samePosition(in: utf16view)
        let to = range.upperBound.samePosition(in: utf16view)
        let distanceToFrom = utf16view.distance(from: utf16view.startIndex, to: from)
        let distanceBetweenFromAndTo = utf16view.distance(from: from, to: to)
        let nsRange = NSMakeRange(distanceToFrom, distanceBetweenFromAndTo)
        return nsRange
    }
    
}
