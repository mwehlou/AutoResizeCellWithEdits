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
    
    func appendItem(_ text: String) -> Item {
        let item = Item(text: text)
        items.append(item)
        return item
    }
    
    func removeItem(_ item: Item) {
        if let index = items.index(where: {currentItem -> Bool in
            return item === currentItem
        }) {
            items.remove(at: index)
        }
    }
    
    func moveItemAtIndex(_ fromIndex: Int, toIndex: Int) {
        if fromIndex == toIndex {
            return
        }
        
        let movedItem = items[fromIndex]
        items.remove(at: fromIndex)
        items.insert(movedItem, at: toIndex)
    }
}
