shader_type canvas_item;

uniform bool rewinding = false;
uniform float transparency: hint_range(0.1, 0.9) = 0.25;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	vec2 base_uv = UV;
	vec4 base_tex = texture(TEXTURE, base_uv);
	if (rewinding) {
		COLOR = vec4(base_tex.r, base_tex.g, base_tex.b, transparency);
	} else {
		COLOR = base_tex;
	}
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
