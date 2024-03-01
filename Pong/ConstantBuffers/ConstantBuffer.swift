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
    
    init(_ device: MTLDevice, _ byteSize: Int? = nil, _ label: String? = nil)
    {
        if byteSize != nil {
            buffer = device.makeBuffer(length: byteSize!)!
        }
        else {
            buffer = device.makeBuffer(length: MemoryLayout<T>.size)!
        }
        
        buffer.label = label
    }
    
    func write(data: inout T, instance: Int = 0)
    {
        buffer.contents()
            .advanced(by: MemoryLayout<T>.size * instance)
            .copyMemory(from: &data, byteCount: MemoryLayout<T>.size)
    }
    
    func writeArray(data: inout Array<T>)
    {
        buffer.contents()
            .copyMemory(from: &data, byteCount: MemoryLayout<T>.size * data.count)
    }
}
