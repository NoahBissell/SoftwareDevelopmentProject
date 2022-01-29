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
    
    func limitDescription(input : String?) -> String {
        if var str = input {
            if(str.count > 300) {
                str = String(str.prefix(upTo: str.index(str.startIndex, offsetBy: 299)))
            }
            return "\(str)..."
        }
        return ""
    }
    
    var body: some View {
        ScrollView {
        VStack {
            ForEach(kitchen.recipes){ recipe in
                NavigationLink (destination:
                    RecipeView(recipe: recipe, kitchen: kitchen)
                                , label: {
                    CardView(image: "", kfImage: recipe.image, title: recipe.title!, description: "")
//                    limitDescription(input: recipe.summary)
                })

            }
        }
        .navigationTitle("My Cookbook")
    }
    }
}

struct SavedRecipesView_Previews: PreviewProvider {
    static var previews: some View {
        SavedRecipesView(kitchen: Kitchen())
    }
}
