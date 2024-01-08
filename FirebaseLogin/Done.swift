//
//  Done.swift
//  FirebaseLogin
//
//  Created by Mansvi Desai on 10/12/23.
//

import SwiftUI

struct Done: View {
    @AppStorage("log_status") var logStatus: Bool = false
    
    var body: some View {
        VStack {
            
            
            Text("Congrats! You are verified")
                .font(.title2)
                .fontWeight(.bold)
            
            Button(action: {
                
                logStatus = true
                
            }, label: {
                Text("Done")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .frame(maxWidth: UIScreen.main.bounds.width / 1.3, maxHeight: 50)
                    .background(Color("Primary"))
                    .cornerRadius(6)
                    .shadow(color: Color("Primary").opacity(0.8), radius: 6, x: 1, y: 1)
            }).padding()
        }.frame(maxWidth: UIScreen.main.bounds.width / 1.2)
        .padding()
        .background(Color.white)
        .clipShape(
            RoundedRectangle(cornerRadius: 25)
        )
        .shadow(color: Color.black.opacity(0.2), radius: 25, x: 1, y: 1)
    }
}

struct Done_Previews: PreviewProvider {
    static var previews: some View {
        Login()
    }
}
