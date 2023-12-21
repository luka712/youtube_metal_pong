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
    
    var unlitPipeline : UnlitRenderPipeline? = nil
    
    var geometryBuffer: GeometryBuffers? = nil
    var projectionViewBuffer: ConstantBuffer<simd_float4x4>? = nil
    
    var angle : Float = 0
    
    
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        
        if !initialized {
            self.device = view.device!
            
            unlitPipeline = UnlitRenderPipeline(device!)
            
            let geometry = GeometryBuilder().createCubeGeometry()
            geometryBuffer = GeometryBuffers(device!, geometry)
            
            let image = NSImage(named: "test_texture")
            unlitPipeline?.diffuseTexture = Texture2D(device!, image!)

            projectionViewBuffer = ConstantBuffer<simd_float4x4>(device!)
            var projectionView = Matrix.ortographic(-2, 2, -2, 2, 0, 5)
            projectionView = Matrix.perspective(45, Float(Constants.gameWidth) / Float(Constants.gameHeight) , 0.01, 5)
            projectionViewBuffer?.write(data: &projectionView)
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
        
        let renderPassEncoder = commandBuffer?.makeRenderCommandEncoder(descriptor: renderPassDescriptor)
        
        // DRAW HERE
        unlitPipeline?.transform = Matrix.translate(0,0,3) * Matrix.rotationX(angle)
        angle += 0.01
        unlitPipeline?.draw(renderPassEncoder!, geometryBuffer!, projectionViewBuffer!)

        
        renderPassEncoder?.endEncoding()
        commandBuffer?.present(view.currentDrawable!)
        commandBuffer?.commit()
        
    }
    
    
}
