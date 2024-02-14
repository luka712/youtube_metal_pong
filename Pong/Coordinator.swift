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
    var depthState: MTLDepthStencilState? = nil
    var depthTexture: Texture2D? = nil
    
    // LIGHTS
    var ambientLight: AmbientLight? = nil
    var directionalLight: DirectionalLight? = nil
    
        
    // GAME OBJECTS
    var camera: Camera? = nil
    var paddle1: Paddle? = nil
    var paddle2: Paddle? = nil
    var ball: Ball? = nil
    
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        
        if !initialized {
            self.device = view.device!
            
            // CONFIGURE DEPTH STATE
            let depthDescriptor = MTLDepthStencilDescriptor()
            depthDescriptor.depthCompareFunction = .lessEqual
            depthDescriptor.isDepthWriteEnabled = true
            depthState = device?.makeDepthStencilState(descriptor: depthDescriptor)
            
            // DEPTH TEXTURE
            depthTexture = Texture2D.createDepthTexture(device!)
            
            // INITIALIZE GEOMETRY BUFFERS
            GeometryBuffersCollection.initialize(device!)
            
            // LIGHTS
            ambientLight = AmbientLight(device!)
            ambientLight?.intensity = 0.2
            directionalLight = DirectionalLight(device!)
            directionalLight?.direction = simd_float3(0,0,1)
            directionalLight?.intensity = 0.8
            
            // GAME OBJECTS
            camera = Camera(device!)
            camera?.position = simd_float3(0,0, -20)
            camera?.target = simd_float3(0,0,0)
            paddle1 = Paddle(device!)
            paddle1?.position.x = -10
            paddle1?.color = simd_float4(0,0,1,1)
            paddle2 = Paddle(device!)
            paddle2?.position.x = 10
            paddle2?.color = simd_float4(1,0,0,1)
            ball = Ball(device!)
        }
    }
    
    func update()
    {
        camera?.update()
        ambientLight?.update()
        directionalLight?.update()
    }
    
    func draw(in view: MTKView) {
        
        if device == nil {
            return
        }
        
        update()
        
        let queue = device!.makeCommandQueue()
        
        let commandBuffer = queue?.makeCommandBuffer()
        
        let renderPassDescriptor = MTLRenderPassDescriptor()
        
        let colorAttachment0 = renderPassDescriptor.colorAttachments[0]!
        colorAttachment0.texture = view.currentDrawable?.texture
        colorAttachment0.loadAction = .clear
        colorAttachment0.storeAction = .store
        colorAttachment0.clearColor = MTLClearColorMake(1, 0.7,0.8, 1)
        
        // CONFIGURE DEPTH
        renderPassDescriptor.depthAttachment.clearDepth = 1.0
        renderPassDescriptor.depthAttachment.texture = depthTexture?.texture!


        let renderPassEncoder = commandBuffer?.makeRenderCommandEncoder(descriptor: renderPassDescriptor)
        
        // SET DEPTH
        renderPassEncoder?.setDepthStencilState(depthState)
        
        // DRAW HERE
        paddle1?.draw(renderPassEncoder!, camera!, ambientLight!, directionalLight!)
        paddle2?.draw(renderPassEncoder!, camera!, ambientLight!, directionalLight!)
        ball?.draw(renderPassEncoder!, camera!, ambientLight!, directionalLight!)
        
        renderPassEncoder?.endEncoding()
        commandBuffer?.present(view.currentDrawable!)
        commandBuffer?.commit()
        
    }
    
    
}
