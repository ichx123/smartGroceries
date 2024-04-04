//
//  FloatingAddButton.swift
//  shoppingList
//
//  Created by Rebecca Nußbaumer on 05.04.24.
//

import SwiftUI

// Button, um ein neues Rezept anlegen zu können
struct FloatingAddButton<Content>: View where Content: View {
    
    
    let addDestination: Content //Variable, um die Destination für den NavigationLink flexibel ändern zu können

    var body: some View {
        
        VStack {
            Spacer()
    
            NavigationLink(destination: addDestination, label: {
                ZStack() {
                    Ellipse() //Runder, grüner Kreis mit Schatten als Hintergrund
                        .foregroundColor(Color(red: 0, green: 0.36, blue: 0.33))
                        .frame(width: 70, height: 70)
                        .shadow(color: Color(red: 0, green: 0, blue: 0, opacity: 0.25), radius: 4, y: 4)
                    Image(systemName: "plus") //Plus-Icon
                        .font(.system(size: 25, weight: .bold))
                        .foregroundColor(.white)
                }
                .padding(.bottom, 40) // Gesamter Z-Stack 40 vom unteren Rand entfernen, um die Tabbar nicht zu überdecken
            })
        }
    }
}

#Preview {
    FloatingAddButton(addDestination: AddListItem())
}
