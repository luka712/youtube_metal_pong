//
//  GeometryBuilder.swift
//  Pong
//
//  Created by Luka Erkapic on 26.10.23.
//

import Foundation

class GeometryBuilder
{
    func createQuadGeometry() ->Geometry {
        
        let positions: [Float] = [
            -0.5, -0.5, 0.0, // bottom left
            -0.5, 0.5, 0.0, // top left
            0.5, -0.5, 0.0, // bottom right
             0.5, 0.5, 0.0, // top right
        ];
        
        let indices: [uint16] = [
            // t1
            0,1,2,
            // t2
            1,3,2
        ]
        
        let colors : [Float] = [
        
            1, 1,1, 1,
            1, 1,1,1,
            1,1,1,1,
            1,1,1,1
        ]
        
        let texCoords: [Float] = [
            0,1,
            0,0,
            1,1,
            1,0
        ]
        
        return Geometry(
            positionVertices: positions,
            indices: indices,
            colors: colors,
            texCoords: texCoords
        )
    }
}
