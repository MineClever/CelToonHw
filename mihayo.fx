////////////////////////////////////////////////////////////
// Force Maya
#ifndef _MAYA_
    #define _MAYA_
#endif

// Settings
#define _DEBUG_
#undef _USE_WARM_COOL_
#define _USE_RIM_LIGHT_

// Constant Parameters
#define PI 3.1415926
#define _3DSMAX_SPIN_MAX 99999
#define _GAMMA_NUM_ 2.2f


////////////////////////////////////////////////////////////

#ifndef _MAYA_
	#define _3DSMAX_	// at time of writing this shader, Nitrous driver did not have the _3DSMAX_ define set
	#define _ZUP_		// Maya is Y up, 3dsMax is Z up
    #define UV_FLIP 1
#else
    #define UV_FLIP -1
#endif
////////////////////////////////////////////////////////////

//tip: UIOrder help to make our ui more readable
cbuffer UpdatePerFrame : register(b0)
{
    float4x4 ViewToWorld            : ViewInverse;
    float4x4 WorldToView            : View;
    float4x4 ViewToProj             : Projection;
    float4x4 ViewToProj_IT          : ProjectionInverseTranspose;
    float4x4 WorldToProj            : ViewProjection;
    float4x4 ObjectToWorld          : World;
    float4x4 ObjectToWorld_IT       : WorldInverseTranspose;
    float4x4 ObjectToView           : WorldView;
    float4x4 ObjectToView_IT        : WorldViewInverseTranspose;
    float4x4 ObjectToProj           : WorldViewProjection;
};


cbuffer UpdateLights : register(b2)
{

    float3 gLamp0Dir : DIRECTION
    <
        string Object = "DirectionalLight0";
        string UIName =  "Light Direction";
        string Space = "World";
        int RefID = 1; // 3DSMAX
        int UIOrder = 0;
    > = {100.0f, 100.0f, 100.0f};

    float3 gLamp0Pos : POSITION
    <
        string Object = "DirectionalLight0";
        string UIName =  "Light Posison";
        string Space = "World";
        int RefID = 1; // 3DSMAX
        int UIOrder = 1;
    > = {100.0f, 100.0f, 100.0f};

    float3 gLamp0Color : Color
    <
        string Object = "DirectionalLight0";
        string UIName =  "Light Color";
        string UIWidget = "Color";
        int UIOrder = 2;
    > = {1.0,1.0,1.0};

	float4x4 glight0Matrix : SHADOWMAPMATRIX //move world to light projection
	<
		string Object = "DirectionalLight0";
		string UIWidget = "None";
	>;
}


bool tAuthor
<
    string UIGroup = "About";
    string UIName =  "MineClever's CelShader";
    int UIOrder = 10;
> = true;

bool tAuthor_2
<
    string UIGroup = "About";
    string UIName =  "E-mail:chnisesbandit@live.cn";
    int UIOrder = 11;
> = true;

bool bUseZFix
<
    string UIGroup = "Outline Parameter";
    string UIName =  "Use Z Offset";
    int UIOrder = 19;
> = false;

bool bKeepOutlineWidth
<
    string UIGroup = "Outline Parameter";
    string UIName =  "Keep Outline Width";
    int UIOrder = 20;
> = false;

float3 _outlineColor
<
    string UIGroup = "Outline Parameter";
    string UIName =  "Outline Color";
    string UIWidget = "Color";
    int UIOrder = 21;
> = {0.0,0.0,0.0};

float _outlineWeightScale
<
    string UIGroup = "Outline Parameter";
    string UIName = "Outline Scale";
    float UIMin = 0.000;
    float UIMax = 10.000;
    float UIStep = 0.001;
    int UIOrder = 22;
> = 1.0f;

bool bUseOutlineColor
<
    string UIGroup = "Outline Parameter";
    string UIName =  "Use Outline Color";
    int UIOrder = 23;
> = false;


float3 gSurfaceColor : DIFFUSE
<
    string UIGroup = "Base Parameter";
    string UIName =  "Surface Color";
    string UIWidget = "Color";
    int UIOrder = 31;
> = {1.0,1.0,1.0};

bool bUseSurfaceColor
<
    string UIGroup = "Base Parameter";
    string UIName =  "Use surface Color";
    int UIOrder = 32;
> = false;

float _firstShadow
<
    string UIGroup = "Base Parameter";
    string UIName = "First Shadow Drop Value";
    float UIMin = 0.000;
    float UIMax = 1.000;
    float UIStep = 0.001;
    //数值越大越容易产生第一层阴影
    int UIOrder = 33;
