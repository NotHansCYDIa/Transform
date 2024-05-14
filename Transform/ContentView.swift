//
//  ContentView.swift
//  Transform
//
//  Created by NotHansCYDIA on 5/10/24.
//

import SwiftUI

struct ContentView: View {
    
    @State var creator = false
    
    var body: some View {
        if creator == false {
            TabView {
                
                NavigationStack {
                    VStack(alignment: .center) {
                        Image(systemName: "square.fill.on.circle.fill")
                            .resizable()
                            .frame(width: 85,height: 80)
                        Text("In Progress")
                            .font(.largeTitle.bold())
                        Text("The feature to view your projects has not been implemented.")
                    } .foregroundColor(.gray) .frame(width: 220) .toolbar {
                        
                        
                        
                        ToolbarItem(placement: .primaryAction) {
                            Button {
                                withAnimation(.easeInOut) {
                                    creator = true
                                }
                            } label: {
                                Image(systemName: "plus")
                            }
                            
                            
                        }
                        
                    }
                } .padding()
                    .tabItem {
                        Label("Projects", systemImage: "square.fill.on.circle.fill")
                    }
            }
        } else {
            ZStack {
                studioTransform()
                    .preferredColorScheme(.dark)
                    .ignoresSafeArea()
            }
        }
            
    }
}

#Preview {
    ContentView()
}
