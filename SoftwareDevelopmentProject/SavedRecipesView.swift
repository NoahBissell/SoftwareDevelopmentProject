//
//  SavedRecipesView.swift
//  SoftwareDevelopmentProject
//
//  Created by Noah Bissell on 1/26/22.
//

import SwiftUI

struct SavedRecipesView: View {
    @ObservedObject var kitchen : Kitchen
    
    var body: some View {
        VStack {
            List(kitchen.recipes){ recipe in
                Text(recipe.title ?? "Error")
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