> = 0.5f;

float _secondShadow
<
    string UIGroup = "Base Parameter";
    string UIName = "Second Shadow Drop Value";
    float UIMin = 0.000;
    float UIMax = 1.000;
    float UIStep = 0.001;
    //数值越大越容易产生第二层阴影
    int UIOrder = 34;
> = 0.2f;

float3 _firstShadowMultColor
<
    string UIGroup = "Base Parameter";
    string UIName =  "First Shadow Color";
    string UIWidget = "Color";
    int UIOrder = 35;
> = {1.0,1.0,1.0};

float3 _secondShadowMultColor
<
    string UIGroup = "Base Parameter";
    string UIName =  "Second Shadow Color";
    string UIWidget = "Color";
    int UIOrder = 36;
> = {1.0,1.0,1.0};

bool bUseShadowColors
<
    string UIGroup = "Base Parameter";
    string UIName =  "Use Shadow Colors";
    int UIOrder = 37;
> = true;

float _shiniess
<
    string UIGroup = "Specular Parameter";
    string UIName = "Pow Shiness Times";
    string UIWidget = "Slider";
    float UIMin = 0.010;
    float UIMax = 150.000;
    float UIStep = 0.001;
    int UIOrder = 41;
> = 10.0f;

float _specMulti
<
    string UIGroup = "Specular Parameter";
    string UIName = "Specular Multipler";
    float UIMin = 0.000;
    float UIMax = 255.000;
    float UIStep = 1.0;
    int UIOrder = 42;
> = 1.0f;

float3 _specularColor
<
    string UIGroup = "Specular Parameter";
    string UIName =  "Specular Color Tint";
    string UIWidget = "Color";
    int UIOrder = 43;
> = {1.0,1.0,1.0};

bool bUseSpecularColor
<
    string UIGroup = "Specular Parameter";
    string UIName =  "Use Specular Color Tint";
    int UIOrder = 44;
> = false;


/// Rim Light ///
#ifdef _USE_RIM_LIGHT_
    float _RimMulti
    <
        string UIGroup = "Specular Parameter";
        string UIName = "Rim Multipler";
        float UIMin = 0.000;
        float UIMax = 1.000;
        float UIStep = 0.01;
        int UIOrder = 45;
    > = 1.0f;

    float _rimPow
    <
        string UIGroup = "Specular Parameter";
        string UIName = "Rim Pow Times";
        float UIMin = 0.01;
        float UIMax = 150.000;
        float UIStep = 0.01;
        int UIOrder = 46;
    > = 48.0f;
#endif


float _emission
<
    string UIGroup = "Unlight Parameter";
    string UIName = "Emission Multipler";
    int UIOrder = 51;
> = 0.0f;

// float _emissionBloomFactor
// <
//     string UIGroup = "Unlight Parameter";
//     string UIName = "Emission Bloom Multipler";
//     int UIOrder = 52;
// > = 1.0f;

float3 _emissionColor
<
    string UIGroup = "Unlight Parameter";
    string UIName =  "Emission Color";
    string UIWidget = "Color";
    int UIOrder = 53;
> = {1.0,1.0,1.0};

float _unLightWeight
<
    string UIGroup = "Unlight Parameter";
    string UIName = "unLighting Weight";
    int UIOrder = 54;
> = 0.0f;

///Color WarmCold///
#ifdef _USE_WARM_COOL_
    float _blue
    <
        string UIGroup = "Color WarmCold";
        string UIName = "Blue factor";
        int UIOrder = 63;
    > = 0.5f;

    float _yellow
    <
        string UIGroup = "Color WarmCold";
        string UIName = "yellow factor";
        int UIOrder = 64;
    > = 0.5f;

    float _gAlpha
    <
        string UIGroup = "Color WarmCold";
        string UIName = "CoolColor factor";
        int UIOrder = 65;
    > = 0.1f;

    float _gBeta
    <
        string UIGroup = "Color WarmCold";
        string UIName = "WarmColor factor";
        int UIOrder = 66;
    > = 0.1f;

    float _gface
    <
        string UIGroup = "Color WarmCold";
        string UIName = "CoolWarm Cool Tinted";
        int UIOrder = 67;
    > = 0.0f;
#endif

///Features///
bool bUseConstantShadowCol
<
    string UIGroup = "Features";
    string UIName =  "Use Constant Shadow Color";
    int UIOrder = 44;
> = false;

