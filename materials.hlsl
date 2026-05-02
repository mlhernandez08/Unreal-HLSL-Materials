// Simple Animated Mask
// Horizontal
return (step((ceil(uv.x * 10) / 10) - (sin(t)), 0.5));
// Veritcal
return (step((ceil(uv.y * 10) / 10) - (sin(t)), 0.5));
// Diagonal
float angle = radians(45.0);
float2 dir = float2(cos(angle), sin(angle));
float v = dot(uv, dir);
return step((ceil(v * 10) / 10) - sin(t), 0.5);
