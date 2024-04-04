//
//  WochenplanRowView.swift
//  shoppingList
//
//  Created by Rebecca Nußbaumer on 08.04.24.
//

import SwiftUI

struct WochenplanRowView: View {
    
    let item: Recipe
    
    var body: some View {
        
            ZStack {
                
                //Rectangle als Hintergrund
                Rectangle()
                    .foregroundColor(.clear)
                    .background(Color("greyBG"))
                    .cornerRadius(10)
                
                //Wenn ein Bild ausgewählt wurde, zeige dieses als Hintergrund an und überlagere dieses mit einem grünen, transparenten Rechteck
                if let image = item.image,
                   let uiImage = UIImage(data: image) {
                    Image(uiImage: uiImage)
                        .resizable(resizingMode: .stretch)
                        .aspectRatio(contentMode: .fill)
                        .frame(height: 60.0)
                        .cornerRadius(10)
                        .overlay {
                            Rectangle()
                                .foregroundColor(Color((#colorLiteral(red: 0, green: 0.4309850335, blue: 0.3999060988, alpha: 0.48))))
                            .cornerRadius(10)}
                }
                
                //Rezept-Name
                HStack {
                    VStack(alignment: .leading, spacing: 3){
                        Text(item.name)
                            .font(.system(size: 17, weight: .medium))
                            .foregroundColor(item.image != nil ? Color.white : Color.black) //Wenn ein Bild ausgewählt wurde, zeige den Text in weiß an
                    }
                    Spacer()
                }
                .padding(.leading, 10)
                .padding(.top, 3)
                .padding(.bottom, 3)
                
                //Bei Klick auf die Reihe leite zur EditRecipe-View, um die Rezeptdetails anzuzeigen
                NavigationLink(destination: EditRecipe(item: item)) {
                    EmptyView() // Blende den Default-Pfeil für den NavigationLink aus
                }
                .opacity(0.0)
                
            }
            .listRowBackground(Color.clear) //Ausblenden des Default-Hintergrundes
            .listRowSeparator(.hidden) //Ausblenden des Separators
    
        }
        
    }

#Preview {
    WochenplanRowView(item: Recipe(name: "Spaghetti Bolognese", category: .fleisch, zutaten: []))
}
