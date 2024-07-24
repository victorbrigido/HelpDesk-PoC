//
//  AccessibleContentView.swift
//  HelpDesk
//
//  Created by Victor Brigido on 23/07/24.
//

import SwiftUI

struct AccessibleContentView: View {
    @State private var useAccessibleColors = false
    
    var body: some View {
        VStack {
            Toggle(isOn: $useAccessibleColors) {
                Text(useAccessibleColors ? "Modo Daltônico: Ligado" : "Modo Daltônico: Desligado")
                    .bold()
                    .foregroundColor(.white)
                    .padding()
                    .background(useAccessibleColors ? ColorPalette.highContrastBlue : Color.blue)
                    .cornerRadius(8)
                    .accessibilityLabel(Text("Toggle modo daltonico. Atualmente o modo é \(useAccessibleColors ? "Ligado" : "Desligado")."))
            }
            .padding()
            .toggleStyle(SwitchToggleStyle(tint: .accentColor))
            .animation(.easeInOut, value: useAccessibleColors)
            
            VStack {
                Text("Texto em azul")
                    .padding()
                    .background(useAccessibleColors ? ColorPalette.highContrastBlue : Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                
                Text("Texto em verde")
                    .padding()
                    .background(useAccessibleColors ? ColorPalette.highContrastGreen : Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                
                Text("Texto em amarelo")
                    .padding()
                    .background(useAccessibleColors ? ColorPalette.highContrastYellow : Color.yellow)
                    .foregroundColor(.black)
                    .cornerRadius(8)
                
                Text("Texto em vermelho")
                    .padding()
                    .background(useAccessibleColors ? ColorPalette.highContrastRed : Color.red)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .padding()
        }
    }
}

struct ColorPalette {
    static let highContrastBlue = Color(red: 0.0, green: 0.0, blue: 0.5)
    static let highContrastGreen = Color(red: 0.0, green: 0.5, blue: 0.0)
    static let highContrastYellow = Color(red: 1.0, green: 1.0, blue: 0.0)
    static let highContrastRed = Color(red: 0.5, green: 0.0, blue: 0.0)
}

struct AccessibleContentView_Previews: PreviewProvider {
    static var previews: some View {
        AccessibleContentView()
    }
}
