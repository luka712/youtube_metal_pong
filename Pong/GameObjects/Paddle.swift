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
    private let inputManager: InputManager
    
    public var playerOne = true
    public var paddleSpeed : Float = 0.2
    
    public var position = simd_float3(0,0,0)
    public var color = simd_float4(1,1,1,1)
    
    private let scale = simd_float3(1,5,1)
    
    private var transform: simd_float4x4
    private let pipeline: RenderPipeline
    private let transformBuffer: ConstantBuffer<simd_float4x4>
    private let normalMatrixBuffer: ConstantBuffer<simd_float4x4>
    
    init(_ device: MTLDevice, _ inputManager: InputManager)
    {
        self.inputManager = inputManager
        pipeline = RenderPipeline(device)
        transformBuffer = ConstantBuffer(device)
        transform = Matrix.identity()
        normalMatrixBuffer = ConstantBuffer(device)
    }
    
    public func update() {
        
        var dirY : Float = 0
        
        if playerOne {
            if inputManager.isKeyPressed(.keyW) {
                dirY = 1
            }
            else if inputManager.isKeyPressed(.keyS) {
                dirY = -1
            }
        }
        // Player two
        else {
            if inputManager.isKeyPressed(.upArrow) {
                dirY = 1
            }
            else if inputManager.isKeyPressed(.downArrow) {
                dirY = -1
            }
        }
        
        
        position.y += dirY * paddleSpeed
        
        if position.y > 5 {
            position.y = 5
        }
        else if position.y < -5 {
            position.y = -5
        }
        
    }
    
    public func draw(_ renderEncoder: MTLRenderCommandEncoder, _ camera: Camera,
                     _ ambientLight: AmbientLight ,
                     _ directionalLight: DirectionalLight,
                     _ pointLights: PointLightsCollection)
    {
        transform = Matrix.translate(position.x, position.y, position.z)
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
