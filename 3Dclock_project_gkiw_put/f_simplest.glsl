#version 330

in vec4 ic;
in vec4 l;
in vec4 l2;
in vec4 n;
in vec4 v;
flat in int iglow;
in vec2 iTexCoord0;
uniform sampler2D textureMap0;

out vec4 pixelColor; //Zmienna wyjsciowa fragment shadera. Zapisuje sie do niej ostateczny (prawie) kolor piksela

void main(void) {
	
	vec4 ml = normalize(l);
	vec4 ml2 = normalize(l2);
	vec4 mn = normalize(n);
	vec4 mv=normalize(v);

	vec4 r = reflect(-ml,mn); //oka
	vec4 r2 = reflect(-ml2,mn); //oka

	float nl=clamp(dot(mn,ml),0,1);
    float rv=pow(clamp(dot(r,mv),0,1),25);
	
	float nl2=clamp(dot(mn,ml2),0,1);
	float rv2=pow(clamp(dot(r2,mv),0,1),25);

	float nls = nl+nl2;
	float rvs = rv+rv2;

	float nlq = max(0.2,floor((nls)*4)/4);
	float rvq = step(0.4,rvs);

	vec4 texColor=texture(textureMap0,iTexCoord0);

	vec4 g = vec4(0,0,0,0);
	if (iglow==1) {pixelColor = texColor+vec4(0.2,0.2,0.2,0);}
	else {pixelColor=texColor*nlq+rvq+g;}
	
}