import SwiftUI
#if os(iOS)
import UIKit
#else
import AppKit
#endif

struct RoundedCorner: Shape {
    let radius: CGFloat
    let corners: Corner
    
    init(radius: CGFloat = .infinity, corners: Corner = .allCorners) {
        self.radius = radius
        self.corners = corners
    }
    
    func path(in rect: CGRect) -> Path {
        #if os(iOS)
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners.uiRectCorner, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
        #else
        var path = Path()
        let topLeft = corners.contains(.topLeft)
        let topRight = corners.contains(.topRight)
        let bottomLeft = corners.contains(.bottomLeft)
        let bottomRight = corners.contains(.bottomRight)
        
        let topLeftRadius = topLeft ? radius : 0
        let topRightRadius = topRight ? radius : 0
        let bottomLeftRadius = bottomLeft ? radius : 0
        let bottomRightRadius = bottomRight ? radius : 0
        
        path.move(to: CGPoint(x: rect.minX + topLeftRadius, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX - topRightRadius, y: rect.minY))
        path.addArc(center: CGPoint(x: rect.maxX - topRightRadius, y: rect.minY + topRightRadius),
                    radius: topRightRadius,
                    startAngle: Angle(degrees: -90),
                    endAngle: Angle(degrees: 0),
                    clockwise: false)
        
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY - bottomRightRadius))
        path.addArc(center: CGPoint(x: rect.maxX - bottomRightRadius, y: rect.maxY - bottomRightRadius),
                    radius: bottomRightRadius,
                    startAngle: Angle(degrees: 0),
                    endAngle: Angle(degrees: 90),
                    clockwise: false)
        
        path.addLine(to: CGPoint(x: rect.minX + bottomLeftRadius, y: rect.maxY))
        path.addArc(center: CGPoint(x: rect.minX + bottomLeftRadius, y: rect.maxY - bottomLeftRadius),
                    radius: bottomLeftRadius,
                    startAngle: Angle(degrees: 90),
                    endAngle: Angle(degrees: 180),
                    clockwise: false)
        
        path.addLine(to: CGPoint(x: rect.minX, y: rect.minY + topLeftRadius))
        path.addArc(center: CGPoint(x: rect.minX + topLeftRadius, y: rect.minY + topLeftRadius),
                    radius: topLeftRadius,
                    startAngle: Angle(degrees: 180),
                    endAngle: Angle(degrees: 270),
                    clockwise: false)
        
        path.closeSubpath()
        return path
        #endif
    }
}

struct Corner: OptionSet {
    let rawValue: Int
    
    static let topLeft = Corner(rawValue: 1 << 0)
    static let topRight = Corner(rawValue: 1 << 1)
    static let bottomLeft = Corner(rawValue: 1 << 2)
    static let bottomRight = Corner(rawValue: 1 << 3)
    
    static let allCorners: Corner = [.topLeft, .topRight, .bottomLeft, .bottomRight]
    
    #if os(iOS)
    var uiRectCorner: UIRectCorner {
        var result: UIRectCorner = []
        if contains(.topLeft) { result.insert(.topLeft) }
        if contains(.topRight) { result.insert(.topRight) }
        if contains(.bottomLeft) { result.insert(.bottomLeft) }
        if contains(.bottomRight) { result.insert(.bottomRight) }
        return result
    }
    #endif
}
