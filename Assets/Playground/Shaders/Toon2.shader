Shader "Custom/Toon2" {
	Properties {
		_Color ("Color", Color) = (1,1,1,1)
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
		_RampMap ("Ramp Map", 2D) = "white" {}
		_CellShadingLevels("_CellShadingLevels", Range(1, 5)) = 1
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		#pragma surface surf Toon 

		#pragma target 3.0

		sampler2D _MainTex;
		sampler2D _RampMap;

		struct Input {
			float2 uv_MainTex;
		};

		fixed4 _Color;
		float _CellShadingLevels;

		half4 LightingToon (SurfaceOutput s, half3 lightDir, half atten){
			half ndotl = dot(s.Normal, lightDir);
			ndotl = tex2D(_RampMap, fixed2(ndotl, 0.5));

			half cel = floor(ndotl * _CellShadingLevels ) / (_CellShadingLevels - .5f);

			half4 c;
			c.rgb = s.Albedo * _LightColor0.rgb * cel * atten;
			c.a = s.Alpha;

			return c;
		}

		void surf (Input IN, inout SurfaceOutput o) {
			fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color;
			
			o.Albedo = c.rgb;
		}
		ENDCG
	}
	FallBack "Diffuse"
}
