Shader "CustomFX/BlendEffect"
{
	Properties
	{
		[HideInInspector]_MainTex ("Texture", 2D) = "white" {}
        _OtherTex ("Texture", 2D) = "white" {}
		_BlendAmmount("_BlendAmmount", Range(0, 1)) = 0
	}
	SubShader
	{
		Cull Off ZWrite Off ZTest Always

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma fragmentoption ARB_precision_hint_fastest
			
			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				float4 vertex : SV_POSITION;
			};

			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = v.uv;
				return o;
			}
			
			sampler2D _MainTex;
            sampler2D _OtherTex;
			fixed _BlendAmmount;

			fixed4 frag (v2f i) : SV_Target
			{
				fixed4 col = tex2D(_MainTex, i.uv);
				fixed4 other = tex2D(_OtherTex, i.uv);
                fixed4 multiplyed = col * other;
                //fixed4 multiplyed = saturate(col + other);
				return lerp(col, multiplyed, _BlendAmmount);
			}
			ENDCG
		}
	}
}
