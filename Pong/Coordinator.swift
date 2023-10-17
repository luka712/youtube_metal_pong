//
//  Renderer.swift
//  Pong
//
//  Created by Luka Erkapic on 15.10.23.
//

import Foundation
import MetalKit

class Coordinator : NSObject, MTKViewDelegate
{
    var renderer: Renderer?
    
    var unlitPipeline: UnlitRenderPipeline?
    
    var initialized = false
    
    
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        
        if !initialized {
            self.renderer = Renderer(view)
            
            self.unlitPipeline = UnlitRenderPipeline(view.device!)
        }
    }
    
    func draw(in view: MTKView) {
                
        let drawable = view.currentDrawable!
        
        renderer?.beginFrame(drawable.texture)
        let renderCommandEncoder = renderer?.renderPassEncoder
        
        // DRAW
        unlitPipeline?.draw(renderCommandEncoder!)
        
        renderer?.endFrame(drawable)
    }
    
    
}
