# Unreal-HLSL-Materials
HLSL Shader Studies in Unreal Engine 5

This repository contains a collection of HLSL-based material experiments and tech art studies created in Unreal Engine 5.  
The goal is to explore real-time shader techniques, material authoring, and procedural effects using Unreal’s Custom HLSL nodes.

---

## 📌 Current Study: Animated Mask Material

### 🎥 Preview
![Animated Mask](assets/simpleMask.gif)

---

## 🧠 Overview

This study focuses on a simple animated masking effect driven by UV manipulation and time-based animation.

The goal was to explore:
- Procedural movement using UV space
- Basic masking logic using step functions
- Time-based animation control in HLSL
- How to structure Custom nodes inside Unreal Materials

---

## ⚙️ Technical Breakdown

The effect is built using a custom HLSL node inside a Material in Unreal Engine 5.

### Core Idea
- The UV space is subdivided into a grid
- A moving threshold is applied over time
- The mask is animated across the surface

### Simplified HLSL Logic
```hlsl
return (step((ceil(uv.x * 10) / 10) - (sin(t)), 0.5));