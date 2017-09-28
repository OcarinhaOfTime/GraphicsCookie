Shader "Custom/SnowFX" {
	Properties {
		_Color ("Color", Color) = (1,1,1,1)
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
		_Snow("Level of snow", Range(1, -1)) = 1 
		_SnowColor("Color of snow", Color) = (1.0,1.0,1.0,1.0) 
		_SnowDirection("Direction of snow", Vector) = (0,1,0) 
		_SnowDepth("Depth of snow", Range(0,1)) = 0
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		#pragma surface surf Standard vertex:vert
		#pragma target 3.0

		sampler2D _MainTex;

		struct Input {
			float2 uv_MainTex;
			float3 worldNormal;
			INTERNAL_DATA
		};

		fixed4 _Color;
		float _Snow;
		fixed4 _SnowColor;
		fixed3 _SnowDirection;
		float _SnowDepth;

		void vert(inout appdata_full v){
			float4 sn = mul(UNITY_MATRIX_IT_MV, _SnowDirection);
			if(dot(v.normal, sn.xyz) > _Snow){
				v.vertex.xyz += (sn.xyz + v.normal) * _SnowDepth * _Snow; 
			}
		}

		void surf (Input IN, inout SurfaceOutputStandard o) {
			fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color;

			if(dot(WorldNormalVector(IN, o.Normal), _SnowDirection) >= _Snow){
				o.Albedo = _SnowColor;
			}
			else{
				o.Albedo = c.rgb;
			}
			
			o.Alpha = c.a;
		}
		ENDCG
	}
	FallBack "Diffuse"
}
