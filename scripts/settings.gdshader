shader_type canvas_item;
uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;
uniform float curvature : hint_range(0.0, 1.0) = 0.03;
uniform float scanline_count : hint_range(10.0, 1080.0) = 450.0;
uniform float scanline_opacity : hint_range(0.0, 1.0) = 0.03;
uniform float scanline_speed : hint_range(0.0, 10.0) = 0.3;
uniform float pixel_bleed : hint_range(0.0, 0.05) = 0.001;
uniform float vignette_intensity : hint_range(0.0, 2.0) = 0.02;
uniform float brightness_boost : hint_range(1.0, 5.0) = 4.5;

vec2 distort_uv(vec2 uv) {
    vec2 delta = uv - 0.5;
    float delta2 = dot(delta, delta);
    float delta4 = delta2 * delta2;
    float delta_offset = delta2 * curvature + delta4 * curvature * 0.5;
    return 0.5 + delta * (1.0 + delta_offset);
}

void fragment() {
    vec2 curved_uv = distort_uv(SCREEN_UV);

    if (curved_uv.x < 0.0 || curved_uv.x > 1.0 || curved_uv.y < 0.0 || curved_uv.y > 1.0) {
        COLOR = vec4(0.0, 0.0, 0.0, 1.0);
    } else {
        float r = texture(screen_texture, vec2(curved_uv.x - pixel_bleed, curved_uv.y)).r;
        float g = texture(screen_texture, curved_uv).g;
        float b = texture(screen_texture, vec2(curved_uv.x + pixel_bleed, curved_uv.y)).b;
        vec3 base_color = vec3(r, g, b);

        base_color *= brightness_boost;

        float scanline_pattern = sin((curved_uv.y * scanline_count) + TIME * scanline_speed);
        float scanline_factor = mix(1.0, (scanline_pattern + 1.0) * 0.5, scanline_opacity);
        base_color *= scanline_factor;

        vec2 vignette_uv = curved_uv * (1.0 - curved_uv.yx);
        float vignette = vignette_uv.x * vignette_uv.y * 50.0;
        vignette = clamp(pow(vignette, vignette_intensity), 0.0, 1.0);
        base_color *= vignette;

        COLOR = vec4(base_color, 1.0);
    }
}