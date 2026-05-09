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
// heart shape
float2 cellPos = frac(uv * gridSize);
float2 centered = (cellPos - 0.5) * 2.0;
centered /= radius;

float x = centered.x;
float y = -centered.y - 0.3; 

float a = x * x + y * y - 1.0;
float b = x * x * y * y * y;
float heart = a * a * a - b;

return heart <= 0.0 ? 1.0 : 0.0;

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

// Animated movement and color
float result = 0;

for (int i = 0; i < nSides; i++)
{
    for(int j = 0; j < nCopies; j++)
    {
        float angle = (i / nSides) * sin(time * 2) * (3.14 * 2);
        float2 pos = center + (j / nCopies) * radius * float2(cos(1 - angle) - sin(time), 
                                                              sin(1 - angle - sin(time)));
        result += length(pos - uv) < size;
    }
}
outEmissive = result * float3(sin(time), 0, 0.1);
return(result);

//Ray marching

float3 rayOrigin = 1- (viewDir - worldPos);
float3 rayStep = viewDir * -1;

float3 lightDirection = normalize(lightPos);

for(int i = 0; i < 256; i++)
{
    float dist = length(rayOrigin - sphereCenter) - sphereRadius;
    if(dist < 0.01)
    {
        float3 normal = normalize(rayOrigin - sphereCenter);
        float diffuse = max(dot(normal, lightDirection), 0);
        float3 reflection = reflect(lightDirection, normal);
        float3 viewDirection = normalize(-worldPos - rayOrigin);
        float specular = pow(max(dot(reflection, viewDirection), 0), 200);

        return (diffuse * float3(1,0,0)) + (specular * float3(1, 1, 1));
    }

    opacityMask = 1;
    rayOrigin += rayStep;
 }
opacityMask = 0;
return float3(0,0,0);

// Raymarching with Displacement

float3 rayOrigin = 1 - (viewDir - worldPos);
float3 rayStep = viewDir * -1;

float3 lightDirection = normalize(lightPos);

for(int i = 0; i < 256; i++)
{
    float displace = sphereCenter + (sin(rayOrigin.x * sin(time)/3) + 
                                     sin(rayOrigin.y * sin(time)/3) +
                                     sin(rayOrigin.z * sin(time)/3));

    float dist = length(rayOrigin - displace) - sphereRadius;

    if(dist < 0.01)
    {
        float3 normal = normalize(rayOrigin - displace);
        float diffuse = max(dot(normal, lightDirection), 0);
        float3 reflection = reflect(lightDirection, normal);
        float3 viewDirection = normalize(-worldPos - rayOrigin);
        float specular = pow(max(dot(reflection, viewDirection), 0), 200);

        return (diffuse * float3(1,0,0)) + (specular * float3(1, 1, 1));
    }

    opacityMask = 1;
    rayOrigin += rayStep;
 }
opacityMask = 0;
return float3(0,0,0);

// Functions - Need to be placed inside a structure

struct colorOperations
{
    float3 colorChoose(int R, int G, int B) {
        return float3(R, G, B);
    }
};
colorOperations co;

return (co.colorChoose(1, 0, 0));

// Copy of RayMarched material with shape function

float3 rayOrigin = 1 - (viewDir - worldPos);
float3 rayStep = viewDir * -1;

float3 lightDirection = normalize(lightPos);

struct sdfShapes
{
    // Donut shape
    float donut(float3 p, float size, float cutout){
        float2 q = float2(length(p.xz) - size, p.y);
        return length(q) - cutout;
    }
    // Box Shape
    float box(float3 p, float3 size) {
        float3 q = abs(p) - size;
        return length(max(q, 0.0)) + min(max(q.x, max(q.y, q.z)), 0.0);
    }
    // Capsule Shape
    float capsule(float3 p, float3 a, float3 b, float radius) {
        float3 pa = p - a;
        float3 ba = b - a;
        float h = clamp(dot(pa, ba) / dot(ba, ba), 0.0, 1.0);
        return length(pa - ba * h) - radius;
    }
    // Mandelbulb
    float mandelbulb(float3 p, float power) {
        float3 z = p;
        float dr = 1.0;
        float r = 0.0;
        
        for(int i = 0; i < 8; i++) {
            r = length(z);
            if(r > 2.0) break;
            
            // Convert to polar coordinates
            float theta = acos(z.z / r);
            float phi = atan2(z.y, z.x);
            dr = pow(r, power - 1.0) * power * dr + 1.0;
            
            // Scale and rotate the point
            float zr = pow(r, power);
            theta = theta * power;
            phi = phi * power;
            
            // Convert back to cartesian coordinates
            z = zr * float3(sin(theta) * cos(phi), sin(phi) * sin(theta), cos(theta));
            z += p;
        }
        return 0.5 * log(r) * r / dr;
    }

