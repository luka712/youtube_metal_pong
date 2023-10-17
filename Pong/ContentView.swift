//
//  ContentView.swift
//  Pong
//
//  Created by Luka Erkapic on 15.10.23.
//

import SwiftUI
import MetalKit

struct ContentView: NSViewRepresentable {


    func makeNSView(context: Context) -> MTKView {
        
        let view = MTKView()
        view.delegate = context.coordinator
        view.device = MTLCreateSystemDefaultDevice()
        view.drawableSize = CGSize(
            width: Constants.gameWidth,
            height: Constants.gameHeight)
        view.preferredFramesPerSecond = 60
        return view
        
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator()
    }

    
     func updateNSView(_ nsView: NSViewType, context: Context) {
         
     }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
