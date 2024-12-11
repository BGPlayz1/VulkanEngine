#version 450
layout (triangles, equal_spacing, ccw) in;

// Uniforms wrapped in a uniform block
layout(set = 0, binding = 0) uniform MatrixData {
    mat4 projectionMatrix;
    mat4 viewMatrix;
    mat4 modelMatrix;
};

layout(set = 0, binding = 1) uniform sampler2D textureData; // Sampler with binding

// Input variables (from the tessellation control shader)
layout(location = 0) in vec2 uvCoordFromCtrl[];   // Input UV coordinates
layout(location = 1) in vec3 normalFromCtrl[];     // Input normals

// Output variables (to be passed to the fragment shader)
layout(location = 2) out vec2 uvCoordFromEval;     // Output UV coordinates for tessellation evaluation
layout(location = 3) out vec3 normalFromEval;      // Output normals for tessellation evaluation

// Interpolation functions
vec2 interpolateVec2(vec2 v0, vec2 v1, vec2 v2) {
    return gl_TessCoord.x * v0 + gl_TessCoord.y * v1 + gl_TessCoord.z * v2;
}

vec3 interpolateVec3(vec3 v0, vec3 v1, vec3 v2) {
    return gl_TessCoord.x * v0 + gl_TessCoord.y * v1 + gl_TessCoord.z * v2;
}

vec4 interpolateVec4(vec4 v0, vec4 v1, vec4 v2) {
    return gl_TessCoord.x * v0 + gl_TessCoord.y * v1 + gl_TessCoord.z * v2;
}

void main() {
    // Interpolate data
    uvCoordFromEval = interpolateVec2(uvCoordFromCtrl[0], uvCoordFromCtrl[1], uvCoordFromCtrl[2]);
    normalFromEval = interpolateVec3(normalFromCtrl[0], normalFromCtrl[1], normalFromCtrl[2]);

    // Interpolate position across the triangle
    vec4 position = interpolateVec4(gl_in[0].gl_Position, gl_in[1].gl_Position, gl_in[2].gl_Position);

    // Sample texture for height adjustment
    float height = texture(textureData, uvCoordFromEval).r;

    // Adjust position based on texture height
    position.y += -2.0 * height;

    // Final position transformation
    gl_Position = projectionMatrix * viewMatrix * modelMatrix * position;
}
