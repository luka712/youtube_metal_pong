//
//  Paddle.swift
//  Pong
//
//  Created by Luka Erkapic on 06.02.24.
//

import Foundation
import MetalKit

class Paddle
{
    public var position = simd_float3(0,0,0)
    public var color = simd_float4(1,1,1,1)
    
    private let scale = simd_float3(1,5,1)
    
    private var transform: simd_float4x4
    private let pipeline: RenderPipeline
    private let transformBuffer: ConstantBuffer<simd_float4x4>
    private let normalMatrixBuffer: ConstantBuffer<simd_float4x4>
    
    private var angle: Float = 0
    
    init(_ device: MTLDevice)
    {
        pipeline = RenderPipeline(device)
        transformBuffer = ConstantBuffer(device)
        transform = Matrix.identity()
        normalMatrixBuffer = ConstantBuffer(device)
    }
    
    public func draw(_ renderEncoder: MTLRenderCommandEncoder, _ camera: Camera,
                     _ ambientLight: AmbientLight ,
                     _ directionalLight: DirectionalLight,
                     _ pointLights: PointLightsCollection)
    {
        angle += 0.01
        transform = Matrix.translate(position.x, position.y, position.z)
        transform *= Matrix.rotationZ(angle)
        transform *= Matrix.scale(scale.x, scale.y, scale.z)
        transformBuffer.write(data: &transform)
        
        // normal matrix
        var normalMatrix = simd_inverse(simd_transpose(transform))
        normalMatrixBuffer.write(data: &normalMatrix)
        
        pipeline.diffuseColor = color
        pipeline.draw(renderEncoder,
                      GeometryBuffersCollection.cubeGeometryBuffer!,
                      camera,
                      transformBuffer,
                      normalMatrixBuffer,
                      ambientLight,
                      directionalLight,
                      pointLights)
    }
}
