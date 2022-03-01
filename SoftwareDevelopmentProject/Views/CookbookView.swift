//
//  CookbookView.swift
//  SoftwareDevelopmentProject
//
//  Created by Noah Bissell on 1/22/22.
//

import SwiftUI

struct CookbookView: View {
    @EnvironmentObject var kitchen : Kitchen
    
    var body: some View {
        NavigationView{
            ScrollView {
                VStack{
                    NavigationLink(destination: BrowseRecipesView(), label: {
                        CardView(image: "BrowseRecipe Image", title: "Browse Recipes", description: "Broaden your horizons by giving some new foods or recipes a try.")
                    })
                    NavigationLink(destination: SavedRecipesView(), label: {
                        CardView(image: "SavedRecipes Image", title: "Saved Recipes", description: "Open up your old cookbook of favorite recipes.")
                    })
                }
            }
        }
    }
}

struct CookBookView_Previews: PreviewProvider {
    static var previews: some View {
        CookbookView().environmentObject(Kitchen())
    }
}
