//
//  PicToggleStyle.swift
//  Features
//
//  Created by wonsik on 3/26/26.
//

import SwiftUI

struct PicToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        let isOn = configuration.isOn
        let trackColor: Color = isOn ? Color(.pGreen100) : Color(.pGrey1)
        let borderColor: Color = isOn ? Color(.pGreen100) : Color(.pGrey2)

        ZStack {
            RoundedRectangle(cornerRadius: 22.63)
                .fill(trackColor)
                .overlay(
                    RoundedRectangle(cornerRadius: 22.63)
                        .stroke(Color.black.opacity(0.25), lineWidth: 1)
                        .blur(radius: 1)
                        .offset(x: 0.75, y: 0.75)
                        .clipShape(RoundedRectangle(cornerRadius: 22.63))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 22.63)
                        .strokeBorder(borderColor, lineWidth: 0.75)
                )
                .frame(width: 56, height: 28)

            Circle()
                .fill(Color.white)
                .shadow(color: .black.opacity(0.25), radius: 2.92, x: -0.73, y: 0.73)
                .frame(width: 19, height: 19)
                .offset(x: isOn ? 14.5 : -14.5)
        }
        .animation(.easeInOut(duration: 0.2), value: isOn)
        .onTapGesture {
            configuration.isOn.toggle()
        }
    }
}