    // MandelBox
    float mandelbox(float3 p, float scale, float minRadius, float fixedRadius) {
        float3 z = p;
        float dr = 1.0;
        float r;
        
        for(int i = 0; i < 12; i++) {
            // Box fold
            z = clamp(z, -1.0, 1.0) * 2.0 - z;
            
            // Sphere fold
            r = dot(z, z);
            float k = max(minRadius / r, 1.0);
            z *= k;
            dr *= k;
            
            // Scale and translate
            z = z * scale + p;
            dr = dr * abs(scale) + 1.0;
        }
        
        return length(z) / abs(dr);
    }

    // julietSet
    float juliaSet(float3 p, float4 c) {
        float4 z = float4(p, 0.0);
        float md2 = 1.0;
        float mz2 = dot(z, z);
        
        for(int i = 0; i < 10; i++) {
            md2 *= 4.0 * mz2;
            
            // Quaternion multiplication
            z = float4(
                z.x * z.x - z.y * z.y - z.z * z.z - z.w * z.w,
                2.0 * z.x * z.y,
                2.0 * z.x * z.z,
                2.0 * z.x * z.w
            ) + c;
            
            mz2 = dot(z, z);
            if(mz2 > 4.0) break;
        }
        
        return 0.25 * sqrt(mz2 / md2) * log(mz2);
    }
};
sdfShapes sdf;

