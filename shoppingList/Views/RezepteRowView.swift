//
//  RezepteRowView.swift
//  shoppingList
//
//  Created by Rebecca Nußbaumer on 06.04.24.
//

import SwiftUI

struct RezepteRowView: View {
    
    let item: Recipe
    
    var body: some View {
        
            ZStack {
                
                Rectangle() //Hintergrund der Row
                    .foregroundColor(.clear)
                    .background(Color("greyBG"))
                    .cornerRadius(10)
                
                //Falls ein Bild für das Rezept hinterlegt wurde, zeige dieses als Hintergrund an und lege ein dunkelgrünes Overlay darüber
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
                
                //Name des Rezeptes
                HStack {
                    VStack(alignment: .leading, spacing: 3){
                        Text(item.name)
                            .font(.system(size: 17, weight: .medium))
                            .foregroundColor(item.image != nil ? Color.white : Color.black) //Ändere die Schriftfarbe, wenn ein Bild vorhanden ist
                        
                    }
                    Spacer()
                    
                    //Bei Tippen auf die Row wird die EditRecipe-View geöffnet
                    ZStack(alignment: .trailing) {
                        NavigationLink(destination: EditRecipe(item: item)) {
                            EmptyView() // blendet den Default-Pfeil aus
                        }
                        .opacity(0.0)
                        
                        Image(systemName: "ellipsis.circle")
                            .font(.system(size: 20))
                            .padding(.trailing, 20)
                            .foregroundColor(item.image != nil ? Color.white : Color.accentColor)
                    }
                    
                }
                .padding(.leading, 10)
                .padding(.top, 3)
                .padding(.bottom, 3)
                
            }
            .listRowBackground(Color.clear) //Blendet den Default-Hintergrund aus
            .listRowSeparator(.hidden) //Blendet den Default-Hintergrund aus
    
        }
        
    }

#Preview {
    RezepteRowView(item: Recipe(name: "Spaghetti Bolognese", category: .fleisch, zutaten: []))
}
