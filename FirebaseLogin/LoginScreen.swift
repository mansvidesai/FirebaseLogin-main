//
//  LoginScreen.swift
//  FirebaseLogin
//
//  Created by Mansvi Desai on 05/12/23.
//

import SwiftUI
import GoogleSignIn
import GoogleSignInSwift
import Firebase
import AuthenticationServices
import FBSDKLoginKit
import CryptoKit


struct LoginScreen: View {
    @StateObject var loginModel: LoginViewModel = .init()
    @State private var isSignUpActive = false
    @State private var isCodeSent = false
    @State private var isHomeActive = false
    @StateObject private var loginViewModel = LoginViewModel()
    var body: some View {
        NavigationView{
            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading, spacing: 20) {
                    Text("Log in or sign up in seconds")
                        .foregroundColor(.black)
                        .lineSpacing(10)
                        .padding(.top, 50)
                        .padding(.trailing, 15)
                        .font(.system(size: 25, weight: .bold))
                    Text("Use your email or another service to continue with (it's free)!")
                        .foregroundColor(.gray)
                        .lineSpacing(10)
                        .padding(.top, 20)
                        .padding(.trailing, 15)
                        .font(.system(size: 15, weight: .bold))
                    
                    VStack(alignment: .leading, spacing: 20) {
                        CustomButton(imageName: "google_logo", text: "Continue with Google") {
                            
                            GIDSignIn.sharedInstance.signIn(withPresenting: UIApplication.shared.rootController()) { res, error in
                                if let error = error {
                                    print(error.localizedDescription)
                                    return
                                }
                                
                                if let user = res?.user {
                                    loginModel.logGoogleUser(user: user)
                                    isHomeActive = true
                                }
                            }
                            
                        }
                        
                        
//                        CustomButton(imageName: "Apple_logo", text: "Continue with Apple") {
//
//
//                        }
                       
                AppleView()
                        
                        Button(action: {
                            isSignUpActive = true
                        }) {
                            HStack {
                                Image("Email_logo")
                                    .resizable()
                                    .renderingMode(.template)
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 25, height: 25)
                                    .frame(height: 45)
                                Spacer()
                                Text("Continue with Email")
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
                        .sheet(isPresented: $isSignUpActive) {
                           EnterEmail()
                        }
                        
                        
                        CustomButton(imageName: "facebook_logo", text: "Continue with Facebook") {
                            signInWithFacebook()
                        }
                        
                        Button(action: {
                            isCodeSent = true
                        }) {
                            HStack() {
                                Image("Phone_logo")
                                    .resizable()
                                    .renderingMode(.template)
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 25, height: 25)
                                    .frame(height: 45)
                                Spacer()
                                Text("Continue with Mobile")
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
                        .sheet(isPresented: $isCodeSent) {
                            Login()
                        }
                        
                    }
                    .padding(.top, 40)
                    Text("By continuing, you agree to App")
                        .foregroundColor(.gray)
                        .lineSpacing(10)
                        .padding(.top, 20)
                        .padding(.trailing, 15)
                        .font(.system(size: 15, weight: .bold))
                }
                .padding(.leading, 40)
                .padding(.top, 60)
                .padding(.bottom, 15)
                .frame(maxWidth: .infinity)
            }
        }
        .navigationBarBackButtonHidden(true)
        .background(
            NavigationLink(
                destination: Home(),
                isActive: $isHomeActive,
                label: { EmptyView() }
            )
            .opacity(0) // Hide the actual NavigationLink view
        )
        .edgesIgnoringSafeArea(.all)
        .frame(maxWidth: .infinity)
        .alert(loginModel.successMessage, isPresented: $loginModel.showSuccess) {
            // Handle success alert
        }
        .alert(loginModel.errorMessage, isPresented: $loginModel.showError) {
            // Handle error alert
        }
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
    func signInWithFacebook() {
        let loginManager = LoginManager()
        loginManager.logIn(permissions: ["email"], from: nil) { result, error in
            if let error = error {
                print("Error logging in with Facebook: \(error.localizedDescription)")
            } else if result?.isCancelled == true {
                print("Facebook login cancelled")
            } else {
                guard let accessToken = AccessToken.current?.tokenString else {
                    print("Failed to get Facebook access token.")
                    return
                }

                let credential = FacebookAuthProvider.credential(withAccessToken: accessToken)

                Auth.auth().signIn(with: credential) { authResult, error in
                    if let error = error {
                        print("Firebase authentication failed with Facebook: \(error.localizedDescription)")
                    } else {
                        print("Successfully signed in with Facebook and Firebase")
                        // Call a function to save user data to Firestore
                        saveUserDataToFirestore()
                    }
                }
            }
        }
    }

    func saveUserDataToFirestore() {
        guard let user = Auth.auth().currentUser else {
            print("No authenticated user.")
            return
        }

        let db = Firestore.firestore()
        let userData = [
            "uid": user.uid,
            "displayName": user.displayName ?? "",
            "email": user.email ?? ""
            // Add more user data as needed
        ]

        // Ensure Firestore operations are performed on the main thread
        DispatchQueue.main.async {
            db.collection("users").document(user.uid).setData(userData) { error in
                if let error = error {
                    print("Error writing user data to Firestore: \(error.localizedDescription)")
                } else {
                    print("User data written to Firestore successfully.")
                }
            }
        }
    }
}



        struct LoginScreen_Previews: PreviewProvider {
            static var previews: some View {
                NavigationStack{
                    LoginScreen()
                }
            }
        }
        
    

