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
        Text("Hello World!")
    }
}

struct RecipeView_Previews: PreviewProvider {
    static var previews: some View {
        RecipeView(kitchen: Kitchen())
    }
}
