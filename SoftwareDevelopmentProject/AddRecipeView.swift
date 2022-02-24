//
//  AddRecipeView.swift
//  SoftwareDevelopmentProject
//
//  Created by Noah Bissell on 1/27/22.
//

import SwiftUI
import struct Kingfisher.KFImage


struct AddRecipeView: View {
    @ObservedObject var kitchen : Kitchen
    var recipeResult : RecipeResult
    @State var isSaved = false
    @State var isRecipeLoaded = false
    @State var recipe = Recipe()
    
    var body: some View {
        ScrollView {
            VStack {
                KFImage(recipe.image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                //                Text(recipe.summary?.removeHtmlTags() ?? "Loading...")
                if(isRecipeLoaded) {
                    RichText(html: recipe.summary ?? "Loading...")
                        .lineHeight(170)
                        .imageRadius(12)
                        .fontType(.system)
                        .colorScheme(.automatic)
                        .colorImportant(true)
                        .linkOpenType(.SFSafariView)
                        //.linkColor(ColorSet(light: "#007AFF", dark: "#0A84FF"))
                        .placeholder {
                            Text("Loading...")
                        }
                }
                Text("Ready in: ")
                HStack {
                    Image(systemName: "clock")
                    Text("\(recipe.readyInMinutes ?? 45) minutes")
                        .font(.title)
                }
            }
            .onAppear {
                FetchData().getRecipeFromId(id: recipeResult.id) { recipe in
                    self.recipe = recipe
                    
                    isSaved = kitchen.recipes.contains(where: { recipe in
                        return self.recipe.id == recipe.id
                    })
                    isRecipeLoaded = true
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

struct AddRecipeView_Previews: PreviewProvider {
    static var previews: some View {
        AddRecipeView(kitchen: Kitchen(), recipeResult: RecipeResult())
    }
}
