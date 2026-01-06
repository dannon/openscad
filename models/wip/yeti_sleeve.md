# Yeti Kids Bottle Sleeve

Backpack-mountable sleeve for Yeti Kids 12oz water bottles. Drops into a backpack's elastic bottle pocket and hooks over the elastic loop to stay secure.

## Target Bottle

- **Yeti Kids 12oz** (Yeti Rambler Jr)
- Dimensions: 76mm diameter × 213mm tall
- Product page: https://www.yeti.com/drinkware/hydration/kids-bottle-12oz.html

## Design

Cylindrical sleeve with:
- **Flared lip** at top that rests on the elastic loop opening
- **3 hooks** that extend outward then drop down, gripping under the elastic
- **Easy drop-in fit** for the bottle (1.5mm clearance)

```
        ┌─────────────┐
       ╱   ___   ___   ╲     <- Flared lip with hooks
      │   ╱   ╲ ╱   ╲   │    <- Hooks extend out, drop down
      │   ╲___╱ ╲___╱   │    <- Grip under elastic
       ╲               ╱
        │             │
        │   SLEEVE    │      <- Drops into pocket
        │             │
        └─────────────┘
```

## Key Parameters

| Parameter | Default | Description |
|-----------|---------|-------------|
| `bottle_diameter` | 76mm | Yeti kids bottle diameter |
| `sleeve_height` | 115mm | Height of sleeve body (~4.5") |
| `clearance` | 1.5mm | Gap for easy bottle insertion |
| `lip_width` | 10mm | How far lip extends outward |
| `hook_drop` | 12mm | How far hooks hang down |
| `elastic_gap` | 8mm | Opening for elastic thickness |

## Print Settings

- **Orientation:** Upright (hooks at top)
- **Supports:** Yes, needed for hook overhangs
- **Infill:** 15-20% sufficient
- **Walls:** 3 perimeters recommended for durability
- **Layer height:** 0.2mm

## Files

- `yeti_sleeve.scad` - Parametric OpenSCAD source
- `yeti_sleeve.md` - This file
