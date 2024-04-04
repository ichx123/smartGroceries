//
//  AddListItem.swift
//  shoppingList
//
//  Created by Rebecca Nußbaumer on 04.04.24.
//

import SwiftUI
import SwiftData

struct AddListItem: View {
    
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var context
    
    @State private var item = ShoppingListItem() //Initialisiert ein neues Listenitem
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 5) {
            
            //Eingabefeld für Name
            VStack(alignment: .leading) {
                Text("Name")
                    .font(.system(size: 16, weight: .medium))
                TextField("Name des Produkts", text: $item.name)
                    .padding()
                    .background(Color("greyBG"))
                    .cornerRadius(8)
            }.padding(.bottom, 10)
            
            //Eingabefeld für Menge
            HStack {
                VStack(alignment: .leading) {
                    Text("Menge")
                        .font(.system(size: 16, weight: .medium))
                    TextField("Menge", value: Binding(
                        get: {
                            if item.menge == 0 {
                                return nil // Auf "nil" setzen, um den Placeholder anzuzeigen
                            } else {
                                return item.menge
                            }
                        },
                        set: { newValue in
                            item.menge = newValue ?? 0 //falls keine Menge eingegeben wird, wird die Menge wieder auf "0" gesetzt
                        }
                    ), format: .number) //Textfeld für die Menge -> SwiftData verlangt die Initialisierung von "ShoppingListItem.menge" bei der Erstellung, daher muss die Menge hier auf "nil" gesetzt werden, um den Platzhalter anzuzeigen
                    .keyboardType(.decimalPad) //zeige nur das Nummernkeyboard
                        .padding()
                        .background(Color("greyBG"))
                        .cornerRadius(8)
                }
                
                //Picker für Einheit
                VStack(alignment: .leading) {
                    Text("Einheit")
                        .font(.system(size: 16, weight: .medium))
                    Picker("Einheit", selection: $item.einheit) {
                        ForEach(Einheit.allCases, id: \.self) {
                            einheit in Text(einheit.rawValue) }
                    }
                    .padding(10)
                    .frame(width: 120)
                    .background(Color("greyBG"))
                    .cornerRadius(8)
                    .accentColor(Color.black)
                }
            }
            .padding(.bottom, 10)
            
            //Speichern-Button
            Button(action: {
                withAnimation {
                    context.insert(item) //Item wird mithilfe des ModelContext gespeichert
                }
                dismiss() //Nach dem Speichern das Sheet entfernen
            }) {
                Text("Speichern")
                    .font(.system(size: 16, weight: .bold))
                    .frame(maxWidth: .infinity)
                    .padding()
                    .foregroundColor(.white)
                    .background(Color.accentColor)
                    .cornerRadius(10)
            }
            Spacer()
        }
        .padding(20)
        .navigationTitle("Produkt hinzufügen")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationView {
        AddListItem()
            .modelContainer(for: ShoppingListItem.self)
    }
}
