#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DeclareDepthTexture.hlsl"
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Shadows.hlsl"

CBUFFER_START(UnityPerMaterial);
float3 _HeadForward;
float3 _HeadRight;

sampler2D _BaseMap;
float4 _BaseMap_ST;

#if _AREA_FACE
    sampler2D _FaceColorMap;
#elif _AREA_HAIR
    sampler2D _HairColorMap;
#elif _AREA_UPPERBODY
    sampler2D _UpperBodyColorMap;
#elif _AREA_LOWERBODY
    sampler2D _LowerBodyColorMap;
#endif

float3 _FrontFaceTintColor;
float3 _BackFaceTintColor;

float _Alpha;
float _AlphaClip;

#if _AREA_HAIR
    sampler2D _HairLightMap;
#elif _AREA_UPPERBODY
    sampler2D _UpperBodyLightMap;
#elif _AREA_LOWERBODY
    sampler2D _LowerBodyLightMap;
#endif

#if _AREA_HAIR
    sampler2D _HairCoolRamp;
    sampler2D _HairWarmRamp;
#elif _AREA_FACE || _AREA_UPPERBODY || _AREA_LOWERBODY
    sampler2D _BodyCoolRamp;
    sampler2D _BodyWarmRamp;
#endif

float _IndirectLightFlattenNormal;
float _IndirectLightUsage;
float _IndirectLightOcclusionUsage;
float _IndirectLightMixBaseColor;

float _MainLightColorUsage;
float _ShadowThresholdCenter;
float _ShadowThresholdSoftness;
float _ShadowRampOffset;

#if _AREA_FACE
    sampler2D _FaceMap;
    float _FaceShadowOffset;
    float _FaceShadowTransitionSoftness;
#endif

#if _AREA_HAIR || _AREA_UPPERBODY || _AREA_LOWERBODY
    float _SpecularExpon;
    float _SpecularKsNonMetal;
    float _SpecularKsMetal;
    float _SpecularBrightness;
#endif

#if _AREA_UPPERBODY || _AREA_LOWERBODY
    #if _AREA_UPPERBODY
        sampler2D _UpperBodyStockings;
    #elif _AREA_LOWERBODY
        sampler2D _LowerBodyStockings;
    #endif
    float3 _StockingsDarkColor;
    float3 _StockingsLightColor;
    float3 _StockingsTransitionColor;
    float _StockingsTransitionThreshold;
    float _StockingsTransitionPower;
    float _StockingsTransitionHardness;
    float _StockingsTextureUsage;
#endif

float _RimLightWidth;
float _RimLightThreshold;
float _RimLightFadeout;
float3 _RimLightTintColor;
float _RimLightBrightness;
float _RimLightMixAlbedo;

#if _EMISSION_ON
    float _EmissionMixBaseColor;
    float3 _EmissionTintColr;
    float _EmissionIntensity;
#endif

#if _OUTLINE_ON
    float _OutlineWidth;
    float _OutlineGamma;
#endif

CBUFFER_END
