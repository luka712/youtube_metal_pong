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
    
    static func rotationX(_ angle: Float) -> simd_float4x4 {
        
        return simd_float4x4(
            simd_float4(1,0,0,0),
            simd_float4(0,cos(angle),-sin(angle),0),
            simd_float4(0,sin(angle),cos(angle),0),
            simd_float4(0,0,0,1)
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
    
    static func ortographic(left: Float = -1,
                            right: Float = 1,
                            bottom: Float = -1,
                            top: Float = 1,
                            near: Float = 0,
                            far: Float = 1) -> simd_float4x4
    {
        let r0c0: Float = 2.0 / (right - left)
        let r1c1: Float = 2.0 / (top - bottom)
        let r2c2: Float = 1.0 / (far - near)
        
        let r3c0: Float = -(right + left)/(right-left)
        let r3c1: Float = -(top + bottom)/(top - bottom)
        let r3c2: Float = -near/(far - near)
        return simd_float4x4(
            simd_float4(r0c0,0,0,0),
            simd_float4(0,r1c1,0,0),
            simd_float4(0,0,r2c2,0),
            simd_float4(r3c0,r3c1,r3c2,1)
        )
    }
    
    static func perspective(_ fov: Float,
                            _ aspectRatio: Float,
                            _ near: Float = 0.01,
                            _ far: Float = 1)-> simd_float4x4
    {
        let r = MathUtil.toRadians(fov)
        
        let r0c0: Float = 1.0 / (tanf(r * 0.5) * aspectRatio)
        let r1c1: Float = 1.0 / tanf(r * 0.5)
        
    
        let r2c2: Float = -(far / (near - far))
        let r3c2: Float = (far*near)/(near-far)
        
        return simd_float4x4(
            simd_float4(r0c0,0,0,0),
            simd_float4(0,r1c1,0,0),
            simd_float4(0,0,r2c2,1),
            simd_float4(0,0,r3c2,0)
        )
    }
}