for(int i = 0; i < 256; i++) // default: 256 Complex Shapes: 128 
{


    // float dist = sdf.donut(rayOrigin, 50, 25);
    // float dist = sdf.box(rayOrigin, float3(40, 30, 20));
    // Vertical capsule
    // float dist = sdf.capsule(rayOrigin, float3(0, -30, 0), float3(0, 30, 0), 15);
    // Mandelbulb
    // float dist = sdf.mandelbulb(rayOrigin / 50.0, 8.0) * 50.0; // Scale for visibility
    // MandelBox
    // float dist = sdf.mandelbox(rayOrigin / 80.0, 2.0, 0.5, 1.0) * 80.0;
    // JulietSet
    // Try different c values for different shapes
    float4 c = float4(-0.2, 0.6, 0.2, 0.2);
    float dist = sdf.juliaSet(rayOrigin / 60.0, c) * 60.0;

    if(dist < 0.01)
    {
        float eps = 0.001;

        /*  Donut Normals
        float3 normal = normalize(float3(
            sdf.donut(float3(rayOrigin.x + eps, rayOrigin.y, rayOrigin.z), 50, 25)
                            - sdf.donut(float3(rayOrigin.x - eps, rayOrigin.y, rayOrigin.z), 50, 25),
            sdf.donut(float3(rayOrigin.x, rayOrigin.y + eps, rayOrigin.z), 50, 25)
                            - sdf.donut(float3(rayOrigin.x, rayOrigin.y - eps, rayOrigin.z), 50, 25),
            sdf.donut(float3(rayOrigin.x, rayOrigin.y, rayOrigin.z + eps), 50, 25)
                            - sdf.donut(float3(rayOrigin.x, rayOrigin.y, rayOrigin.z - eps), 50, 25)
        )); */
        
        /* Capsule Normals
        float3 a = float3(0, -30, 0);
        float3 b = float3(0, 30, 0);
        float radius = 15;

        float3 normal = normalize(float3(
            sdf.capsule(float3(rayOrigin.x + eps, rayOrigin.y, rayOrigin.z), a, b, radius)
                - sdf.capsule(float3(rayOrigin.x - eps, rayOrigin.y, rayOrigin.z), a, b, radius),
            sdf.capsule(float3(rayOrigin.x, rayOrigin.y + eps, rayOrigin.z), a, b, radius)
                - sdf.capsule(float3(rayOrigin.x, rayOrigin.y - eps, rayOrigin.z), a, b, radius),
            sdf.capsule(float3(rayOrigin.x, rayOrigin.y, rayOrigin.z + eps), a, b, radius)
                - sdf.capsule(float3(rayOrigin.x, rayOrigin.y, rayOrigin.z - eps), a, b, radius)
        ));
        */

        /* Mandelbulb
        float power = 8.0;
        float scale = 50.0;

        float3 normal = normalize(float3(
            sdf.mandelbulb(float3(rayOrigin.x + eps, rayOrigin.y, rayOrigin.z) / scale, power) * scale
                - sdf.mandelbulb(float3(rayOrigin.x - eps, rayOrigin.y, rayOrigin.z) / scale, power) * scale,
            sdf.mandelbulb(float3(rayOrigin.x, rayOrigin.y + eps, rayOrigin.z) / scale, power) * scale
                - sdf.mandelbulb(float3(rayOrigin.x, rayOrigin.y - eps, rayOrigin.z) / scale, power) * scale,
            sdf.mandelbulb(float3(rayOrigin.x, rayOrigin.y, rayOrigin.z + eps) / scale, power) * scale
                - sdf.mandelbulb(float3(rayOrigin.x, rayOrigin.y, rayOrigin.z - eps) / scale, power) * scale
        ));
        */

        /* MandelBox
        float scale = 2.0;
        float minRadius = 0.5;
        float fixedRadius = 1.0;
        float fractalScale = 80.0;

        float3 normal = normalize(float3(
            sdf.mandelbox(float3(rayOrigin.x + eps, rayOrigin.y, rayOrigin.z) / fractalScale, scale, minRadius, fixedRadius) * fractalScale
                - sdf.mandelbox(float3(rayOrigin.x - eps, rayOrigin.y, rayOrigin.z) / fractalScale, scale, minRadius, fixedRadius) * fractalScale,
            sdf.mandelbox(float3(rayOrigin.x, rayOrigin.y + eps, rayOrigin.z) / fractalScale, scale, minRadius, fixedRadius) * fractalScale
                - sdf.mandelbox(float3(rayOrigin.x, rayOrigin.y - eps, rayOrigin.z) / fractalScale, scale, minRadius, fixedRadius) * fractalScale,
            sdf.mandelbox(float3(rayOrigin.x, rayOrigin.y, rayOrigin.z + eps) / fractalScale, scale, minRadius, fixedRadius) * fractalScale
                - sdf.mandelbox(float3(rayOrigin.x, rayOrigin.y, rayOrigin.z - eps) / fractalScale, scale, minRadius, fixedRadius) * fractalScale
        ));
        */
        float4 c = float4(
            -0.2 + sin(time * 0.3) * 0.2,
            0.6 + cos(time * 0.4) * 0.2,
            0.2,
            0.2
        );      
        float fractalScale = 60.0;

        float3 normal = normalize(float3(
            sdf.juliaSet(float3(rayOrigin.x + eps, rayOrigin.y, rayOrigin.z) / fractalScale, c) * fractalScale
                - sdf.juliaSet(float3(rayOrigin.x - eps, rayOrigin.y, rayOrigin.z) / fractalScale, c) * fractalScale,
            sdf.juliaSet(float3(rayOrigin.x, rayOrigin.y + eps, rayOrigin.z) / fractalScale, c) * fractalScale
                - sdf.juliaSet(float3(rayOrigin.x, rayOrigin.y - eps, rayOrigin.z) / fractalScale, c) * fractalScale,
            sdf.juliaSet(float3(rayOrigin.x, rayOrigin.y, rayOrigin.z + eps) / fractalScale, c) * fractalScale
                - sdf.juliaSet(float3(rayOrigin.x, rayOrigin.y, rayOrigin.z - eps) / fractalScale, c) * fractalScale
        ));
        
        float diffuse = max(dot(normal, lightDirection), 0);
        float3 reflection = reflect(lightDirection, normal);
        float3 viewDirection = normalize(-worldPos - rayOrigin);
        float specular = pow(max(dot(reflection, viewDirection), 0), 16);

        return (diffuse * float3(0,0.6,0.5)) + (specular * float3(1, 1, 1));
    }

    opacityMask = 1;
    rayOrigin += rayStep;
 }
opacityMask = 0;
return float3(0,0,0);