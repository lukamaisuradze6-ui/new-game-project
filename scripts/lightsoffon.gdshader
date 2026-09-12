shader_type canvas_item;

uniform float darkness : hint_range(0.0, 1.0) = 0.7;

void fragment() {
    COLOR = vec4(0.0, 0.0, 0.0, darkness);
}