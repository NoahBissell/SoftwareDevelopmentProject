//
//  RecipeView.swift
//  SoftwareDevelopmentProject
//
//  Created by Noah Bissell on 1/28/22.
//
import Foundation
import SwiftUI
import struct Kingfisher.KFImage


struct RecipeView: View {
    @Environment(\.defaultMinListRowHeight) var minRowHeight
    var recipe : Recipe
    @EnvironmentObject var kitchen : Kitchen
    @State var isPresentingMakeRecipe = false
    @State var canMakeRecipe = true
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    
    
    var body: some View {
        ScrollView {
            VStack {
                Text(recipe.title ?? "Loading...")
                    .font(.title)
                    .fontWeight(.semibold)
                KFImage(recipe.image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                RichText(html: recipe.instructions ?? "")
                    .lineHeight(170)
                    .imageRadius(12)
                    //.fontType(Font.system)
                    //.colorScheme(ColorScheme.automatic)
                    .colorImportant(true)
                    //.linkOpenType(.SFSafariView)
                    //.linkColor(ColorSet(light: "#007AFF", dark: "#0A84FF"))
                    .placeholder {
                        Text("Loading...")
                    }
                Divider()
                Text("Ingredients")
                    .font(.title2)
                    .fontWeight(.semibold)
                LazyVGrid(columns: columns, spacing: 20) {
                    Text("Required in recipe")
                        .font(.caption2)
                    Text("What's in my kitchen")
                        .font(.caption2)
                    Text("Enough?")
                        .font(.caption2)
                    
                    ForEach(recipe.extendedIngredients){ extendedIngredient in
                        Text("\(extendedIngredient.amount, specifier: "%.1f") \(extendedIngredient.unit) of \(extendedIngredient.getName())")
                        if let kitchenIngredient = kitchen.ingredients.first { ingredient in
                            ingredient.id == extendedIngredient.id
                        }{
                            Text("\(kitchenIngredient.amount, specifier: "%.1f") \(kitchenIngredient.unit) of \(kitchenIngredient.getName())")
                            if(kitchenIngredient.amount >= extendedIngredient.amount){
                                Image(systemName: "checkmark")
                                    .foregroundColor(.green)
                            }
                            else{
                                Image(systemName: "multiply")
                                    .foregroundColor(.red)
                            }
                        }
                        else{
                            Text("0.0 \(extendedIngredient.unit) of \(extendedIngredient.getName())")
                            Image(systemName: "multiply")
                                .foregroundColor(.red)
                        }
                    }
                }
                .padding()
                Divider()
                //                List(recipe.extendedIngredients){ ingredient in
                //                    Text(ingredient.name)
                //                }
                //                .frame(minHeight: minRowHeight * CGFloat(recipe.extendedIngredients.count + 2))
                
                Text("Ready in: ")
                HStack {
                    Image(systemName: "clock")
                    Text("\(recipe.readyInMinutes ?? 30) minutes")
                        .font(.title)
                }
            }
            .padding()
            .onAppear(perform: {
                for extendedIngredient in recipe.extendedIngredients {
                    if let index = kitchen.ingredients.firstIndex(where: { ingredient in
                        ingredient.id == extendedIngredient.id
                    }){
                        if(kitchen.ingredients[index].unit != extendedIngredient.unit){
                            FetchData().convertUnits(ingredient: kitchen.ingredients[index].name, amount: kitchen.ingredients[index].amount, sourceUnit: kitchen.ingredients[index].unit, targetUnit: extendedIngredient.unit) { conversion in
                                print(conversion.targetUnit)
                                kitchen.ingredients[index].amount = conversion.targetAmount
                                kitchen.ingredients[index].unit = conversion.targetUnit
                                if(kitchen.ingredients[index].amount < extendedIngredient.amount) {
                                    canMakeRecipe = false
                                }
                            }
                        }
                        else{
                            if(kitchen.ingredients[index].amount < extendedIngredient.amount) {
                                canMakeRecipe = false
                            }
                        }
                    }
                    else{
                        canMakeRecipe = false
                        print("HERE")
                    }
                }
            })
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
//                    NavigationLink(destination:
//                        CookRecipeView()
//                    , label: {
//                        Button("Make this recipe"){
//                            isPresentingMakeRecipe = true
//                        }
//                        .sheet(isPresented: $isPresentingMakeRecipe){
//                            makeRecipeSheet
//                        }
//                    })
                    Button("Make this recipe"){
                        isPresentingMakeRecipe = true
                    }
                    .sheet(isPresented: $isPresentingMakeRecipe){
                        //makeRecipeSheet
                    }

                }
            }
        }
    }
}

struct RecipeView_Previews: PreviewProvider {
    static var previews: some View {
        RecipeView(recipe: Recipe()).environmentObject(Kitchen())
    }
}

//struct MakeRecipeSheet : View {
//    @Binding var canMakeRecipe : Bool
//
//
//    var body : some View {
//        VStack{
//            if (!canMakeRecipe){
//                Text("It looks like you don't have enough ingredients logged in your kitchen to make this recipe.")
//            }
//            else if(canMakeRecipe){
//                Text("You have enough ingredients to make this recipe.")
//                Button("Subtract ingredients"){
//                    for extendedIngredient in recipe.extendedIngredients {
//                        if let index = kitchen.ingredients.firstIndex(where: { ingredient in
//                            ingredient.id == extendedIngredient.id
//                        }){
//                            kitchen.ingredients[index].amount = kitchen.ingredients[index].amount - extendedIngredient.amount
//                            if(kitchen.ingredients[index].amount < 0){
//                                kitchen.ingredients.remove(at: index)
//                            }
//                        }
//                    }
//                }
//            }
//
//        }
//        .onAppear(){
//            print(canMakeRecipe)
//        }
//    }
//}
