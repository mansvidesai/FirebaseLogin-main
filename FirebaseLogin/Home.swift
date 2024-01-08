//
//  Home.swift
//  FirebaseLogin
//
//  Created by Mansvi Desai on 05/12/23.
//

import SwiftUI

struct Home: View {
    @AppStorage("log_status") var logStatus: Bool = false
    var body: some View {
        VStack{
            Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
            
            Button(action: {
                logStatus = false
                
            }, label:{
                Text("Log out")
            })
            .navigationBarBackButtonHidden(true)
        }
        
    }
}

#Preview {
    Home()
}
