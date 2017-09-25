Shader "Custom/CustomBlend" {
	Properties {
		_Color ("Color", Color) = (1,1,1,1)
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
		_EvilTex("Evil Tex (RGB)", 2D) = "white" {}
		_Percent("How Evil", Range(0, 1)) = 0
		_Glossiness("Gloss", Range(0, 1)) = 0
		_Metal("Metallic", Range(0, 1)) = 0
	}

	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		// Physically based Standard lighting model, and enable shadows on all light types
		#pragma surface surf Standard fullforwardshadows

		// Use shader model 3.0 target, to get nicer looking lighting
		#pragma target 3.0

		sampler2D _MainTex;
		sampler2D _EvilTex;

		struct Input {
			float2 uv_MainTex;
		};
		half _Percent;
		fixed4 _Color;
		half _Metal;
		half _Glossiness;

		void surf (Input IN, inout SurfaceOutputStandard o) {
			fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color;
			fixed4 evil = tex2D (_EvilTex, IN.uv_MainTex) * _Color;
			
			o.Albedo = c.rgb * (1 - _Percent) + evil * _Percent;
			o.Alpha = c.a;
			o.Smoothness = _Glossiness;
			o.Metallic = _Metal;
		}
		ENDCG
	}
	FallBack "Diffuse"
}
