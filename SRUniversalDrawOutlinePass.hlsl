struct Attributes
{
    float3 positionOS   : POSITION;
    float3 normalOS     : NORMAL;
    float4 tangentOS    : TANGENT;
    float4 color        : COLOR;
    float4 uv           : TEXCOORD0;
};

struct Varyings
{
    float4 positionCS       : SV_POSITION;
    float2 uv               : TEXCOORD0;
    float fogFactor         : TEXCOORD1;
    float4 color            : TEXCOORD2;
};

Varyings vert(Attributes input)
{
    Varyings output = (Varyings)0;
    return output;
}

float frag(Varyings input) : SV_TARGET
{
    float4 color = 0;
    return color;
}