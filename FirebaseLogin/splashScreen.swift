//
//  splashScreen.swift
//  FirebaseLogin
//
//  Created by Mansvi Desai on 12/12/23.
//

import SwiftUI
@available(iOS, introduced: 13.0, deprecated: 15.0, message: "Use withAnimation or animation(_:value:) instead.")
struct splashScreen: View {
  @State private var isActive = false
  @State private var size = 0.8
  @State private var opacity = 0.5
  var body: some View {
    ZStack {
        Color("backcolor").edgesIgnoringSafeArea(.all)
      Image(.logo)
        .resizable()
        .frame(width: 200,height: 200)
            .scaleEffect(isActive ? 1.5 : 1.0) // Scale the image
            .animation(Animation.interpolatingSpring(stiffness: 50, damping: 5).repeatForever(autoreverses: true))
            .onAppear {
              isActive.toggle() // Trigger the animation by changing the state
          }
    }
  }
}
#Preview {
  splashScreen()
}





















