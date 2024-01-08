//
//  SignupView.swift
//  FirebaseLogin
//
//  Created by Mansvi Desai on 19/12/23.
//
import SwiftUI
import FirebaseAuth

struct SignUpView: View {
  @State private var email: String = ""
  @State private var password: String = ""
  @AppStorage("uid") var userID: String = ""
  @State private var showingErrorAlert = false
  @State private var errorAlertMessage = ""
  @State private var confirmPassword: String = ""
  @State private var isSigningUp = false
  @State private var isVerificationEmailSent = false
    
  private func isValidPassword(_ password: String) -> Bool {
    // Your password validation logic here
    return true
  }
  var body: some View {
    ZStack {
      Color.white.edgesIgnoringSafeArea(.all)
      VStack {
        HStack {
          Text("Create an Account!")
            .foregroundColor(.black)
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
          if password.count != 0 {
            Image(systemName: isValidPassword(password) ? "checkmark" : "xmark")
              .fontWeight(.bold)
              .foregroundColor(isValidPassword(password) ? .green : .red)
          }
        }
        .foregroundColor(.black)
        .padding()
        .overlay(
          RoundedRectangle(cornerRadius: 10)
            .stroke(lineWidth: 2)
            .foregroundColor(.black)
        )
        .padding()
        Button {
          signUp()
        } label: {
          Text("Countiune")
            .foregroundColor(.white)
            .font(.title3)
            .bold()
            .frame(maxWidth: .infinity)
            .padding()
            .background(
              RoundedRectangle(cornerRadius: 10)
                .fill(Color.black)
            )
            .padding(.horizontal)
        }
        .alert(isPresented: $isVerificationEmailSent) {
          Alert(
            title: Text("Verification Email Sent"),
            message: Text("An email verification has been sent to your email address."),
            dismissButton: .default(Text("OK"))
          )
        }
      }
    }
  }
  private func signUp() {
    isSigningUp = true
    Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
      isSigningUp = false
      if let error = error {
        print(error)
        errorAlertMessage = error.localizedDescription
        showingErrorAlert = true
        return
      }
      if let authResult = authResult {
        print(authResult.user.uid)
        // Send email verification
        authResult.user.sendEmailVerification { error in
          if let error = error {
            print("Error sending email verification: \(error.localizedDescription)")
            // Handle the error as needed
          } else {
            print("Email verification sent successfully.")
            isVerificationEmailSent = true
            // You may want to provide user feedback here
          }
        }
        userID = authResult.user.uid
        // You might want to provide visual feedback for successful sign-up
      }
    }
  }
}





















