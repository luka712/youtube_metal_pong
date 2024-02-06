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
    public var texture: MTLTexture? = nil
    public var samplerState: MTLSamplerState? = nil
    
    init(_ device: MTLDevice, _ image: NSImage? = nil, _ texture: MTLTexture? = nil)
    {
        if(image != nil){
            let textureLoader = MTKTextureLoader(device: device)
            let bitmap = image!.cgImage(forProposedRect: nil, context: nil, hints: nil)!
            
            self.texture = try! textureLoader.newTexture(cgImage: bitmap, options: [
                MTKTextureLoader.Option.origin: MTKTextureLoader.Origin.topLeft
            ])
            
            let samplerDescriptor = MTLSamplerDescriptor()
            samplerDescriptor.minFilter = .linear
            samplerDescriptor.magFilter = .linear
            samplerDescriptor.sAddressMode = .repeat
            samplerDescriptor.tAddressMode = .repeat
            samplerState = device.makeSamplerState(descriptor: samplerDescriptor)!
        }
        else if(texture != nil) {
            self.texture = texture!
        }
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
    
    static func createDepthTexture(_ device: MTLDevice) -> Texture2D
    {
        let depthTextureDescriptor = MTLTextureDescriptor()
        depthTextureDescriptor.pixelFormat = .depth32Float
        depthTextureDescriptor.width = Int(Constants.gameWidth)
        depthTextureDescriptor.height = Int(Constants.gameHeight)
        depthTextureDescriptor.usage = .renderTarget
        let depthTexture = device.makeTexture(descriptor: depthTextureDescriptor)
        
        return Texture2D(device, nil, depthTexture)
    }
}

