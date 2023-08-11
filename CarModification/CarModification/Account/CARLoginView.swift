//
//  CARLoginView.swift
//  CarModification
//
//  Created by GorCat on 2023/8/11.
//

import SwiftUI

struct CARLoginView: View {
    var body: some View {
        ZStack {
            Image("car_login_backgroud")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .edgesIgnoringSafeArea(.all)
                .frame(width: CAR_ScreenWidth)
            
            VStack(spacing: 0) {
                Image("car_login_titleMessage")
                    .offset(x: -29)
                
                car_signInView
                    .padding(.top, 277)
                
                car_signUpView
                    .padding(.top, 30)
                
                Image("car_login_appleIcon")
                    .padding(.top, 30)
                
                car_EULAView
                    .padding(.top, 49)
            }
        }
    }
    
    var car_signInView: some View {
        Text("Sign in")
            .font(.car_system(size: 16).bold())
            .foregroundColor(.white)
            .frame(width: 255, height: 50)
            .background(
                Capsule()
                    .stroke(lineWidth: 1)
                    
            )
    }
    
    var car_signUpView: some View {
        Text("Sign up")
            .font(.car_system(size: 16).bold())
            .foregroundColor(.car_yellow)
            .frame(width: 255, height: 50)
            .background(
                Capsule()
                    .fill(Color.black)
                    
            )
    }
    
    var car_EULAView: some View {
        VStack(spacing: 0) {
            Text("Continue means you agree with our")
                .font(.car_system(size: 12))
            
            HStack(spacing: 0) {
                Text("Terms of Service")
                    .underline()
                
                Text("EULA")
                    .underline()
            }
            .foregroundColor(.car_yellow)
            .font(.car_system(size: 12).weight(.bold))
        }
    }

}

struct CARLoginView_Previews: PreviewProvider {
    static var previews: some View {
        CARLoginView()
    }
}
