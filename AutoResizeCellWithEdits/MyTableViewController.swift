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
        
        let statusbarHeight = UIApplication.sharedApplication().statusBarFrame.height
        let inset = UIEdgeInsets(top: statusbarHeight, left: 0, bottom: 0, right: 0)
        tableView.contentInset = inset
        tableView.scrollIndicatorInsets = inset
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 300
    }

    // MARK: - Refresh table management
    
    var runningTimer: NSTimer? = nil
    
    func refresh() {
        if let timer = runningTimer {
            stopTimer(timer)
        }
        runningTimer = startTimer()
    }
    
    private func startTimer() -> NSTimer {
        NSLog("starting timer")
        return NSTimer.scheduledTimerWithTimeInterval(0.25, target: self, selector: #selector(MyTableViewController.DoTheRefresh), userInfo: nil, repeats: false)
    }
    
    private func stopTimer(timer: NSTimer) {
        if let timer = runningTimer {
            NSLog("stopping timer")
            timer.invalidate()
            runningTimer = nil
        }
    }
    
    func DoTheRefresh(timer: NSTimer) {
        NSLog("fired timer for refresh")
        stopTimer(timer)
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    
    // MARK: - Actions
    
    @IBAction func addNewItem(sender: AnyObject) {
        let newItem = store.appendItem("New text")
        
        if let index = store.items.indexOf({ (item) -> Bool in
            return item === newItem
        }) {
            let indexPath = NSIndexPath(forRow: index, inSection: 0)
            tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
            updateVisibleCells()
        }
    }
    
    @IBAction func toggleEditingMode(sender: AnyObject) {
        if editing {
            sender.setTitle("Edit", forState: .Normal)
            setEditing(false, animated: true)
        }
        else {
            sender.setTitle("Done", forState: .Normal)
            setEditing(true, animated: true)
        }
    }
    
    @IBAction func backgroundTapped(sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    // MARK: - UITableViewDataSource
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return store.items.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ItemCell") as! ItemTableCell
        let item = store.items[indexPath.row]
        cell.controller = self
        cell.tableView = tableView
        cell.item = item
        return cell
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            let item = store.items[indexPath.row]
            store.removeItem(item)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
        }
    }

    override func tableView(tableView: UITableView, moveRowAtIndexPath sourceIndexPath: NSIndexPath, toIndexPath destinationIndexPath: NSIndexPath) {
        store.moveItemAtIndex(sourceIndexPath.row, toIndex: destinationIndexPath.row)
    }
    
    // MARK: - View functions
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        NSLog("MTVC viewWillAppear")
    }
    
    // once the tableView has settled down and the width can be relied upon in the
    // table cells, we'll go through all visible table cells and make them recalculate
    // the height constraint.
    // same goes for after device rotations
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        updateVisibleCells()
    }
    
    override func didRotateFromInterfaceOrientation(fromInterfaceOrientation: UIInterfaceOrientation) {
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