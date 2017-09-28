Shader "Custom/VolumetricExplosion" {
	Properties {
		_Color ("Color", Color) = (1,1,1,1)
		_RampTex("Ramp Texture", 2D) = ""{}
		_RampOffset("Ramp Offset", Range(-.5, .5)) = 0

		_NoiseTex("Noise Texture", 2D) = ""{}
		_Period("Period", Range(0, 1)) = 0.5
		_Ammount("Ammount", Range(0, 1)) = .1
		_ClipRange("Clip Range", Range(0, 1)) = 1
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		#pragma surface surf Standard vertex:vert
		#pragma target 3.0

		sampler2D _RampTex;
		sampler2D _NoiseTex;

		struct Input {
			float2 uv_NoiseTex;
		};
		fixed4 _Color;
		float _RampOffset;
		float _Period;
		float _Ammount;
		float _ClipRange;

		void vert(inout appdata_full v){
			float3 displacement = tex2Dlod(_NoiseTex, float4(v.texcoord.xy, 0, 0));
			float time = sin(_Time[3] * _Period + displacement.r * 10);
			v.vertex.xyz += v.normal * displacement.r * time * _Ammount;
		}

		void surf (Input IN, inout SurfaceOutputStandard o) {
			float3 nois = tex2D(_NoiseTex, IN.uv_NoiseTex);
			float n = saturate(nois.r + _RampOffset);
			clip(_ClipRange - n);
			half4 c = tex2D(_RampTex, float2(n,0.5));
			o.Albedo = c.rgb;
			o.Emission = c.rgb * c.a;
		}
		ENDCG
	}
	FallBack "Diffuse"
}
