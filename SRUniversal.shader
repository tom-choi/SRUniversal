Shader "Custom/SRUniversal"
{
    Properties
    {
        [KeywordEnum (None, Face, Hair, UpperBody, LowerBody)] _Area("Material area", float) =0
        [HideInInspector] _HeadForward("", Vector) = (0,0,1)
        [HideInInspector] _HeadRight("", Vector) = (1,0,0)

        [Header (Base Color)]
        [HideinInspector] _BaseMap ("", 2D) = "white" {}
        [NoScaleOffset] _FaceColorMap ("Face color map (Default white)", 2D) = "white" {}
        [NoScaleOffset] _HairColorMap ("Hair color map (Default white)", 2D) = "white" {}
        [NoScaleOffset] _UpperBodyColorMap ("Upper body color map (Default white)", 2D) = "white" {}
        [NoScaleOffset] _LowerBodyColorMap ("Lower body color map (Default white)", 2D) = "white" {}
        _FrontFaceTintColor("Front face tint color (Default white)",Color) = (1,1,1)
        _BackFaceTintColor("Back face tint color (Default white)",Color) = (1,1,1)
        _Alpha("Alpha (Default 1)", Range(0,1)) = 1
        _AlphaClip("Alpha clip (Default 0.333)", Range(0,1)) = 0.333

        [Header(Light Map)]
        [NoScaleOffset] _HairLightMap("Hair light map (Default black)",2D) = "black" {}
        [NoScaleOffset] _UpperBodyLightMap("Upper body map (Default black)",2D) = "black" {}
        [NoScaleOffset] _LowerBodyLightMap("Lower body map (Default black)",2D) = "black" {}

        [Header(Ramp Map)]
        [NoScaleOffset] _HairCoolRamp("Hair cool ramp (Default white)",2D) = "white" {}
        [NoScaleOffset] _HairWarmRamp("Hair warm ramp (Default white)",2D) = "white" {}
        [NoScaleOffset] _BodyCoolRamp("Body cool ramp (Default white)",2D) = "white" {}
        [NoScaleOffset] _BodyWarmRamp("Body warm ramp (Default white)",2D) = "white" {}

        [Header(Indirect Lighting)]
        _IndirectLightFlattenNormal("Indirect light flatten normal (Default 0)",Range(0,1)) = 0
        _IndirectLightUsage("Indirect light usage (Default 0.5)",Range(0,1)) = 0.5
        _IndirectLightOcclusionUsage("Indirect light occlusion usage (Default 0.5)",Range(0,1)) = 0.5
        _IndirectLightMixBaseColor("Indirect light mix base color (Default 1)",Range(0,1)) = 1

        [Header(Main Lighting)]
        _MainLightColorUsage("Main light color usage (Default 1)",Range(0,1)) = 1
        _ShadowThresholdCenter("Shadow threshold center (Default 0)",Range(-1,1)) = 0
        _ShadowThresholdSoftness("Shadow threshold softness (Default 0.1)",Range(0,1)) = 0.1
        _ShadowRampOffset("Shadow ramp offset (Default 0.75)",Range(0,1)) = 0.75

        [Header(Face)]
        [NoScaleOffset] _FaceMap("Face map (Default black)",2D) = "black" {}
        _FaceShadowOffset("Face shadow offset (Default -0.01)",Range(-1,1)) = -0.01
        _FaceShadowTransitionSoftness("Face shadow transition softness (Default 0.05)", Range(0,1)) = 0.05

        [Header(Specular)]
        [Toggle(_SPECULAR_ON)] _EnableSpecular ("Enable Specular (Default YES)", float) = 1
        [Toggle(_METAL_SPECULAR_ON)] _EnableMetalSpecular ("Enable Metal Specular (Default YES)", float) = 1
        _SpecularExpon("Specular exponent (Default 50)",Range(0,100)) = 50
        _SpecularKsNonMrtal("Specular KS non-metal (Default 0.04)",Range(0,1)) = 0.04
        _SpecularKsMetal("Specular KS metal (Default 1)",Range(0,1)) = 1
        _SpecularBrightness("Specular brightness (Default 1)",Range(0,10)) = 10

        [Header(Emission)]
        [Toggle(_EMISSION_ON)] _UseEmission("Use emission (Default NO)",float) = 0
        _EmissionMixBaseColor("Emission mix base color (Default 1)", Range(0,1)) = 1
        _EmissionTintColor("Emission tint color (Default white)", Color) = (1,1,1) 
        _EmissionIntensity("Emission intensity (Default 1)", Range(0,100)) = 1

        [Header(Outline)]
        [Toggle(_OUTLINE_ON)] _UseOutline("Use outline (Default YES)", float ) = 1
        [Toggle(_OUTLINE_VERTEX_COLOR_SMOOTH_NORMAL)] _OutlineUseVertexColorSmoothNormal("Use vertex color smooth normal (Default NO)", float) = 0
        _OutlineWidth("Outline width (Default 1)", Range(0,10)) = 1
        _OutlineGamma("Outline gamma (Default 16)", Range(1,255)) = 16

        [Header(Surface Options)]
        [Enum(UnityEngine.Rendering.CullMode)] _Cull ("Cull (Default back)", Float) = 2
        [Enum(UnityEngine.Rendering.BlendMode)] _SrcBlendMode ("Src blend mode (Default One)", Float) = 1
        [Enum(UnityEngine.Rendering.BlendMode)] _DstBlendMode ("Dst blend mode (Default Zero)", Float) = 0
        [Enum(UnityEngine.Rendering.BlendOp)] _BlendOp ("Blend operation (Default back)", Float) = 0
        [Enum(Off,0, On,1)] _ZWrite("ZWrite (Default On)",Float) = 1
        _StencilRef ("Stencil reference (Default 0)",Range(0,255)) = 0
        [Enum(UnityEngine.Rendering.CompareFunction)] _StencilComp("Stencil comparison (Default disabled)",Int) = 0
        [Enum(UnityEngine.Rendering.StencilOp)] _StencilPassOp("Stencil pass comparison (Default keep)",Int) = 0
        [Enum(UnityEngine.Rendering.StencilOp)] _StencilFailOp("Stencil fail comparison (Default keep)",Int) = 0
        [Enum(UnityEngine.Rendering.StencilOp)] _StencilZFailOp("Stencil z fail comparison (Default keep)",Int) = 0

        [Header(Draw Overlay)]
        [Toggle(_DRAW_OVERLAY_ON)] _UseDrawOverlay("Use draw overlay (Default NO)",float) = 0
        [Enum(UnityEngine.Rendering.BlendMode)] _ScrBlendModeOverlay("Overlay pass scr blend mode (Default One)",Float) = 1
        [Enum(UnityEngine.Rendering.BlendMode)] _DstBlendModeOverlay("Overlay pass dst blend mode (Default Zero)", Float) = 0
        [Enum(UnityEngine.Rendering.BlendOp)] _BlendOpOverlay("Overlay pass blend operation (Default Add)", Float) = 0
        _StencilRefOverlay ("Overlay pass stencil reference (Default 0)", Range(0,255)) = 0
        [Enum(UnityEngine.Rendering.CompareFunction)] _StencilCompOverlay("Overlay pass stencil comparison (Default disabled)",Int) = 0

    }
    SubShader
    {
        LOD 100

        HLSLINCLUDE
        #pragma shader_feature_local _AREA_FACE
        #pragma shader_feature_local _AREA_HAIR
        #pragma shader_feature_local _AREA_UPPERBODY
        #pragma shader_feature_local _AREA_LOWERBODY
        #pragma shader_feature_local _OUTLINE_ON
        #pragma shader_feature_local _OUTLINE_VERTEX_COLOR_SMOOTH_NORMAL
        #pragma shader_feature_local _DRAW_OVERLAY_ON
        #pragma shader_feature_local _EMISSION_ON
        ENDHLSL

        Pass
        {
            Name "ShadowCaster"
            Tags{"LightMode" = "ShadowCaster"}

            ZWrite [_ZWrite]
            ZTest LEqual
            ColorMask 0
            Cull[_Cull]

            HLSLPROGRAM
            #pragma exclude_renderers gles gles3 glcore
            #pragma target 4.5

            // Material keywords
            #pragma shader_feature_local_fragment _ALPHATEST_ON
            #pragma shader_feature_local_fragment _SMOOTHNESS_TEXTURE_ALBEDO_CHANNEL_A

            // GPU Instancing
            #pragma multi_compile_instancing
            #pragma multi_compile _ DOTS_INSTANCING_ON

            // This is used during shadow map generation to differentiate between directional and punctual light shadows, as they use different formulas to apply Normal Bias
            #pragma multi_compile_vertex _ _CASTING_PUNCTUAL_LIGHT_SHADOW
            
            #pragma vertex ShadowPassVertex // 和後面的include 有關係
            #pragma fragment ShadowPassFragment

            #include "Packages/com.unity.render-pipelines.universal/Shaders/LitInput.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/Shaders/ShadowCasterPass.hlsl"
            ENDHLSL
        }

        Pass
        {
            Name "DepthOnly"
            Tags{"LightMode" = "DepthOnly"}

            ZWrite [_ZWrite]
            ColorMask 0
            Cull[_Cull]

            HLSLPROGRAM
            #pragma exclude_renderers gles gles3 glcore
            #pragma target 4.5

            #pragma vertex DepthOnlyVertex // 和後面的include 有關係
            #pragma fragment DepthOnlyFragment

            // Material keywords
            #pragma shader_feature_local_fragment _ALPHATEST_ON
            #pragma shader_feature_local_fragment _SMOOTHNESS_TEXTURE_ALBEDO_CHANNEL_A

            // GPU Instancing
            #pragma multi_compile_instancing
            #pragma multi_compile _ DOTS_INSTANCING_ON

            #include "Packages/com.unity.render-pipelines.universal/Shaders/LitInput.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/Shaders/DepthOnlyPass.hlsl"
            ENDHLSL
        }

        Pass
        {
            Name "DepthNormals"
            Tags{"LightMode" = "DepthNormals"}

            ZWrite [_ZWrite]
            Cull[_Cull]

            HLSLPROGRAM
            #pragma exclude_renderers gles gles3 glcore
            #pragma target 4.5

            #pragma vertex DepthNormalsVertex // 和後面的include 有關係
            #pragma fragment DepthNormalsFragment

            // Material keywords
            #pragma shader_feature_local _NORMALMAP 
            #pragma shader_feature_local _PARALLAXMAP
            #pragma shader_feature_local _ _DETAIL_MULX2 _DETAIL_SCALED
            #pragma shader_feature_local_fragment _ALPHATEST_ON
            #pragma shader_feature_local_fragment _SMOOTHNESS_TEXTURE_ALBEDO_CHANNEL_A

            // GPU Instancing
            #pragma multi_compile_instancing
            #pragma multi_compile _ DOTS_INSTANCING_ON

            #include "Packages/com.unity.render-pipelines.universal/Shaders/LitInput.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/Shaders/LitDepthNormalsPass.hlsl"
            ENDHLSL
        }

        Pass
        {
            Name "DrawCore"
            Tags
            {
                "RenderPipeline" = "UniversalPipeline"
                "RenderType" = "Opaque"
            }
            Cull[_Cull]
            Stencil{
                Ref [_StencilRef]
                Comp [_StencilComp]
                Pass [_StencilPassOp]
                Fail [_StencilFailOp]
                ZFail [_StencilZFailOp]
            }
            Blend [_SrcBlendMode] [_DstBlendMode]
            BlendOp [_BlendOp]
            ZWrite [_ZWrite]

            HLSLPROGRAM
            #pragma multi_compile _MAIN_LIGHT_SHADOWS
            #pragma multi_compile _MAIN_LIGHT_SHADOWS_CASCADE
            #pragma multi_compile _SHADOWS_SOFT

            #pragma vertex vert
            #pragma fragment frag

            #include "SRUniversalInput.hlsl"
            #include "SRUniversalDrawCorePass.hlsl"
            ENDHLSL
        }
    }
    FallBack "Diffuse"
}
