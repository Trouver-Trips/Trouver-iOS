//
//  UIApplication+ViewController.swift
//  Trouver
//
//  Created by Sagar Punhani on 1/2/21.
//

import UIKit

extension UIApplication {
    static var currentViewController: UIViewController? {
        UIApplication.shared.windows.last?.rootViewController
    }
}
