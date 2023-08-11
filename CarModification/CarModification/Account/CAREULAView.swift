//
//  CAREULAView.swift
//  CarModification
//
//  Created by GorCat on 2023/8/11.
//

import SwiftUI

struct CAREULAView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack {
            Spacer()
            VStack(spacing: 0) {
                Text("EULA")
                    .font(.car_system(size: 18).bold())
                
                Text(
"""
End User License Agreement (EULA)
1. Acknowledgement
This End-User License Agreement („EULA“) is a legal agreement between you and Aiken Bab.
This agreement is between You and Aiken Bab only, and not Apple Inc. („Apple“). Aiken Bab, not Apple is solely responsible for the Spark-Video iOS App and their content. Although Apple is not a party to this agreement, Apple has the right to enforce this agreement against you as a third party beneficiary relating to your use of the Spark-Video iOS App.
2. Scope of License
Aiken Bab grants you a limited, non-exclusive, non-transferrable , revocable license to use the Spark-Video iOS Apps for your personal, non-commercial purposes. You may only use the Spark-Video iOS Apps on an iPhone, iPod Touch, iPad, or other Apple device that you own or control and as permitted by the Apple App Store Terms of Service.
3. Maintenance and Support
the right (and will be deemed to have accepted
"""
                )
                .padding(.top, 20)
                .padding(.horizontal, 20)
                .foregroundColor(.car_textGray)
                .font(.car_system(size: 12))
                
                Text("Agree")
                    .frame(width: 235, height: 48)
                    .font(.car_system(size: 16).bold())
                    .background(
                        Capsule()
                            .fill(Color.car_yellow)
                    )
                    .padding(.top, 30)
                    .padding(.bottom, 50)
                    .onTapGesture {
                        presentationMode.wrappedValue.dismiss()
                    }
                
            }
            .background(
                CustomCornersShape([
                    .topLeft(30),
                    .topRight(30)
                ])
                .fill(Color.white)
                .edgesIgnoringSafeArea(.bottom)
            )
        }
    }
}

struct CAREULAView_Previews: PreviewProvider {
    static var previews: some View {
        CAREULAView()
    }
}
