//
//  FTActivityIndicator.swift
//  LQDNews
//
//  Created by Mohanraj on 17/03/26.
//


import SwiftUI
import FTLinearActivityIndicator

struct FTActivityIndicator: UIViewRepresentable {
    @Binding var isAnimating: Bool

    func makeUIView(context: Context) -> FTLinearActivityIndicator {
        let indicator = FTLinearActivityIndicator()
        // Optional: Customize color to match your Liquid Glass design
        return indicator
    }

    func updateUIView(_ uiView: FTLinearActivityIndicator, context: Context) {
        if isAnimating {
            uiView.startAnimating()
        } else {
            uiView.stopAnimating()
        }
    }
}