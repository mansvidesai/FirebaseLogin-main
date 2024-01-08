//
//  AppleView.swift
//  FirebaseLogin
//
//  Created by Mansvi Desai on 15/12/23.
//

import SwiftUI
import AuthenticationServices
import CryptoKit
import FirebaseAuth
import FirebaseFirestore


struct User : Identifiable {
  var id, idSignInWithApple, email, firstName, lastName: String
  static func createUser(user: User) -> [String : Any]{
    [
      "doucmentId": user.id,
      "idSignInWithApple" : user.idSignInWithApple,
      "email" : user.email,
      "firstName": user.firstName,
      "lastName": user.lastName
    ]
  }
}
struct AppleView: View {
  @State private var currentNonce: String?
  @State private var isHomeActive = false
  @Environment(\.colorScheme) var colorScheme
  var body: some View {
    ZStack {
      appleButtonView
    }
    .fullScreenCover(isPresented: $isHomeActive) {
      Home()
    }
    .ignoresSafeArea()
  }
  var appleButtonView: some View {
      CustomButton(imageName: "Apple_logo", text: "Continue with Apple", action: {
          signInWithAppleButton()
      })
    .signInWithAppleButtonStyle(colorScheme == .dark ? .white : .white)
    .frame(width: 280, height: 40)
    .foregroundColor(.white)
    .padding(.horizontal, 15)
    .background(RoundedRectangle(cornerRadius: 10, style: .continuous)
        .fill(.black))
  }
  func signInWithAppleButton() {
    // Add your Sign In with Apple functionality here
    let appleIDProvider = ASAuthorizationAppleIDProvider()
    let request = appleIDProvider.createRequest()
    request.requestedScopes = [.fullName, .email]
    let authorizationController = ASAuthorizationController(authorizationRequests: [request])
    authorizationController.performRequests()
    let signInWithAppleButton = SignInWithAppleButton(.signUp) { request in
      request.requestedScopes = [.email, .fullName]
      request.nonce = startSignInWithAppleFlow()
    } onCompletion: { authResults in
      switch authResults {
      case .success(_):
        // Handle successful Apple Sign In
        // Access user information from auth.credential
        print("Successfully signed in with Apple")
      case .failure(let error):
        print("Apple Sign In failed: \(error.localizedDescription)")
      }
    }
    signInWithAppleButton
  }
  func startSignInWithAppleFlow() -> String {
    let nonce = randomNonceString()
    currentNonce = nonce
    return sha256(nonce)
  }
  private func sha256(_ input: String) -> String {
    let inputData = Data(input.utf8)
    let hashedData = SHA256.hash(data: inputData)
    let hashString = hashedData.compactMap {
      String(format: "%02x", $0)
    }.joined()
    return hashString
  }
  // Adapted from https://auth0.com/docs/api-auth/tutorials/nonce#generate-a-cryptographically-random-nonce
  private func randomNonceString(length: Int = 32) -> String {
    precondition(length > 0)
    let charset: [Character] =
    Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
    var result = ""
    var remainingLength = length
    while remainingLength > 0 {
      let randoms: [UInt8] = (0 ..< 16).map { _ in
        var random: UInt8 = 0
        let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
        if errorCode != errSecSuccess {
          fatalError(
            "Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)"
          )
        }
        return random
      }
      randoms.forEach { random in
        if remainingLength == 0 {
          return
        }
        if random < charset.count {
          result.append(charset[Int(random)])
          remainingLength -= 1
        }
      }
    }
    return result
  }
    
}
#Preview {
  AppleView()
}
func CustomButton(imageName: String, text: String, action: @escaping () -> Void) -> some View {
    return Button(action: action) {
        HStack {
            Image(imageName)
                .resizable()
                .renderingMode(.template)
                .aspectRatio(contentMode: .fit)
                .frame(width: 25, height: 25)
                .frame(height: 45)
            Spacer()
            
            Text(text)
                .font(.callout)
                .foregroundColor(.white)
                .lineLimit(1)
                .padding(.horizontal, 5)
            Spacer()
        }
        .frame(width: 280, height: 40)
        .foregroundColor(.white)
        .padding(.horizontal, 15)
        .background(RoundedRectangle(cornerRadius: 10, style: .continuous)
            .fill(.black))
    }
    
}