SamplerState BaseTexSampler
{
    Filter = ANISOTROPIC;
    AddressU = Wrap;
    AddressV = Wrap;
    BorderColor = float4(0.0f, 0.0f, 0.0f, 1.0f);
};

Texture2D gMainTex
<
    string UIGroup = "Maps";
    string ResourceName = "white.tga";
    string ResourceType = "2D";
    string UIName = "baseColor Map";
    int mipmaplevels = 0;
    int UIOrder = 90;
>;

Texture2D gLightinfoTex
<
    string UIGroup = "Maps";
    /*LightInfo.r == SpecularLevel Mask*/
    /*LightInfo.g == Shadow Offset Mask*/
    /*LightInfo.b == Shiniess offset Mask*/
    /*LightInfo.a == Rim Mask*/
    string ResourceName = "ctrl.tga";
    string ResourceType = "2D";
    string UIName = "Light Infomation Map";
    int mipmaplevels = 0;
    int UIOrder = 91;
>;

Texture2D gFirstShadowTex
<
    string UIGroup = "Maps";
    string ResourceName = "grey.tga";
    string ResourceType = "2D";
    string UIName = "First ShadowColor Map";
    int mipmaplevels = 0;
    int UIOrder = 92;
>;

Texture2D gSecondShadowTex
<
    string UIGroup = "Maps";
    string ResourceName = "dark.tga";
    string ResourceType = "2D";
    string UIName = "Second ShadowColor Map";
    int mipmaplevels = 0;
    int UIOrder = 93;
>;

Texture2D gSpecualColorTex
<
    string UIGroup = "Maps";
    string ResourceName = "white.tga";
    string ResourceType = "2D";
    string UIName = "SpecularColor Map";
    int mipmaplevels = 0;
    int UIOrder = 94;
>;

Texture2D gOutlineColorTex
<
    string UIGroup = "Maps";
    string ResourceName = "black.tga";
    string ResourceType = "2D";
    string UIName = "OutlineColor Map";
    int mipmaplevels = 0;
    int UIOrder = 95;
>;


////////////////////////////////////////
////// Debug ///////////////////////////
////////////////////////////////////////
float enumShowDebugChannel
<
    string UIGroup = "Debug";
    string UIName =  "1:BaseCol|2:VtxCol|3:LitInfo";
    float UIMin = 0.0;
    float UIMax = 3.0;
    float UIStep = 1.0;
    int UIOrder = 100;
> = 0;

float enumChannelChooser
<
    string UIGroup = "Debug";
    string UIName =  "1:R|2:G|3:B|4:A";
    float UIMin = 0.0;
    float UIMax = 4.0;
    float UIStep = 1.0;
    int UIOrder = 101;
> = 0;


////////////////////////////////////////
////// Structs /////////////////////////
////////////////////////////////////////

struct a2v
{
    float4 vertex       : POSITION;
    float2 uv           : TEXCOORD0;
    float2 uv2          : TEXCOORD1;
    float4 normal       : NORMAL;
    float4 tangent      : TANGENT;
    float4 binormal     : BINORMAL;
    /*
        vtx.r = shadowOffsetScale
        vtx.g = undefined
        vtx.b = lineWeightScale
    */
    float4 vertexColor  : COLOR1;
};

struct v2f
{
    float4 pos          : POSITION;
    float4 uv           : TEXCOORD0;
    float4 normal       : NORMAL;
    float4 tangent      : TANGENT;
    float4 binormal     : BINORMAL;
    float4 vertexColor  : TEXCOORD1;
    float4 cameraDir    : TEXCOORD2;
};


/*Here my function*/

////////////////////////////////////////
////// Decode sRGB /////////////////////
////////////////////////////////////////
float sRGB2linear(float x)
{
  return x <= 0.04045 ?
    x * 0.0773993808 : // 1.0/12.92
    pow((x + 0.055) / 1.055, 2.4);
}

float3 sRGB2linear(float3 rgb)
{
  return float3(
    sRGB2linear(rgb.r),
    sRGB2linear(rgb.g),
    sRGB2linear(rgb.b));
}

float4 sRGB2linear(float4 rgba)
{
  return float4(sRGB2linear(rgba.rgb), rgba.a);
}


////////////////////////////////////////
////// Normal //////////////////////////
////////////////////////////////////////
float3 unpackZeroOne (float3 map)
{
    return (map.rgb * 2.0f - 1.0f);
}

