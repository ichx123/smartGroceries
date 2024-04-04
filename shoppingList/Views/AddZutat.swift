//
//  AddZutat.swift
//  shoppingList
//
//  Created by Rebecca Nußbaumer on 08.04.24.
//

import SwiftUI

struct AddZutat: View {
    
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var context
    
    @State private var item = Zutat() //Erstellt eine neue Zutat
    
    @Bindable var recipe: Recipe //Stellt die Verbindung zum jeweiligen Rezept her
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 5) {
            
            //Name des Produkts
            VStack(alignment: .leading) {
                Text("Name")
                    .font(.system(size: 16, weight: .medium))
                TextField("Name des Produkts", text: $item.name)
                    .padding()
                    .background(Color("greyBG"))
                    .cornerRadius(8)
            }.padding(.bottom, 10)
            
            //Menge des Produkts
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
                    ), format: .number)
                        .padding()
                        .background(Color("greyBG"))
                        .cornerRadius(8)
                        .keyboardType(.decimalPad)//zeige nur das Nummernkeyboard
                    //Textfeld für die Menge -> SwiftData verlangt die Initialisierung von "Zutat.menge" bei der Erstellung, daher muss die Menge hier auf "nil" gesetzt werden, um den Platzhalter anzuzeigen
                }
                
                //Picker für die Einheit
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
        
            //Zutat speichern und zum Zutaten-Array des Rezeptes hinzufügen
            Button(action: {
                withAnimation {
                    context.insert(item) // Zutat-Objekt speichern
                    recipe.zutaten?.append(item) //Zutat-Objekt zum Array des Rezeptes hinzufügen
                }
                dismiss() //Zutaten-Sheet wieder schließen
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
        .navigationTitle("Zutat hinzufügen")
        .navigationBarTitleDisplayMode(.inline)
    }
}

/*
#Preview {
    AddZutat()
}
*/
