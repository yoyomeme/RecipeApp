//
//  RecipeTypesParser.swift
//  RecipeApp
//
//  Created by Melon on 1/3/2024.
//

import Foundation
import SwiftUI

class RecipeTypeParser: NSObject, XMLParserDelegate {
    var recipeTypes: [RecipeType] = []
    var currentElement = ""
    var currentName = ""
    var currentId = 0

    func parseRecipeTypes(xmlData: Data) -> [RecipeType] {
        let parser = XMLParser(data: xmlData)
        parser.delegate = self
        parser.parse()
        return recipeTypes
    }

    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        currentElement = elementName
        if elementName == "RecipeType" {
            if let id = attributeDict["id"], let idInt = Int(id) {
                currentId = idInt
            }
        }
    }

    func parser(_ parser: XMLParser, foundCharacters string: String) {
        if currentElement == "Name" {
            currentName += string
        }
    }

    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "RecipeType" {
            let recipeType = RecipeType(id: currentId, name: currentName.trimmingCharacters(in: .whitespacesAndNewlines))
            recipeTypes.append(recipeType)
            currentName = ""
            currentId = 0
        }
    }
    
   
    
}
