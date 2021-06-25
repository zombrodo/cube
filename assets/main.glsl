uniform mat4 projectionMatrix;
uniform mat4 modelMatrix;
uniform mat4 viewMatrix;

vec4 position(mat4 transform_projection, vec4 vertex_position)
{
  return projectionMatrix * viewMatrix * modelMatrix * vertex_position;
}