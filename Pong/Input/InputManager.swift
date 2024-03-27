//
//  InputManager.swift
//  Pong
//
//  Created by Luka Erkapic on 11.03.24.
//

import Foundation
import GameController

class InputManager
{
    private var keyPressed: Dictionary<GCKeyCode, Bool> = [:]

    init()
    {
        NotificationCenter.default.addObserver(forName: .GCKeyboardDidConnect, object: nil, queue: nil){ notification in 
          
            let keyboard = notification.object as? GCKeyboard
            
            keyboard?.keyboardInput?.keyChangedHandler = { keyboard, key, keyCode, pressed in
                self.keyPressed[keyCode] = pressed
            }
            
        }
    }
    
    func isKeyPressed(_ keyCode: GCKeyCode) -> Bool {
        return keyPressed[keyCode] ?? false 
    }
}
