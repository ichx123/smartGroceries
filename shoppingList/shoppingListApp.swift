//
//  shoppingListApp.swift
//  shoppingList
//
//  Created by Rebecca Nußbaumer on 04.04.24.
//

import SwiftUI
import SwiftData

@main
struct shoppingListApp: App {
    
    //Erstellt einen ModelContainer -> automatisch von XCode erstellt
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            ShoppingListItem.self, //Hinzufügen der Model-Klassen
            Recipe.self,
            Zutat.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        
        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
    

    
    var body: some Scene {
        WindowGroup {
            TabView {
                EinkaufslisteView()
                    .tabItem {
                        Image(systemName: "cart.fill")
                        Text("Einkaufsliste")}
                    .modelContainer(sharedModelContainer) //Fügt den Model-Container zur jeweilgen View hinzu
                
                RecipeListView()
                    .tabItem {
                        Image(systemName: "book.pages.fill")
                        Text("Rezepte")}
                    .modelContainer(sharedModelContainer)
                
                WochenplanView()
                    .tabItem {
                        Image(systemName: "calendar")
                        Text("Wochenplan")
                    }
                    .modelContainer(sharedModelContainer)
            }

        }
    }
}
