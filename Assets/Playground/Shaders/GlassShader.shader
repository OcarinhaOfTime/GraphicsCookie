Shader "Custom/Glas"
{
	properties{
		_Color("Color", Color) = (1,1,1,1)
		_MainTex("Main Texture", 2D) = ""{}
		_NormalMap("Normal Map", 2D) = ""{}
		_Magnitude("Magnitude", Range(0, 1)) = .1
	}
	SubShader
	{
		GrabPass{}
		Tags {"Queue" = "Transparent" "IgnoreProjector" = "True" "RenderType" = "Transparent"}
		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"

			sampler2D _GrabTexture;

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				float4 grabuv : TEXCOORD1;
				float4 vertex : SV_POSITION;
			};

			half4 _Color;
			sampler2D _MainTex;
			float4 _MainTex_ST;
			sampler2D _NormalMap;
			float _Magnitude;
			
			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.grabuv = ComputeGrabScreenPos(o.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);

				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				half2 bump = UnpackNormal(tex2D(_NormalMap, i.uv)).rg;
				i.grabuv.xy += bump * _Magnitude;
				fixed4 grabtex = tex2Dproj(_GrabTexture, UNITY_PROJ_COORD(i.grabuv));
				fixed4 col = tex2D(_MainTex, i.uv);
				return (col * _Color.a) * _Color + grabtex * (1 - _Color.a); 
			}
			ENDCG
		}
	}
}
