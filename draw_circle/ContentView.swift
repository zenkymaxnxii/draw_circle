//
//  ContentView.swift
//  draw_circle
//
//  Created by Hoàng Hồng Quân on 14/09/2022.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        Text("he")
    }
}


struct LineView: View {
    @State var removeAll = false
    @State var lines = [CGPoint]()
    
    private func arrowPath() -> Path {
        // Doing it rightwards
        Path { path in
            path.move(to: .zero)
            path.addLine(to: .init(x: -20.0, y: 10.0))
            path.addLine(to: .init(x: -20.0, y: -10.0))
            path.closeSubpath()
        }
    }
    
    private func arrowTransform(lastPoint: CGPoint, previousPoint: CGPoint) -> CGAffineTransform {
        let translation = CGAffineTransform(translationX: lastPoint.x, y: lastPoint.y)
        let angle = atan2(lastPoint.y-previousPoint.y, lastPoint.x-previousPoint.x)
        let rotation = CGAffineTransform(rotationAngle: angle)
        return rotation.concatenating(translation)
    }
    
    var body: some View {
        ZStack {
            Rectangle()
                .cornerRadius(20)
                .opacity(0.1)
                .shadow(color: .gray, radius: 4, x: 0, y: 2)
            Path { path in
                path.addLines(lines)
            }
            .stroke(lineWidth: 3)
            if lines.count >= 2 {
                arrowPath()
                    .transform(arrowTransform(lastPoint: lines[lines.count-1], previousPoint: lines[lines.count-2]))
                    .fill()
            }
        }
        .gesture(
            DragGesture()
                .onChanged { state in
                    if removeAll {
                        lines.removeAll()
                        removeAll = false
                    }
                    
                    lines.append(state.location)
                }
                .onEnded { _ in
                    removeAll = true
                }
        )
        .frame(width: 370, height: 500)
    }
}


struct CirclesView: View {
    @State var startPoint = CGPoint(x: 0,y: 0)
    @State var endPoint = CGPoint(x: 0,y: 0)
    @State var isHiddenStart = true
    @State var isHiddenEnd = true
    var body: some View{
        GeometryReader{
            geometry in
            ZStack{
                Circle()
                    .offset(x: startPoint.x, y: startPoint.y)
                    .fill(Color.blue)
                    .frame(width: 40, height: 40)
                    .isHidden(isHiddenStart)
                Circle()
                    .offset(x: endPoint.x, y: endPoint.y)
                    .fill(Color.red)
                    .frame(width: 40, height: 40)
                    .isHidden(isHiddenEnd)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.gray)
                    .gesture(DragGesture(minimumDistance: 0)
                        .onChanged({ value in
                            let halfWidth = geometry.size.width/2
                            let halfHeight = geometry.size.height/2
                            let offset = CGPoint(x: value.location.x - halfWidth, y: value.location.y - halfHeight)
                            if isHiddenStart{
                                startPoint = offset
                                isHiddenStart = !isHiddenStart
                            } else {
                                endPoint = offset
                                isHiddenEnd = !isHiddenEnd
                            }
                        }))
        }.frame(maxWidth: .infinity, maxHeight: .infinity)
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        CirclesView()
    }
}

extension View{
    @ViewBuilder func isHidden(_ hidden: Bool) -> some View{
        if hidden {
            self.hidden()
        } else {
            self
        }
    }
}
