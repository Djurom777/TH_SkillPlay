//
//  LoadingView.swift
//  TH_SkillPlay
//
//  Created by IGOR on 28/08/2025.
//

import SwiftUI

struct LoadingView: View {
    var body: some View {

        ZStack {
            
            Color.gray.opacity(0.4)
                .ignoresSafeArea()
            
            VStack {
                
                Image("aispth")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 120)
            }
            
            VStack {
                
                Spacer()
                
                ProgressView()
                    .padding(.bottom)
            }
        }
    }
}

#Preview {
    LoadingView()
}
