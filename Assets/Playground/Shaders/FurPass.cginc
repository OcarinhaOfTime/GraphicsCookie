#pragma target 3.0

fixed4 _Color;
sampler2D _MainTex;
half _Glossiness;
half _Metallic;

float _FurLength;
fixed _Cutoff;
fixed _CutoffEnd;
fixed _EdgeFade;
fixed4 _Gravity;
fixed _GravityStrength;

void vert(inout appdata_full v){
	fixed3 diretion = lerp(v.normal, _Gravity * _GravityStrength + v.normal * (1 - _GravityStrength), FUR_MULTIPLIER);
	v.vertex.xyz += diretion * _FurLength * FUR_MULTIPLIER * v.color.a;
}

struct Input {    
	float2 uv_MainTex;    
	float3 viewDir; 
};

void surf(Input IN, inout SurfaceOutputStandard o){
	fixed4 c = tex2D(_MainTex, IN.uv_MainTex) * _Color;
	o.Albedo = c.rgb;
	o.Smoothness = _Glossiness;
	o.Alpha = step(lerp(_Cutoff, _CutoffEnd, FUR_MULTIPLIER), c.a);
	float a = 1 - (FUR_MULTIPLIER * FUR_MULTIPLIER);
	a += dot(IN.viewDir, o.Normal) - _EdgeFade;
	o.Alpha *= a;
}