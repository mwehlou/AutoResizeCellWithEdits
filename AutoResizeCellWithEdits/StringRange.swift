//
//  StringRange.swift
//  tftest
//
//  Created by mw on 2016-07-24.
//  Copyright © 2016 mw. All rights reserved.
//

import UIKit

extension String {
    func rangeFromNSRange(nsRange: NSRange) -> Range<String.Index>? {
        let from16 = utf16.startIndex.advancedBy(nsRange.location, limit: utf16.endIndex)
        let to16 = from16.advancedBy(nsRange.length, limit: utf16.endIndex)
        if let from = String.Index(from16, within: self), to = String.Index(to16, within: self) {
            return from ..< to
        }
        return nil
    }
    
    func NSRangeFromRange(range: Range<String.Index>) -> NSRange {
        let from = String.UTF16View.Index(range.startIndex, within: utf16)
        let to = String.UTF16View.Index(range.endIndex, within: utf16)
        return NSMakeRange(utf16.startIndex.distanceTo(from), from.distanceTo(to))
    }
    
}