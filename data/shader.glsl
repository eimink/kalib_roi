// All Shadertoy uniforms you use must be defined
// here.
uniform float iGlobalTime;
uniform vec2 iResolution;
uniform vec3 iPots;

float hash21(vec2 co)
{
 	return fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453);
}

float star(vec2 uv, vec2 p, float rot, float size)
{
    uv-=p;
    float x = uv.x;
    float y = uv.y;
    uv.x = sin(1.0-iPots.x)*x + cos(1.0-iPots.y)*y;
    uv.y = cos(1.0-iPots.z)*x - sin(1.0-iPots.z)*y;
    uv+=p;
    
    float lm = 1.0-min(abs(uv.x- p.x), abs(uv.y-p.y));
    
    float ld = 1.-length(uv - p);
    ld = max(0., ld);
    lm = max(0., lm);
    ld = pow(ld, 2.5);
    lm = pow(lm, 20.)*ld;
    
    return max(0., (lm+ld)*size);
}

vec3 sc(vec2 uv, vec2 off, vec2 gx)
{
    vec2 gxy =gx+off;
    float h = hash21(gxy);
    vec2 puv = uv-off;
  return star(puv, vec2(h, fract(h*10.))*0.5+0.5, gxy.x+iGlobalTime*0.5, pow(fract(h*100.),3.)) * vec3(h, fract(10.*h),h*.4);
   
}

void main()
{
    // Normalized pixel coordinates (from 0 to 1)
    vec2 uv = gl_FragCoord.xy/iResolution.xy;
    uv.y/= iResolution.x/iResolution.y;
	
    uv*=5.;
    uv.y+=iGlobalTime*0.8;
    vec3 col = vec3(0.);

    vec2 guv = fract(uv);
    vec2 gx = floor(uv);
    
    col += sc(guv, vec2(-1, -1), gx);
    col += sc(guv, vec2(0, -1), gx);
    col += sc(guv, vec2(1, -1), gx);
    col += sc(guv, vec2(-1, 0), gx);
    col += sc(guv, vec2(0, 0), gx);
    col += sc(guv, vec2(1, 0), gx);
/*    col += sc(guv, vec2(-1, 1), gx);
    col += sc(guv, vec2(0, 1), gx);
    col += sc(guv, vec2(1, 1), gx);*/

    float h = hash21(gx);
    //col += star(guv, vec2(h, h), 0.5);
    
    //if(guv.x < 0.01 || guv.y < 0.01)
      //  col.r = 1.;
    
    // Output to screen
    gl_FragColor = vec4(col,1.0);
}
