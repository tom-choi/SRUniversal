struct Attributes
{
    float3 positionOS   : POSITION;
    half3 normalOS      : NORMAL;
    half4 tangentOS     : TANGENT;
    float2 uv           : TEXCOORD0;
};

struct Varyings
{
    float2 uv                       : TEXCOORD0;
    float4 positionWSAndFogFactor   : TEXCOORD1;
    float3 normalWS                 : TEXCOORD2;
    float3 viewDirectionsWS         : TEXCOORD3;
    float3 SH                       : TEXCOORD4;
    float4 positionCS               : SV_POSITION;
};

float3 destruation(float3 color)
{
    float3 grayXfar = float3(0.3, 0.59, 0.11);
    float grayf = dot(color, grayXfar);
    return float3(grayf,grayf,grayf);
}

Varyings vert(Attributes input)
{
    Varyings output = (Varyings)0;

    VertexPositionInputs vertexInput = GetVertexPositionInputs(input.positionOS);
    VertexNormalInputs vertexNormalInput = GetVertexNormalInputs(input.normalOS,input.tangentOS);

    output.uv = TRANSFORM_TEX(input.uv, _BaseMap);
    // 世界空間
    output.positionWSAndFogFactor = float4(vertexInput.positionWS,ComputeFogFactor(vertexInput.positionCS.z));
    // 世界空間法線
    output.normalWS = vertexNormalInput.normalWS;
    // 世界空間相機向量
    output.viewDirectionsWS = unity_OrthoParams.w == 0 ? GetCameraPositionWS() - vertexInput.positionWS : GetWorldToViewMatrix()[2].xyz;
    
    // 間接光 with 球諧函數
    output.SH = SampleSH(vertexNormalInput.normalWS);
    // 間接光 with 球諧函數
    output.SH = SampleSH(lerp(vertexNormalInput.normalWS, float3(0,0,0), _IndirectLightFlattenNormal));
    
    output.positionCS = vertexInput.positionCS;

    return output;
}

