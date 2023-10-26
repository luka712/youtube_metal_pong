//
//  GeometryBuffers.swift
//  Pong
//
//  Created by Luka Erkapic on 26.10.23.
//

import Foundation
import MetalKit

class GeometryBuffers
{
    let positionsBuffer: MTLBuffer
    var indexBuffer: MTLBuffer? = nil
    var colorBuffer: MTLBuffer? = nil
    
    let vertexCount: Int
    var indexCount: Int = 0
    
    var usesIndices = false
    
    init(_ device: MTLDevice, _ geometry: Geometry)
    {
        positionsBuffer = device.makeBuffer(
            bytes: geometry.positionVertices,
            length: geometry.positionVertices.count * MemoryLayout<Float>.size)!
        
        vertexCount = geometry.positionVertices.count / 3  // (xyz) per vertex
        
        colorBuffer = device.makeBuffer(
            bytes: geometry.colors,
            length: geometry.colors.count * MemoryLayout<Float>.size
        )!
        
        
        // Index buffer
        if !geometry.indices.isEmpty {
            
            indexBuffer = device.makeBuffer(
                bytes: geometry.indices,
                length: geometry.indices.count * MemoryLayout<uint16>.size
            )!
            
            indexCount = geometry.indices.count
            usesIndices = true
        }
    }
}
