//
//  SoftwareDevelopmentProjectApp.swift
//  SoftwareDevelopmentProject
//
//  Created by Noah Bissell (student LM) on 1/9/22.
//

import SwiftUI

@main
struct SoftwareDevelopmentProjectApp: App {
    @StateObject var userInfo = UserInfo()
    @StateObject var kitchen = Kitchen()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(userInfo)
                .environmentObject(kitchen)
        }
    }
}
