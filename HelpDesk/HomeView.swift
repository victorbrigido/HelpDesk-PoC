//
//  HomeView.swift
//  HelpDesk
//
//  Created by Victor Brigido on 18/07/24.
//

import SwiftUI

struct HomeView: View {
    @ObservedObject var sessionManager = SessionManager.shared
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        if sessionManager.userDataLoaded {
            VStack (spacing: 10){
                Text("Nome: \(sessionManager.currentUser?.nome ?? "Nome não disponível")")
                Text("Email: \(sessionManager.currentUser?.email ?? "Email não disponível")")
                Text("Permissão: \(sessionManager.currentUser?.permissao ?? "Permissão não disponível")")
                Text("UID: \(sessionManager.currentUser?.uid ?? "UID não disponível")")
                
                
                Button("Sair"){
                    logOut()
                }
                .foregroundColor(.red)
                .padding()
            }
        } else {
            ProgressView()
                .padding()
            Text("Carregando dados do usuário...")
                .font(.callout)
            
        }
    }
    
    private func logOut() {
            sessionManager.signOut()
            presentationMode.wrappedValue.dismiss()
    }
}

#Preview {
    HomeView()
}

