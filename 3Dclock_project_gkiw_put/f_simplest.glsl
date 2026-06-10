#version 330

in vec4 l;
in vec4 l2;
in vec4 n;
in vec4 v;
flat in int iglow;
in vec2 iTexCoord0;
uniform sampler2D textureMap0;

out vec4 pixelColor; //Zmienna wyjsciowa fragment shadera. Zapisuje sie do niej ostateczny (prawie) kolor piksela

float toonise(float x, int levels){
	return floor(x*levels)/levels;
}

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

	float nl_toon = max(0.2,toonise(nls,5));
	float rv_toon = step(0.9,rvs)*0.24;

	vec4 texColor=texture(textureMap0,iTexCoord0);

	vec4 normalColor = texColor * nl_toon + rv_toon;
	vec4 glowColor = texColor + vec4(0.2, 0.2, 0.2, 0.0);

	pixelColor = mix(normalColor, glowColor, float(iglow));
	
}