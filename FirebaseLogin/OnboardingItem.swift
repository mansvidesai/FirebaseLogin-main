//
//  OnboardingItem.swift
//  FirebaseLogin
//
//  Created by Mansvi Desai on 12/12/23.
//

import Foundation
import SwiftUI
import Lottie
struct OnboardingItem : Identifiable, Equatable {
  let id : UUID = .init()
  let title : String
  let description : String
  let lottieView : LottieAnimationView
}
