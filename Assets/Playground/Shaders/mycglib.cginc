#ifndef MY_CG_LIB
#define MY_CG_LIB

inline fixed4 LightingHalfLambert(SurfaceOutput s, fixed3 lightDir, fixed atten){
    fixed diff = max(0, dot(s.Normal, lightDir));
    diff = (diff + .5) * .5;
    fixed4 c;
    c.rgb = s.Albedo * _LightColor0.rgb * diff* atten;
    c.a = s.Alpha;
    return c;
}


#endif