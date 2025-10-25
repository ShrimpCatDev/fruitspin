//palette/lut.glsl

// Credits: https://lettier.github.io/3d-game-shaders-for-beginners/lookup-table.html
uniform Image lut;

vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords)
{
  vec3 pixel = Texel(texture, texture_coords).rgb;

  float u  =  floor(pixel.b * 15.0) / 15.0 * 240.0;
        u  = (floor(pixel.r * 15.0) / 15.0 *  15.0) + u;
        u /= 255.0;
  float v  = floor(pixel.g * 15.0) / 15.0;

  return vec4(Texel(lut, vec2(u, v)).rgb, 1.0);
}