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
    var depthTexture: MTLTexture? = nil
    
    var unlitPipeline : UnlitRenderPipeline? = nil
    
    var geometryBuffer: GeometryBuffers? = nil
    var projectionViewBuffer: ConstantBuffer<simd_float4x4>? = nil
    
    // TRANSFORMS
    var transformsBuffer: ConstantBuffer<simd_float4x4>? = nil
    var transforms : [simd_float4x4] = Array(repeating: simd_float4x4(), count: 100)
    
    var angle : Float = 0
    
    
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        
        if !initialized {
            self.device = view.device!
            
            // CONFIGURE DEPTH STATE
            let depthDescriptor = MTLDepthStencilDescriptor()
            depthDescriptor.depthCompareFunction = .lessEqual
            depthDescriptor.isDepthWriteEnabled = true
            depthState = device?.makeDepthStencilState(descriptor: depthDescriptor)
            
            // DEPTH TEXTURE
            let depthTextureDescriptor = MTLTextureDescriptor()
            depthTextureDescriptor.pixelFormat = .depth32Float
            depthTextureDescriptor.width = Int(Constants.gameWidth)
            depthTextureDescriptor.height = Int(Constants.gameHeight)
            depthTextureDescriptor.usage = .renderTarget
            depthTexture = device?.makeTexture(descriptor: depthTextureDescriptor)
            
            unlitPipeline = UnlitRenderPipeline(device!)
            
            let geometry = GeometryBuilder().createCubeGeometry()
            geometryBuffer = GeometryBuffers(device!, geometry)
            
            let image = NSImage(named: "test_texture")
            unlitPipeline?.diffuseTexture = Texture2D(device!, image!)

            projectionViewBuffer = ConstantBuffer<simd_float4x4>(device!)
            var projectionView = Matrix.ortographic(-2, 2, -2, 2, 0, 5)
            projectionView = Matrix.perspective(45, Float(Constants.gameWidth) / Float(Constants.gameHeight) , 0.01, 10)
            projectionViewBuffer?.write(data: &projectionView)
            
            // TRANSFORMS
            transformsBuffer = ConstantBuffer<simd_float4x4>(device!,
                                                             MemoryLayout<simd_float4x4>.size * transforms.count)
            for i in 0..<100 {
                transforms[i] = Matrix.translate(
                    Float.random(in: -5..<5),
                    Float.random(in: -5..<5),
                    Float.random(in: 5..<10)
                )
            }
            transformsBuffer?.writeArray(data: &transforms)
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
        colorAttachment0.clearColor = MTLClearColorMake(0.8, 0.8,0.8, 1)
        
        // CONFIGURE DEPTH
        renderPassDescriptor.depthAttachment.clearDepth = 1.0
        renderPassDescriptor.depthAttachment.texture = depthTexture
        
        let renderPassEncoder = commandBuffer?.makeRenderCommandEncoder(descriptor: renderPassDescriptor)
        
        // SET DEPTH
        renderPassEncoder?.setDepthStencilState(depthState)
        
        // DRAW HERE
        for i in 0..<10 {
            var matrix = Matrix.translate(
                Float.random(in: -5..<5),
                Float.random(in: -5..<5),
                Float.random(in: 5..<10)
            )
            
            transformsBuffer?.write(data: &matrix, instance: i)
        }
        
        
        unlitPipeline?.draw(renderPassEncoder!, geometryBuffer!, projectionViewBuffer!, transformsBuffer!, 100)
        
        
        renderPassEncoder?.endEncoding()
        commandBuffer?.present(view.currentDrawable!)
        commandBuffer?.commit()
        
    }
    
    
}
