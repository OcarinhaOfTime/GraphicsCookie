Shader "Custom/FurShader"{
    Properties{
        _Color ("Color", Color) = (1,1,1,1)
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
		_Glossiness ("Smoothness", Range(0,1)) = 0.5
		_Metallic ("Metallic", Range(0,1)) = 0.0
        _FurLength("Fur length", Range(.001, 1)) = .25
        _Cutoff("Cutoff", Range(0, 1)) = .5
        _CutoffEnd("Cutoff End", Range(0, 1)) = .5
        _EdgeFade("Edge Fade", Range(0, 1)) = .4
        _Gravity("Gravity direction", Vector) = (0,0,1,0)
        _GravityStrength("G Strength", Range(0, 1)) = .25
    }

    SubShader{
        Tags {"RenderType" = "Opaque"}

        CGPROGRAM
		#pragma surface surf Standard fullforwardshadows

		#pragma target 3.0
		sampler2D _MainTex;

		struct Input {
			float2 uv_MainTex;
		};

		half _Glossiness;
		half _Metallic;
		fixed4 _Color;

		void surf (Input IN, inout SurfaceOutputStandard o) {
			fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color;
			o.Albedo = c.rgb;
			o.Metallic = _Metallic;
			o.Smoothness = _Glossiness;
			o.Alpha = c.a;
		}
		ENDCG

        CGPROGRAM
        #pragma surface surf Standard fulldorwardshadows alpha:blend vertex:vert
        #define FUR_MULTIPLIER 0.05
        #include "FurPass.cginc"
        ENDCG
    }
    FallBack "Diffuse"
}