//
//  Coordinator.swift
//  Pong
//
//  Created by Luka Erkapic on 20.10.23.
//

import Foundation
import MetalKit

class Coordinator : NSObject, MTKViewDelegate {
    
    var initialized = false
    
    var device: MTLDevice? = nil
    
    var renderPipelineState: MTLRenderPipelineState? = nil
    
    
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {

        if !initialized {
            self.device = view.device!
            
            let shaderLibrary = ShaderLib(device!, "unlitMaterialVS", "unlitMaterialFS")
            
            let renderDescriptor = MTLRenderPipelineDescriptor()
            renderDescriptor.label = "Unlit Render Pipeline"
            renderDescriptor.vertexFunction = shaderLibrary.vertexFunction!
            renderDescriptor.fragmentFunction = shaderLibrary.fragmentFunction!
            renderDescriptor.colorAttachments[0].pixelFormat = .bgra8Unorm
            
            guard let renderPipelineState = try?
                    device!.makeRenderPipelineState(descriptor: renderDescriptor) else {
                fatalError("Could not create Unlit Render Pipeline")
            }
            
            self.renderPipelineState = renderPipelineState
        }
    }
    
    func draw(in view: MTKView) {
        
        if device == nil {
            return
        }
        
        let queue = device!.makeCommandQueue()
        
        let commandBuffer = queue?.makeCommandBuffer()
        
        let renderPassDescriptor = MTLRenderPassDescriptor()
        
        let colorAttachment0 = renderPassDescriptor.colorAttachments[0]!
        colorAttachment0.texture = view.currentDrawable?.texture
        colorAttachment0.loadAction = .clear
        colorAttachment0.storeAction = .store
        colorAttachment0.clearColor = MTLClearColorMake(1, 0,0, 1)
        
        let renderPassEncoder = commandBuffer?.makeRenderCommandEncoder(descriptor: renderPassDescriptor)
        
        // DRAW HERE
        renderPassEncoder?.setRenderPipelineState(renderPipelineState!)
        renderPassEncoder?.drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: 3)
        
        
        renderPassEncoder?.endEncoding()
        commandBuffer?.present(view.currentDrawable!)
        commandBuffer?.commit()
        
        
    }
    
    
}
