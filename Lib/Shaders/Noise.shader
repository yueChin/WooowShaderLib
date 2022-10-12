Shader "Unlit/Noise"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _UVScale("uv Scale", Range(0.01,100)) = 1
        _UVTiling("uv Tiling", Vector) = (0,0,0,0)
        [Toggle(INVERTNOISE)]_InvertNoise("噪声反色", Float) = 0
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        HLSLINCLUDE

        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        
        float _UVScale;
        float2 _UVTiling;

        struct Varings
        {
            float3 positionOS : POSITION;
            float2 uv : TEXCOORD0;
        };
        struct Output
        {
            float4 positionCS : SV_POSITION;
            float2 uv : TEXCOORD0;
        };

        Output vertex(Varings v)
        {
            Output o;
            o.positionCS = TransformObjectToHClip(v.positionOS);
            o.uv = v.uv;
            return o;
        }

        ENDHLSL
        Pass
        {
            HLSLPROGRAM
            #include "NoiseLib.hlsl"
            #pragma vertex vertex
            #pragma fragment fragment
            #pragma shader_feature VALUE PRELIN SIMPLE VORONOI FBM
            #pragma shader_feature INVERTNOISE
            half4 fragment(Output i) : SV_TARGET
            {
                float noise = 0;
                float2 uv = i.uv * _UVScale + _UVTiling;

                #ifdef VALUE
                    noise = valueNoise(uv);
                #elif PRELIN
                    noise = perlinNoise(uv);
                #elif SIMPLE
                    noise = simpleNoise(uv);
                #elif VORONOI
                    noise = voronoiNoise(uv);
                #elif FBM
                    noise = FBMvalueNoise(uv);
                #endif

                #ifdef INVERTNOISE
                    noise = 1 -  noise;
                #endif

                return noise;
            }
            ENDHLSL
        }
    }
    CustomEditor "CustomNoiseEditor" //使用自定义材质面板
}