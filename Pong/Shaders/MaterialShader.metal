#include <metal_stdlib>
using namespace metal;


struct VSOutput
{
    float4 position [[position]];
    float4 color;
    float2 texCoords;
    float3 normal;
    float3 fragPos;
    float3 eye;
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
                                constant packed_float3 &eye [[buffer(8)]],
                                
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
    out.eye = eye;
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
    float specularIntensity;
    packed_float3 specularColor;
    float _;
};

struct PointLight
{
    packed_float3 color;
    float intensity;
    packed_float3 position;
    float attenConst;
    float attenLin;
    float attenQuad;
    float specularIntensity;
    packed_float3 specularColor;
    packed_float2 _;
};


fragment float4 materialFS(VSOutput in [[stage_in]],
                                
                                // constant buffers
                                constant packed_float4 &diffuseColor [[buffer(0)]],
                                constant float &shininess [[buffer(1)]],
                           
                                // lights
                                constant AmbientLight& ambient [[buffer(2)]],
                                constant DirectionalLight& directional [[buffer(3)]],
                                constant PointLight* pointLights [[buffer(4)]],
                                
                                texture2d<float> diffuseTexture [[texture(0)]],
                                sampler texSampler [[sampler(0)]]
                                )
{
    // Vector towards the eye, normalized.
    float3 toEye = normalize(in.eye - in.fragPos);
    float4 color = in.color * diffuseColor * diffuseTexture.sample(texSampler, in.texCoords);
    
    // AMBIENT
    float3 lightAmount = ambient.color * ambient.intensity;
    
    // DIRECTIONAL
    // - Diffuse
    float3 normal = normalize(in.normal);
    float3 direction = normalize(directional.direction);
    float3 directionalAmount = dot(normal, -direction);
    directionalAmount = clamp(0, 1, directionalAmount);
    lightAmount += directionalAmount;
    
    // - Specular
    float3 reflectVector = reflect(direction, normal);
    float specularAmount = dot(reflectVector, toEye);
    lightAmount += directional.specularColor * directional.specularIntensity * pow(specularAmount, shininess);
    
    // POINT LIGHTS
    for(int i = 0; i < 3; i++)
    {
        // Diffuse
        float3 direction = normalize(pointLights[i].position - in.fragPos);
        float3 pointAmount = dot(normal, direction);
        pointAmount = clamp(0, 1, pointAmount);
        
        float d = distance(pointLights[i].position, in.fragPos);
        float attenuation = pointLights[i].attenConst + pointLights[i].attenLin * d + pointLights[i].attenQuad * d * d;
        attenuation = 1.0 / attenuation;
        
        lightAmount += pointAmount  * pointLights[i].color * pointLights[i].intensity * attenuation;
        
        // Specular
        reflectVector = reflect(-direction, normal);
        specularAmount = dot(reflectVector, toEye);
        lightAmount += pointLights[i].specularColor * pointLights[i].specularIntensity * pow(specularAmount, shininess);
    }
    
    color.rgb *= lightAmount;
    
    return color;
}
