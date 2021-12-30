shader_type canvas_item;
render_mode unshaded, blend_disabled;

uniform float angle = 1.0;
uniform float speed = 1.0;
uniform float scale = 1.0;

vec2 rotateUV(vec2 uv, vec2 pivot, float rotation) {
	vec2 res;
    float sine = sin(rotation);
    float cosine = cos(rotation);

    uv -= pivot;
    res.x = uv.x * cosine - uv.y * sine;
    res.y = uv.x * sine + uv.y * cosine;
    res += pivot;

    return res;
}

void vertex() {
	UV = (UV - 0.5) * scale + 0.5;
    VERTEX = rotateUV(VERTEX, 0.0/TEXTURE_PIXEL_SIZE, sin(TIME*speed) * angle);
}