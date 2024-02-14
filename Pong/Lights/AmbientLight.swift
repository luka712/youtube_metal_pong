//
//  AmbientLight.swift
//  Pong
//
//  Created by Luka Erkapic on 12.02.24.
//

import Foundation
import simd
import MetalKit

class AmbientLight
{
    public var color = simd_float3(1,1,1);
    public var intensity : Float = 0.1
    
    public let buffer: ConstantBuffer<simd_float4>
    
    init(_ device: MTLDevice)
    {
        buffer = ConstantBuffer(device)
    }
    
    public func update()
    {
        var writeData = simd_float4(color.x, color.y, color.z, intensity)
        buffer.write(data: &writeData)
    }
}
