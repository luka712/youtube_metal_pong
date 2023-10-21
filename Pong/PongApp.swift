//
//  PongApp.swift
//  Pong
//
//  Created by Luka Erkapic on 20.10.23.
//

import SwiftUI

@main
struct PongApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .frame(width: CGFloat(Constants.gameWidth), height: CGFloat(Constants.gameHeight))
        }
    }
}
