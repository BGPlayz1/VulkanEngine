#version 450
#extension GL_ARB_separate_shader_objects : enable

layout(location = 0) in vec2 uvCoordFromEval;
layout(location = 1) in vec3 normalFromEval;

layout(location = 0) out vec4 fragColor;

layout(binding = 0) uniform sampler2D surfaceTextrure;

void main() {
    fragColor = texture(surfaceTextrure, uvCoordFromEval);
    //fragColor = vec4(1.0, 1.0, 1.0, 1.0);
}
