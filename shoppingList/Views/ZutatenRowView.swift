//
//  ZutatenRowView.swift
//  shoppingList
//
//  Created by Rebecca Nußbaumer on 09.04.24.
//

import SwiftUI
import SwiftData

//Individuelle View für jede einzelne "Row" von Zutaten
struct ZutatenRowView: View {
    
    let zutat: Zutat
    
    var body: some View {
        ZStack {
            
            Rectangle() //Rectangle als Hintergrund
                .foregroundColor(.clear)
                .background(Color(red: 0.92, green: 0.92, blue: 0.92))
                .cornerRadius(10)
            
            HStack {
                VStack(alignment: .leading, spacing: 3){
                    Text(zutat.name)
                        .font(.system(size: 17, weight: .medium))
                    if zutat.menge != 0 { //Menge wird nur angezeigt, falls eine Menge eingegeben wurde
                        Text("\(String(format: "%.1f", zutat.menge)) \(zutat.einheit.rawValue)")
                            .font(.system(size: 13))
                            .lineSpacing(22)
                    }
                }
                .padding(.leading, 20)
                Spacer()
            }
        
        }
        .listRowBackground(Color.clear) // Ausblenden des Default-Hintergrundes
        .listRowSeparator(.hidden) //Separator ausblenden

    }
    
}
    
    #Preview {
        ZutatenRowView(zutat: Zutat(name: "Eis", menge: 2, einheit: .pkg))
    }
