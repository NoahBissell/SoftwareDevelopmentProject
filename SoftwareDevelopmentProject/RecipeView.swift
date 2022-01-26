//
//  BrowseRecipeView.swift
//  SoftwareDevelopmentProject
//
//  Created by Noah Bissell on 1/22/22.
//

import SwiftUI

struct RecipeView: View {
    @ObservedObject var kitchen : Kitchen
    
    var body: some View {
        NavigationView{
            VStack{
                NavigationLink(destination: BrowseRecipesView(kitchen: kitchen), label: {
                    CardView(image: "BrowseRecipe Image", title: "Browse Recipes", description: "Broaden your horizons by giving some new foods or recipes a try.")
                })
                NavigationLink(destination: SavedRecipesView(kitchen: kitchen), label: {
                    CardView(image: "SavedRecipes Image", title: "Saved Recipes", description: "Open up your old cookbook of favorite recipes.")
                })
            }
        }
    }
}

struct RecipeView_Previews: PreviewProvider {
    static var previews: some View {
        RecipeView(kitchen: Kitchen())
    }
}
