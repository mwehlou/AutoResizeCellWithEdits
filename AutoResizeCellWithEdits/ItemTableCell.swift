//
//  ItemTableCell.swift
//  AutoResizeCellWithEdits
//
//  Created by mw on 2016-07-26.
//  Copyright © 2016 mw. All rights reserved.
//

import UIKit


class ItemTableCell: UITableViewCell, UITextViewDelegate {

    // MARK: - Outlets
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    
    // MARK: - Properties
    
    var item: Item? {
        didSet {
            textView.text = (item != nil) ? item!.text : ""
            updateTextViewSize()
        }
    }
    
    // called from the tableView controller just once after the table
    // view has appeared, to set the initial constraints
    
    func updateTextViewSize() {
        let height = calculateHeightOfTextView(textView, forText: textView.text)
        updateConstraintIfNeeded(height)
    }
    
    // MARK: - Delegates
    
    var controller: RefreshableController?
    var tableView: UITableView?
    
    // MARK: - Instance variables
    
    var oldHeight: CGFloat = 0.0
    
    // MARK: - Text view delegate
    
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
    
        // this delegate function doesn't seem to get triggered by forward delete, only regular backward delete
        // OTOH, there is no forward delete on iPhones, so maybe it doesn't matter?

        let newText = buildChangedText(textView.text, range: range, replacementText: text)
        let newHeight = calculateHeightOfTextView(textView, forText: newText)
        updateConstraintIfNeeded(newHeight)
        
        makeCursorPositionVisible()
        
        item?.text = newText
        
        return true
    }
    
    

    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        addDoneButtonToKeyboard(textView)
        return true
    }
    
    // MARK: - Done button

    
    func addDoneButtonToKeyboard(_ textView: UITextView) {
        let doneToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
        doneToolbar.barStyle = .blackTranslucent
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(ItemTableCell.doneButtonPressed))
        doneToolbar.setItems([space, doneButtonItem], animated: false)
        doneToolbar.sizeToFit()
        textView.inputAccessoryView = doneToolbar
        NSLog("added done")
    }
    
    func doneButtonPressed(_ sender: UIBarButtonItem) {
        textView.resignFirstResponder()
    }
    
    // MARK: - Overrides
    
    override func didTransition(to state: UITableViewCellStateMask) {
        super.didTransition(to: state)
        updateTextViewSize()
    }
    
    // MARK: - Helper functions
    
    private func buildChangedText(_ oldText: String, range nsRange: NSRange, replacementText: String) -> String {
        
        guard let range = oldText.rangeFromNSRange(nsRange) else {
            return oldText
        }
        let newText = oldText.replacingCharacters(in: range, with: replacementText)
        
        return newText
    }
    
    // find out where the curson is and make sure it's within
    // the visible area of the tableView
    // else typing a long text in a growing textView tends
    // to let the cursor position slip behind the keyboard
    
    private func makeCursorPositionVisible() {
        if let textRange = textView.selectedTextRange {
            let textPosition = textRange.end
            let caretRect = textView.caretRect(for: textPosition)
            if let caretRectInTableView = tableView?.convert(caretRect, from: textView) {
                let adjustedRect = CGRect(x: caretRectInTableView.minX, y: caretRectInTableView.minY, width: caretRectInTableView.width, height: caretRectInTableView.height + tableView!.contentInset.top)
                NSLog("top inset: \(tableView!.contentInset.top)")
                // the scroll actually looks better to me without animation,
                // but YMMV
                tableView!.scrollRectToVisible(adjustedRect, animated: false)
                NSLog("scroll to visible")
            }
        }
    }
    
    private func calculateHeightOfTextView(_ textView: UITextView, forText text: String) -> CGFloat {
        
        // if we fail, simply return the old height instead
        guard let font = textView.font else {
            return textView.contentSize.height
        }
        
        let attributes = [NSFontAttributeName: font]
        let options: NSStringDrawingOptions = [.usesFontLeading, .usesLineFragmentOrigin]
        let lineLength = getLineLengthOfTextView(textView)
        let startSize = CGSize(width: lineLength, height: CGFloat.greatestFiniteMagnitude)
        
        let newRect = text.boundingRect(with: startSize,
                                                options: options,
                                                attributes: attributes,
                                                context: nil)
        
        let textInset = textView.textContainerInset
        let newHeight = newRect.size.height + textInset.top + textInset.bottom

        return newHeight
    }
    
    private func getLineLengthOfTextView(_ textView: UITextView) -> CGFloat {
        
        let width = textView.contentSize.width
        let padding = textView.textContainer.lineFragmentPadding
        let lineLength = width - 2 * padding
        
        return lineLength
    }
    
    private func updateConstraintIfNeeded(_ newHeight: CGFloat) {
        
        if (oldHeight != newHeight) {
            oldHeight = newHeight
            heightConstraint.constant = newHeight
            controller?.refresh()
        }
    }

}
