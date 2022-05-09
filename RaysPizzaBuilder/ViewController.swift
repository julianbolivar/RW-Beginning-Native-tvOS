//
//  ViewController.swift
//  RaysPizzaBuilder
//
//  Created by Julian Bolivar on 2/05/22.
//

import UIKit
import AVFoundation
import AVKit

class ViewController: UIViewController {
    
    @IBOutlet weak var choicesSegment: UISegmentedControl!
    @IBOutlet weak var pizzaTableView: UITableView!
    @IBOutlet weak var pizzaImage: UIImageView!
    @IBOutlet weak var theWorksButton: UIButton!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var aboutButton: UIButton!
    @IBOutlet weak var orderButton: UIButton!
    
    var tableSection = TableSection.Size
    
    var viewToFocus: UIView? = nil {
        didSet {
            if viewToFocus != nil {
                self.setNeedsFocusUpdate()
                self.updateFocusIfNeeded()
            }
        }
    }
    
    override var preferredFocusEnvironments: [UIFocusEnvironment] {
        
        if let viewTarget = viewToFocus {
            return [viewTarget]
        }
        
        return [aboutButton]
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(showFavoritePizza(notification:)), name: NSNotification.Name(rawValue: "ShowFaveNotification"), object: nil)
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(aboutPizzaBuilder(sender:)))
        tapRecognizer.allowedPressTypes = [NSNumber(value: UIPress.PressType.playPause.rawValue)]
        self.view.addGestureRecognizer(tapRecognizer)
        
        let swipeRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(startOver))
        swipeRecognizer.direction = .left
        self.view.addGestureRecognizer(swipeRecognizer)
        
        configureChoicesSegment()
        createPizzaImage()
        calculatePizzaTotal()
        theWorksButton.isEnabled = false
        orderButton.isEnabled = false
    }
    
    func configureChoicesSegment() {
        let segmentBackgroundImage = UIImage(named: "Segment_background")
        choicesSegment.setBackgroundImage(segmentBackgroundImage, for: .normal, barMetrics: .default)
    }
    
    // MARK: - Actions
    
    @IBAction func crustOrToppings(sender: UISegmentedControl) {
        tableSection = TableSection(rawValue: sender.selectedSegmentIndex)!
        pizzaTableView.reloadData()
        theWorksButton.isEnabled = sender.selectedSegmentIndex == 2
    }
    
    @IBAction func theWorks(sender: AnyObject) {
        
        let alertController = UIAlertController(title: "The Works", message: "  Are you sure you want all toppings on your pizza?", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "No", style: .cancel, handler: nil)
        let acceptAction = UIAlertAction(title: "Yes", style: .destructive) { _ in
            toppings = [Toppings]()
            for index in 0..<13 {
                toppings.append(Toppings(rawValue: index)!)
            }
            self.updatePizza()
            self.orderButton.isEnabled = true
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(acceptAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func aboutPizzaBuilder(sender: Any) {
        let videoAddress = "http://www.rwdevcon.com/videos/Ray-Wenderlich-Teamwork.mp4"
        guard let videoUrl = URL(string: videoAddress) else {
            print("problem with the video url!")
            return
        }
        let player = AVPlayer(url: videoUrl)
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        
        present(playerViewController, animated: true) {
            playerViewController.player!.play()
        }
    }

    // MARK: - Pizza Builder
    
    @objc func startOver() {
        let isFocusOnTableView = UIScreen.main.focusedView?.isKind(of: UITableViewCell.self) == true
        if tableSection != .Toppings || !isFocusOnTableView {
            return
        }
        
        let alert = UIAlertController(title: "Start Over", message: "Remove all toppings and start fresh?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Si", style: .destructive, handler: { action in
            toppings = [Toppings]()
            self.updatePizza()
            let initialIndexPath = IndexPath(row: 0, section: 0)
            self.pizzaTableView.scrollToRow(at: initialIndexPath, at: .top, animated: false)
            self.viewToFocus = self.choicesSegment
            self.orderButton.isEnabled = false
        }))
        
        present(alert, animated: true, completion: nil)
    }
    
    func selectPizzaSize(_ item: PizzaSize) {
        pizzaSize = item
        self.pizzaTableView.reloadData()
        calculatePizzaTotal()
    }
    
    func selectCrust(_ item: Crust) {
      crust = item
      self.pizzaTableView.reloadData()
      calculatePizzaTotal()
    }
    
    func addTopping(_ item: Toppings) {
      toppings.append(item)
      calculatePizzaTotal()
        orderButton.isEnabled = true
    }
    
    func removeTopping(_ item: Toppings) {
        guard let topping = toppings.firstIndex(of: item) else { return }
        toppings.remove(at: topping)
        calculatePizzaTotal()
        
        orderButton.isEnabled = toppings.count > 0
    }
    
    func createPizzaImage() {
        let imageSize = CGSize(width: 888, height: 888)
        let baseImage = UIImage(named: "PizzaBase")
        UIGraphicsBeginImageContextWithOptions(imageSize, false, 1.0)
        baseImage?.draw(at: CGPoint.zero)
      
      // Composite Toppings
      for index in 0..<toppings.count {
            let toppingImage = UIImage(named: toppings[index].info.name)
            toppingImage?.draw(at: CGPoint.zero)
      }
      
      let finalPizza = UIGraphicsGetImageFromCurrentImageContext()
      UIGraphicsEndImageContext()
      
      pizzaImage.image = finalPizza
    }
    
    func calculatePizzaTotal() {
      total = pizzaSize!.info.price
      total += crust!.info.price
      
      for index in 0..<toppings.count {
        let price = toppings[index].info.price
        total += price
      }
      
      totalLabel.text = String(format: "%@%.02f", "$", total)
    }
    
    func updatePizza() {
        createPizzaImage()
        pizzaTableView.reloadData()
        calculatePizzaTotal()
    }
    
    @objc func showFavoritePizza(notification: Notification) {
        guard
            let userInfo = notification.userInfo,
            let favePizza = userInfo["Fave"] as? String
        else {
            return
        }
        
        if favePizza.contains("ExtraCheesy") {
            toppings = [Toppings.Cheese]
        }
        
        if favePizza.contains("PepperoniPizza") {
            toppings = [Toppings.Cheese, Toppings.Pepperoni]
        }
        
        if favePizza.contains("MightyMeaty") {
            toppings = [Toppings.Cheese, Toppings.Pepperoni, Toppings.Ham, Toppings.Chicken, Toppings.Sausage]
        }
        
        if favePizza.contains("VeggiePizza") {
            toppings = [Toppings.Cheese, Toppings.Pineapple, Toppings.Pepperoncini, Toppings.Mushroom, Toppings.BellPepper, Toppings.Onion, Toppings.BlackOlive]
        }
        
        choicesSegment.selectedSegmentIndex = 2
        viewToFocus = choicesSegment
        orderButton.isEnabled = true
        
        crustOrToppings(sender: choicesSegment)
        updatePizza()
    }
}

extension ViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableSection {
        case .Size:
            return 4
        case .Crust:
            return 3
        case .Toppings:
            return 13
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PizzaStuff", for: indexPath)
        
        if tableSection == .Size {
            cell.textLabel?.text = PizzaSize(rawValue: indexPath.item)?.info.name
            let price = String(format: "%@%.02f", "$", (PizzaSize(rawValue: indexPath.item)?.info.price)!)
            cell.detailTextLabel?.text = price
            
            cell.accessoryType = pizzaSize == PizzaSize(rawValue: indexPath.item)
                ? .checkmark
                : .none
        }
        
        if tableSection == .Crust {
            cell.textLabel?.text = Crust(rawValue: indexPath.item)?.info.name
            let price = String(format: "%@%.02f", "$", (Crust(rawValue: indexPath.item)?.info.price)!)
            cell.detailTextLabel?.text = price

            cell.accessoryType = crust == Crust(rawValue: indexPath.item)
                ? .checkmark
                : .none
        }
        
        if tableSection == .Toppings {
            cell.textLabel?.text = Toppings(rawValue: indexPath.item)?.info.name
            let price = String(format: "%@%.02f", "$", (Toppings(rawValue: indexPath.item)?.info.price)!)
            cell.detailTextLabel?.text = price
            
            cell.accessoryType = toppings.count > 0 && toppings.contains(Toppings(rawValue: indexPath.item)!)
                ? .checkmark
                : .none
        }
        
        return cell
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableSection == .Size {
            let item = PizzaSize(rawValue: indexPath.item)!
            selectPizzaSize(item)
        }
        
        if tableSection == .Crust {
            selectCrust(Crust(rawValue: indexPath.item)!)
        }
        
        if tableSection == .Toppings {
            let cell = tableView.cellForRow(at: indexPath)
            
            if cell!.accessoryType == UITableViewCell.AccessoryType.none {
                cell!.accessoryType = UITableViewCell.AccessoryType.checkmark
                addTopping(Toppings(rawValue: indexPath.item)!)
            }
            else if  cell!.accessoryType == UITableViewCell.AccessoryType.checkmark {
                cell!.accessoryType = UITableViewCell.AccessoryType.none
                removeTopping(Toppings(rawValue: indexPath.item)!)
            }
            
            createPizzaImage()
        }
    }
    
    func tableView(_ tableView: UITableView, canFocusRowAt indexPath: IndexPath) -> Bool {
        
        if tableSection == .Size {
            if pizzaSize == PizzaSize(rawValue: indexPath.item)! {
                return false
            }
        }
        
        if tableSection == .Crust {
            if crust == Crust(rawValue: indexPath.item)! {
                return false
            }
        }
        
        return true
    }
}
