//
//  UnlitMaterialShader.metal
//  Pong
//
//  Created by Luka Erkapic on 20.10.23.
//

#include <metal_stdlib>
using namespace metal;


struct VSOutput
{
    float4 position [[position]];
};

vertex VSOutput unlitMaterialVS(uint vid [[vertex_id]])
{
    float4 positions[3] = {
        float4(-0.5, -0.5, 0.0, 1.0),
        float4(-0.5, 0.5, 0.0, 1.0),
        float4(0.5, -0.5, 0.0, 1.0)
    };
    
    VSOutput out;
    out.position = positions[vid];
    return out;
}

fragment float4 unlitMaterialFS(VSOutput in [[stage_in]])
{
    return float4(0.0, 1.0, 0.0, 1.0);
}
