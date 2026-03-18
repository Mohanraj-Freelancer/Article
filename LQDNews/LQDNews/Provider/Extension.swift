//
//  Extension.swift
//  LQDNews
//
//  Created by Mohanraj on 17/03/26.
//

import UIKit

extension UIApplication {
    func topViewController() -> UIViewController? {
        guard let scene = connectedScenes.first as? UIWindowScene,
              let root = scene.windows.first?.rootViewController else {
            return nil
        }
        
        var top = root
        while let presented = top.presentedViewController {
            top = presented
        }
        return top
    }
}
