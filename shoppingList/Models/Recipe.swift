//
//  Recipe.swift
//  shoppingList
//
//  Created by Rebecca Nußbaumer on 06.04.24.
//

import Foundation
import SwiftData


@Model
final class Recipe: Identifiable {
    var id: String
    var name: String
    var category: Rezeptkategorie
    
    @Attribute(.externalStorage) //Speichert das Bild nicht direkt in der Datenbank von SwiftData
    var image: Data?
    
    @Relationship(deleteRule: .cascade) //Legt fest, dass alle zugehörigen "Zutaten"-Objekte gelöscht werden, sollte das Rezept gelöscht werden
    var zutaten: [Zutat]?
    
    init(name: String = "", category: Rezeptkategorie = .none, zutaten: [Zutat] = [] ) {
        self.id = UUID().uuidString
        self.name = name
        self.category = category
        self.zutaten = zutaten
    }
}

@Model
final class Zutat: Identifiable {
    var id: String
    var name: String
    var menge: Double
    var einheit: Einheit
    
    //Muss mit konrekten Werten initialisiert werden, um den Error "Missing BackingData" bei der Nutzung von SwiftData zu verhindern
    init(name: String = "", menge: Double = 0, einheit: Einheit = .kg) {
        self.id = UUID().uuidString
        self.name = name
        self.menge = menge
        self.einheit = einheit
    }
    
    // Funktion, um eine Zutat zum Typ "ShoppingListItem" umzuwandeln
    func convertToListItem(zutat: Zutat) -> ShoppingListItem {
        let listItem = ShoppingListItem(name: zutat.name, menge: zutat.menge, einheit: zutat.einheit)
        return listItem
    }
}

enum Rezeptkategorie: String, Codable, CaseIterable, Identifiable {
    var id: Self {self}
    case nudeln = "Nudelgerichte"
    case kartoffeln = "Kartoffelgerichte"
    case reis = "Reisgerichte"
    case suppen = "Suppen & Eintöpfe"
    case sues = "Süße Hauptgerichte"
    case huelsenfruechte = "Hülsenfrüchte"
    case fleisch = "Fleisch- und Fischgerichte"
    case none = "Keine"
}

