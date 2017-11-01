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
		#define FUR_MULTIPLIER 0.1
		#pragma surface surf Standard fulldorwardshadows alpha:blend vertex:vert
#pragma target 3.0
fixed4 _Color;
sampler2D _MainTex;
half _Glossiness;
half _Metallic;

float _FurLength;
fixed _Cutoff;
fixed _CutoffEnd;
fixed _EdgeFade;
fixed4 _Gravity;
fixed _GravityStrength;

void vert(inout appdata_full v){
	fixed3 diretion = lerp(v.normal, _Gravity * _GravityStrength + v.normal * (1 - _GravityStrength), FUR_MULTIPLIER);
	v.vertex.xyz += diretion * _FurLength * FUR_MULTIPLIER * v.color.a;
}

struct Input {    
	float2 uv_MainTex;    
	float3 viewDir; 
};

void surf(Input IN, inout SurfaceOutputStandard o){
	fixed4 c = tex2D(_MainTex, IN.uv_MainTex) * _Color;
	o.Albedo = c.rgb;
	o.Smoothness = _Glossiness;
	o.Alpha = step(lerp(_Cutoff, _CutoffEnd, FUR_MULTIPLIER), c.a);
	float a = 1 - (FUR_MULTIPLIER * FUR_MULTIPLIER);
	a += dot(IN.viewDir, o.Normal) - _EdgeFade;
	o.Alpha *= a;
}
		ENDCG
		

		CGPROGRAM
		#define FUR_MULTIPLIER 0.1
        #pragma surface surf Standard fulldorwardshadows alpha:blend vertex:vert
		#include "FurPass.cginc"
		ENDCG

		CGPROGRAM
		#define FUR_MULTIPLIER 0.2
        #pragma surface surf Standard fulldorwardshadows alpha:blend vertex:vert
		#include "FurPass.cginc"
		ENDCG

		CGPROGRAM
		#define FUR_MULTIPLIER 0.3
        #pragma surface surf Standard fulldorwardshadows alpha:blend vertex:vert
		#include "FurPass.cginc"
		ENDCG

		CGPROGRAM
		#define FUR_MULTIPLIER 0.4
        #pragma surface surf Standard fulldorwardshadows alpha:blend vertex:vert
		#include "FurPass.cginc"
		ENDCG

		CGPROGRAM
		#define FUR_MULTIPLIER 0.5
        #pragma surface surf Standard fulldorwardshadows alpha:blend vertex:vert
		#include "FurPass.cginc"
		ENDCG
    }
    FallBack "Diffuse"
}