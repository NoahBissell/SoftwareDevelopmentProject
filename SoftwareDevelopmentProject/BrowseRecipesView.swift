//
//  BrowseRecipesView.swift
//  SoftwareDevelopmentProject
//
//  Created by Noah Bissell on 1/26/22.
//

import SwiftUI
import Kingfisher

struct BrowseRecipesView: View {
    @ObservedObject var kitchen : Kitchen
    @State var ingredientFilter = false;
    @State var query = ""
    @State var fetchedRecipeList = [RecipeResult]()
    @State private var searchMode : SearchMode = .random
    
    private enum SearchMode : String, CaseIterable, Identifiable {
        case search
        case random
        case filterIngredients
        
        var id : String { self.rawValue}
    }
    
    var body: some View {
        VStack {
            Form {
                Section{
                    if(searchMode == .search){
                        TextField(
                            "Search all recipes",
                            text: $query)
                        
                        if(query.count > 0){
                            Button("Search"){
                                FetchData().searchRecipes(query: query) { recipeList in
                                    self.fetchedRecipeList = recipeList
                                }
                            }
                        }
                    }
                    else{
                        Button("Generate Recipes"){
                            if(searchMode == .random) {
                                FetchData().getRandomRecipes { recipeList in
                                    self.fetchedRecipeList = recipeList
                                }
                            }
                            else {
                                FetchData().getRecipesFromIngredients(ingredients: kitchen.ingredients) { recipeList in
                                    self.fetchedRecipeList = recipeList
                                }
                            }
                        }
                    }
                }
                Section{
                    List(fetchedRecipeList){ recipeResult in
                        NavigationLink {
                            AddRecipeView(kitchen: kitchen, recipeResult: recipeResult)
                        } label: {
                            HStack {
                                if(recipeResult.image != nil){
                                    KFImage(recipeResult.image)
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                }
                                Text(recipeResult.title ?? "Error loading recipe")
                            }
                        }
                    }
                }
            }
        }
        
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing){
                Picker(selection: $searchMode, label:
                        Text("Browsing mode")
                       , content: {
                    ForEach(SearchMode.allCases){ mode in
                        Text(mode.rawValue.titleCase())
                            .tag(mode)
                        
                    }
                })
                    .pickerStyle(SegmentedPickerStyle())
            }
            //            ToolbarItem(placement: .navigationBarTrailing) {
            //                Toggle("Ingredient filter", isOn: $ingredientFilter)
            //                    .toggleStyle(.switch)
            //            }
        }
    }
}


struct BrowseRecipesView_Previews: PreviewProvider {
    static var previews: some View {
        BrowseRecipesView(kitchen: Kitchen())
    }
}

