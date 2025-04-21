#version 450
#extension GL_ARB_separate_shader_objects : enable

layout(location = 0) in vec4 vVertex;
layout(location = 1) in vec3 vNormal;
layout(location = 2) in vec2 uvCoord;

layout(std140, binding = 0) uniform UniformBufferObject {
    mat4 projectionMatrix;
    mat4 viewMatrix;
    mat4 modelMatrix;
} ubo;

layout(location = 0) out vec2 uvCoordFromVert;
layout(location = 1) out vec3 normalFromVert;
layout(location = 2) out float vertDistance;

void main() {
    uvCoordFromVert = uvCoord;
   vec3 viewPosition = (ubo.viewMatrix * ubo.modelMatrix * vVertex).xyz;
vertDistance = length(viewPosition);
    gl_Position =  vVertex;
}

