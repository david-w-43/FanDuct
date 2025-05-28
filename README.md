# FanDuct

A parametric duct for PC fans, written in OpenSCAD

![OpenSCAD Render](/docs/FanDuct.png)

*Example of a 2x 120 mm fan shroud with slotted mounting holes and reinforcement*

This OpenSCAD document creates a fan duct to guide air from case fans to a heatsink. This may be used to ensure your CPU heatsink gets a supply of cool air direct from a case fan, or for cooling a deshrouded GPU in a SFF case (see [example](#example-project) below).

The project supports 1-by-n fan setups, and can be easily customised to suit your needs. The variables at the top of the document allow the design to be adjusted easily. Ensure these are set to suit your application. The shape of the duct exhaust is fully customisable, with a configurable shape and optional cutouts.

## Example project

The example values used in this project are for an MSI GTX 960 in a Fractal Design Node 202. This has slotted holes for easier alignment, and reinforcement to help support the card. As this was too large to print in one piece, I added a dovetail joint in my slicer and slotted the two parts together.

| Printed part                           | Installed in case                 |
| ---------------------------------------|-----------------------------------|
| ![Printed part](/docs/PrintedDuct.jpg) | ![Installed](/docs/Installed.jpg) |
