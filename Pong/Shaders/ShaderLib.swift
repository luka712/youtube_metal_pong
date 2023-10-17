//
//  ShaderLib.swift
//  Pong
//
//  Created by Luka Erkapic on 15.10.23.
//

import Foundation
import MetalKit

class ShaderLib
{
    public var library: MTLLibrary
    public var vertexFunction: MTLFunction? = nil
    public var fragmentFunction: MTLFunction? = nil
    
    init(_ device: MTLDevice, _ vertexFnName: String, _ fragmentFnName: String)
    {
        library = device.makeDefaultLibrary()!
        
        guard let vFn = library.makeFunction(name: vertexFnName) else {
            fatalError("Vertex \(vertexFnName) function not found")
        }
        
        guard let fFn = library.makeFunction(name: fragmentFnName) else {
            fatalError("Fragment \(fragmentFnName) function not found")
        }
        
        self.vertexFunction = vFn
        self.fragmentFunction = fFn
    }
}
