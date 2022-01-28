//
//  SavedRecipesView.swift
//  SoftwareDevelopmentProject
//
//  Created by Noah Bissell on 1/26/22.
//

import SwiftUI
import Kingfisher

struct SavedRecipesView: View {
    @ObservedObject var kitchen : Kitchen
    
    var body: some View {
        VStack {
            List(kitchen.recipes){ recipe in
                NavigationLink (destination: {
                    RecipeView(recipe: recipe, kitchen: kitchen)
                }, label: {
                    HStack {
                        if(recipe.image != nil){
                            KFImage(recipe.image!)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                        }
                        Text(recipe.title ?? "Error")
                    }
                })

            }
        }
        .navigationTitle("My Cookbook")
    }
}

struct SavedRecipesView_Previews: PreviewProvider {
    static var previews: some View {
        SavedRecipesView(kitchen: Kitchen())
    }
}
