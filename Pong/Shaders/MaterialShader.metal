#include <metal_stdlib>
using namespace metal;


struct VSOutput
{
    float4 position [[position]];
    float4 color;
    float2 texCoords;
    float3 normal;
    float3 fragPos;
};

vertex VSOutput materialVS(
                                // attributes or data per vertex
                                const device packed_float3 *positions [[buffer(0)]],
                                const device packed_float4 *colors [[buffer(1)]],
                                const device packed_float2 *texCoords [[buffer(2)]],
                                const device packed_float3 *normals [[buffer(3)]],
                            
                                // constant buffer
                                constant float4x4 *transform [[buffer(4)]],
                                constant float4x4 *normalMatrix [[buffer(5)]],
                                constant packed_float2 &textureTilling [[buffer(6)]],
                                constant float4x4 &projectionView [[buffer(7)]],
                                
                                // builtins
                                uint vid [[vertex_id]],
                                uint iid [[instance_id]]
                                )
{

    
    VSOutput out;
    float4 pos = float4(positions[vid], 1.0);
    out.position = projectionView * transform[iid] * pos;
    out.color = colors[vid];
    out.texCoords = texCoords[vid] * textureTilling;
    out.normal =  (normalMatrix[iid] * float4(normals[vid], 1.0)).xyz;
    out.fragPos = (transform[iid] * pos).xyz;
    return out;
}

struct AmbientLight
{
    packed_float3 color;
    float intensity;
};

struct DirectionalLight
{
    packed_float3 color;
    float intensity;
    packed_float3 direction;
};

struct PointLight
{
    packed_float3 color;
    float intensity;
    packed_float3 position;
    float _;
};


fragment float4 materialFS(VSOutput in [[stage_in]],
                                
                                // constant buffers
                                constant packed_float4 &diffuseColor [[buffer(0)]],
                           
                                // lights
                                constant AmbientLight& ambient [[buffer(1)]],
                                constant DirectionalLight& directional [[buffer(2)]],
                                constant PointLight* pointLights [[buffer(3)]],
                                
                                texture2d<float> diffuseTexture [[texture(0)]],
                                sampler texSampler [[sampler(0)]]
                                )
{
    float4 color = in.color * diffuseColor * diffuseTexture.sample(texSampler, in.texCoords);
    
    // AMBIENT
    float3 lightAmount = ambient.color * ambient.intensity;
    
    // DIRECTIONAL
    float3 directionalAmount = dot(normalize(in.normal), normalize(-directional.direction));
    directionalAmount = clamp(0, 1, directionalAmount);
    lightAmount += directionalAmount;
    
    // POINT LIGHTS
    for(int i = 0; i < 3; i++)
    {
        float3 direction = normalize(pointLights[i].position - in.fragPos);
        float3 pointAmount = dot(normalize(in.normal), direction);
        pointAmount = clamp(0, 1, pointAmount);
        lightAmount += pointAmount  * pointLights[i].color * pointLights[i].intensity;
    }
    
    color.rgb *= lightAmount;
    
    return color;
}
