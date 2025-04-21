#version 450
#extension GL_ARB_separate_shader_objects : enable
layout (location = 0) in vec2 uvCoordFromEval;
layout (location = 1) in vec3 normalFromEval;
layout (location = 0) out vec4 fragColor;
layout (binding = 2) uniform sampler2D surfaceTexture;//diffuse
layout (binding = 3) uniform sampler2D normalTexture;//normal


void main() {
    // Sample the diffuse texture
    vec4 diffuseColor = texture(surfaceTexture, uvCoordFromEval);

    // Sample the normal map texture
    vec3 normalColor = texture(normalTexture, uvCoordFromEval).rgb;

    // Convert normal map values from [0,1] to [-1,1]
    vec3 mappedNormal = normalize(normalColor * 2.0 - 1.0);

    // Simulate simple diffuse lighting (example)
    vec3 lightDir = normalize(vec3(0.0, -5.0, 3.0)); // Direction of light
    float lighting = max(dot(mappedNormal, lightDir), 0.0);

    // Combine diffuse texture with lighting
    vec3 finalColor = diffuseColor.rgb * lighting;

    // Output the final color
    fragColor = vec4(finalColor, diffuseColor.a);
    
}