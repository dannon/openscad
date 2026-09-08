# Open-Air Pruning Bonsai Pot

A small rectangular training pot in the style of an Air-Pot / Rootmaker container:
the walls are covered in outward cones with an air hole bored through each tip, so
roots that run out to the wall hit dry air and stop instead of circling. A drip tray
slides out of the front of the base.

Sized for a shohin-to-small-chuhin tree -- roughly the maple in the reference photo.

## Dimensions

| | |
|---|---|
| Outer footprint | 150 x 110 mm (162 x 122 including the cones) |
| Overall height | 85 mm |
| Soil depth | 65 mm, approx. 1050 ml |
| Tray | 76 x 100 x 14 mm, approx. 70 ml to a 10 mm fill |

Everything is driven from the parameter block at the top of the `.scad`. The two
values worth understanding before you change anything:

- **`tray_w`** sets the width of the drawer channel, and the channel ceiling is the
  one unsupported bridge in the whole print. At the default 76 mm the bridge is 77 mm,
  which an A1 Mini handles with full fan. Push much past 85 mm and it will sag into
  the tray.
- **`floor_slope`** raises the floor at the side walls so runoff runs inward to the
  perforated centre strip rather than dripping out through the open pockets in the
  base. If you flatten it, water will find the corners.

## How the base works

The floor is only perforated over the drawer channel, so all runoff lands in the
tray. Either side of the channel the base is open underneath -- those pockets are
the pot's feet, and they are where the four tie-down wire holes come out, so you can
twist the wire off up under the pot instead of inside the tray.

The tray rides on the 2 mm base plate and is guided by the channel walls; there are
no rails to break. The drawer face laps 7 mm onto the pot on each side, which doubles
as the stop when you push it home. The wedge pull is flat on top and chamfered at 45
degrees underneath so it prints off the face without support.

## Print settings

```
PRINT (pot):  upright on its base, no supports
PRINT (tray): flat on its floor, no supports
```

Print the two parts as separate jobs -- side by side they are 227 mm wide, past the
A1 Mini bed.

- Material: PETG or ASA if it lives outside. PLA will get brittle in UV within a season.
- Walls: 3 perimeters (the cone bosses want the material), 15% infill.
- **Bridging matters.** 100% part cooling and a slow bridge speed for the layer that
  closes over the drawer channel. Everything else is trivial.
- No supports anywhere. If your slicer wants to add them under the drawer ceiling,
  turn them off -- the span is designed to bridge.

## Using it

Bonsai substrate (pumice, lava, akadama) at 3-6 mm will mostly sit on the 5 mm
drainage holes, but drop a square of drainage mesh over the centre strip if you are
running anything finer.

The cone holes are 3.8 mm. Anything finer than about 4 mm will trickle out of the
walls for the first few waterings until the mix settles and bridges the openings --
that is normal for an air-pot and it stops. A root tip that reaches one dries off. Expect a dense fibrous root pad rather
than long circling roots -- that is the point, but it also means the pot dries faster
than a solid one. In summer it will want watering more often than a glazed pot.

Wire the tree down through the four corner holes on repotting; the pot is light and
a top-heavy tree will walk in wind otherwise.

## Tweaks worth knowing

- Smaller tree: `pot_w = 120; pot_d = 90; soil_h = 55;` and drop `tray_len` to 80.
- Denser air pruning: lower `cone_pitch_h` / `cone_pitch_v` to 10. Render time climbs
  fast -- there are already about 180 cones at the defaults.
- Deeper tray: raise `tray_h`. It only pushes the whole pot up by the same amount.
- `part = "pot" | "tray" | "both"` -- `"both"` previews the tray pulled halfway out.
