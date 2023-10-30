//
//  SideView.swift
//  MindYourScreen
//
//  Created by Mac on 03/09/23.
//

import SwiftUI

struct SideView: View {
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.blue, .purple]), startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            
            VStack(alignment: .leading, spacing: 15) {
                Image(systemName: "person.crop.circle")
                    .font(.system(size: 50))
                Text("Dhruvik Sakariya")
                Spacer()
                Text("Profile")
                Text("Settrings")
                Spacer()
                Spacer()
                Spacer()
                
                HStack {
                    Image(systemName: "escape")
                    Text("Logout")
                }
                
            }
            .foregroundColor(.white)
            .padding(.trailing, 200)
            .padding(.top, 30)
        }
    }
}

struct SideView_Previews: PreviewProvider {
    static var previews: some View {
        SideView()
    }
}
