//
//  AddRecipe.swift
//  shoppingList
//
//  Created by Rebecca Nußbaumer on 06.04.24.
//

import SwiftUI
import SwiftData
import PhotosUI

struct AddRecipe: View {
    
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var context
    
    @Query var zutaten: [Zutat]
    
    @State private var item = Recipe()
    @State private var addZutatButton = false
    @State var selectedPhoto: PhotosPickerItem?
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 10) {
            
            //Name und Foto des Rezeptes
            HStack {
                VStack(alignment: .leading) {
                    Text("Name")
                        .font(.system(size: 16, weight: .medium))
                    TextField("Name des Rezepts", text: $item.name)
                        .padding()
                        .background(Color("greyBG"))
                        .cornerRadius(8)
                }.padding(.bottom, 10)
                
            //Foto auswählen - Photo Picker
                VStack(alignment: .leading) {
                    Text("Foto")
                        .font(.system(size: 16, weight: .medium))
                    
                    //Wenn ein Foto vorhanden ist, zeige das Foto an und zeige darüber ein "Löschen"-Symbol an, um das Foto wieder löschen zu können
                    if let image = item.image,
                       let uiImage = UIImage(data: image) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 80, height: 55.0)
                            .cornerRadius(10)
                            .zIndex(-1) //Bug-Fix, da sonst Teile des Interfaces nicht mehr klickbar sind
                            .overlay {
                                Button(role: .destructive) { //Button, um das ausgewählte Foto wieder zu löschen
                                    selectedPhoto = nil
                                    item.image = nil
                                } label: {
                                    Image(systemName: "trash")
                                        .foregroundStyle(.red)
                                }
                            }
                    }
                    
                    if item.image == nil { //Wenn noch kein Foto ausgewählt wurde, zeige einen Button mit einem Photo-Picker an, um ein Bild auszuwählen
                        
                        PhotosPicker(selection: $selectedPhoto, matching: .images, photoLibrary: .shared()) {
                            ZStack {
                                Rectangle()
                                    .frame(width: 80, height: 55.0)
                                    .background(Color.accentColor)
                                    .cornerRadius(10)
                                Image(systemName: "camera")
                                    .foregroundColor(.white)
                                    .font(.system(size:20))
                            }
                        }
                    }
                    
                }.padding(.bottom, 10)
                
            }
            
            //Rezept-Kategorie auswählen
            Text("Kategorie")
                .font(.system(size: 16, weight: .medium))
                .padding(.top, 5)
            
            Picker("Kategorie", selection: $item.category) {
                ForEach(Rezeptkategorie.allCases, id: \.self) {
                    category in Text(category.rawValue) }
            }
            .padding(10)
            .frame(width: UIScreen.main.bounds.width - 40)
            .background(Color("greyBG"))
            .cornerRadius(8)
            .accentColor(Color.black)
            
            
            //Zutatenliste und Möglichkeit, Zutaten hinzufügen
            HStack {
                Text("Zutaten")
                    .font(.system(size: 16, weight: .medium))
                Spacer()
                Button(action: {
                    withAnimation {
                        addZutatButton.toggle() //Stellt die Variable "addZutatButton" auf true, um das Sheet anzuzeigen
                    }
                    
                }) {
                    Image(systemName: "plus")
                        .font(.system(size: 16, weight: .bold))
                        .padding()
                }
            }
            
            //Liste für die Zutaten
            List {
                ForEach(item.zutaten ?? [], id: \.id) {zutat in
                    ZutatenRowView(zutat: zutat) //Zeit die individuelle Zutatenlisten-Row-View an
                        .listRowInsets(EdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 0))
                }
                .onDelete { indexes in
                    for index in indexes {
                        let removedItem = item.zutaten?.remove(at: index)
                        context.delete(removedItem!) } //ermöglicht das Löschen mithilfe einer Swipe-Action
                }
            }
            .scrollContentBackground(.hidden) //entfernt den Default-Background
            .listStyle(PlainListStyle()) //entfernt den zu hohen oberen Rand der Liste
            .environment(\.defaultMinListRowHeight, 70) //stellt die Row-Items auf eine Mindesthöhe von 70
            
            //Speichern-Button
            Button(action: {
                withAnimation {
                    context.insert(item) //speichert das Item mithilfe des ModelContextes
                }
                dismiss()
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
        .navigationTitle("Rezept hinzufügen")
        .navigationBarTitleDisplayMode(.inline)
        
        //Sheet, um eine Zutat hinzufügen zu können
        .sheet(isPresented: $addZutatButton, content: {
            NavigationStack {
                AddZutat(recipe: item)
            }.presentationDetents([.medium])
        })
        //Task, um das ausgewählte Foto bei jedem Auswählen in das jeweilige item.image zu speichern
        .task(id: selectedPhoto) {
            if let data = try? await selectedPhoto?.loadTransferable(type: Data.self) {
                item.image = data
            }
        }
    }
}


#Preview {
    AddRecipe()
}
