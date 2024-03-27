//
//  PointLight.swift
//  Pong
//
//  Created by Luka Erkapic on 29.02.24.
//

import Foundation
import simd
import MetalKit

class PointLight
{
    public var color = simd_float3(1,1,1)
    public var intensity : Float = 3
    public var position = simd_float3(0,-1,0)
    
    public var attenConstant: Float = 0.5
    public var attenLinear : Float = 0.2
    public var attenQuadtratic : Float = 0.08
    
    public var specularColor = simd_float3(1,1,1);
    public var specularIntensity: Float = 1
}

class PointLightsCollection
{
    public let lights: [PointLight]
    public let buffer: ConstantBuffer<simd_float4x4>
    
    init (_ device: MTLDevice)
    {
        buffer = ConstantBuffer(device, MemoryLayout<simd_float4x4>.size * 3, "Point Lights Buffer")
        lights = [
          PointLight(),
          PointLight(),
          PointLight()
        ]
    }
    
    public func update()
    {
        
        for i in 0...2 {
            
            var light = lights[i]
            
            var writeData = simd_float4x4(
                simd_float4(light.color.x, light.color.y, light.color.z, light.intensity),
                simd_float4(light.position.x, light.position.y, light.position.z, light.attenConstant),
                simd_float4(light.attenLinear, light.attenQuadtratic, light.specularIntensity, light.specularColor.x),
                simd_float4(light.specularColor.y, light.specularColor.z, 0,0 )
            )
            buffer.write(data: &writeData, instance: i)
        }
    
    }
}
