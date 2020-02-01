// All Shadertoy uniforms you use must be defined
// here.
uniform float iGlobalTime;
uniform vec2 iResolution;

uniform float p1;
uniform float p2;
uniform float p3;


void main(void) {
        float a = iTime;
	vec2 uv = (gl_fragCoord.xy-.5*iResolution.xy)/iResolution.y;
	vec2 st = vec2(atan(uv.x,uv.y)+iGlobalTime,length(uv));
    uv = vec2(st.x/6.2831,st.y);
    
    vec3 p = (0.5*cos(iGlobalTime+sin(12.5*uv.y))+0.5*cos(cos(15.*uv.x)))/2.*vec3(1,uv.y,1);
    vec3 r = vec3(cos(a)*p.x - sin(a)*p.x,sin(a)*p.y + cos(a)*p.y,p.z);
    // Output to screen
    gl_fragColor = vec4(p,1.0);
}
