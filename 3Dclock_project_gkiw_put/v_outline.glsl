#version 330

//Zmienne jednorodne
uniform mat4 P;
uniform mat4 V;
uniform mat4 M;
uniform float thickness = 0.05;


//Atrybuty
in vec4 vertex; //wspolrzedne wierzcholka w przestrzeni modelu
in vec4 normal;

void main(void) {
    vec3 pos = vertex.xyz + (normal.xyz * thickness);
    vec4 VMv = V*M*vec4(pos,1.0);
    gl_Position=P*vec4(VMv.xy, (V*M*vertex).z,1.0);
    //gl_Position=P*V*M*vec4(pos, 1);
}
