Shader "Custom/BlinnPhong" {
	Properties {
		_Color ("Color", Color) = (1,1,1,1)
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
		_SpecPower("Specular Power", Range(0, 30)) = 1
		_SpecularColor("Specular Color", Color) = (1, 1, 1, 1)
        _Roughness ("Surface Roughness", Float) = 1
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		#pragma surface surf OrenNayar
		#pragma target 3.0

		sampler2D _MainTex;

		struct Input {
			float2 uv_MainTex;
		};

		fixed4 _Color;
		float _SpecPower;
		half4 _SpecularColor;
        const float pi = 3.14159265358979323846264338327;
		float _Roughness;

		fixed4 LightingOrenNayar(SurfaceOutput o, fixed3 lightDir, half3 viewDir, fixed atten){
			float ndotl = max(0, dot(o.Normal, lightDir));
			half r2 = pow(_Roughness, 2);
			half a = 1 - .5 * (r2 / (r2 - 0.33));
			half b = 0.45 * (r2 / (r2 + 0.09));
			
            half3 lr = (o.Albedo / pi) * cos(ndotl);
			half4 c = (1,1,1,1);
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
