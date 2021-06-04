//
//  DIsabledPasteboardTextField.swift
//  Noter
//
//  Created by jorjyb0i on 27.01.2021.
//

import UIKit

class DisabledPasteboardTextField: UITextField {
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        return false
    }
    
    override func selectionRects(for range: UITextRange) -> [UITextSelectionRect] {
        return []
    }
}
