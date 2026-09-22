shader_type canvas_item;

uniform float darkness : hint_range(0.0, 1.0) = 0.7;
uniform float vignette_size : hint_range(0.0, 2.0) = 0.5;
uniform float vignette_smoothness : hint_range(0.0, 2.0) = 0.5;

void fragment() {
    // Distance from the center of the screen (0.5, 0.5)
    float dist = distance(UV, vec2(0.5));

    // Smoothly transition from transparent (center) to dark (edges)
    float vignette = smoothstep(vignette_size, vignette_size + vignette_smoothness, dist);

    // Set the final color (black) with variable alpha based on vignette intensity
    COLOR = vec4(0.0, 0.0, 0.0, vignette * darkness);
}