//
//  MyTableViewController.swift
//  AutoResizeCellWithEdits
//
//  Created by mw on 2016-07-26.
//  Copyright © 2016 mw. All rights reserved.
//

import UIKit

protocol RefreshableController {
    func refresh()
}

class MyTableViewController: UITableViewController, RefreshableController {
    
    // MARK: - Properties
    
    var store: ItemStore!

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let statusbarHeight = UIApplication.shared.statusBarFrame.height
        let inset = UIEdgeInsets(top: statusbarHeight, left: 0, bottom: 0, right: 0)
        tableView.contentInset = inset
        tableView.scrollIndicatorInsets = inset
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 300
    }

    // MARK: - Refresh table management
    
    var runningTimer: Timer? = nil
    
    func refresh() {
        if let timer = runningTimer {
            stopTimer(timer)
        }
        runningTimer = startTimer()
    }
    
    private func startTimer() -> Timer {
        NSLog("starting timer")
        return Timer.scheduledTimer(timeInterval: 0.25, target: self, selector: #selector(MyTableViewController.DoTheRefresh), userInfo: nil, repeats: false)
    }
    
    private func stopTimer(_ timer: Timer) {
        if let timer = runningTimer {
            NSLog("stopping timer")
            timer.invalidate()
            runningTimer = nil
        }
    }
    
    func DoTheRefresh(_ timer: Timer) {
        NSLog("fired timer for refresh")
        stopTimer(timer)
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    
    // MARK: - Actions
    
    @IBAction func addNewItem(_ sender: AnyObject) {
        let newItem = store.appendItem("New text")
        
        if let index = store.items.index(where: { (item) -> Bool in
            return item === newItem
        }) {
            let indexPath = IndexPath(row: index, section: 0)
            tableView.insertRows(at: [indexPath], with: .automatic)
            updateVisibleCells()
        }
    }
    
    @IBAction func toggleEditingMode(_ sender: AnyObject) {
        if isEditing {
            sender.setTitle("Edit", for: UIControlState())
            setEditing(false, animated: true)
        }
        else {
            sender.setTitle("Done", for: UIControlState())
            setEditing(true, animated: true)
        }
    }
    
    @IBAction func backgroundTapped(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    // MARK: - UITableViewDataSource
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return store.items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell") as! ItemTableCell
        let item = store.items[(indexPath as NSIndexPath).row]
        cell.controller = self
        cell.tableView = tableView
        cell.item = item
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let item = store.items[(indexPath as NSIndexPath).row]
            store.removeItem(item)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }

    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        store.moveItemAtIndex((sourceIndexPath as NSIndexPath).row, toIndex: (destinationIndexPath as NSIndexPath).row)
    }
    
    // MARK: - View functions
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NSLog("MTVC viewWillAppear")
    }
    
    // once the tableView has settled down and the width can be relied upon in the
    // table cells, we'll go through all visible table cells and make them recalculate
    // the height constraint.
    // same goes for after device rotations
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateVisibleCells()
    }
    
    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
        updateVisibleCells()
        // after rotation, the cursor has a tendency to keep indicating editing
        // even though the current view doesn't respond to typing
        // anymore. Ending editing cleans that up.
        view.endEditing(true)
    }

    func updateVisibleCells() {
        let visibleCells = self.tableView.visibleCells as! [ItemTableCell]
        
        for itemCell in visibleCells {
            itemCell.updateTextViewSize()
        }
    }
    


    
    
}
