//
//  UnlitRenderPipeline.swift
//  Pong
//
//  Created by Luka Erkapic on 26.10.23.
//

import Foundation
import MetalKit

class UnlitRenderPipeline
{
    var renderPipelineState: MTLRenderPipelineState? = nil

    
    init(_ device: MTLDevice)
    {
        let shaderLibrary = ShaderLib(device, "unlitMaterialVS", "unlitMaterialFS")
        
        let renderDescriptor = MTLRenderPipelineDescriptor()
        renderDescriptor.label = "Unlit Render Pipeline"
        renderDescriptor.vertexFunction = shaderLibrary.vertexFunction!
        renderDescriptor.fragmentFunction = shaderLibrary.fragmentFunction!
        renderDescriptor.colorAttachments[0].pixelFormat = .bgra8Unorm
        
        guard let renderPipelineState = try?
                device.makeRenderPipelineState(descriptor: renderDescriptor) else {
            fatalError("Could not create Unlit Render Pipeline")
        }
        
        self.renderPipelineState = renderPipelineState
    }
    
    func draw(_ renderEncoder: MTLRenderCommandEncoder, _ buffers: GeometryBuffers)
    {
        renderEncoder.setRenderPipelineState(renderPipelineState!)
        renderEncoder.setVertexBuffer(buffers.positionsBuffer, offset: 0, index: 0)
        renderEncoder.setVertexBuffer(buffers.colorBuffer, offset: 0, index: 1)
        
        if buffers.usesIndices {
            renderEncoder.drawIndexedPrimitives(
                type: .triangle,
                indexCount: buffers.indexCount,
                indexType: .uint16,
                indexBuffer: buffers.indexBuffer!,
                indexBufferOffset: 0)
        }
        else {
            renderEncoder.drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: buffers.vertexCount)
        }
    }
}
