//
//  ToastManager.swift
//  LQDNews
//
//  Created by Mohanraj on 17/03/26.
//


import UIKit
import Loaf

final class ToastManager {
    
    static func show(_ message: String, state: Loaf.State = .info) {
        guard let vc = UIApplication.shared.topViewController() else { return }
        Loaf(message, state: state, location: .bottom, sender: vc).show()
    }
}