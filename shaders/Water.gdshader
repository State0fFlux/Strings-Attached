shader_type canvas_item;

uniform sampler2D noise: repeat_enable;
uniform float speed = 1.0;
uniform float strength = 1.0;

void fragment() {
	vec2 uv1 = vec2(UV.x - speed * TIME, UV.y - speed * TIME);
	vec2 uv2 = vec2(UV.x, UV.y + speed * TIME);
	vec2 uv3 = vec2(UV.x + speed * TIME, UV.y);

	float noise_r = texture(noise, uv1).r;
	float noise_g = texture(noise, uv2).g;
	float noise_b = texture(noise, uv3).b;

	float new_alpha = noise_r * noise_g * noise_b;

	vec3 new_color = vec3(noise_r, noise_g, noise_b);

	COLOR.a = clamp(new_alpha * strength * texture(TEXTURE, UV).a, 0.0, 1.0);
}
