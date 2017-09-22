Shader "Custom/Silhoette" {
	Properties {
		_Color ("Color", Color) = (1,1,1,1)
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
        _DotProduct("Rim effect", Range(-1,1)) = 0.25 
	}
	SubShader {
		Tags { "RenderType"="Transparent" "Queue"="Transparent" "IgnoreProjector"="True"}
		LOD 200
		Cull Back
		
		CGPROGRAM
		#pragma surface surf Lambert alpha:fade nolighting

		#pragma target 3.0

		sampler2D _MainTex;
        float _DotProduct;
		fixed4 _Color;

		struct Input {
			float2 uv_MainTex;
            float3 worldNormal;
            float3 viewDir;
		};

		UNITY_INSTANCING_CBUFFER_START(Props)
			// put more per-instance properties here
		UNITY_INSTANCING_CBUFFER_END

		void surf (Input IN, inout SurfaceOutput o) {
			fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color;

            float border = 1 - abs(dot(IN.viewDir, IN.worldNormal));
            float alpha = border * (1 - _DotProduct) + _DotProduct;

			o.Albedo = c.rgb;
			o.Alpha = c.a * alpha;
		}
		ENDCG
	}
	FallBack "Diffuse"
}
