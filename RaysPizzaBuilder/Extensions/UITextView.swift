//
//  UITextView.swift
//  RaysPizzaBuilder
//
//  Created by Julian Bolivar on 9/05/22.
//

import UIKit

extension UITextView {
    var isScrollInYAxisRequired: Bool {
        return self.frame.size.height < self.contentSize.height
    }
}
