shader_type canvas_item;

uniform float time_remaining: hint_range(0, 60.0) = 60.0;

void fragment() {
    vec2 centered_uv = UV - vec2(0.5);
    float circle = length(centered_uv) * 2.0;
    float arc_width = 0.1;
    
    // Normalize time remaining to 0-1 range
    float normalized_time = time_remaining / 60.0;
    
    // Angle calculation
    float angle = atan(centered_uv.y, centered_uv.x) + 3.14159;
    float full_circle_angle = radians(360.0);
    
    // Base circle outline
    float timer_arc = step(circle, 0.5) - step(circle, 0.5 - arc_width);
    
    // Remaining time arc
    float remaining_arc = step(circle, 0.5) * 
                          step(0.5 - arc_width, circle) * 
                          step(angle, full_circle_angle * normalized_time);
    
    // Color gradient from green to red
    vec3 base_color = mix(vec3(0.8, 0.2, 0.2), vec3(0.2, 0.8, 0.2), normalized_time);
    
    COLOR = vec4(base_color, timer_arc * remaining_arc);
}