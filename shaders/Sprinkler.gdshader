shader_type canvas_item;

uniform sampler2D noise : repeat_enable;
uniform vec2 scroll = vec2(0, 1);

void fragment() {
	vec4 noise_col = texture(noise, UV + scroll * TIME);
		
	COLOR = noise_col;
	COLOR.a = (COLOR.r + COLOR.g + COLOR.b)/3.0;
}