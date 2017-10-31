Shader "CustomFX/OldMovie"
{
	Properties
	{
		[HideInInspector]_MainTex ("Texture", 2D) = "white" {}
        _Vignette ("_Vignette", 2D) = "white" {}
		_Scratches ("_Scratches", 2D) = "black" {}
		_DustTexture ("_Scratches", 2D) = "black" {}
        _SepiaColor ("Sepia Color", Color) = (1,1,1,1)
        _EffectAmount ("Old Film Effect Amount", Range(0,1)) = 1.0
        _VignetteAmount ("Vignette Opacity", Range(0,1)) = 1.0
        _ScratchesYSpeed ("Scratches Y Speed", Float) = 10.0
        _ScratchesXSpeed ("Scratches X Speed", Float) = 10.0
        _dustXSpeed ("Dust X Speed", Float) = 10.0        
        _dustYSpeed ("Dust Y Speed", Float) = 10.0
        _RandomValue ("Random Value", Float) = 1.0
		_Contrast("Contrast", Float) = 1
	}
	SubShader
	{
		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
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
			half _VignetteAmount;
			half4 _SepiaColor;
			half _RandomValue;
			half _ScratchesXSpeed;
			half _ScratchesYSpeed;
			half _dustXSpeed;
			half _dustYSpeed;
			half _EffectAmount;
			half _Contrast;

			half2 barrelDistortion(half2 uv){
				half2 distUV = uv;
				distUV.y += _SinTime * .005 * _RandomValue;
				return distUV;	
			}

			fixed4 frag (v2f i) : SV_Target
			{
				half2 distortedUV = barrelDistortion(i.uv);

				fixed4 col = tex2D(_MainTex, distortedUV);
				fixed4 vig = tex2D(_Vignette, i.uv);

				half2 scratUV = i.uv + half2(_RandomValue * _SinTime.z * _ScratchesXSpeed, _Time.x * _ScratchesYSpeed);
				half4 scrat = tex2D(_Scratches, scratUV);

				fixed lum = dot(fixed3(0.299, 0.587, 0.114), col.rgb);
				fixed4 finalCol = lum + lerp(_SepiaColor, _SepiaColor + fixed4(0.1f,0.1f,0.1f,.0f), _RandomValue);
				finalCol = pow(finalCol, _Contrast);
				fixed3 white = fixed3(1,1,1);

				finalCol = lerp(finalCol, vig * finalCol, _VignetteAmount);

				finalCol.rgb *= lerp(scrat, white, _RandomValue);

				finalCol = lerp(col, finalCol, _EffectAmount);

				return finalCol;
			}
			ENDCG
		}
	}
}
