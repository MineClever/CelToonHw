//////////////////////////////////////////////////////
/* import from substance painter */
// ref to : https://substance3d.adobe.com/documentation/spdoc/shader-api-89686018.html
import lib-sampler.glsl

/* Settings */
#define _USE_RIM_LIGHT_

//////////////////////////////////////////////////////
/* Substance Render Engine */

//: state cull_face on
//: state blend none

//: param auto is_perspective_projection
uniform bool uniform_perspective_projection; //a bool indicating whether the projection is perspective or orthographic

//: param auto main_light
uniform vec4 uniform_main_light; // a vec4 indicating the position of the main light in the environment

//: param auto world_camera_direction
uniform vec3 uniform_world_camera_direction;

//: param auto world_eye_position
uniform vec3 uniform_world_eye_position;

//////////////////////////////////////////////////////
/* Substance Painter Channels */

//: param auto channel_basecolor
uniform SamplerSparse basecolor_tex;

//: param auto channel_specularlevel
uniform SamplerSparse specular_level_mask;

//: param auto channel_specular
uniform SamplerSparse specular_color;

//: param auto channel_user0
uniform SamplerSparse shadow_offset;

//: param auto channel_user1
uniform SamplerSparse shiniess_offset;

//: param auto channel_user2
uniform SamplerSparse rim_mask;

//: param auto channel_user3
uniform SamplerSparse first_shadow_color;

//: param auto channel_user4
uniform SamplerSparse second_shadow_color;

//: param auto channel_user5
uniform SamplerSparse outline_color;

//: param auto channel_emissive
uniform SamplerSparse emission_color;


//////////////////////////////////////////////////////
/* Parameters */

//: param custom { "default": 1, "label": "Light Color", "widget": "color", "group" : "Light Parameter" }
uniform vec3 gLamp0Color;

//: param custom {
//: "default": 0.2,
//: "label": "First Shadow Drop Value",
//: "min": 0.0,
//: "max": 1.0,
//: "step": 0.001,
//: "group" : "Base Parameter"
//: }
uniform float _firstShadow;

//: param custom {
//: "default": 0.25,
//: "label": "Second Shadow Drop Value",
//: "min": 0.0,
//: "max": 1.0,
//: "step": 0.001,
//: "group" : "Base Parameter"
//: }
uniform float _secondShadow;

//: param custom {
//: "default": 10.0,
//: "label": "Pow Shiness Times",
//: "min": 0.0,
//: "max": 150.0,
//: "step": 0.001,
//: "group" : "Specular Parameter"
//: }
uniform float _shiniess;

//: param custom {
//: "default": 1.0,
//: "label": "Specular Multipler",
//: "min": 0.0,
//: "max": 255.0,
//: "step": 1.0,
//: "group" : "Specular Parameter"
//: }
uniform float _specMulti;

/// Rim Light ///
#ifdef _USE_RIM_LIGHT_
    //: param custom {
    //: "default": 1.0,
    //: "label": "Rim Multipler",
    //: "min": 0.0,
    //: "max": 1.0,
    //: "step": 0.01,
    //: "group" : "Specular Parameter"
    //: }
    uniform float _RimMulti;

    //: param custom {
    //: "default": 48.0,
    //: "label": "Rim Pow Times",
    //: "min": 0.0,
    //: "max": 150.0,
    //: "step": 0.001,
    //: "group" : "Specular Parameter"
    //: }
    uniform float _rimPow;
#endif

//: param custom {
//: "default": 1.0,
//: "label": "Emission Multipler",
//: "min": 0.0,
//: "max": 1.0,
//: "step": 0.01,
//: "group" : "Unlight Parameter"
//: }
uniform float _emission;

//: param custom {
//: "default": 0.0,
//: "label": "unLighting Weight",
//: "min": 0.0,
//: "max": 1.0,
//: "step": 0.01,
//: "group" : "Unlight Parameter"
//: }
uniform float _unLightWeight;


//////////////////////////////////////////////////////
/* Convert from hlsl*/

#define float4 vec4
#define float3 vec3
#define float2 vec2
#define half float

#define lerp mix

////////////////////////////////////////
////// saturate ////////////////////////
////////////////////////////////////////
float saturate(float value)
{
    return clamp(value, 0.0f, 1.0f);
}

vec2 saturate(vec2 value)
{
    return clamp(value, 0.0f, 1.0f);
}

vec3 saturate(vec3 value)
{
    return clamp(value, 0.0f, 1.0f);
}

vec4 saturate(vec4 value)
{
    return clamp(value, 0.0f, 1.0f);
}


