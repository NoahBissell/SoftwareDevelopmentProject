//
//  RecipeView.swift
//  SoftwareDevelopmentProject
//
//  Created by Noah Bissell on 1/28/22.
//

import SwiftUI
import Kingfisher
import RichText

struct RecipeView: View {
    @Environment(\.defaultMinListRowHeight) var minRowHeight
    var recipe : Recipe
    @ObservedObject var kitchen : Kitchen
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        ScrollView {
            VStack {
                KFImage(recipe.image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                
                RichText(html: recipe.instructions ?? "")
                    .lineHeight(170)
                    .imageRadius(12)
                    .fontType(.system)
                    .colorScheme(.automatic)
                    .colorImportant(true)
                    .linkOpenType(.SFSafariView)
                    .linkColor(ColorSet(light: "#007AFF", dark: "#0A84FF"))
                    .placeholder {
                        Text("Loading...")
                    }
                
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(recipe.extendedIngredients){ extendedIngredient in
                        Text("\(extendedIngredient.amount) \(extendedIngredient.unit) of \(extendedIngredient.getName())")
                        if(kitchen.ingredients.contains(where: { ingredient in
                            return extendedIngredient.id == ingredient.id
                        })) {
                            Image(systemName: "checkmark")
                        }
                        else {
                            Image(systemName: "multiply")
                        }
                    }
                }
//                List(recipe.extendedIngredients){ ingredient in
//                    Text(ingredient.name)
//                }
//                .frame(minHeight: minRowHeight * CGFloat(recipe.extendedIngredients.count + 2))
                
                Text("Ready in: ")
                HStack {
                    Image(systemName: "clock")
                    Text("\(recipe.readyInMinutes ?? 45) minutes")
                        .font(.title)
                }
            }
            .padding()
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink {
                        CookRecipeView()
                    } label: {
                        Text("Make this recipe")
                    }
                    
                }
            }
        }
    }
}

struct RecipeView_Previews: PreviewProvider {
    static var previews: some View {
        RecipeView(recipe: Recipe(), kitchen: Kitchen())
    }
}
