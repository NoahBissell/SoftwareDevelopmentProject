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
                    if #available(iOS 14.5, *) {
                        Label("Kitchen", systemImage: "house")
                            .labelStyle(TitleAndIconLabelStyle())
                    } else {
                        Text("Kitchen")
                    }
                }
            
            CookbookView(kitchen: kitchen)
                .tabItem(){
                    if #available(iOS 14.5, *) {
                        Label("Cookbook", systemImage: "text.book.closed")
                            .labelStyle(TitleAndIconLabelStyle())
                    } else {
                        Text("Cookbook")
                    }
                    
                }
        }
        
        
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
