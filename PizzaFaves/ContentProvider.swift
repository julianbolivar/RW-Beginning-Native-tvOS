//
//  ContentProvider.swift
//  PizzaFaves
//
//  Created by Julian Bolivar on 9/05/22.
//

import TVServices

class ContentProvider: TVTopShelfContentProvider {

    override func loadTopShelfContent(completionHandler: @escaping (TVTopShelfContent?) -> Void) {
        let items = [
            createContentItem(name: "ExtraCheesy"),
            createContentItem(name: "PepperoniPizza"),
            createContentItem(name: "MightyMeaty"),
            createContentItem(name: "VeggiePizza")
        ]
        
        let sections = TVTopShelfItemCollection(items: items)
        
        let sectionedContent = TVTopShelfSectionedContent(sections: [sections])
        
        // Fetch content and call completionHandler
        completionHandler(sectionedContent)
    }
    
    func createContentItem(name: String) -> TVTopShelfSectionedItem {
        guard let imageURL = Bundle.main.url(forResource: name, withExtension: "png")
        else {
            fatalError("Error loading file URL.")
        }
        
        let itemID = "PizzaBuilder.faves.\(name)"
        let itemContent = TVTopShelfSectionedItem(identifier: itemID)
        
        itemContent.setImageURL(imageURL, for: .screenScale1x)
        itemContent.imageShape = .square
        
        var components = URLComponents()
        components.scheme = "PizzaBuilder"
        components.path = "faves"
        components.queryItems = [URLQueryItem(name: "id", value: name)]
        
        itemContent.displayAction = TVTopShelfAction(url: components.url!)
        
        return itemContent
    }
}

