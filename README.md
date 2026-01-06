# OpenSCAD 3D Print Design Workspace

Parametric 3D model designs for the Bambu A1 Mini printer.

## Printer Specs

- **Build volume:** 180mm x 180mm x 180mm
- **Nozzle:** 0.4mm
- **Default layer height:** 0.2mm

## Directory Structure

```
openscad/
├── models/
│   ├── finished/    # Tested, print-ready designs
│   └── wip/         # Work in progress
├── lib/             # Reusable modules (rounded_box, snap_fits, etc.)
├── exports/         # Generated STL files
└── .mcp.json        # OpenSCAD MCP server config
```

## Design Conventions

### Parameters
All designs should be parametric. Define dimensions at the top:

```openscad
// User parameters
width = 50;
depth = 30;
height = 20;

// Print settings (usually don't change)
wall = 2;
$fn = 32;
```

### Wall Thickness
- Default: 2mm walls
- Thin features: 1.2mm minimum (3 perimeters at 0.4mm nozzle)
- Structural: 2.4mm+ (6 perimeters)

### Tolerances
- Friction fit: +0.1mm to +0.15mm
- Loose fit: +0.3mm to +0.4mm
- Snap fits: design with 0.2mm interference

### Print Orientation
Add comments when orientation matters:

```openscad
// PRINT: Flat on bed, no supports needed
// PRINT: Stand upright for strength in Z
```

## Workflow

1. **Design** - Create `.scad` file in `models/wip/`
2. **Preview** - Use MCP server to render and iterate
3. **Export** - Generate STL to `exports/`
4. **Test print** - Verify fit and function
5. **Finalize** - Move to `models/finished/` when proven

## Using the Library

```openscad
use <../lib/rounded_box.scad>
use <../lib/snap_fits.scad>

rounded_box([50, 30, 20], r=3, wall=2);
```

## Common Modules

- `rounded_box.scad` - Boxes with rounded edges
- `snap_fits.scad` - Cantilever snap joints
- `hinges.scad` - Print-in-place hinges
- `standoffs.scad` - PCB/component mounting

## STL Export

Via command line:
```bash
openscad -o exports/model.stl models/wip/model.scad
```

Via MCP server: Use the render tools with output format set to STL.