////////////////////////////////////////
////// Lighting ////////////////////////
////////////////////////////////////////
float unclampLambertShader(in float3 N,in float3 L)
{
    float lambert = dot(N,L).x;
    return lambert;
}
float3 RampLighting (float U ,float V,Texture2D rampmap)
{
    return sRGB2linear(rampmap.SampleLevel( BaseTexSampler, float2(U,V),0).rgb);
}

////////////////////////////////////////
////// Camera //////////////////////////
////////////////////////////////////////

/*
ViewMatrix(OpenGL - Column)
[ 0, 0, 0, tx]
[ 0, 0, 0, ty]
[ 0, 0, 0, tz]
[ 0, 0, 0, 1]

ViewMatrix(DirectX - Row)
[ 0, 0, 0, 0]
[ 0, 0, 0, 0]
[ 0, 0, 0, 0]
[ tx, ty, tz, 1]

*/

float3 getCameraDir ()
{
    return normalize(ViewToWorld[3].xyz-ObjectToWorld[3].xyz);
}

float3 getCameraPos ()
{
    return ViewToWorld[3].xyz;
}

float fixCameraLengthOp (float3 pos, half scale=0.001)
{
    float camLength = length(pos - getCameraPos());
    return bKeepOutlineWidth ? (scale * camLength * 0.1) : (scale / camLength);
}

////////////////////////////////////////
////// Smooth //////////////////////////
////////////////////////////////////////

//this methon come from "https://github.com/ColinLeung-NiloCat/UnityURPToonLitShaderExample/blob/master/NiloInvLerpRemap.hlsl"
// just like smoothstep(), but linear, not clamped
float invLerp(float from, float to, float value)
{
    return (value - from) / (to - from);
}

float invLerpClamp(float from, float to, float value)
{
    return saturate(invLerp(from,to,value));
}

// full control remap, but slower
float remap(float origFrom, float origTo, float targetFrom, float targetTo, float value)
{
    float rel = invLerp(origFrom, origTo, value);
    return lerp(targetFrom, targetTo, rel);
}


////////////////////////////////////////
////// fresnel /////////////////////////
////////////////////////////////////////

/* Compute fresnel Ranges */
float fresnel( float3 vNormal, float3 vEyeDir )
{
	float fresnel = 1-saturate( dot( vNormal, vEyeDir ) );				// 1-(N.V) for Fresnel term
	return fresnel * fresnel;											// Square for a more subtle look
}

float FresnelRange(float3 vNormal, float3 vEyeDir, float3 vRanges)
{

	float result, f = fresnel( vNormal, vEyeDir );			// Traditional Fresnel

	if ( f > 0.5f )
		result = lerp( vRanges.y, vRanges.z, (2*f)-1 );		// Blend between mid and high values
	else
        result = lerp( vRanges.x, vRanges.y, 2*f );			// Blend between low and mid values

	return result;
}


/*Here my Shader Function*/

shared v2f shader_outline_vs (in a2v v)
{ // Offset vex pos by normal direction ...
    /*BasePart*/
    v2f o;
    /* Sample outline color into uv */
    o.uv.xyz =  bUseOutlineColor ? _outlineColor : sRGB2linear(gOutlineColorTex.SampleLevel(BaseTexSampler,v.uv.xy,0).rgb);
    o.uv.w = 1.0;

    /* Make outline shell */
    // Fix distance from view
    o.pos = mul(v.vertex, ObjectToView); // ViewSpace position
    float offsetValue = fixCameraLengthOp(o.pos.xyz, _outlineWeightScale);
    float4 vertexOffset = float4( v.vertex.xyz + (offsetValue * v.normal.xyz) * abs(v.vertexColor.zzz) , 1.0);
    o.pos = mul(vertexOffset, ObjectToView);
    o.pos.z += bUseZFix ? -offsetValue : 0.0;
    o.pos = mul(o.pos, ViewToProj);

    return o;

};

//make outline PS
shared float4 shader_outline_ps (v2f i) : SV_Target
{
    return i.uv;
}

shared v2f shader_vs (in a2v v)
{
    /*BasePart*/
    v2f o;
    o.uv.x = v.uv.x;o.uv.y = UV_FLIP * v.uv.y;
    o.uv.z = v.uv2.x;o.uv.w = UV_FLIP * v.uv2.y;
    float4 vtxWsPos = mul(v.vertex, ObjectToWorld);
    o.cameraDir.xyz = normalize(getCameraPos() - vtxWsPos.xyz);
    o.pos = mul(vtxWsPos, WorldToProj);
    o.normal.xyz = normalize(mul(v.normal.xyz,(float3x3)ObjectToWorld_IT));
    o.binormal.xyz = normalize(mul(v.binormal.xyz,(float3x3)ObjectToWorld_IT));
    o.tangent.xyz = normalize(mul(v.tangent.xyz,(float3x3)ObjectToWorld_IT));
    /*pass vertexColor into ps shader*/
    o.vertexColor = abs(v.vertexColor);
    return o;
};

