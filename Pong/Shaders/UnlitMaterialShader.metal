#include <metal_stdlib>
using namespace metal;


struct VSOutput
{
    float4 position [[position]];
    float4 color;
    float2 texCoords;
};

vertex VSOutput unlitMaterialVS(
                                // attributes or data per vertex
                                const device packed_float3 *positions [[buffer(0)]],
                                const device packed_float4 *colors [[buffer(1)]],
                                const device packed_float2 *texCoords [[buffer(2)]],
                                
                                // constant buffer
                                constant packed_float2 &textureTilling [[buffer(3)]],
                                
                                // builtins
                                uint vid [[vertex_id]])
{

    
    VSOutput out;
    out.position = float4(positions[vid], 1.0);
    out.color = colors[vid];
    out.texCoords = texCoords[vid] * textureTilling;
    return out;
}



fragment float4 unlitMaterialFS(VSOutput in [[stage_in]],
                                
                                // constant buffers
                                constant packed_float4 &diffuseColor [[buffer(0)]],
                                
                                texture2d<float> diffuseTexture [[texture(0)]],
                                sampler texSampler [[sampler(0)]]
                                )
{
    return in.color * diffuseColor * diffuseTexture.sample(texSampler, in.texCoords);
}
