//
//  ConstantBuffer.swift
//  Pong
//
//  Created by Luka Erkapic on 10.11.23.
//

import Foundation
import MetalKit

class ConstantBuffer<T>
{
    let buffer : MTLBuffer
    
    init(_ device: MTLDevice)
    {
        buffer = device.makeBuffer(length: MemoryLayout<T>.size)!
    }
    
    func write(data: inout T)
    {
        buffer.contents().copyMemory(from: &data, byteCount: MemoryLayout<T>.size)
    }
}
