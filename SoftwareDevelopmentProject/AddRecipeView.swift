//
//  RecipeView.swift
//  SoftwareDevelopmentProject
//
//  Created by Noah Bissell on 1/27/22.
//

import SwiftUI
import Kingfisher

struct RecipeView: View {
    @ObservedObject var kitchen : Kitchen
    var recipeResult : RecipeResult
    @State var isSaved = false
    @State var recipe = Recipe()
    
    
    
    var body: some View {
        ScrollView {
            VStack {
                KFImage(recipe.image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                Text(recipe.summary?.removeHtmlTags() ?? "Loading...")
                
            }
            .onAppear {
                FetchData().getRecipeFromId(id: recipeResult.id) { recipe in
                    self.recipe = recipe
                    
                    isSaved = kitchen.recipes.contains(where: { recipe in
                        return self.recipe.id == recipe.id
                    })
                }

            }
            .padding()
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    if(!isSaved){
                        Button (action: {
                            kitchen.addRecipe(recipe: recipe)
                            isSaved = true
                        }, label: {
                            if #available(iOS 14.5, *) {
                                Label("Save", systemImage: "text.book.closed")
                                    .labelStyle(TitleAndIconLabelStyle())
                            } else {
                                Text("Save")
                            }
                        })
                    }
                    else{
                        if #available(iOS 14.5, *) {
                            Label("Saved", systemImage: "checkmark")
                                .labelStyle(TitleAndIconLabelStyle())
                        } else {
                            Text("Saved")
                        }
                    }
                }
            }
        }
        .navigationTitle(recipeResult.title ?? "")
        .navigationBarTitleDisplayMode(NavigationBarItem.TitleDisplayMode.inline)
    }
}

struct RecipeView_Previews: PreviewProvider {
    static var previews: some View {
        RecipeView(kitchen: Kitchen(), recipeResult: RecipeResult())
    }
}
