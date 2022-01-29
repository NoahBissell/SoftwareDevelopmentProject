//
//  IngredientView.swift
//  SoftwareDevelopmentProject
//
//  Created by Noah Bissell on 1/28/22.
//

import SwiftUI
import Kingfisher

struct IngredientView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    @Binding var ingredient : Ingredient
    var body: some View {
        VStack(spacing: 20){
            Text("Ingredient: \(ingredient.getName())")
            
            if(ingredient.image != nil){
                KFImage(ingredient.getImageURL())
            }
            
            Stepper(value: $ingredient.amount, in: 0.1...100.0, step: 0.1) {
                Text("Amount: \(ingredient.amount, specifier: "%.1f")")
            }
            
            HStack{
                Text("Units: ")
                Picker("Units", selection: $ingredient.unit) {
                    ForEach(ingredient.possibleUnits, id: \.self){ unit in
                        Text(unit)
                    }
                }
                .id(ingredient.possibleUnits)
            }
            
        }
        .padding()
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button (action: {
                    self.presentationMode.wrappedValue.dismiss()
                }, label: {
                    Text("Done")
                })
            }
        }
    }
}

struct IngredientView_Previews: PreviewProvider {
    static var previews: some View {
        IngredientView(ingredient: .constant(Ingredient()))
    }
}
