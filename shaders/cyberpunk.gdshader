shader_type canvas_item;

uniform float scan_line_intensity : hint_range(0.0, 1.0) = 0.3;
uniform float scan_line_frequency : hint_range(1.0, 100.0) = 50.0;
uniform vec3 color_tint : source_color = vec3(0.0, 1.0, 1.0);
uniform float tint_strength : hint_range(0.0, 1.0) = 0.2;
uniform float noise_intensity : hint_range(0.0, 1.0) = 0.1;

float random(vec2 uv) {
    return fract(sin(dot(uv, vec2(12.9898, 78.233))) * 43758.5453);
}

void fragment() {
    vec4 original_color = texture(TEXTURE, UV);
    
    // Scan lines
    float scan_line = sin(UV.y * scan_line_frequency) * scan_line_intensity;
    
    // Color tinting
    vec3 tinted = mix(original_color.rgb, color_tint, tint_strength);
    
    // Add some noise
    float noise = random(UV + TIME * 0.1) * noise_intensity;
    
    // Combine effects
    COLOR = vec4(tinted + scan_line + noise, original_color.a);
}