float4 frag(Varyings input, bool isFrontFace : SV_IsFrontFace): SV_TARGET
{
    float3 positionWS = input.positionWSAndFogFactor.xyz;
    float4 shadowCoord = TransformWorldToShadowCoord(positionWS);
    Light mainLight = GetMainLight(shadowCoord);
    float3 lightDirectionWS = normalize(mainLight.direction);
    float3 viewDirectionsWS = normalize(input.viewDirectionsWS);

    float3 normalWS = normalize(input.normalWS);

    float3 viewDirections = normalize(input.viewDirectionsWS);

    float3 baseColor = tex2D(_BaseMap, input.uv);
    float4 areaMap = 0;

    #if _AREA_FACE
        areaMap = tex2D(_FaceColorMap, input.uv);
    #elif _AREA_HAIR
        areaMap = tex2D(_HairColorMap, input.uv);
    #elif _AREA_UPPERBODY
        areaMap = tex2D(_UpperBodyColorMap, input.uv);
    #elif _AREA_LOWERBODY
        areaMap = tex2D(_LowerBodyColorMap, input.uv);
    #endif
    baseColor = areaMap.rgb;
    baseColor *= lerp(_BackFaceTintColor,_FrontFaceTintColor, isFrontFace); //眼睛有問題 

    float4 lightMap = 0;
    #if _AREA_HAIR || _AREA_UPPERBODY || _AREA_LOWERBODY
    {
        #if _AREA_HAIR
            lightMap = tex2D(_HairLightMap, input.uv);
        #elif _AREA_UPPERBODY
            lightMap = tex2D(_UpperBodyLightMap, input.uv);
        #elif _AREA_LOWERBODY
            lightMap = tex2D(_LowerBodyLightMap, input.uv);
        #endif
    }
    #endif
    float4 faceMap = 0;
    #if _AREA_FACE
        faceMap = tex2D(_FaceMap, input.uv);
    #endif

    float3 indirectLightColor = input.SH.rgb;
    #if _AREA_HAIR || _AREA_UPPERBODY || _AREA_LOWERBODY
        indirectLightColor *= lerp(1, lightMap.r, _IndirectLightOcclusionUsage); // 加個 Ambient Occlusion
    #else
        indirectLightColor *= lerp(1, lerp(faceMap.g,1,step(faceMap.r,0.5)), _IndirectLightOcclusionUsage);
    #endif
    indirectLightColor *= lerp(1,baseColor,_IndirectLightMixBaseColor);
    
    float3 mainLightColor = lerp(destruation(mainLight.color), mainLight.color, _MainLightColorUsage);
    float mainLightShadow = 1;
    float rampRowIndex = 0;
    float rampRowNum = 1;
    #if _AREA_HAIR || _AREA_UPPERBODY || _AREA_LOWERBODY
    {
        float NoL = dot(normalWS,lightDirectionWS);
        //mainLightShadow = NoL;
        //mainLightShadow = step(0,NoL); // 二值化
        float remappedNoL = NoL * 0.5 + 0.5;
        //mainLightShadow = step(1 - lightMap.g,remappedNoL);
        mainLightShadow = smoothstep(1 - lightMap.g + _ShadowThresholdCenter - _ShadowThresholdSoftness , 1 - lightMap.g + _ShadowThresholdCenter + _ShadowThresholdSoftness  , remappedNoL);
        mainLightShadow *= lightMap.r;

        #if _AREA_HAIR
            rampRowIndex = 0;
            rampRowNum = 1;
        #elif _AREA_UPPERBODY || _AREA_LOWERBODY
            int rawIndex = (round((lightMap.a + 0.0425) / 0.0625) - 1) / 2;
            rampRowIndex = lerp(rawIndex, rawIndex + 4 < 8 ? rawIndex + 4 : rawIndex + 4 - 8,fmod(rawIndex, 2));
            rampRowNum = 8;
        #endif
    }
    #elif _AREA_FACE
    {
        float3 headForward = normalize(_HeadForward);
        float3 headRight = normalize(_HeadRight);
        float3 headUp = cross(headForward,headRight);

        float3 fixedLightDirectionWS = normalize(lightDirectionWS - dot(lightDirectionWS, headUp) * headUp);
        float2 sdfUV = float2(sign(dot(fixedLightDirectionWS,headRight)),1) * input.uv* float2(-1,1);
        float sdfValue = tex2D(_FaceMap,sdfUV).a;
        sdfValue += _FaceShadowOffset; 

        
        float sdfThreshold = 1 - (dot(fixedLightDirectionWS,headForward) * 0.5 + 0.5);
        // float sdf = step(sdfThreshold,sdfValue);
        float sdf = smoothstep(sdfThreshold - _FaceShadowTransitionSoftness, sdfThreshold + _FaceShadowTransitionSoftness, sdfValue);

        // mainLightShadow = sdf;
        mainLightShadow = lerp(faceMap.g, sdf, step(faceMap.r, 0.5));
    
        rampRowIndex = 0;
        rampRowNum = 8;
    }
    #endif
    
    float rampUVx = mainLightShadow * (1 - _ShadowRampOffset) + _ShadowRampOffset;
    float rampUVy = (2 * rampRowIndex + 1) * (1.0 / (rampRowNum * 2));
    float2 rampUV = float2(rampUVx, rampUVy);
    float3 coolRamp = 1;
    float3 warmRamp = 1;
    #if _AREA_HAIR
    {
        coolRamp = tex2D(_HairCoolRamp, rampUV).rgb;
        warmRamp = tex2D(_HairWarmRamp, rampUV).rgb;
    }
    #elif _AREA_FACE || _AREA_UPPERBODY || _AREA_LOWERBODY
    {
        coolRamp = tex2D(_BodyCoolRamp, rampUV).rgb;
        warmRamp = tex2D(_BodyWarmRamp, rampUV).rgb;
    }
    #endif
    float isDay = lightDirectionWS.y * 0.5 + 0.5;
    float3 rampColor = lerp(coolRamp, warmRamp, isDay);
    mainLightColor *= baseColor * rampColor;

    float3 specularColor = 0;
    #if _AREA_HAIR || _AREA_UPPERBODY || _AREA_LOWERBODY
    {
        float3 halfVectorWS = normalize(viewDirectionsWS + lightDirectionWS);
        float NoH = dot(normalWS, halfVectorWS);
        float blinnPhong = pow(saturate(NoH), _SpecularExpon);
        
        float nonMatalSpecular = step(1.04 - blinnPhong, lightMap.b) * _SpecularKsNonMetal;
        float metalSpecular = blinnPhong * lightMap.b * _SpecularKsMetal;
        
        float metallic = 0;
        #if _AREA_UPPERBODY || _AREA_LOWERBODY
            metallic = saturate((abs(lightMap.a - 0.52) - 0.1) / (0 - 0.1));
        #endif

        // specularColor = metalSpecular;
        // specularColor = metallic;
        specularColor = lerp(nonMatalSpecular, metalSpecular * baseColor, metallic);
        specularColor *= mainLight.color;
        specularColor *= _SpecularBrightness;
    }
    #endif
    
    float3 albedo = 0;
    //albedo += baseColor;
    albedo += indirectLightColor;
    //albedo = faceMap.rgb;
    //albedo = lightDirectionWS; // 主光源向量
    //albedo = normalWS; // 
    //albedo = viewDirections; // 相機向量
    //albedo += mainLightShadow;
    albedo += mainLightColor;
    albedo += specularColor;
    float alpha = _Alpha;

    float4 color = float4(albedo,alpha);
    return color;
}

