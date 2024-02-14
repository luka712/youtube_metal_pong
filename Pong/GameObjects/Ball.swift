//
//  Ball.swift
//  Pong
//
//  Created by Luka Erkapic on 06.02.24.
//

import Foundation
import MetalKit

class Ball
{
    public var position = simd_float3(0,0,0)
    public var color = simd_float4(1,1,1,1)
    
    private let scale = simd_float3(1,1,1)
    
    private var transform: simd_float4x4
    private let pipeline: RenderPipeline
    private let transformBuffer: ConstantBuffer<simd_float4x4>
    
    init(_ device: MTLDevice)
    {
        pipeline = RenderPipeline(device)
        transformBuffer = ConstantBuffer(device)
        transform = Matrix.identity()
    }
    
    public func draw(_ renderEncoder: MTLRenderCommandEncoder, _ camera: Camera,
                     _ ambientLight: AmbientLight,
                     _ directionalLight: DirectionalLight)
    {
        transform = Matrix.scale(scale.x, scale.y, scale.z)
        transform *= Matrix.translate(position.x, position.y, position.z)
        
        transformBuffer.write(data: &transform)
        
        pipeline.diffuseColor = color
        pipeline.draw(renderEncoder,
                      GeometryBuffersCollection.cubeGeometryBuffer!,
                      camera,
                      transformBuffer,
                      ambientLight,
                     directionalLight
        )
    }
}
