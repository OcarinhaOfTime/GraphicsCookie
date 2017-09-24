Shader "Custom/AnisotropicSpecular" {
	Properties {
		_Color ("Color", Color) = (1,1,1,1)
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
		_SpecularAmmount("Specular Ammount", Range(0, 1)) = .5
		_SpecularPower("Specular Power", Range(0, 1)) = .5
		_SpecularColor("Specular Color", Color) = (1, 1, 1, 1)
		_AnisoDir("Aniso Direction", 2D) = "" {}
		_AnisoOffset("Aniso Offset", Range(-1, 1)) = 0
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		#pragma surface surf Anisotropic
		#pragma target 3.0

		sampler2D _MainTex;

		struct Input {
			float2 uv_MainTex;
			float2 uv_AnisoDir;
		};

		struct SurfaceAnisoOutput{
			fixed3 Albedo;
			fixed3 Normal;
			fixed3 Emission;
			fixed3 AnisoDirection;
			half Specular;
			fixed Gloss;
			fixed Alpha;
		};

		fixed4 _Color;
		float _SpecularAmmount;
		float _SpecularPower;
		fixed4 _SpecularColor;
		sampler2D _AnisoDir;
		float _AnisoOffset;

		fixed4 LightingAnisotropic(SurfaceAnisoOutput s, fixed3 lightDir, fixed3 viewDir, fixed atten){
			fixed3 halfVec = normalize(lightDir + viewDir);
			float ndotl = saturate(dot(s.Normal, lightDir));
			fixed3 halfNormAni = normalize(s.Normal + s.AnisoDirection);
			fixed hdota = dot(halfNormAni, halfVec);
			float aniso = max(0, sin(radians((hdota + _AnisoOffset) * 180)));
			float spec = saturate(pow(aniso, s.Gloss * 128) * s.Specular);

			fixed4 c;
			c.rgb = ((s.Albedo * _LightColor0.rgb * ndotl) + (_LightColor0.rgb * _SpecularColor.rgb * spec)) * atten;
			c.a = s.Alpha;
			return c;
		}

		void surf (Input IN, inout SurfaceAnisoOutput o) {
			fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color;
			float3 anisoTex = UnpackNormal(tex2D(_AnisoDir, IN.uv_AnisoDir));

			o.AnisoDirection = anisoTex;
			o.Specular = _SpecularAmmount;
			o.Gloss = _SpecularPower;
			o.Albedo = c.rgb;
			o.Alpha = c.a;
		}
		ENDCG
	}
	FallBack "Diffuse"
}
