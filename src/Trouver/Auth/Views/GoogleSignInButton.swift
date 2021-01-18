//
//  GoogleSignInButton.swift
//  Trouver
//
//  Created by Sagar Punhani on 1/2/21.
//

import SwiftUI
import GoogleSignIn

struct GoogleSignInButton: UIViewRepresentable {

    func makeUIView(context: Context) -> GIDSignInButton {
        let googleManager = GIDSignIn.sharedInstance()
        if googleManager?.presentingViewController == nil {
            googleManager?.presentingViewController = UIApplication.currentViewController
        }
        let button = GIDSignInButton()
        // Customize button here
        button.colorScheme = .light
        return button
    }

    func updateUIView(_ uiView: UIViewType, context: Context) {}
}

struct GoogleSignInButtonPreviews: PreviewProvider {
    static var previews: some View {
        GoogleSignInButton()
    }
}
