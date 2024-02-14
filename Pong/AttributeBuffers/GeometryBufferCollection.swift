//
//  GeometryBuffersCollection.swift
//  Pong
//
//  Created by Luka Erkapic on 06.02.24.
//

import Foundation
import MetalKit

class GeometryBuffersCollection
{
    public static var cubeGeometryBuffer: GeometryBuffers? = nil
    
    public static func initialize(_ device: MTLDevice)
    {
        let geometry = GeometryBuilder().createCubeGeometry()
        cubeGeometryBuffer = GeometryBuffers(device, geometry)
    }
}
