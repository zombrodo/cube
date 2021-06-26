uniform vec3 lightPosition;

varying vec3 normal;
varying vec3 fragPosition;

vec4 effect(vec4 color, Image tex, vec2 textureCoords, vec2 screenCoords)
{
  vec3 lightColor = vec3(1.0, 1.0, 1.0);

  vec3 norm = normalize(normal);
  vec3 lightDirection = normalize(lightPosition - fragPosition);

  float diff = max(dot(norm, lightDirection), 0.0);
  vec3 diffuse = diff * lightColor;

  float ambientStrength = 0.1;
  vec3 ambient = ambientStrength * lightColor;

  vec4 textureColor = Texel(tex, textureCoords);
  vec4 objectColor = textureColor * color;

  return objectColor * vec4((ambient + diffuse), 1.0);
}