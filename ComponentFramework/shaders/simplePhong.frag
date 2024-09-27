#version 450
#extension GL_ARB_separate_shader_objects : enable
const int MAX_LIGHTS = 3;

layout (location = 0) in vec3 vertNormal;
layout (location = 1) in vec3 lightDir[MAX_LIGHTS];
layout (location = 4) in vec3 eyeDir; 
layout (location = 5) in vec2 fragTexCoords;
layout (location = 6) in vec4 lightDiffuse[MAX_LIGHTS]; // Input for diffuse
layout (location = 9) in vec4 lightSpecular[MAX_LIGHTS]; // Input for specular
layout (location = 12) in vec4 lightAmbient; // Input for ambient

layout (location = 0) out vec4 fragColor;


layout(binding = 2) uniform sampler2D texSampler;

void main() { 
    fragColor = vec4(0.0);  // Initialize fragColor to black (0,0,0,0)
//	vec4 ks = vec4(0.2, 0.2, 0.6, 0.0);
//	vec4 kd = vec4(0.2, 0.2, 0.6, 0.0); 
//	vec4 ka = 0.1 * kd;
vec4 ks[MAX_LIGHTS];
vec4 kd[MAX_LIGHTS];
vec4 ka;
vec4 kt;
// You can use the lightDiffuse, lightSpecular, and lightAmbient here
	ka = lightAmbient;    // Ambient lighting coefficient
	kt = texture(texSampler,fragTexCoords); 
 for (int i = 0; i < MAX_LIGHTS; i++){
	ks[i] = lightSpecular[i];  // Specular lighting coefficient
	kd[i] = lightDiffuse[i];    // Diffuse lighting coefficient

	float diff = max(dot(vertNormal, lightDir[i]), 0.0);

	/// Reflection is based incedent beam of light which means a vector 
	///from the light source not the direction to the light source. 
	///Put a minus sign on light dir to turn it in the opposite direction. 
	vec3 reflection = normalize(reflect(-lightDir[i], vertNormal));

	float spec = max(dot(eyeDir, reflection), 0.0);
	spec = pow(spec,14.0);
	
    fragColor += (diff * kt * (kd[i])) + (spec * ks[i]); 
    }
 fragColor += ka;

} 

