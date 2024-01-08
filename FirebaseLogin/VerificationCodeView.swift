//
//  VerificationCodeView.swift
//  FirebaseLogin
//
//  Created by Mansvi Desai on 10/12/23.
//

import SwiftUI
import SwiftUIX

struct Login: View {
    @StateObject var viewModel = ViewModel()
    @State private var navigateToHome = false

    var body: some View {
        NavigationView {
            ZStack {
                VStack(spacing: 0) {
                    Text("OTP Verification")
                        .font(.title2)
                        .fontWeight(.bold)
                        .padding(20)

                    Text("We will send you a \(Text("One Time Password").fontWeight(.bold).foregroundColor(.black)) on this mobile number")
                        .font(.callout)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                        .padding(.bottom, 20)

                    VStack {
                        Text("Enter Mobile Number")
                            .font(.callout)
                            .fontWeight(.semibold)
                            .foregroundColor(.gray)
                            .padding()

                        TextField("+1", text: $viewModel.phoneNumber)
                            .font(.title2)
                            .frame(maxWidth: UIScreen.main.bounds.width / 2, maxHeight: 60)
                            .keyboardType(.numberPad)
                            
                    }

                    Divider()
                        .frame(maxWidth: UIScreen.main.bounds.width / 2, maxHeight: 1)
                        .padding(.bottom)

                    Button(action: {
                        withAnimation {
                            viewModel.sendCode()
                        }
                    }, label: {
                        Text("Send OTP")
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity, maxHeight: 60)
                            .background(Color("Primary"))
                            .cornerRadius(6)
                            .shadow(color: Color("Primary").opacity(0.8), radius: 6, x: 1, y: 1)
                    }).padding()
                }
                .blur(radius: viewModel.isLoading || viewModel.isVerify || viewModel.isVerified ? 20 : 0)

                if viewModel.isLoading {
                    Loading()
                }

                Verification(viewModel: viewModel)
                    .opacity(viewModel.isVerify ? 1 : 0)
                    .scaleEffect(CGSize(width: viewModel.isVerify ? 1 : 0, height: viewModel.isVerify ? 1 : 0), anchor: .center)
                    .animation(.interpolatingSpring(stiffness: 200, damping: 10, initialVelocity: 5))

                Done()
                    .opacity(viewModel.isVerified ? 1 : 0)
                    .scaleEffect(CGSize(width: viewModel.isVerified ? 1 : 0, height: viewModel.isVerified ? 1 : 0), anchor: .center)
                    .animation(.interpolatingSpring(stiffness: 200, damping: 10, initialVelocity: 5))
            }
            .navigationBarHidden(true)
            .alert(isPresented: $viewModel.isError) {
                Alert(title: Text("Error"), message: Text(viewModel.errorMsg))
            }
            .onReceive(viewModel.$isVerified) { isVerified in
                if isVerified {
                    navigateToHome = true
                }
            }
            .background(
                NavigationLink(destination: Home(), isActive: $navigateToHome) {
                    EmptyView()
                }
                .hidden()
            )
        }
    }
}

struct Login_Previews: PreviewProvider {
    static var previews: some View {
        Login()
    }
}

struct Loading: View {
    var body: some View {
        ProgressView()
    }
}
