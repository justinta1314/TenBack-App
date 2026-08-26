//
//  ContentView.swift
//  TenBack
//
//  Created by Justin Ta on 8/22/26.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Text("TenBack Bowling Tracker").font(.largeTitle)
            
            Text("Track your games and improve your bowling")
            
            NavigationLink("Get Started") {
                DashboardView()
            }
        }
        .padding()
    }
}

#Preview {
    NavigationStack {
        ContentView()
    }
    .environment(GameStore())
}
