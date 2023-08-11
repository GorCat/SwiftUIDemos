//
//  CustomCornersView.swift
//  CarModification
//
//  Created by GorCat on 2023/8/11.
//

import SwiftUI

enum CustomCorners {
    case topLeft(CGFloat)
    case topRight(CGFloat)
    case bottomLeft(CGFloat)
    case bottomRight(CGFloat)
}

struct CustomCornersShape: Shape {
    private var topLeft: CGFloat = 0
    private var topRight: CGFloat = 0
    private var bottomLeft: CGFloat = 0
    private var bottomRight: CGFloat = 0
    
    init(_ corners: [CustomCorners]) {
        for corner in corners {
            switch corner {
            case .topLeft(let cGFloat):
                topLeft = cGFloat
            case .topRight(let cGFloat):
                topRight = cGFloat
            case .bottomLeft(let cGFloat):
                bottomLeft = cGFloat
            case .bottomRight(let cGFloat):
                bottomRight = cGFloat
            }
        }
    }
    
    func path(in rect: CGRect) -> Path {
        Path { path in
            let w = rect.size.width
            let h = rect.size.height
            
            let tr = min(topRight, min(w/2, h/2))
            let tl = min(topLeft, min(w/2, h/2))
            let bl = min(bottomLeft, min(w/2, h/2))
            let br = min(bottomRight, min(w/2, h/2))
            
            path.move(to: CGPoint(x: w/2, y: 0))
            
            path.addLine(to: CGPoint(x: w - tr, y: 0))
            path.addArc(center: CGPoint(x: w - tr, y: tr), radius: tr, startAngle: Angle(degrees: -90), endAngle: Angle(degrees: 0), clockwise: false)
            
            path.addLine(to: CGPoint(x: w, y: h - br))
            path.addArc(center: CGPoint(x: w - br, y: h - br), radius: br, startAngle: Angle(degrees: 0), endAngle: Angle(degrees: 90), clockwise: false)
            
            path.addLine(to: CGPoint(x: bl, y: h))
            path.addArc(center: CGPoint(x: bl, y: h - bl), radius: bl, startAngle: Angle(degrees: 90), endAngle: Angle(degrees: 180), clockwise: false)
            
            path.addLine(to: CGPoint(x: 0, y: tl))
            path.addArc(center: CGPoint(x: tl, y: tl), radius: tl, startAngle: Angle(degrees: 180), endAngle: Angle(degrees: 270), clockwise: false)
        }
    }
    
}
