Shader "Custom/VertexAnimation" {
	Properties {
		_Color ("Color", Color) = (1,1,1,1)
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
		_ColorA("Color A", Color) = (1,1,1,1)
		_ColorB("Color B", Color) = (1,1,1,1)
		_TintAmm("Tint Amount", Range(0, 1)) = .5
		_Speed("Speed", Range(0.1, 80)) = 5
		_Frequency("Frequency", Range(0, 5)) = 2
		_Amplitude("Amplitude", Range(-1, 1)) = 1
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		#pragma surface surf Lambert vertex:vert 
		#pragma target 3.0

		sampler2D _MainTex;

		struct Input {
			float2 uv_MainTex;
			float3 vertColor;
		};

		fixed4 _Color;
		fixed4 _ColorA;
		fixed4 _ColorB;
		float _TintAmm;
		float _Speed;
		float _Frequency;
		float _Amplitude;
		float _OffsetVal;

		void vert(inout appdata_full v, out Input o){
			float time = _Speed * _Time;
			float wave = sin(time + v.vertex.x * _Frequency) * _Amplitude;
			v.vertex.xyz = float3(v.vertex.x, v.vertex.y + wave, v.vertex.z);
			v.normal = normalize(float3(v.normal.x + wave, v.normal.y, v.normal.z));
			o.vertColor = float3(wave, wave, wave);
			o.uv_MainTex = v.texcoord;
		}

		void surf (Input IN, inout SurfaceOutput o) {
			fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color;
			float3 tintColor = lerp(_ColorA, _ColorB, IN.vertColor).rgb; 
			o.Albedo = c.rgb * tintColor * _TintAmm;
			o.Alpha = c.a;
		}
		ENDCG
	}
	FallBack "Diffuse"
}
