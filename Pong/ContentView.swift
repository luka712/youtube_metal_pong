//
//  ContentView.swift
//  Pong
//
//  Created by Luka Erkapic on 20.10.23.
//

import SwiftUI
import MetalKit

struct ContentView: NSViewRepresentable
{
        
    func makeNSView(context: Context) -> MTKView {
        
        let view = MTKView()
        view.delegate = context.coordinator
        view.device = MTLCreateSystemDefaultDevice()
        view.drawableSize = CGSize(width: Constants.gameWidth, height: Constants.gameHeight)
        view.preferredFramesPerSecond = 60
        view.depthStencilPixelFormat = .depth32Float
        return view
    }
    
    func updateNSView(_ nsView: MTKView, context: Context) {
        
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
