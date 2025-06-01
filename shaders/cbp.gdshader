shader_type canvas_item;

// Screen texture sampler (required for Godot 4)
uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;

// Cyberpunk screen filter parameters
uniform float darkness : hint_range(0.0, 1.0) = 0.3;
uniform float scan_line_intensity : hint_range(0.0, 0.5) = 0.15;
uniform float scan_line_frequency : hint_range(10.0, 200.0) = 80.0;
uniform vec3 cyan_tint : source_color = vec3(0.0, 0.8, 1.0);
uniform float tint_strength : hint_range(0.0, 0.3) = 0.1;
uniform float noise_intensity : hint_range(0.0, 0.1) = 0.03;
uniform float vignette_strength : hint_range(0.0, 1.0) = 0.4;

// Random function for noise
float random(vec2 uv) {
    return fract(sin(dot(uv, vec2(12.9898, 78.233))) * 43758.5453);
}

void fragment() {
    // Get the original screen color
    vec4 original_color = texture(SCREEN_TEXTURE, UV);

    // Apply darkness/contrast
    vec3 darkened = original_color.rgb * (1.0 - darkness);

    // Add cyan cyberpunk tint
    vec3 tinted = mix(darkened, cyan_tint, tint_strength);

    // Horizontal scan lines
    float scan_line = sin(UV.y * scan_line_frequency) * scan_line_intensity;

    // Add subtle noise
    float noise = (random(UV + TIME * 0.1) - 0.5) * noise_intensity;

    // Vignette effect (darker edges)
    vec2 center = UV - 0.5;
    float vignette = 1.0 - dot(center, center) * vignette_strength;

    // Combine all effects
    vec3 final_color = (tinted + scan_line + noise) * vignette;

    COLOR = vec4(final_color, 1.0);
}