shared float4 shader_ps (v2f i) : SV_Target
{
    /*Get Base L,N,V,H*/
    #ifdef _MAYA_
        gLamp0Dir = -gLamp0Dir;
    #endif
    // clip as early as possible
    //OpacityMaskClip(i.UV);
    float3 L = normalize(gLamp0Dir);
    float3 V = (i.cameraDir.xyz);//matrix methon(uniform direction)
    float3 N = (i.normal.xyz);
    float3 H = normalize(L+V);

    /*Get Maps into Values*/
        /*LightInfo.r == Specular Mask*/
        /*LightInfo.g == Shadow Offset*/
        /*LightInfo.b == Shiniess offset Mask*/
        /*LightInfo.a == Rim Mask*/
    float4 lightInfo = gLightinfoTex.Sample(BaseTexSampler,i.uv.xy);

    //Remerber to decode color in gamma-space
    float4 mainColor = sRGB2linear(gMainTex.Sample(BaseTexSampler,i.uv.xy)); // Decode gamma into linear;
    mainColor.rgb = bUseSurfaceColor ? gSurfaceColor.rgb : mainColor.rgb; // where using shader color ...
    half3 curFirstShadowCol = bUseShadowColors  ? _firstShadowMultColor     : sRGB2linear(gFirstShadowTex.Sample(BaseTexSampler,i.uv.xy).rgb);
    half3 curSecShadowCol   = bUseShadowColors  ? _secondShadowMultColor    : sRGB2linear(gSecondShadowTex.Sample(BaseTexSampler,i.uv.xy).rgb);
    half3 curSpecularCol    = bUseSpecularColor ? _specularColor            : sRGB2linear(gSpecualColorTex.Sample(BaseTexSampler,i.uv.xy).rgb);

    /*Compute Lambert Shaders*/
    float unclampLambert = unclampLambertShader(N,L);
    #define lambert unclampLambert
    float halfLambert = saturate(lambert * 0.5 + 0.5);

    /*Compute Shadow*/
    float4 diffuse = {0.0f,0.0f,0.0f,1.0f};
        /*first Shadow term */
    float diffuseMask = lightInfo.y * i.vertexColor.x;
    /*Shadow Core*/
    float3 preBaseColor = bUseConstantShadowCol ? float3(1.0f, 1.0f, 1.0f) : mainColor.rgb;
        /*Step method*/
    if (diffuseMask > 0.1 )
    { /*(vtxColor.x * LightInfoMap.y + halfLambert) *0.5 - _firstShadow > 0*/
        float firstMask = diffuseMask > 0.5 ? diffuseMask * 1.2f - 0.1f : diffuseMask * 1.25f - 0.125f ;
        bool isLight = (firstMask + halfLambert) * 0.5 > _firstShadow;
        diffuse.rgb = isLight ? mainColor.rgb : preBaseColor * curFirstShadowCol;
    }
    else /*second Shadow term*/
    { /*(vtxColor.x * LightInfoMap.y + halfLambert) *0.5 - _secondShadow > 0*/
        bool isFirst = (diffuseMask + halfLambert)* 0.5 > _secondShadow;
        diffuse.rgb = isFirst ? preBaseColor * curFirstShadowCol : preBaseColor * curSecShadowCol;
    };

    /*Compute Diffuse Lighting*/
    // Check if Warm Cool tint ...
    #ifdef _USE_WARM_COOL_
        //TODO:view based toon
            /*this part help to make really soft gradient~*/
        float3 k_blue = float3(0.0f, 0.0f, _blue);
        float3 k_yellow = float3 (_yellow, _yellow, 0.0f);

        float3 k_cool = k_blue * _gAlpha*diffuse.rgb;
        float3 k_warm = k_yellow * _gBeta*diffuse.rgb;
        //float3 k_gradient =(halfLambert * k_warm + (1 - halfLambert) * k_cool)*(_gface);
        float3 k_gradient = lerp(k_warm, k_cool, halfLambert) * (_gface) ;
        diffuse.rgb = 1-(1-k_gradient)*(1-diffuse.rgb); //screen fliter
    #endif

    /*Compute Specular*/
        /*Cheap methon*/
    //float NdotH = dot(N, normalize(gLamp0Dir + getCameraDir()));
    float NdotH = dot(N, H);
    float shinePow = pow(max(NdotH,0.0),_shiniess);
    float3 spec = shinePow + lightInfo.z > 1.0f ? lightInfo.x * _specMulti : float3(0.0, 0.0, 0.0);

    /*Compute RimLight*/
    #ifdef _USE_RIM_LIGHT_
        float fFresnel = pow( fresnel(N, V) , _rimPow) * 16 * pow(fresnel(normalize(gLamp0Dir + V),V) , 16) * 16;
        spec += lightInfo.a * fFresnel * _RimMulti;
    #endif

    /*Compute Emission*/
    float4 emission;
    emission.rgb = mainColor.rgb + _emission * _emissionColor;

    /*final Color*/
    //diffuse.rgb += spec.rgb;
    //diffuse.rgb += emission.rgb;

    float4 finalColor = float4(lerp((diffuse.rgb + (spec) * curSpecularCol) * gLamp0Color.rgb, emission.rgb, _unLightWeight), 1);

    /*debug Here*/
    #ifdef _DEBUG_
        switch ((int)enumShowDebugChannel)
        {
            case 1:
                finalColor = mainColor;
                break;
            case 2:
                finalColor = i.vertexColor;
                break;
            case 3:
                finalColor.rgb = lightInfo.rgb;
                break;
            default:
                break;
        };

        switch((int)enumChannelChooser)
        {
            case 1:
                finalColor.rgb = finalColor.rrr;
                break;
            case 2:
                finalColor.rgb = finalColor.ggg;
                break;
            case 3:
                finalColor.rgb = finalColor.bbb;
                break;
            case 4:
                finalColor.rgb = finalColor.aaa;
                break;
            default:
                break;
        };
    #endif


    //finalColor.rgb = lightInfo.bbb;
    return finalColor;

    // float4 extraColor = saturate(finalColor - float4(1.0f,1.0f,1.0f,1.0f));
    // return saturate(finalColor - extraColor);
};

