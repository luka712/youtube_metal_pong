//
//  Camera.swift
//  Pong
//
//  Created by Luka Erkapic on 01.02.24.
//

import Foundation
import simd
import MetalKit

class Camera
{
    public var buffer: ConstantBuffer<simd_float4x4>
    
    // Matrices
    private var projection: simd_float4x4
    private var view: simd_float4x4
    private var projectionView: simd_float4x4
    
    // View
    private let up = simd_float3(0,1,0)
    public var position: simd_float3 = simd_float3(0,3,-3)
    public var target: simd_float3 = simd_float3(0,0,0)
    
    // Perspective
    public var fov: Float = 45.0
    public var near: Float = 0.01
    public var far: Float  = 100
    
    
    init(_ device: MTLDevice)
    {
        buffer = ConstantBuffer<simd_float4x4>(device)
        projection = Matrix.perspective(fov, Float(Constants.gameWidth) / Float(Constants.gameHeight) , near, far)
        view = Matrix.lookAt(position, target, up)
        projectionView = projection * view
    }
    
    func update()
    {
        projection = Matrix.perspective(fov, Float(Constants.gameWidth) / Float(Constants.gameHeight) , near, far)
        view = Matrix.lookAt(position, target, up)
        projectionView = projection * view
        buffer.write(data: &projectionView)
    }
}
