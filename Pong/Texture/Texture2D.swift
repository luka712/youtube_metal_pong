//
//  Texture2D.swift
//  Pong
//
//  Created by Luka Erkapic on 01.11.23.
//

import Foundation
import MetalKit

class Texture2D
{
    let texture: MTLTexture
    let samplerState: MTLSamplerState
    
    init(_ device: MTLDevice, _ image: NSImage)
    {
        let textureLoader = MTKTextureLoader(device: device)
        
        let bitmap = image.cgImage(forProposedRect: nil, context: nil, hints: nil)!
        
        texture = try! textureLoader.newTexture(cgImage: bitmap, options: [
            MTKTextureLoader.Option.origin: MTKTextureLoader.Origin.topLeft
        ])
        
        let samplerDescriptor = MTLSamplerDescriptor()
        samplerDescriptor.minFilter = .linear
        samplerDescriptor.magFilter = .linear
        samplerDescriptor.sAddressMode = .repeat
        samplerDescriptor.tAddressMode = .repeat
        samplerState = device.makeSamplerState(descriptor: samplerDescriptor)!
    }
    
    static func makeEmpty(_ device: MTLDevice) -> Texture2D {
        
        let color = NSColor(red: 1, green: 1, blue: 1, alpha: 1)
        let size = NSSize(width: 1, height: 1)
        
        let image = NSImage(size: size, flipped: false, drawingHandler: { (rect) -> Bool in
            color.drawSwatch(in: rect)
            return true
        })
        
        return Texture2D( device, image)
        
    }
}

