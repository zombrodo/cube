attribute vec3 VertexNormal;
varying vec3 normal;
varying vec3 fragPosition;

uniform mat4 projectionMatrix;
uniform mat4 modelMatrix;
uniform mat4 viewMatrix;

vec4 position(mat4 transform_projection, vec4 vertex_position)
{
  normal = VertexNormal;
  fragPosition = vec3(modelMatrix * vertex_position);
  return projectionMatrix * viewMatrix * modelMatrix * vertex_position;
}