shader_type spatial;

uniform vec4 red: hint_color;
uniform vec4 blk: hint_color;
uniform sampler2D noise;
uniform float noise_fac;
uniform float threshold;

void fragment() {
	float level = (texture(noise, SCREEN_UV * vec2(4.0/3.0, 1)).r * noise_fac) + SCREEN_UV.y;
	if (level > threshold) {
		ALBEDO = red.rgb;
	} else {
		ALBEDO = blk.rgb;
	}
}