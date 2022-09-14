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
