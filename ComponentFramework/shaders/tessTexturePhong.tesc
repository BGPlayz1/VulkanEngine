#version 450 
layout(vertices = 3) out; // Specifies that this is a tessellation control shader for triangles

// Input variables (from previous shader stages)
layout(location = 0) in vec2 uvCoordFromVert[];   // Input vertex UV coordinates
layout(location = 1) in vec3 normalFromVert[];     // Input vertex normals
layout(location = 2) in float vertDistance[];      // Input vertex distances

// Output variables (to be passed to tessellation evaluation shader)
layout(location = 3) out vec2 uvCoordFromCtrl[];   // Output UV coordinates for tessellation evaluation
layout(location = 4) out vec3 normalFromCtrl[];    // Output normals for tessellation evaluation

void main() {
    // Pass through input vertices to tessellation evaluation stage
    gl_out[gl_InvocationID].gl_Position = gl_in[gl_InvocationID].gl_Position;
    uvCoordFromCtrl[gl_InvocationID] = uvCoordFromVert[gl_InvocationID];
    normalFromCtrl[gl_InvocationID] = normalFromVert[gl_InvocationID];

    // Tessellation level setting
    float tesslevel = 10.0;

    // Set tessellation levels
    if (gl_InvocationID == 0) {
    //        if(vertDistance[0] < 30.0){
//            tesslevel = 20.0;
//        }else if (vertDistance[0] < 50){
//            tesslevel = 5.0;
//        }else{
//            tesslevel = 1.0;
//        }
        gl_TessLevelInner[0] = tesslevel;
        gl_TessLevelOuter[0] = tesslevel;
        gl_TessLevelOuter[1] = tesslevel;
        gl_TessLevelOuter[2] = tesslevel;
    }
}