////////////////////////////////////////
////// Lighting ////////////////////////
////////////////////////////////////////
float unclampLambertShader(in vec3 N,in vec3 L)
{
    return dot(N,L);
}

////////////////////////////////////////
////// fresnel /////////////////////////
////////////////////////////////////////

/* Compute fresnel Ranges */
float fresnel( vec3 vNormal, vec3 vEyeDir )
{
    float fresnel = 1-saturate( dot( vNormal, vEyeDir ) );				// 1-(N.V) for Fresnel term
    return fresnel * fresnel;											// Square for a more subtle look
}

////////////////////////////////////////
////// MaskSample //////////////////////
////////////////////////////////////////

float getMaskValue(vec4 sampledValue, float defaultValue)
{
  return sampledValue.r + defaultValue * (1.0 - sampledValue.g);
}

float getMaskValue(SamplerSparse sampler, SparseCoord coord, float defaultValue)
{
  return getMaskValue(textureSparse(sampler, coord), defaultValue);
}


//////////////////////////////////////////////////////
/* Main Fragment Shader */

void shade(V2F inputs) {
    // Get Base Data
    vec3 L = normalize(uniform_main_light.xyz);
    vec3 V = normalize(uniform_world_eye_position.xyz - inputs.position.xyz);
    vec3 N = normalize(inputs.normal.xyz);
    vec3 H = normalize(L+V);
    #define sp_uv inputs.sparse_coord
    #define sp_vtxCol inputs.color[0]

    // Build LightInfo
    vec4 lightInfo;
    lightInfo.r = getMaskValue(specular_level_mask , sp_uv , 0.0f);
    lightInfo.g = getMaskValue(shadow_offset , sp_uv , 0.25f);
    lightInfo.b = getMaskValue(shiniess_offset , sp_uv , 0.0f);
    lightInfo.a = getMaskValue(rim_mask , sp_uv , 1.0f);

    vec3 mainColor = getBaseColor(basecolor_tex, sp_uv);
    vec3 curFirstShadowCol = getBaseColor(first_shadow_color,sp_uv);
    vec3 curSecShadowCol = getBaseColor(second_shadow_color,sp_uv);
    vec3 curSpecularCol = getBaseColor(specular_color,sp_uv);

    /*Compute Lambert Shaders*/
    float unclampLambert = unclampLambertShader(N,L);
    #define lambert unclampLambert
    float halfLambert = saturate(lambert * 0.5 + 0.5);

    /*Compute Shadow*/
    vec3 diffuse = vec3(0.0f,0.0f,0.0f);
        /*first Shadow term */
    float diffuseMask = lightInfo.y * sp_vtxCol.x;


    /*Shadow Core*/
        /*Step method*/
    if (diffuseMask > 0.1 )
    {
        float firstMask = diffuseMask > 0.5 ? diffuseMask * 1.2f - 0.1f : diffuseMask * 1.25f - 0.125f ;
        bool isLight = (firstMask + halfLambert) * 0.5 > _firstShadow;
        diffuse.rgb = isLight ? mainColor.rgb : mainColor.rgb * curFirstShadowCol;
    }
    else /*second Shadow term*/
    {
        bool isFirst = (diffuseMask + halfLambert)* 0.5 > _secondShadow;
        diffuse.rgb = isFirst ? mainColor.rgb * curFirstShadowCol : mainColor.rgb * curSecShadowCol;
    };


    /*Compute Specular*/
        /*Cheap methon*/
    //float NdotH = dot(N, normalize(gLamp0Dir + getCameraDir()));
    float NdotH = dot(N, H);
    float shinePow = pow(max(NdotH,0.0f),_shiniess);
    vec3 spec = shinePow + lightInfo.z > 1.0f ? vec3(lightInfo.x * _specMulti) : vec3(0.0,0.0,0.0);

    /*Compute RimLight*/
    #ifdef _USE_RIM_LIGHT_
        float fFresnel = pow( fresnel(N, V) , _rimPow) * 16 * pow(fresnel(normalize(L + V),V) , 16) * 16;
        spec += lightInfo.a * fFresnel * _RimMulti;
    #endif

    /*Compute Emission*/
    vec3 emission;
    emission.rgb = mainColor.rgb * getBaseColor(emission_color, sp_uv) *_emission;

    // Export to Viewport
    diffuse.rgb = mix((diffuse.rgb + saturate(spec) * curSpecularCol) * gLamp0Color.rgb, emission.rgb, _unLightWeight);
    diffuseShadingOutput(diffuse);

}