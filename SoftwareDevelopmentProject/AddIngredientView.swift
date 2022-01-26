//
//  AddIngredientView.swift
//  SoftwareDevelopmentProject
//
//  Created by Noah Bissell on 1/25/22.
//

import SwiftUI
import Kingfisher

struct AddIngredientView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @ObservedObject var kitchen : Kitchen
    @State var ingredient = Ingredient()
    @State var searchedIngredientList = [IngredientResult]()
    @State var isPresentingIngredientSearch = false
    @State var query : String = ""
    
    var ingredientSearchSheet : some View {
        VStack{
            Spacer()
            
            // For some reason the keyboard dismisses after typing the first character, can't seem to figure out why
            // Bug has gone away for me now, will keep this comment for reference
            Form{
                Section{
                    TextField(
                        "Search all ingredients",
                        text: $query)
                    
                    if(query.count > 0){
                        Button("Search"){
                            FetchData().searchIngredients(query: query) { ingredientList in
                                self.searchedIngredientList = ingredientList
                            }
                        }
                    }
                    
                }
                Section{
                    List(searchedIngredientList){ ingredientResult in
                        Button(ingredientResult.name?.capitalized ?? "Error Loading Product"){
                            FetchData().getIngredientFromId(id: ingredientResult.id) { ingredient in
                                self.ingredient = ingredient
                            }
                            self.isPresentingIngredientSearch = false
                        }
                    }
                }
            }
            
        }
    }
    
    var body: some View {
        VStack(spacing: 20){
            Text("Ingredient: \(ingredient.getName())")
            
            if(ingredient.image != nil){
                KFImage(ingredient.getImageURL())
            }
            
            Stepper("Amount: \(ingredient.amount)", value: $ingredient.amount)
            
            
            Button("Search for an ingredient"){
                self.isPresentingIngredientSearch = true
            }
            .sheet(isPresented: $isPresentingIngredientSearch){
                ingredientSearchSheet
            }
        }
        .padding()
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button (action: {
                    kitchen.addIngredient(ingredient: ingredient)
                    self.presentationMode.wrappedValue.dismiss()
                }, label: {
                    Text("Add ingredient")
                })
            }
        }
    }
}


struct AddIngredientView_Previews: PreviewProvider {
    static var previews: some View {
        AddIngredientView(kitchen: Kitchen())
    }
}