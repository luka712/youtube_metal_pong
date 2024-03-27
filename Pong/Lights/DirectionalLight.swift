//
//  AmbientLight.swift
//  Pong
//
//  Created by Luka Erkapic on 13.02.24.
//

import Foundation
import simd
import MetalKit

class DirectionalLight
{
    public var color = simd_float3(1,1,1)
    public var intensity : Float = 0.1
    public var direction = simd_float3(0,-1,0)
    public var specularColor = simd_float3(1,1,1);
    public var specularIntensity: Float = 1
    
    public let buffer: ConstantBuffer<simd_float3x4>
    
    init (_ device: MTLDevice)
    {
        buffer = ConstantBuffer(device)
    }
    
    public func update()
    {
        var writeData = simd_float3x4(
            simd_float4(color.x, color.y, color.z, intensity),
            simd_float4(direction.x, direction.y, direction.z, specularIntensity),
            simd_float4(specularColor.x, specularColor.y, specularColor.z, 0)
        )
        buffer.write(data: &writeData)
    }
}
