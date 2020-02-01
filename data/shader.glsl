// All Shadertoy uniforms you use must be defined
// here.
uniform float iGlobalTime;
uniform vec2 iResolution;

uniform vec3 iMouse;

float hash21(vec2 co)
{
 	return fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453);
}

float star(vec2 uv, vec2 p, float rot, float size)
{
    uv-=p;
    float x = uv.x;
    float y = uv.y;
    uv.x = sin(rot)*x + cos(rot)*y;
    uv.y = cos(rot)*x - sin(rot)*y;
    uv+=p;
    
    float lm = 1.0-min(abs(uv.x- p.x), abs(uv.y-p.y));
    
    float ld = 1.-length(uv - p);
    ld = max(0., ld);
    lm = max(0., lm);
    ld = pow(ld, 2.5);
    lm = pow(lm, 20.)*ld;
    
    return max(0., (lm+ld)*size);
}

void mainImage()
{
    // Normalized pixel coordinates (from 0 to 1)
    vec2 uv = gl_FragCoord/iResolution.xy;
    uv.y/= iResolution.x/iResolution.y;
	
    uv*=10.;
    uv.y+=iTime*0.8;
    vec3 col = vec3(0.);

    vec2 guv = fract(uv);
    vec2 gx = floor(uv);
    
    for( int i = -1; i < 3; i++)
    {
     for(int j = -1; j < 3; j++)
     {
        vec2 off = vec2(i,j);
        vec2 gxy =gx+off;
        
        float h = hash21(gxy);
        
        vec2 puv = guv-off;
    	col += star(puv, vec2(h, fract(h*10.))*0.5+0.5, gxy.x+iGlobalTime*0.5, pow(fract(h*100.),3.)) * vec3(h, fract(10.*h),h*.4);
    	
     }
    }
    float h = hash21(gx);
    //col += star(guv, vec2(h, h), 0.5);
    
    //if(guv.x < 0.01 || guv.y < 0.01)
      //  col.r = 1.;
    
    // Output to screen
    gl_FragColor = vec4(col,1.0);
}
