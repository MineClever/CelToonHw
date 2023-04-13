//////////////////////////////////////////////////////
/* import from substance painter */

// Defines the SamplerSparse structure
import lib-sparse.glsl // ref to : https://substance3d.adobe.com/documentation/spdoc/all-engine-params-shader-api-188976087.html


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


//////////////////////////////////////////////////////
/* Parameters */

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
//: "default": 0.2,
//: "label": "Second Shadow Drop Value",
//: "min": 0.0,
//: "max": 1.0,
//: "step": 0.001,
//: "group" : "Base Parameter"
//: }
uniform float _secondShadow;



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


//////////////////////////////////////////////////////
/* Main Fragment Shader */

void shade(V2F inputs) {
    // Get Base Data
    vec3 L = - normalize(uniform_main_light);
    vec3 V = normalize(uniform_world_eye_position - inputs.position.xyz);
    vec3 N = normalize(inputs.normal);
    H = normalize(L+V);

    // Export to Viewport
    albedoOutput(vec3);
}