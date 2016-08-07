//
//  ItemStore.swift
//  AutoResizeCellWithEdits
//
//  Created by mw on 2016-07-26.
//  Copyright © 2016 mw. All rights reserved.
//

import Foundation

class ItemStore {
    var items = [Item]()
    
    func appendItem(text: String) -> Item {
        let item = Item(text: text)
        items.append(item)
        return item
    }
    
    func removeItem(item: Item) {
        if let index = items.indexOf({currentItem -> Bool in
            return item === currentItem
        }) {
            items.removeAtIndex(index)
        }
    }
    
    func moveItemAtIndex(fromIndex: Int, toIndex: Int) {
        if fromIndex == toIndex {
            return
        }
        
        let movedItem = items[fromIndex]
        items.removeAtIndex(fromIndex)
        items.insert(movedItem, atIndex: toIndex)
    }
}