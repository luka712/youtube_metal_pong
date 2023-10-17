//
//  Renderer.swift
//  Pong
//
//  Created by Luka Erkapic on 15.10.23.
//

import Foundation
import MetalKit

class Renderer
{
    let device: MTLDevice
    var commandBuffer: MTLCommandBuffer!
    var renderPassEncoder: MTLRenderCommandEncoder!
    
    init(_ view: MTKView)
    {
        self.device = view.device!
    }
    
    public func beginFrame(_ drawToTexture: MTLTexture)
    {
        let commandQueue = device.makeCommandQueue()!
        self.commandBuffer = commandQueue.makeCommandBuffer()!
        
        
        let renderPassDescriptor = MTLRenderPassDescriptor()
        
        // draw to first color attachment
        let colorAttachment0 = renderPassDescriptor.colorAttachments[0]!;
        colorAttachment0.texture = drawToTexture
        colorAttachment0.loadAction = .clear
        colorAttachment0.storeAction = .store
        colorAttachment0.clearColor = MTLClearColorMake(1, 0, 0,  1)

        self.renderPassEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: renderPassDescriptor)!
    }
    
    public func endFrame(_ currentDrawable: MTLDrawable)
    {
        renderPassEncoder.endEncoding()
        commandBuffer.present(currentDrawable)
        commandBuffer.commit()
    }
}
