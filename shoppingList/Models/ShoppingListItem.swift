//
//  Item.swift
//  shoppingList
//
//  Created by Rebecca Nußbaumer on 04.04.24.
//

import Foundation
import SwiftData

@Model
final class ShoppingListItem: Identifiable {
    var id: String
    var name: String
    var menge: Double
    var einheit: Einheit
    var istGekauft: Bool
    var creationDate: Date
    
    //Muss mit konrekten Werten initialisiert werden, um den Error "Missing BackingData" bei der Nutzung von SwiftData zu verhindern
    init(name: String = "", menge: Double = 0, einheit: Einheit = .kg) {
        self.id = UUID().uuidString
        self.name = name
        self.menge = menge
        self.einheit = einheit
        self.istGekauft = false
        self.creationDate = .now //Fügt das aktuelle Datum hinzu, um nach Erstellungsdatum sortieren zu können
    }
}


enum Einheit: String, Codable, CaseIterable, Identifiable {
    var id: Self {self}
    case kg = "kg"
    case pkg = "Pkg."
    case l = "l"
    case stk = "Stk."
}

