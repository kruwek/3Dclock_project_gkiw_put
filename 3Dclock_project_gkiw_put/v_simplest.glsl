#version 330

//Zmienne jednorodne
uniform mat4 P;
uniform mat4 V;
uniform mat4 M;
uniform vec4 col;
uniform vec4 lp;
uniform int glow;


//Atrybuty
in vec4 vertex; //wspolrzedne wierzcholka w przestrzeni modelu
in vec4 normal;

out vec4 ic;
out vec4 l;
out vec4 l2;
out vec4 n;
out vec4 v;
flat out int iglow;

void main(void) {
    //light inside moon
    vec4 lp2 = M*vec4(0,4,0,1); //modelu

    l = normalize(V*(lp-M*vertex)); //oka
    l2 = normalize(V*(lp2-M*vertex)); //oka
    n = normalize(V*M*normal); //oka
    v = normalize(vec4(0,0,0,1) - V*M*vertex); //oka

    gl_Position=P*V*M*vertex;
    ic = col;
    iglow = glow;
}
