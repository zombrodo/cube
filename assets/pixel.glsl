uniform vec3 lightPosition;
uniform vec3 viewPosition;

varying vec3 normal;
varying vec3 fragPosition;

vec4 effect(vec4 color, Image tex, vec2 textureCoords, vec2 screenCoords)
{
  vec3 norm = normalize(normal);
  vec3 lightColor = vec3(1.0, 1.0, 1.0);
  vec3 lightDirection = normalize(lightPosition - fragPosition);

  float specularStrength = 0.5;
  vec3 viewDirection = normalize(viewPosition - fragPosition);
  vec3 reflectDirection = reflect(-lightDirection, norm);
  float spec = pow(max(dot(viewDirection, reflectDirection), 0.0), 16);
  vec3 specular = specularStrength * spec * lightColor;

  float diff = max(dot(norm, lightDirection), 0.0);
  vec3 diffuse = diff * lightColor;

  float ambientStrength = 0.1;
  vec3 ambient = ambientStrength * lightColor;

  vec4 textureColor = Texel(tex, textureCoords);
  vec4 objectColor = textureColor * color;

  return objectColor * vec4((ambient + diffuse + specular), 1.0);
}