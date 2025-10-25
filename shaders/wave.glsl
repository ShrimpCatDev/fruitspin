extern float time;
extern float freq;
extern float amp;
extern float speed;

vec4 effect(vec4 color, Image texture,vec2 tCoords,vec2 sCoords){
    //vec4 pixel=Texel(texture,tCoords);
    float waveX = sin((tCoords.y*freq)+(time*speed))*amp;

    vec2 dist = vec2(tCoords.x+waveX,tCoords.y);

    return Texel(texture,dist)*vec4(0.2,0.8,1,1);
}