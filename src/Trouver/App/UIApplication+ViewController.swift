//
//  UIApplication+ViewController.swift
//  Trouver
//
//  Created by Sagar Punhani on 1/2/21.
//

import UIKit

extension UIApplication {
    static var currentViewController: UIViewController! {
        // Get connected scenes
        return UIApplication.shared.connectedScenes
            // Keep only active scenes, onscreen and visible to the user
            .filter { $0.activationState == .foregroundActive }
            // Keep only the first `UIWindowScene`
            .first(where: { $0 is UIWindowScene })
            // Get its associated windows
            .flatMap({ $0 as? UIWindowScene })?.windows
            // Finally, keep only the key window
            .first(where: \.isKeyWindow)?
            // Get root view controller
            .rootViewController!
    }
}
