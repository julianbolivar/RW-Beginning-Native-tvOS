//
//  PizzaData.swift
//  RaysPizzaBuilder
//
//  Created by Julian Bolivar on 2/05/22.
//

import Foundation

// MARK: - PizzaSize
enum PizzaSize: Int {
  case Small = 0
  case Medium
  case Large
  case ExtraLarge
  
  var info: (name: String, price: Double) {
    let data: [(String, Double)] = [
      ("Small 10\" Pizza", 6.50),
      ("Medium 12\" Pizza", 8.50),
      ("Large 14\" Pizza", 10.50),
      ("Extra Large 16\" Pizza", 12.50)
    ]
    
    return data[rawValue]
  }
}

// MARK: - Crust
enum Crust: Int {
  case Regular = 0
  case ThinCrust
  case DeepDish
  
  var info: (name: String, price: Double) {
    let data: [(String, Double)] = [
      ("Regular", 0.00),
      ("Thin Crust", 0.00),
      ("Deep Dish", 1.00)
    ]
    
    return data[rawValue]
  }
}

// MARK: - Toppings
enum Toppings: Int {
  case Cheese = 0
  case Pepperoni
  case Ham
  case Chicken
  case Sausage
  case Anchovy
  case Onion
  case BellPepper
  case Mushroom
  case BlackOlive
  case Jalapeno
  case Pepperoncini
  case Pineapple
  
  var info: (name: String, price: Double) {
    let data: [(String, Double)] = [
      ("Cheese", 1.50),
      ("Pepperoni", 1.50),
      ("Ham", 1.50),
      ("Chicken", 1.50),
      ("Sausage", 1.50),
      ("Anchovy", 1.50),
      ("Onion", 0.50),
      ("Bell Pepper", 0.50),
      ("Mushroom", 0.75),
      ("Black Olive", 0.50),
      ("Jalapeno", 0.50),
      ("Pepperoncini", 0.50),
      ("Pineapple", 0.50)
    ]
    
    return data[rawValue]
  }
}

// MARK: - TableSection
enum TableSection: Int {
  case Size = 0
  case Crust
  case Toppings
}

// MARK: - Global vars
var toppings = [Toppings]()
var pizzaSize = PizzaSize(rawValue: 0)
var crust = Crust(rawValue: 0)
var total = 0.00
