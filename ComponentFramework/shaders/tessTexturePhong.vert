#version 450
#extension GL_ARB_separate_shader_objects : enable

// Input attributes
layout(location = 0) in vec4 vVertex;
layout(location = 1) in vec3 vNormal;
layout(location = 2) in vec2 uvCoord;

// Uniform block for transformation matrices
layout(binding = 0) uniform Matrices {
    mat4 projectionMatrix;
    mat4 viewMatrix;
    mat4 modelMatrix;
};

// Outputs to the next stage
layout(location = 0) out vec2 uvCoordFromVert;
layout(location = 1) out vec3 normalFromVert;
layout(location = 2) out float vertDistance;

void main() {
    uvCoordFromVert = uvCoord;
    normalFromVert = mat3(modelMatrix) * vNormal; // Transform the normal
    vertDistance = length(viewMatrix * modelMatrix * vVertex);
    gl_Position = projectionMatrix * viewMatrix * modelMatrix * vVertex;
}
