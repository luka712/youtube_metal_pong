
#include <metal_stdlib>
using namespace metal;


struct VSOutput
{
    float4 position [[position]];
    float4 color;
};

vertex VSOutput unlitMaterialVS(
                                // attributes or data per vertex
                                const device packed_float3 *positions [[buffer(0)]],
                                const device packed_float4 *colors [[buffer(1)]],
                                
                                // builtins
                                uint vid [[vertex_id]])
{

    
    VSOutput out;
    out.position = float4(positions[vid], 1.0);
    out.color = colors[vid];
    return out;
}

fragment float4 unlitMaterialFS(VSOutput in [[stage_in]])
{
    return in.color;
}
