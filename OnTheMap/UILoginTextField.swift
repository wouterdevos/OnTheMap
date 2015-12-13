//
//  UILoginTextField.swift
//  OnTheMap
//
//  Created by Wouter de Vos on 2015/12/12.
//  Copyright © 2015 Wouter. All rights reserved.
//

import UIKit

class UILoginTextField: UITextField {

    let inset : CGFloat = 10

    override func textRectForBounds(bounds: CGRect) -> CGRect {
        return CGRectInset(bounds, inset, 0)
    }
    
    override func editingRectForBounds(bounds: CGRect) -> CGRect {
        return CGRectInset(bounds, inset, 0)
    }
}
