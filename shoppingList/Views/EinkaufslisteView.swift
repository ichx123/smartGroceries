//
//  EinkaufslisteView.swift
//  shoppingList
//
//  Created by Rebecca Nußbaumer on 04.04.24.
//

import SwiftUI
import SwiftData

//Erster View in der App
//Zeigt eine Einkaufliste mit den aktuellen Listenitems und einen Button, um neue Items hinzuzufügen

struct EinkaufslisteView: View {
    
    @Environment(\.modelContext) private var context //Context, um Veränderugnen im Model speichern zu können
    
    @Query(sort: \ShoppingListItem.creationDate, order: .reverse) private var items: [ShoppingListItem] //Ruft die gesamten gespeicherten ShoppingListItems aus der Datenbank ab, sortiert sie nach Erstellungsdatum
    
    @State private var showDetails = false //Variable, um die Präsentation des Sheets zu steuern
    @State private var itemToEdit: ShoppingListItem?
    
    var body: some View {
        
        NavigationStack {
            
            VStack {
                //Header mit Edit-Button
                HStack {
                    Text("Einkaufsliste")
                        .font(.system(size: 20, weight: .medium))
                    Spacer()
                    EditButton() //Damit kann die Liste bearbeitet werden
                }
                .padding([.top, .leading,. trailing], 20)
                
                //Einkaufliste mit einem Floating-Button
                ZStack { // wird verwendet, um einen Button über der Liste anzeigen zu können
                    List {
                        ForEach(items) {item in
                            EinkaufslisteRowView(item: item) // Zeigt das individuelle Row-Design für die Einkaufslistenitems an
                                .onTapGesture {
                                    item.istGekauft = !item.istGekauft
                                    if item.istGekauft == true {
                                        deleteItem(item)
                                    }
                                } // fügt eine Tap-Gesture hinzu, um das Item mit einem Tap als "gekauft" zu markieren und gleichzeitig aus der Liste zu löschen
                                .swipeActions {
                                    Button(role: .destructive) { // Swipe-Action zum Löschen des Items
                                        
                                        withAnimation {
                                            context.delete(item)
                                        }
                                        
                                    } label: {
                                        Label("Löschen", systemImage: "trash")
                                    }
                                    Button { //Swipe-Action zum Editieren des Listenitems
                                        itemToEdit = item //Setzt die Variable auf das aktuelle Listenitem, um das passende "Sheet" aufzurufen
                                    } label: {
                                        Label("Bearbeiten", systemImage: "square.and.pencil")
                                    }
                                    .tint(Color.accentColor)
                                }
                        }
                        .onDelete { indexes in
                            for index in indexes {
                                deleteItem(items[index])
                            }
                        }// muss zusätzlich implementiert werden, um das Löschen der Listenitems über den "Bearbeiten"-Button im Header zu ermöglichen
                    }
                    .scrollContentBackground(.hidden) // enfernt den Default-Hintergrund (grau) der Liste
                    .listStyle(.grouped)
                    .environment(\.defaultMinListRowHeight, 70) // setzt die Mindesthöhe der Listenitems auf 70
                    
                    // Floating-Button, um ein neues Item hinzuzufügen
                    VStack {
                        Spacer()
                        // Button
                        Button(action: {
                            showDetails.toggle() //setzt die Variable für das Präsentieren des Sheets für das Hinzufügen der Items auf true
                        }, label: {
                            ZStack() {
                                Ellipse() //Runder, grüner Kreis mit Schatten als Hintergrund
                                    .foregroundColor(Color(red: 0, green: 0.36, blue: 0.33))
                                    .frame(width: 70, height: 70)
                                    .shadow(
                                        color: Color(red: 0, green: 0, blue: 0, opacity: 0.25), radius: 4, y: 4
                                    )
                                Image(systemName: "plus") //Plus-Icon
                                    .font(.system(size: 25, weight: .bold))
                                    .foregroundColor(.white)
                            }
                        })
                        .padding(.bottom, 40) //Gesamter Z-Stack 40 vom unteren Rand entfernen, um die Tabbar nicht zu überdecken
                    }
                    
                }
         //Sheet, das die AddListItem-View präsentiert, um schnell ein neues Listenitem hinzufügen zu können -> wird mithilfe der Variable "showDetails" über den Floating-Button gesteuert
            }.sheet(isPresented: $showDetails, content: {
                NavigationStack {
                    AddListItem()
                }
                .presentationDetents([.medium])
            })
            //Sheet, dass die UpdateEinkaufslisteItem-View präsentiert, um das Listenitem bearbeiten zu können -> wird mithilfe der Swipe-Action gesteuert
            .sheet(item: $itemToEdit) {
                itemToEdit = nil
            } content: { item in
                NavigationStack {
                    UpdateEinkaufslisteItem(item: item)
                }.presentationDetents([.medium])
            }
        }
    }
}

extension EinkaufslisteView {
    
    //Funktion, um ein Item aus der Liste zu löschen
    func deleteItem(_ item: ShoppingListItem) {
        context.delete(item)
        
    }
    
}

#Preview {
    TabView {
        EinkaufslisteView()
            .tabItem {
                Image(systemName: "cart.fill")
                Text("Einkaufsliste")}
        
        Text("RecipeListView")
            .tabItem {
                Image(systemName: "book.pages.fill")
                Text("Rezepte")}
        
        Text("Wochenplan")
            .tabItem {
                Image(systemName: "calendar")
                Text("Wochenplan")
            }
    }
    
    
    
}





