//
//  OrderViewController.swift
//  RaysPizzaBuilder
//
//  Created by Julian Bolivar on 3/05/22.
//

import UIKit

class OrderViewController: UIViewController {

    @IBOutlet weak var summaryField: UITextView!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var addressField: UITextField!
    @IBOutlet weak var cityField: UITextField!
    @IBOutlet weak var stateField: UITextField!
    @IBOutlet weak var zipField: UITextField!
    @IBOutlet weak var phoneField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var creditCardField: UITextField!
    @IBOutlet weak var confirmLabel: UILabel!
    @IBOutlet weak var orderButton: UIButton!
    @IBOutlet weak var zipLabel: UILabel!
    
    var focusGuide: UIFocusGuide!
    private var isFocusLayoutConfigured = false
    
    override var preferredFocusEnvironments: [UIFocusEnvironment] {
        return summaryField.isScrollInYAxisRequired ? [summaryField] : [nameField]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showOrderSummary()
        confirmLabel.text = ""
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if isFocusLayoutConfigured == false {
            configureFocusLayout()
            isFocusLayoutConfigured = true
        }
    }
    
    private func configureFocusLayout() {
        addFocusGuide(from: cityField, to: stateField, direction: .bottom)
        addFocusGuide(from: stateField, to: zipField, direction: .bottom, debugMode: true)
        addFocusGuide(from: zipField, to: stateField, direction: .top, debugMode: true)
        
        if summaryField.isScrollInYAxisRequired {
            summaryField.isSelectable = true
            summaryField.panGestureRecognizer.allowedTouchTypes = [NSNumber(value: UITouch.TouchType.indirect.rawValue)]
            
            addFocusGuide(from: summaryField, to: nameField, direction: .right)
            addFocusGuide(from: nameField, to: summaryField, direction: .left)
            addFocusGuide(from: nameField, to: addressField, direction: .bottom)
            
            addFocusGuide(from: creditCardField, to: orderButton, direction: .bottom)
            addFocusGuide(from: orderButton, to: creditCardField, direction: .top)
        }
    }
      
    // MARK: - Actions
      
    @IBAction func orderPizza(sender: AnyObject) {
        let alertController = UIAlertController(title: "Order Pizza", message: "Place your order for pizza delivery?", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            self.confirmLabel.text = "No Pizza for You!"
        }
        
        let orderAction = UIAlertAction(title: "Submmit Pizza Order", style: .destructive) { _ in
            self.confirmLabel.text = "Thank you for your order!\nYour pizza's on it's way!"
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(orderAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        super.didUpdateFocus(in: context, with: coordinator)
        
        guard let nextFocusedView = context.nextFocusedView else { return }
        
        if nextFocusedView == summaryField {
            summaryField.layer.borderColor = UIColor.white.withAlphaComponent(0.5).cgColor
            summaryField.layer.borderWidth = 1
            summaryField.showsVerticalScrollIndicator = true
        } else {
            summaryField.layer.borderColor = UIColor.clear.cgColor
            summaryField.layer.borderWidth = 0
            summaryField.showsVerticalScrollIndicator = false
        }
    }
      
    func showOrderSummary() {
        var message = "\(crust!.info.name) \(pizzaSize!.info.name) with:\n"
        
        for index in 0..<toppings.count {
            message += "✔️ \(toppings[index].info.name)\n"
        }
            
        summaryField.text = message
        totalLabel.text = String(format: "%@%.02f", "$", total)
    }
}
