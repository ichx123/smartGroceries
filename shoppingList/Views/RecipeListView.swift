//
//  RecipeListView.swift
//  shoppingList
//
//  Created by Rebecca Nußbaumer on 05.04.24.
//

import SwiftUI
import SwiftData

struct RecipeListView: View {
    
    @Environment(\.modelContext) private var context
    @Query private var items: [Recipe]

    
    var body: some View {
        
        NavigationView {
            VStack {
                
                //Header mit Edit-Button
                HStack {
                    Text("Rezepte")
                        .font(.system(size: 20, weight: .medium))
                    Spacer()
                    EditButton()
                }
                .padding([.top, .leading,. trailing], 20)
                
                //Rezepte-Liste
                ZStack {
                    List {
                            ForEach(items) {item in
                                RezepteRowView(item: item) //Ruft die individuelle Row-View für die Rezepteliste auf
                                    
                            }
                            .onDelete { indexes in
                                for index in indexes {
                                deleteItem(items[index])
                                } //ermöglicht das Löschen der Rezepte per Swipe-Action und über den "Edit"-Button
                            }
                    }
                    .scrollContentBackground(.hidden) // blendet den Hintergrund der Liste aus
                    .listStyle(.grouped)
                    .environment(\.defaultMinListRowHeight, 70) // Setzt die Höhe der einzelnen Rows auf 70
                    
                    FloatingAddButton(addDestination: AddRecipe()) // Fügt einen Floating-Button hinzu, um zur AddRecipe-View zu gelangen
                }
            }
        }
    }
 
}

extension RecipeListView {
    
    //Funktion, um Rezepte zu löschen
    func deleteItem(_ item: Recipe) {
        context.delete(item)
        
    }
    
}

    #Preview {
        TabView {
            RecipeListView()
                .tabItem {
                    Image(systemName: "book.pages.fill")
                    Text("Rezepte")}
            EinkaufslisteView()
                .tabItem {
                    Image(systemName: "cart.fill")
                    Text("Einkaufsliste")}
            
            WochenplanView()
                .tabItem {
                    Image(systemName: "calendar")
                    Text("Wochenplan")
                }
        }
        
        
        
    }