RasterizerState DisableCulling { CullMode = NONE; };
RasterizerState FrontCulling { CullMode = FRONT;};
RasterizerState BackCulling { CullMode = BACK; };
DepthStencilState DepthEnabling { DepthEnable = TRUE; DepthWriteMask = All;};
DepthStencilState RenderInBack
{
    DepthEnable = TRUE;
    DepthWriteMask = ZERO;
    DepthFunc = ALWAYS;
};

DepthStencilState DepthDisabling
{
	DepthEnable = FALSE;
	DepthWriteMask = ZERO;
};

BlendState DisableBlend { BlendEnable[0] = FALSE; };

BlendState BaseBlend
{
    BlendEnable[0] = TRUE;
    AlphaToCoverageEnable = TRUE; //better for aa
};


/*Here my render pass*/

technique11 ToonSurface
{
    pass mainPass
    { // main ps shader
        SetVertexShader (
            CompileShader (
                vs_5_0,shader_vs()
            )
        );
		SetGeometryShader(NULL);
        SetPixelShader(
            CompileShader (
                ps_5_0,shader_ps()
            )
        );
        SetRasterizerState(DisableCulling);
	    SetDepthStencilState(DepthEnabling, 0);
	    //SetBlendState(DisableBlend, float4( 0.0, 0.0, 0.0, 0.0 ), 0xFFFFFFFF);
    }

};

technique11 ToonSurfaceWithOutLine
{
    pass p0
    { // outline shader
        SetVertexShader (
            CompileShader (
                vs_5_0,shader_outline_vs()
            )
        );
		SetGeometryShader(NULL);
        SetPixelShader(
            CompileShader (
                ps_5_0,shader_outline_ps()
            )
        );
        SetRasterizerState(BackCulling);
	    SetDepthStencilState(DepthEnabling, 0);
    }

    pass p1
    { // main ps shader
        SetVertexShader (
            CompileShader (
                vs_5_0,shader_vs()
            )
        );
		SetGeometryShader(NULL);
        SetPixelShader(
            CompileShader (
                ps_5_0,shader_ps()
            )
        );
        SetRasterizerState(DisableCulling);
	    SetDepthStencilState(DepthEnabling, 0);
	    //SetBlendState(DisableBlend, float4( 0.0, 0.0, 0.0, 0.0 ), 0xFFFFFFFF);
    }

};