//
//  LottieView.swift
//  FirebaseLogin
//
//  Created by Mansvi Desai on 12/12/23.
//

import SwiftUI
import Lottie
struct LottieView : UIViewRepresentable {
  @Binding var onboardingItem : OnboardingItem
  var loopMode: LottieLoopMode = .playOnce
  func makeUIView(context: Context) -> UIView {
    let view = UIView()
    view.backgroundColor = .clear
    setLottieView(view)
    return view
  }
  func updateUIView(_ uiView: UIViewType, context: Context) {}
  func setLottieView(_ to: UIView){
    let lottieView = onboardingItem.lottieView
    lottieView.loopMode = loopMode
    lottieView.backgroundColor = .clear
    lottieView.translatesAutoresizingMaskIntoConstraints = false
    let constraints = [
      lottieView.widthAnchor.constraint(equalTo : to.widthAnchor),
      lottieView.heightAnchor.constraint(equalTo: to.heightAnchor)
    ]
    to.addSubview(lottieView)
    to.addConstraints(constraints)
  }
}









