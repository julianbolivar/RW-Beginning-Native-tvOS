//
//  UIViewController.swift
//  RaysPizzaBuilder
//
//  Created by Julian Bolivar on 7/05/22.
//

import UIKit

extension UIViewController {
    func addFocusGuide(from origin: UIView, to destination: UIView, direction: UIRectEdge, debugMode: Bool = false) {
        let focusGuide = UIFocusGuide()
        view.addLayoutGuide(focusGuide)
        
        focusGuide.preferredFocusEnvironments = [destination]
        focusGuide.widthAnchor.constraint(equalTo: origin.widthAnchor).isActive = true
        focusGuide.heightAnchor.constraint(equalTo: origin.heightAnchor).isActive = true
        
        switch direction {
        case .bottom:
            focusGuide.topAnchor.constraint(equalTo: origin.bottomAnchor).isActive = true
            focusGuide.leftAnchor.constraint(equalTo: origin.leftAnchor).isActive = true
            
        case .top:
            focusGuide.bottomAnchor.constraint(equalTo: origin.topAnchor).isActive = true
            focusGuide.leftAnchor.constraint(equalTo: origin.leftAnchor).isActive = true
            
        case .left:
            focusGuide.topAnchor.constraint(equalTo: origin.topAnchor).isActive = true
            focusGuide.rightAnchor.constraint(equalTo: origin.leftAnchor).isActive = true
            
        case .right:
            focusGuide.topAnchor.constraint(equalTo: origin.topAnchor).isActive = true
            focusGuide.leftAnchor.constraint(equalTo: origin.rightAnchor).isActive = true
            
        default:
            break
        }
        
        if debugMode {
            view.addSubview(FocusGuideDebugView(focusGuide: focusGuide))
        }
    }
}

class FocusGuideDebugView: UIView {
    
    init(focusGuide: UIFocusGuide) {
        super.init(frame: focusGuide.layoutFrame)
        backgroundColor = UIColor.green.withAlphaComponent(0.15)
        layer.borderColor = UIColor.green.withAlphaComponent(0.3).cgColor
        layer.borderWidth = 1
    }
    
    required init?(coder: NSCoder) {
        return nil
    }
}
