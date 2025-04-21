#version 450
layout (triangles, equal_spacing, ccw) in;

layout(std140, binding = 0) uniform UniformBufferObject {
    mat4 projectionMatrix;
    mat4 viewMatrix;
    mat4 modelMatrix;

} ubo;



layout (binding = 1) uniform sampler2D textureData; // height map
layout (location = 0) in vec2 uvCoordFromCtrl[];
layout (location = 1) in vec3 normalFromCtrl[];

layout (location = 0) out vec2 uvCoordFromEval;
layout (location = 1) out vec3 normalFromEval;

vec2 interpolateVec2(vec2 v0, vec2 v1, vec2 v2) {
    return gl_TessCoord.x * v0 + gl_TessCoord.y * v1 + gl_TessCoord.z * v2;
}

vec3 interpolateVec3(vec3 v0, vec3 v1, vec3 v2) {
    return  gl_TessCoord.x * v0 + gl_TessCoord.y * v1 + gl_TessCoord.z * v2;
}

vec4 interpolateVec4(vec4 v0, vec4 v1, vec4 v2) {
    return  gl_TessCoord.x * v0 + gl_TessCoord.y * v1 + gl_TessCoord.z * v2;
}

void main() {
   
    uvCoordFromEval = interpolateVec2(uvCoordFromCtrl[0], uvCoordFromCtrl[1], uvCoordFromCtrl[2]);
    normalFromEval =  interpolateVec3(normalFromCtrl[0], normalFromCtrl[1], normalFromCtrl[2]);
    /// Interpolate position across the triangle
    vec4 position = interpolateVec4(gl_in[0].gl_Position, gl_in[1].gl_Position, gl_in[2].gl_Position);
    //vec4 height = vec4(texture(textureData,uvCoordFromEval));
    float height = texture(textureData, uvCoordFromEval).r ;
    position.y += -2.0 * height.r;
    //vec3 displacement =  height * 4.0;
    gl_Position =  ubo.projectionMatrix * ubo.viewMatrix * ubo.modelMatrix * (position ) ;
}
