//
//  EinkaufslisteRowView.swift
//  shoppingList
//
//  Created by Rebecca Nußbaumer on 04.04.24.
//

import SwiftUI
import SwiftData

//Individuelle View für jede einzelne "Row" der Einkaufsliste
struct EinkaufslisteRowView: View {
    
    let item: ShoppingListItem
    
    var body: some View {
        
        ZStack {

                Rectangle()//Rectangle als Hintergrund
                    .foregroundColor(.clear)
                    .background(Color(red: 0.92, green: 0.92, blue: 0.92))
                    .cornerRadius(10)
                
                HStack {
                    Image(systemName: item.istGekauft ? "checkmark.circle.fill" : "circle.fill")
                        .font(.system(size: 20))
                        .padding(.trailing, 10)
                        .foregroundColor(Color(#colorLiteral(red: 0, green: 0.3826054335, blue: 0.4471401572, alpha: 1)))
                    VStack(alignment: .leading, spacing: 3){
                        Text(item.name)
                            .font(.system(size: 17, weight: .medium))
                        if item.menge != 0 { //Die Menge wird nur dann angezeigt, falls eine Menge eingegeben wurde
                            Text("\(String(format: "%.1f", item.menge)) \(item.einheit.rawValue)")
                                .font(.system(size: 13))
                                .lineSpacing(22)
                        }
                    }
                    Spacer()
                }
                .padding(.leading, 10)
                .padding(.top, 3)
                .padding(.bottom, 3)
                
        }
        .listRowBackground(Color.clear) //Ausblenden des Default-Hintergrundes
        .listRowSeparator(.hidden) //Ausblenden des Separators
    }
    
}

#Preview {
    EinkaufslisteRowView(item: ShoppingListItem(name: "Kartoffeln", menge: 1, einheit: .kg))
        
}
