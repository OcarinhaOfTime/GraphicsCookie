Shader "CustomFX/OldMovie"
{
	Properties
	{
		[HideInInspector]_MainTex ("Texture", 2D) = "white" {}
        _Vignette ("_Vignette", 2D) = "white" {}
		_Scratches ("_Scratches", 2D) = "black" {}
        _SepiaColor ("Sepia Color", Color) = (1,1,1,1)
        _EffectAmount ("Old Film Effect Amount", Range(0,1)) = 1.0
        _VignetteAmount ("Vignette Opacity", Range(0,1)) = 1.0
        _ScratchesYSpeed ("Scratches Y Speed", Float) = 10.0
        _ScratchesXSpeed ("Scratches X Speed", Float) = 10.0
        _dustXSpeed ("Dust X Speed", Float) = 10.0        
        _dustYSpeed ("Dust Y Speed", Float) = 10.0
        _RandomValue ("Random Value", Float) = 1.0
        _Contrast ("Contrast", Float) = 3.0 
	}
	SubShader
	{
		Cull Off ZWrite Off ZTest Always

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma fragmentoption ARB_precision_hint_fastest
			
			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				float4 vertex : SV_POSITION;
			};

			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = v.uv;
				return o;
			}
			
			sampler2D _MainTex;
            sampler2D _Vignette;
            sampler2D _Scratches;

			fixed4 frag (v2f i) : SV_Target
			{
				fixed4 col = tex2D(_MainTex, i.uv);
				return col;
			}
			ENDCG
		}
	}
}
