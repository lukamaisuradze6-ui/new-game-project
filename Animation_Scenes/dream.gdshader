shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;

uniform float crt_curve : hint_range(0.0, 1.0) = 0.05;
uniform float vignette_amount : hint_range(0.0, 1.0) = 0.3;
uniform float abberation_amount : hint_range(0.0, 0.1) = 0.01;

uniform float darkness_amount : hint_range(0.0, 1.0) = 0.30; 

vec2 curve_lens(vec2 uv) {
    uv = uv * 2.0 - 1.0;
    vec2 offset = abs(uv.yx) / vec2(2.0, 2.0);
    uv = uv + uv * offset * offset * crt_curve;
    uv = uv * 0.5 + 0.5;
    return uv;
}

void fragment() {
    vec2 curved_uv = curve_lens(UV);
    
    if (curved_uv.x < 0.0 || curved_uv.x > 1.0 || curved_uv.y < 0.0 || curved_uv.y > 1.0) {
        COLOR = vec4(0.0, 0.0, 0.0, 1.0);
    } else {
        float r = texture(SCREEN_TEXTURE, curved_uv - vec2(abberation_amount, 0.0)).r;
        float g = texture(SCREEN_TEXTURE, curved_uv).g;
        float b = texture(SCREEN_TEXTURE, curved_uv + vec2(abberation_amount, 0.0)).b;
        
        vec3 color = vec3(r, g, b);
        
        vec2 uv_vig = UV * (1.0 - UV.yx);
        float vig = uv_vig.x * uv_vig.y * 15.0;
        vig = clamp(pow(vig, vignette_amount), 0.0, 1.0);
        color *= vig;
        
        color *= (1.0 - darkness_amount);
        
        COLOR = vec4(color, 1.0);
    }
}
