//
//  EnterEmail.swift
//  FirebaseLogin
//
//  Created by Mansvi Desai on 16/12/23.
//

import SwiftUI
import FirebaseAuth
struct EnterEmail: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @AppStorage("uid") var userID: String = ""
    @State private var showingErrorAlert = false
    @State private var errorAlertMessage = ""
    @State private var redirectToMainScreen = false
    @State private var redirectToSignUp = false
    @State private var isSigningIn = false
    @State private var showingSuccessAlert = false
    @State private var showingSignUpAlert = false
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.white.edgesIgnoringSafeArea(.all)
                VStack {
                    HStack {
                        Text("Welcome Back!")
                            .font(.largeTitle)
                            .bold()
                        Spacer()
                    }
                    .padding()
                    .padding(.top)
                   
                    HStack {
                        Image(systemName: "mail")
                        TextField("Email", text: $email)
                            .accentColor(.black)
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)
                        Spacer()
                    }
                    .foregroundColor(.black)
                    .padding()
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(lineWidth: 2)
                            .foregroundColor(.black)
                    )
                    .padding()
                    HStack {
                        Image(systemName: "lock")
                        SecureField("Password", text: $password)
                            .accentColor(.black)
                        Spacer()
                    }
                    .foregroundColor(.black)
                    .padding()
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(lineWidth: 2)
                            .foregroundColor(.black)
                    )
                    .padding()
                    NavigationLink(destination: Home(), isActive: $redirectToMainScreen) {
                        EmptyView()
                    }
                    NavigationLink(destination: SignUpView(), isActive: $redirectToSignUp) {
                        EmptyView()
                    }
                    Button {
                        signIn()
                    } label: {
                        if isSigningIn {
                            Text("Signing In...")
                                .foregroundColor(.white)
                                .font(.title3)
                                .bold()
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(Color.black)
                                )
                        } else {
                            Text("Sign In")
                                .foregroundColor(.white)
                                .font(.title3)
                                .bold()
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(Color.black)
                                )
                        }
                    }
                    .padding()
                    .alert(isPresented: $showingSuccessAlert) {
                        Alert(
                            title: Text("Success"),
                            message: Text("You have successfully signed in."),
                            dismissButton: .default(Text("OK")) {
                                // Optionally perform any action after a successful sign-in
                            }
                        )
                    }
                    .alert(isPresented: $showingSignUpAlert) {
                        Alert(
                            title: Text("Not Signed In"),
                            message: Text("You are not signed in. Do you want to sign up?"),
                            primaryButton: .default(Text("Sign Up")) {
                                redirectToSignUp = true
                            },
                            secondaryButton: .cancel()
                        )
                    }
                }
            }
            .navigationViewStyle(StackNavigationViewStyle())
        }
    }
    private func signIn() {
        isSigningIn = true
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            isSigningIn = false
            if let error = error {
                print(error)
                errorAlertMessage = error.localizedDescription
                showingSignUpAlert = true

                return
            }
            if let authResult = authResult {
                print(authResult.user.uid)
                showingSuccessAlert = true
                withAnimation {
                    userID = authResult.user.uid
                    redirectToMainScreen = true
                }
            }
        }
    }
}
#Preview(body: {
    EnterEmail()
})









