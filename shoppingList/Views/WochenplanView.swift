//
//  WochenplanView.swift
//  shoppingList
//
//  Created by Rebecca Nußbaumer on 05.04.24.
//

import SwiftUI
import SwiftData

struct WochenplanView: View {
    
    
    @Query private var recipes: [Recipe]
    @Query private var items: [ShoppingListItem]
    
    @State private var showConfirmation: Bool = false
    @State var randomNudelgericht: Recipe?
    @State var randomKartoffelgericht: Recipe?
    @State var randomReisgericht: Recipe?
    @State var randomFleischgericht: Recipe?
    @State var randomSuppengericht: Recipe?
    @State var randomSuessgericht: Recipe?
    @State var randomHuelsengericht: Recipe?
    
    @State var recipesInMealPlan: [Recipe] = []
    
    
    @Environment(\.modelContext) var context
    
    var body: some View {
        
        NavigationView {
            VStack{
                
                //Header
                HStack {
                    Text("Wochenplan")
                        .font(.system(size: 20, weight: .medium))
                        .padding(.bottom, 20)
                    Spacer()
                    
                }
                .padding([.top, .leading,. trailing], 20)
                
                //Buttons zum Erstellen eines Wochenplans und zum Hinzufügen der Zutaten zur Einkaufsliste
                HStack {
                    //Neuer Wochenplan - Button
                    ZStack(alignment: .leading) {
                        Rectangle() //Grünes Rechteck als Hintergrund
                            .foregroundColor(.clear)
                            .frame(height: 100)
                            .background(Color(red: 0, green: 0.36, blue: 0.33))
                            .cornerRadius(10)
                
                        Image(systemName: "arrow.triangle.2.circlepath") //Bild für die Gestaltung des Buttons
                            .foregroundColor((Color.white.opacity(0.7)))
                            .font(.system(size: 50))
                            .offset(x: 125, y: 30)
                        Button(action: {
                            generateMealPlan() //Ruft die Funktion auf, um aus den vorhandenen Rezepten zufällig ein Rezept pro Kategorie auszuwählen
                        }, label: {
                            Text("Neuer automatischer Wochenplan")
                                .multilineTextAlignment(.leading)
                        })
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.white)
                        .padding(.leading, 10)
                    }
                    
                    // Zutaten zur Einkaufsliste - Button
                    ZStack(alignment: .leading) {
                        Rectangle() //Grünes Rechteck als Hintergrund
                            .foregroundColor(.clear)
                            .frame(height: 100)
                            .background(Color(red: 0, green: 0.36, blue: 0.33))
                            .cornerRadius(10)
                            
                        Image(systemName: "cart.fill") //Bild zur Gestaltung des Buttons
                            .foregroundColor((Color.white.opacity(0.7)))
                            .font(.system(size: 50))
                            .offset(x: 120, y: 30)
                        Button(action: {
                            for recipe in recipesInMealPlan { //Iteriert durch die Rezepte, die vorher durch die Funktion "generateMealPlan" zum Array hinzugefügt wurden
                                addToList(for: recipe) //Fügt alle Zutaten des Rezeptes zur Einkaufsliste hinzu
                            }
                            showConfirmation = true // Setzt die Variable, um einen kurzen Hinweis anzuzeigen, dass die Zutaten zur Liste hinzugefügt wurden
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                showConfirmation = false //Sorgt dafür, dass der Hinweis nach 1 Sekunde wieder ausgeblendet wird
                            }
                        }, label: {
                            Text("Zutaten zur Einkaufsliste hinzufügen")
                                .multilineTextAlignment(.leading)
                        })
                        .padding(.leading, 10)
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.white)
                    }
                }
                .padding([.leading, .trailing], 20)
                .padding(.bottom, 10)
                
