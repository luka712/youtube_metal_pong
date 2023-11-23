//
//  UnlitRenderPipeline.swift
//  Pong
//
//  Created by Luka Erkapic on 26.10.23.
//

import Foundation
import MetalKit
import simd

class UnlitRenderPipeline
{
    var renderPipelineState: MTLRenderPipelineState? = nil
    var diffuseTexture: Texture2D

    private var _textureTilling = simd_float2(1,1)
    private var textureTillingBuffer: ConstantBuffer<simd_float2>
    
    var textureTilling: simd_float2 {
        get { return _textureTilling}
        set {
            _textureTilling = newValue
            textureTillingBuffer.write(data: &_textureTilling)
        }
    }
    
    private var _diffuseColor = simd_float4(1,1,1,1)
    private var diffuseColorBuffer: ConstantBuffer<simd_float4>
    
    var diffuseColor: simd_float4 {
        get { return _diffuseColor}
        set {
            _diffuseColor = newValue
            diffuseColorBuffer.write(data: &_diffuseColor)
        }
    }
    
    private var _transform = Matrix.identity()
    private var transformBuffer: ConstantBuffer<simd_float4x4>
    
    var transform: simd_float4x4 {
        get { return _transform}
        set {
            _transform = newValue
            transformBuffer.write(data: &_transform)
        }
    }
    
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
        diffuseTexture = Texture2D.makeEmpty(device)
        
        textureTillingBuffer = ConstantBuffer(device)
        diffuseColorBuffer = ConstantBuffer(device)
        transformBuffer = ConstantBuffer(device)
        
        textureTilling = simd_float2(5,5)
        diffuseColor = simd_float4(1,1,1,1)
        transform = Matrix.identity()
    }
    
    
    func draw(_ renderEncoder: MTLRenderCommandEncoder, _ buffers: GeometryBuffers)
    {
        renderEncoder.setRenderPipelineState(renderPipelineState!)
        renderEncoder.setVertexBuffer(buffers.positionsBuffer, offset: 0, index: 0)
        renderEncoder.setVertexBuffer(buffers.colorBuffer, offset: 0, index: 1)
        renderEncoder.setVertexBuffer(buffers.texCoordsBuffer, offset: 0, index: 2)
        renderEncoder.setVertexBuffer(transformBuffer.buffer, offset: 0, index: 3)
        renderEncoder.setVertexBuffer(textureTillingBuffer.buffer, offset: 0, index: 4)
        
        renderEncoder.setFragmentBuffer(diffuseColorBuffer.buffer, offset: 0, index: 0)
        renderEncoder.setFragmentTexture(diffuseTexture.texture, index: 0)
        renderEncoder.setFragmentSamplerState(diffuseTexture.samplerState, index: 0)
      
        
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
