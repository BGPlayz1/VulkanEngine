#version 450
#extension GL_ARB_separate_shader_objects : enable
const int MAX_LIGHTS = 3;

layout (location = 0) in  vec4 vVertex;
layout (location = 1) in  vec4 vNormal;
layout (location = 2) in  vec2 texCoords;

layout(std140,binding = 0) uniform UniformBufferObject {
    mat4 projectionMatrix;
    mat4 viewMatrix;
    mat4 modelMatrix;
} ubo;

layout(std140,binding = 1) uniform LightBufferObject {
	vec4 lightPos[MAX_LIGHTS];
	vec4 diffuse[MAX_LIGHTS];
    vec4 specular[MAX_LIGHTS];
    vec4 ambient;
} lbo;

layout(push_constant) uniform Push{
mat4 modelMatrix;
mat4 normalMatrix;
//mat3x4 normalMatrix;
} push;

layout (location = 0) out vec3 vertNormal;
layout (location = 1) out vec3 lightDir[MAX_LIGHTS];
layout (location = 4) out vec3 eyeDir;
layout (location = 5) out vec2 fragTexCoords;
layout (location = 6) out vec4 lightDiffuse[MAX_LIGHTS]; // New output for diffuse
layout (location = 9) out vec4 lightSpecular[MAX_LIGHTS]; // New output for specular
layout (location = 12) out vec4 lightAmbient; // New output for ambient



void main() {
	fragTexCoords = texCoords;
	/// We must fix this, just load the normalMatrix in to the UBO
//	mat3 normalMatrix = mat3(transpose(inverse(ubo.modelMatrix)));
	mat3 normalMatrix = mat3(push.normalMatrix);
	vertNormal = normalize(normalMatrix * vNormal.xyz); /// Rotate the normal to the correct orientation 
	vec3 vertPos = vec3(ubo.viewMatrix * push.modelMatrix * vVertex); /// This is the position of the vertex from the origin
	vec3 vertDir = normalize(vertPos);
	eyeDir = -vertDir;

	//multiple lights
	 for (int i = 0; i < 3; i++){

	lightDir[i] = normalize(vec3(lbo.lightPos[i]) - vertPos); /// Create the light direction.
	lightDiffuse[i] = lbo.diffuse[i];
	lightSpecular[i] = lbo.specular[i];	
	 }
	lightAmbient = lbo.ambient;

	// Pass the light properties to the fragment shader
	
	gl_Position =  ubo.projectionMatrix * ubo.viewMatrix * push.modelMatrix * vVertex; 
}
