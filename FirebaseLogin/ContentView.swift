//
//  ContentView.swift
//  FirebaseLogin
//
//  Created by Mansvi Desai on 05/12/23.
//

import SwiftUI

struct ContentView: View {
    @State private var isActive = false
    @State private var dynamicLinkURL: URL?
    @AppStorage("log_status") var logStatus: Bool = false
    var body: some View {
        if isActive
              {
                OnboardingView()
              }else{
                splashScreen()
                  .onAppear{
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                      withAnimation {
                        self.isActive = true
                              }
                                  }
                  }
              }
      
       
    }
}


#Preview {
    ContentView()
}

