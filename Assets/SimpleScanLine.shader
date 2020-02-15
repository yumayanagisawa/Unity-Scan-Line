Shader "Unlit/SimpleScanLine"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            // make fog work
            #pragma multi_compile_fog

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
				float2 uv = i.uv.xy;
				float modX = -_Time.y / 1.;
				float modY = 1.9;
				// make glsl's mod function, write it inside frag or main()
				float y = (modX - modY * floor(modX / modY)) - .4;

				float str = -pow((uv.y - y) * 110., 2.) + .8;
				uv.x -= clamp(str*.01, 0., 1.);
				float3 col = float3(0, 0, 0);
				float colorAdd = pow(1. - pow(abs(uv.y - y), .3), 3.);
				col.g += colorAdd * 1.5;
				col.b += colorAdd * 1.;
				return float4(col, 1.0);
            }
            ENDCG
        }
    }
}
