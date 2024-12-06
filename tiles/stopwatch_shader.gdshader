shader_type canvas_item;

uniform float time_remaining: hint_range(0, 60.0) = 60.0;
uniform float rewind_duration: hint_range(0, 3.0) = 3.0;

void fragment() {
    vec2 centered_uv = UV - vec2(0.5);
    float circle = length(centered_uv) * 2.0;
    float arc_width = 0.1;
    
    // Normalize times
    float normalized_time = time_remaining / 60.0;
    float normalized_rewind = rewind_duration / 60.0;
    
    // Angle calculation
    float angle = atan(centered_uv.y, centered_uv.x) + 3.14159;
    float full_circle_angle = radians(360.0);
    
    // Base circle outline
    float timer_arc = step(circle, 0.5) - step(circle, 0.5 - arc_width);
    
    // Main time remaining arc (green to red)
    float remaining_arc = step(circle, 0.5) * 
                          step(0.5 - arc_width, circle) * 
                          step(angle, full_circle_angle * normalized_time);
    
    // Rewind duration arc (orange, after main timer)
    float rewind_arc = step(circle, 0.5) * 
                       step(0.5 - arc_width, circle) * 
                       step(full_circle_angle * normalized_time, angle) *
                       step(angle, full_circle_angle * (normalized_time + normalized_rewind));
    
    // Color logic
    vec3 main_color = mix(vec3(0.8, 0.2, 0.2), vec3(0.2, 0.8, 0.2), normalized_time);
    vec3 rewind_color = vec3(1.0, 0.5, 0.0);  // Orange
    
    // Combine colors
    vec3 final_color = remaining_arc * main_color + rewind_arc * rewind_color;
    
    COLOR = vec4(final_color, timer_arc * (remaining_arc + rewind_arc));
}