                //Liste mit Rezepten
                VStack {
                    
                    //Wenn Rezepte generiert wurden, zeige diese in einer Liste an
                    if !recipesInMealPlan.isEmpty { List {
                        Section("Nudelgericht") {
                            if let randomNudelgericht {
                                WochenplanRowView(item: randomNudelgericht) //Zeige die individuelle Row-View für das Rezept an
                            } else {
                                Text("Noch kein Rezept vorhanden.") //Falls kein Rezept in dieser Kategorie vorhanden ist, zeige einen Hinweis als Text
                            }
                        }
                        Section("Kartoffelgericht") {
                            if let randomKartoffelgericht {
                                WochenplanRowView(item: randomKartoffelgericht)
                            } else {
                                Text("Noch kein Rezept vorhanden.")
                            }
                        }
                        Section("Reisgericht") {
                            if let randomReisgericht {
                                WochenplanRowView(item: randomReisgericht)
                            } else {
                                Text("Noch kein Rezept vorhanden.")
                            }
                        }
                        Section("Fleisch- oder Fischgericht") {
                            if let randomFleischgericht {
                                WochenplanRowView(item: randomFleischgericht)
                            } else {
                                Text("Noch kein Rezept vorhanden.")
                            }
                        }
                        Section("Suppen und Eintöpfe") {
                            if let randomSuppengericht {
                                WochenplanRowView(item: randomSuppengericht)
                            } else {
                                Text("Noch kein Rezept vorhanden.")
                            }
                        }
                        Section("Süßes Hauptgericht") {
                            if let randomSuessgericht {
                                WochenplanRowView(item: randomSuessgericht)
                            } else {
                                Text("Noch kein Rezept vorhanden.")
                            }
                        }
                        Section("Hülsenfrüchte") {
                            if let randomHuelsengericht {
                                WochenplanRowView(item: randomHuelsengericht)
                                
                            } else {
                                Text("Noch kein Rezept vorhanden.")
                            }
                        }
                        
                    }.scrollContentBackground(.hidden) //Default-Hintergrund ausblenden
                            .padding([.leading, .trailing], -15)
                            .environment(\.defaultMinListRowHeight, 70) //Row-Height auf 70 setzen
                        
                    } else { // Falls noch kein Wochenplan generiert wurde, zeige einen Hinweis für den Nutzer
                        VStack {
                            Text("Noch kein Wochenplan erstellt.")
                                .multilineTextAlignment(.center)
                                .padding(.bottom, 15)
                            Text("Tippe auf den Button, um einen neuen Wochenplan zu erstellen.")
                                .multilineTextAlignment(.center)
                            
                            Spacer()
                        }
                        .padding(20)
                    }
                }
            }
            .overlay( // Wenn "showConfirmation" auf true gesetzt ist, zeige einen Overlay in der Mitte der gesamten View
                VStack {
                    if showConfirmation {
                        Rectangle()
                            .foregroundColor(Color.gray.opacity(0.8)) // Grauer Hintergrund
                            .cornerRadius(10)
                            .frame(width: 200, height: 100)
                            .overlay( //Text des Hinweises
                                Text("Zutaten erfolgreich zur Einkaufliste hinzugefügt")
                                    .foregroundColor(.white)
                                    .font(.system(size: 16, weight: .bold))
                            )
                    }
                }
            )
        }
    }
}

// Benötigte Funktionen dieser View

extension WochenplanView {
    
    //Funktion, um einen automatischen Wochenplan aus den vorhandenen Rezepten zu erstellen
    func generateMealPlan() {
        
        recipesInMealPlan = [] //Setze das Array wieder auf ein leeres Array, um es im Anschluss mit neuen Rezepten füllen zu können
        
        if let randomNudelgericht = recipes.filter({ $0.category == .nudeln }).randomElement() { //Filtere aus den vorhanden Rezepten die Nudelgerichte heraus und wähle ein zufälliges Rezept aus
            self.randomNudelgericht = randomNudelgericht
            self.recipesInMealPlan.append(randomNudelgericht) //Füge das ausgewählte Rezept dem Array hinzu, um später die Zutaten der Einkaufsliste hinzufügen zu können
        }
        if let randomSuppengericht = recipes.filter({ $0.category == .suppen }).randomElement() {
            self.randomSuppengericht = randomSuppengericht
            self.recipesInMealPlan.append(randomSuppengericht)
        }
        if let randomKartoffelgericht = recipes.filter({ $0.category == .kartoffeln }).randomElement() {
            self.randomKartoffelgericht = randomKartoffelgericht
            self.recipesInMealPlan.append(randomKartoffelgericht)
        }
        if let randomReisgericht = recipes.filter({ $0.category == .reis }).randomElement() {
            self.randomReisgericht = randomReisgericht
            self.recipesInMealPlan.append(randomReisgericht)
        }
        if let randomFleischgericht = recipes.filter({ $0.category == .fleisch }).randomElement() {
            self.randomFleischgericht = randomFleischgericht
            self.recipesInMealPlan.append(randomFleischgericht)
        }
        if let randomSuessgericht = recipes.filter({ $0.category == .sues }).randomElement() {
            self.randomSuessgericht = randomSuessgericht
            self.recipesInMealPlan.append(randomSuessgericht)
        }
        if let randomHuelsengericht = recipes.filter({ $0.category == .huelsenfruechte }).randomElement() {
            self.randomHuelsengericht = randomHuelsengericht
            self.recipesInMealPlan.append(randomHuelsengericht)
        }
        
    }
    
    //Funktion, um die Zutaten der Einkaufsliste hinzuzufügen
    func addToList(for recipe: Recipe) {
        if let zutaten = recipe.zutaten {
            for zutat in zutaten {
                if let existingItemIndex = items.firstIndex(where: { $0.name == zutat.name && $0.einheit == zutat.einheit}) {
                    // Wenn bereits ein ShoppingListItem mit den gleichen Eigenschaften vorhanden ist, aktualisiere die Menge, statt ein neues anzulegen
                    items[existingItemIndex].menge += zutat.menge }
                else {
                    let neuesListenItem: ShoppingListItem = zutat.convertToListItem(zutat: zutat) //Aus dem Zutaten-Objekt ein ShoppingListItem erstellen
                    context.insert(neuesListenItem)
                    try? context.save() //Verhindert den Fehler, dass doppelte Items entstehen, wenn in der aktuellen Rezepte-Liste Zutaten mehrmals vorkommen
                }
            }
        }
    }
    
}



#Preview {
    WochenplanView()
}

