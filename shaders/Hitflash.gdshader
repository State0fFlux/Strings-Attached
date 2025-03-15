shader_type canvas_item;

uniform vec4 flash_color : source_color;
uniform float strength: hint_range(0.0, 1.0) = 0.0;

void fragment() {
    vec4 texture_color = texture(TEXTURE, UV);
	vec4 final_color = mix(texture_color, flash_color, strength);
	final_color.a = texture_color.a;
    COLOR = final_color;
}