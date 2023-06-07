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

Varyings vert(Attributes input)
{
    Varyings output = (Varyings)0;

    VertexPositionInputs vertexInput = GetVertexPositionInputs(input.positionOS);
    VertexNormalInputs vertexNormalInput = GetVertexNormalInputs(input.normalOS,input.tangentOS);

    output.uv = TRANSFORM_TEX(input.uv, _BaseMap);
    output.positionCS = vertexInput.positionCS;

    return output;
}

float4 frag(Varyings input, bool isFrontFace : SV_IsFrontFace): SV_TARGET
{

    float4 color = tex2D(_BaseMap, input.uv);
    return color;
}

