//
//  UnlitRenderPipeline.swift
//  Pong
//
//  Created by Luka Erkapic on 15.10.23.
//

import Foundation
import MetalKit

class UnlitRenderPipeline
{
    let renderPipelineState: MTLRenderPipelineState
    
    init(_ device: MTLDevice)
    {
        let shaderLibrary = ShaderLib(device, "unlitMaterialVS", "unlitMaterialFS")
        
        let renderDescriptor = MTLRenderPipelineDescriptor()
        renderDescriptor.label = "Unlit Render Pipeline"
        renderDescriptor.vertexFunction = shaderLibrary.vertexFunction!
        renderDescriptor.fragmentFunction = shaderLibrary.fragmentFunction!
        renderDescriptor.colorAttachments[0].pixelFormat = .bgra8Unorm
        
        guard let renderPipelineState = try? device.makeRenderPipelineState(descriptor: renderDescriptor) else {
            fatalError("Could not create Unlit Render Pipeline")
        }
        self.renderPipelineState = renderPipelineState
    }
    
    func draw(
        _ renderEncoder: MTLRenderCommandEncoder
    )
    {
        renderEncoder.setRenderPipelineState(renderPipelineState)
        
        renderEncoder.drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: 3)
    }
}
