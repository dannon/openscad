# CLAUDE.md - OpenSCAD Project Guidelines

## Project Purpose
3D printable functional designs for a Bambu A1 Mini printer.

## Printer Constraints
- **Build volume:** 180mm × 180mm × 180mm
- **Nozzle:** 0.4mm
- **Layer height:** 0.2mm default

## Design Conventions

### Parametric Style
All designs should be parametric with user-adjustable values at the top:
```openscad
/* [User Parameters] */
width = 50;
height = 30;

/* [Print Settings] */
wall = 2.5;
$fn = 64;
```

### Default Values
- Wall thickness: 2-2.5mm
- Clearance (friction fit): 0.15mm
- Clearance (loose fit): 0.3-0.5mm
- Corner radius: 2-3mm
- $fn for curves: 32-64

### Print Orientation
Add comments when orientation matters:
```openscad
// PRINT: Upright, hooks need supports
// PRINT: Flat on bed, no supports
```

## Project Structure
```
openscad/
├── models/
│   ├── wip/         # Work in progress
│   └── finished/    # Tested, proven designs
├── lib/             # Reusable modules
├── exports/         # Generated STL files (gitignored)
└── .mcp.json        # OpenSCAD MCP server config
```

## Workflow

### Creating New Models
1. Create `.scad` file in `models/wip/`
2. Create matching `.md` README documenting the design
3. Iterate using OpenSCAD GUI or MCP renders
4. Export STL to `exports/` when ready to print
5. Move to `models/finished/` after successful print

### Rendering
```bash
# Preview PNG
openscad -o exports/model.png --autocenter --viewall model.scad

# Export STL
openscad -o exports/model.stl model.scad
```

### Opening GUI (WSL2)
```bash
openscad models/wip/model.scad &
```

## Documentation
Each model should have a companion `.md` file with:
- Purpose and target use case
- Key parameters and what they control
- Print settings (orientation, supports, infill)
- Any measurements taken from real objects

## Library Modules
Reusable modules in `lib/`:
- `rounded_box.scad` - Parametric rounded boxes with optional lids
