//
//  ContentView.swift
//  HelpDesk
//
//  Created by Victor Brigido on 18/07/24.
//

import SwiftUI
import Firebase

struct ContentView: View {
    @StateObject var sessionManager = SessionManager.shared
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var isLoggedIn = false
    @State private var errorMessage = ""
    
    var body: some View {
        VStack {
            TextField("Email", text: $email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            SecureField("Senha", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.top, 4)
        }
        .padding()
        .fullScreenCover(isPresented: $isLoggedIn, content: {
            HomeView()
        })
        
        if !errorMessage.isEmpty {
            Text(errorMessage)
                .font(.callout)
                .foregroundColor(.red)
                .padding(.top, 4)
        }
        
        Button(action: {
            signIn()
        }) {
            Text("Entrar")
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.blue)
                .cornerRadius(10)
        }
        .padding()
    }
    
    private func signIn() {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let error = error {
                errorMessage = error.localizedDescription
                print(errorMessage)
            } else {
                if let user = authResult?.user {
                    sessionManager.fetchUserData(uid: user.uid)
                    DispatchQueue.main.async {
                        isLoggedIn = true
                    }
                    print("Usuário logado: \(user.uid)")
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
