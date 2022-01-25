//
//  ContentView.swift
//  SoftwareDevelopmentProject
//
//  Created by Noah Bissell (student LM) on 1/9/22.
//

import SwiftUI

struct ContentView: View {

    @StateObject var kitchen = Kitchen()
    
    var body : some View {
        
        
        TabView{
            
            KitchenView(kitchen: kitchen)
                .tabItem(){
                    Text("Kitchen")
                }
            
            RecipeView(kitchen: kitchen)
                .tabItem(){
                    Text("Recipes")
                }
        }
        
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
