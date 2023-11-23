//
//  Matrix.swift
//  Pong
//
//  Created by Luka Erkapic on 22.11.23.
//

import Foundation
import simd

class Matrix
{
    static func identity() -> simd_float4x4
    {
        return simd_float4x4(
            simd_float4(1,0,0,0),
            simd_float4(0,1,0,0),
            simd_float4(0,0,1,0),
            simd_float4(0,0,0,1)
        )
    }
    
    static func scale(_ x: Float, _ y: Float , _ z: Float)  -> simd_float4x4
    {
        return simd_float4x4(
            simd_float4(x,0,0,0),
            simd_float4(0,y,0,0),
            simd_float4(0,0,z,0),
            simd_float4(0,0,0,1)
        )
    }
    
    static func translate(_ x: Float, _ y: Float, _ z : Float)  -> simd_float4x4
    {
        return simd_float4x4(
            simd_float4(1,0,0,0),
            simd_float4(0,1,0,0),
            simd_float4(0,0,1,0),
            simd_float4(x,y,z,1)
        )
    }
    
    static func rotationZ(_ angle: Float) -> simd_float4x4 {
        
        return simd_float4x4(
            simd_float4(cos(angle),-sin(angle),0,0),
            simd_float4(sin(angle),cos(angle),0,0),
            simd_float4(0,0,1,0),
            simd_float4(0,0,0,1)
        )
        
    }
}
