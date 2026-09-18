shader_type canvas_item;

uniform float dissolve_amount : hint_range(0.0, 1.0) = 0.0;

float random(vec2 p) {
	return fract(sin(dot(p, vec2(12.9898, 78.233))) * 43758.5453);
}

void fragment() {
	vec4 tex = texture(TEXTURE, UV);

	float grid_size = 80.0;

	vec2 grid = floor(UV * grid_size);
	float noise = random(grid);

	float dissolve = step(noise, dissolve_amount);

	COLOR = tex;

	if (dissolve > 0.5) {
		COLOR.a = 0.0;
	}
}