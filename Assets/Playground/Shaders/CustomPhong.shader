Shader "Custom/CustomPhong" {
	Properties {
		_Color ("Color", Color) = (1,1,1,1)
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
		_SpecPower("Specular Power", Range(0, 30)) = 1
		_SpecularColor("Specular Color", Color) = (1, 1, 1, 1)
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		#pragma surface surf Phong
		#pragma target 3.0

		sampler2D _MainTex;

		struct Input {
			float2 uv_MainTex;
		};

		fixed4 _Color;
		float _SpecPower;
		half4 _SpecularColor;

		fixed4 LightingPhong(SurfaceOutput o, fixed3 lightDir, half3 viewDir, fixed atten){
			float ndotl = dot(o.Normal, lightDir);
			float3 reflectionVec = normalize(2 * o.Normal * ndotl - lightDir);

			float spec = pow(max(0, dot(reflectionVec, viewDir)), _SpecPower) * _SpecularColor;
			fixed4 c;
			c.rgb = o.Albedo * _LightColor0.rgb * max(0, ndotl) + _LightColor0.rgb * spec * atten;
			c.a = o.Alpha;
			return c;
		}

		void surf (Input IN, inout SurfaceOutput o) {
			fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color;
			o.Albedo = c.rgb;
			o.Alpha = c.a;
		}
		ENDCG
	}
	FallBack "Diffuse"
}
