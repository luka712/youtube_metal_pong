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
        
        let texCoords : [Float] = [
            0,1,
            0,0,
            1,1,
            1,0
        ]
        
        let normals: [Float] = [
          0,0,-1,
          0,0,-1,
          0,0,-1,
          0,0,-1
        ]
        
        return Geometry(positionVertices: positions, indices: indices, colors: colors, texCoords: texCoords, normals: normals)
    }
    
    func createCubeGeometry() -> Geometry {
        let positions: [Float] = [
            // front
            -0.5, -0.5, -0.5, // bottom left
             -0.5, 0.5, -0.5, // top left
             0.5, -0.5, -0.5, // bottom right
             0.5, 0.5,  -0.5, // top right
             // back
             -0.5, -0.5, 0.5, // bottom left
             -0.5, 0.5, 0.5, // top left
             0.5, -0.5, 0.5, // bottom right
             0.5, 0.5, 0.5, // top right
             
             // left
             -0.5, -0.5, -0.5, // bottom left
             -0.5, 0.5, -0.5, // top left
             -0.5, -0.5, 0.5, // bottom right
             -0.5, 0.5, 0.5, // top right
             
             // right
             0.5, -0.5, -0.5, // bottom left
             0.5, 0.5, -0.5, // top left
             0.5, -0.5, 0.5, // bottom right
             0.5, 0.5, 0.5, // top right
             
             // top
             -0.5, 0.5, -0.5, // bottom left
             -0.5, 0.5, 0.5, // top left
             0.5, 0.5, -0.5, // bottom right
             0.5, 0.5, 0.5, // top right
             
             // bottom
             -0.5, -0.5, -0.5, // bottom left
             -0.5, -0.5, 0.5, // top left
             0.5, -0.5, -0.5, // bottom right
             0.5, -0.5, 0.5, // top right
        ];
        
        let indices: [uint16] = [
            // front
            0,1,2,
            1,3,2,
            // back
            4,6,5,
            5,6,7,
            // left
            8,9,10,
            9,11,10,
            // right
            12,14,13,
            13,14,15,
            // top
            16,18,17,
            17,18,19,
            // bottom
            20,21,22,
            21,23,22
        ]
        
        let colors : [Float] = [
            // front
            1, 1,1, 1,
            1, 1,1,1,
            1,1,1,1,
            1,1,1,1,
            // back
            1, 1,1, 1,
            1, 1,1,1,
            1,1,1,1,
            1,1,1,1,
            // left
            1, 1,1, 1,
            1, 1,1,1,
            1,1,1,1,
            1,1,1,1,
            // right
            1, 1,1, 1,
            1, 1,1,1,
            1,1,1,1,
            1,1,1,1,
            // top
            1, 1,1, 1,
            1, 1,1,1,
            1,1,1,1,
            1,1,1,1,
            // bottom
            1, 1,1, 1,
            1, 1,1,1,
            1,1,1,1,
            1,1,1,1
        ]
        
        let texCoords: [Float] = [
            // front
            0,1,
            0,0,
            1,1,
            1,0,
            // back
            0,1,
            0,0,
            1,1,
            1,0,
            // left
            0,1,
            0,0,
            1,1,
            1,0,
            // right
            0,1,
            0,0,
            1,1,
            1,0,
            // top
            0,1,
            0,0,
            1,1,
            1,0,
            // bottom
            0,1,
            0,0,
            1,1,
            1,0
        ]
        
        let normals : [Float] = [
            // front
            0,0,-1,
            0,0,-1,
            0,0,-1,
            0,0,-1,
            // back
            0,0,1,
            0,0,1,
            0,0,1,
            0,0,1,
             
             // left
             -1,0,0,
             -1,0,0,
            -1,0,0,
            -1,0,0,
            
             
             // right
            1,0,0,
            1,0,0,
           1,0,0,
           1,0,0,
             
             // top
          0,1,0,
            0,1,0,
            0,1,0,
            0,1,0,
             
             // bottom
            0,-1,0,
            0,-1,0,
            0,-1,0,
            0,-1,0
        ]
        
        return Geometry(
            positionVertices: positions,
            indices: indices,
            colors: colors,
            texCoords: texCoords,
            normals: normals
        )
        
    }
}
