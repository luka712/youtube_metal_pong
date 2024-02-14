//
//  Geometry.swift
//  Pong
//
//  Created by Luka Erkapic on 26.10.23.
//

import Foundation

struct Geometry
{
    let positionVertices: [Float]
    let indices: [uint16]
    let colors: [Float]
    let texCoords: [Float]
    let normals: [Float]
    
    init(positionVertices: [Float], indices: [uint16] = [], colors: [Float], texCoords: [Float] = [], normals: [Float] = [])
    {
        self.positionVertices = positionVertices
        self.indices = indices
        self.colors = colors
        self.texCoords = texCoords
        self.normals = normals
    }
}
