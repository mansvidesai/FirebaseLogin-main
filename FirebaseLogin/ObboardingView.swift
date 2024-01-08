//
//  ObboardingView.swift
//  FirebaseLogin
//
//  Created by Mansvi Desai on 12/12/23.
//

import SwiftUI
struct OnboardingView: View {
  @State private var isLoggedIn: Bool = false
  @State var currentPage : Int = 0
  @State var onboardingItems : [OnboardingItem] = [
    .init(title: "Explore the world of internet safely", description: "You can browse securely from any location in the world", lottieView: .init(name: "first",bundle: .main)),
    .init(title: "Keep your data private and safe", description: "One of the best virtual private Network services to protect all data", lottieView: .init(name: "second",bundle: .main)),
    .init(title: "Block viruses and online threats", description: "Get your work done seamlessly under our security", lottieView: .init(name: "third",bundle: .main)),
  ]
  var body: some View {
    NavigationView{
    GeometryReader{  proxy in
      let size = proxy.size
      HStack(spacing : .zero){
        ForEach($onboardingItems){ $item in
          let islastItem = currentPage == onboardingItems.count - 1
          VStack{
            HStack {
              Button("Back") {
                if currentPage > 0{
                  currentPage -= 1
                }
              }.tint(Color.red)
                .opacity(currentPage > 0 ? 1 : 0)
                .animation(currentPage > 0 ? .easeIn : .none, value: currentPage)
              Spacer()
              Button("Skip"){
                isLoggedIn = true
              }
              .opacity(islastItem ? 0 : 1)
              .animation(.easeOut, value: currentPage)
            }.tint(Color(.blue))
              .bold()
            VStack{
              let offset = -CGFloat(currentPage) * size.width
              LottieView(onboardingItem: $item, loopMode: .loop)
                .frame(height: size.width)
                .onAppear {
                  if currentPage == indexOf(item) {
                    item.lottieView.play()
                  }
                }.onChange(of: currentPage) { currentPage in
                  if currentPage == indexOf(item) {
                    item.lottieView.play()
                  } else {
                    item.lottieView.stop()
                  }
                }
                .offset(x: offset)
                .animation(.easeOut(duration: 0.5), value: currentPage)
              Text(item.title)
                .font(.title.bold())
                .offset(x: offset)
                .multilineTextAlignment(.center)
                .animation(.easeOut(duration: 0.5).delay(0.1), value: currentPage)
              Text(item.description)
                .font(.system(size: 14))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 16)
                .foregroundColor(.secondary)
                .offset(x: offset)
                .animation(.easeOut(duration: 0.5).delay(0.2), value: currentPage)
            }
            Spacer()
            VStack(spacing : 15){
                NavigationLink(destination: LoginScreen(), isActive: $isLoggedIn) {
               EmptyView()
             
              }.hidden()
                Button {
                  if currentPage < onboardingItems.count - 1 {
                    currentPage += 1
                  }else {
                    isLoggedIn = true
                  }
                } label: {
                  Text(islastItem ? "Signin and Signup" : "Next")
                    .bold()
                    .padding(.vertical, 4)
                    .frame(maxWidth: .infinity)
                }
                .tint(Color.black)
                .buttonStyle(.borderedProminent)
                .clipShape(Capsule())
                .padding(.horizontal, islastItem ? 30 : 100)
                .animation(.easeInOut(duration: 0.5), value: islastItem)
              }
            }
          }.padding(15)
          .frame(width: size.width, height: size.height, alignment: .leading)
        }
    }
    }
  }
  func indexOf(_ item: OnboardingItem) -> Int {
    if let index = onboardingItems.firstIndex(of: item) {
      return index
    }
    return 0
  }
}
#Preview {
  NavigationStack{
    OnboardingView()
  }
}





















