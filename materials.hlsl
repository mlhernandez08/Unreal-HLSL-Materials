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

// Tiling Shapes

// simple circle 
float d = length(pos - uv);
return d;
// sharp circle
float d = length(pos - uv);
return d <= 0.5;
// tiling circle
float d = length(pos - (frac(uv * gridSize)));
return d <= radius;
// diamond shape
float2 p = abs(pos - frac(uv * gridSize));
float d = p.x + p.y;
return d <= radius;
// ring
float d = abs(length(pos - frac(uv * gridSize)) - radius * 0.7);
return d <= radius * 0.3;
// gear
float2 p = pos - frac(uv * gridSize);
float a = atan2(p.y, p.x);
float teeth = 8.0;
float d = length(p) - radius * (0.8 + 0.2 * step(0.5, frac(a * teeth / 6.28318)));
return d <= 0;
// spiral
float2 p = pos - frac(uv * gridSize);
float a = atan2(p.y, p.x);
float r = length(p);
float spiral = frac(a / 6.28318 + r * 2.0);
return spiral > 0.5 && r <= radius;
// flower petals
float2 p = pos - frac(uv * gridSize);
float a = atan2(p.y, p.x);
float petals = 5.0;
float r = length(p);
float petal = 0.5 + 0.5 * cos(a * petals);
return r <= radius * petal;

// Tiling/Brick Generator

// Simple tiling material  
float2 tex = frac(float2(uv.x * grid.x + offset.x, uv.y * grid.y + offset.y));
if(tex.x >= dim.x || tex.x <= -dim.x || 
  tex.y >= dim.y || tex.y <= -dim.y) 
  return(colMotar);
return (colBrick);

// Randomizing per tile between color range using hashing
// Calculate which brick we're on (brick ID)
float2 brickID = floor(uv * grid + float2(offset.x, offset.y));

float2 hashSeed = float2(10, 75);
float hashMultiplier = 1000;

// Exposed hash seeds for control
float hash = frac(sin(dot(brickID, hashSeed)) * hashMultiplier);

// Get UV within current brick
float2 tex = frac(float2(uv.x * grid.x + offset.x, uv.y * grid.y + offset.y));

// Check if we're in mortar
if(tex.x >= dim.x || tex.x <= -dim.x || 
   tex.y >= dim.y || tex.y <= -dim.y) 
   return colMotar;

// Return brick color with variation
return lerp(colBrick, colBrick2, hash * variationStrength);

// For loops

float result = 0;

for (int i = 0; i < nSides; i++)
{
    for(int j = 0; j < nCopies; j++)
    {
        float angle = (i / nSides) * (time) * 3.14;
        float2 pos = center + (j / nCopies) * radius * float2(cos(1 - angle), sin(3 * angle));
        result += length(pos - uv) < size; // Draw Circle
    }
}
return(result);