// FanDuct.scad - David Way, 2025
//
// A parametric multi-fan (1 x n) duct designed for PC fans.

// ============= Configuration variables, all units in mm =========

// Number of fans
num_fans = 2;

// Fan size, e.g. 120 or 140
fan_size = 120;

// Fan hole size
fan_hole_size = 116;

// Spacing between mounting holes, e.g. 105 for a 120 mm fan
hole_spacing = 105;

// Mounting hole diameter
hole_diameter = 4.3;

// Use slots instead of holes
slot = false;

// Thickness of the plate that mounts to the fans
plate_thickness = 3;

// Thickness of the walls
wall_thickness = 2;

// Here you can customise the shape of the duct output
module duct_out() {
    square([235, 90]);
}

// Full height of the duct
full_height = 40;

// Offset of duct output 
output_offset = [20, 40];

// Segments for circle, improves model quality at cost of render time
$fn = 50;


// ================================================================

// Create the model!
create_model(
    num_fans, 
    fan_size,
    fan_hole_size,
    full_height, 
    plate_thickness, 
    output_offset, 
    wall_thickness, 
    hole_spacing, 
    hole_diameter,
    slot
);

module create_model(n, fan_size, fan_hole_size, full_height, plate_thickness, output_offset, wall_thickness, hole_spacing, hole_diameter, slot)
{
    duct_height = full_height - plate_thickness;
    
    // Create plate that attaches to fans
    plate(n, fan_size, fan_hole_size, plate_thickness, wall_thickness, hole_spacing, hole_diameter, slot);
    
    translate([0, 0, plate_thickness])
        duct(n, fan_size, fan_hole_size, duct_height, output_offset, wall_thickness);
}

module duct(n, fan_size, fan_hole_size, height, output_offset, wall_thickness) {
    difference() {
        // Positive space with added wall thickness
        duct_shell(n, fan_size, fan_hole_size, output_offset, height, wall_thickness);
        
        // Negative space
        duct_shell(n, fan_size, fan_hole_size, output_offset, height);
    }
}

module duct_shell(n, fan_size, fan_hole_size, output_offset, height, expansion = 0) {
    // Need non-zero extrusion to make 3D shaped prior to hull()
    solidifier = 1;
    offset = fan_size/2;
    hull() {
        translate([offset, offset, 0])
            linear_extrude(solidifier)
                offset(r = expansion)
                    fan_hole(n, fan_size, fan_hole_size);
        
        translate([output_offset.x, output_offset.y, height-solidifier])
            linear_extrude(solidifier)
                offset(r = expansion)
                    duct_out();
    }
}

// Create the mounting plate
module plate(n, fan_size, fan_hole_size, plate_thickness, wall_thickness, hole_spacing, hole_diameter, slot)
{
    linear_extrude(plate_thickness)
        difference() {
            plate_positive(n, fan_size, hole_spacing, wall_thickness);
            fan_negatives(n, fan_size, fan_hole_size, hole_spacing, hole_diameter, slot);
        }
}

// Create positive space for the mounting plate (nice rounded rectangle)
module plate_positive(n, fan_size, hole_spacing, wall_thickness) {
    
    // Calculate fan's corner radius :)
    corner_radius = (fan_size - hole_spacing)/2;
    
    // Add the wall thickness
    //offset(r = wall_thickness)
        // Round the corners
        offset(r = corner_radius)
        offset(r = -corner_radius)
            // "Bounding box" of the fans, square edges
            square([n*fan_size, fan_size]);
    
}

// Create plate negative space for n fans 
module fan_negatives(n, fan_size, fan_hole_size, hole_spacing, hole_diameter, slot) {
    offset = fan_size/2;
    translate([offset, offset, 0]) {
        // Create joined fan hole
        fan_hole(n, fan_size, fan_hole_size);
        
        // Special case: single fan
        if (n == 1) {
            mounting_holes(fan_size, hole_spacing, hole_diameter, slot, "all");
        } else {
            // Fans at the end get holes, those in the middle get none
            for (i = [0:n-1]) {
                translate([i*fan_size, 0, 0])
                    mounting_holes(hole_spacing, hole_diameter, slot,
                        i == 0 ? "left" : 
                        i == n - 1 ? "right" : "none"
                    );
            }
        }
    }
}

// Creates a joined hole for n fans of a given size
module fan_hole(n, fan_size, fan_hole_size) {
    hull() {
        for (i = [0:n-1]) {
            translate([i*fan_size, 0, 0])
                circle(d = fan_hole_size);
        }
    }
}

// Create the holes for a single fan, specifying dimensions and which holes
module mounting_holes(hole_spacing, hole_diameter, slot = false, holes=
    "all") {
    
    // Mounting hole locations
    offset = hole_spacing/2;
    locs_master = [[0, 0],
            [hole_spacing, 0],
            [hole_spacing, hole_spacing],
            [0, hole_spacing]];
        
    // Define which mounting holes we'll be adding    
    for (locs = 
        holes=="all" ? locs_master : 
        holes=="left" ? [locs_master[0], locs_master[3]]  :
        holes=="right" ? [locs_master[1], locs_master[2]] : []) {
   
        translate([locs.x - offset, locs.y - offset, 0])
            if (slot == false)
            {
                circle(d=hole_diameter);
            } else {
                hull(){
                    translate([-0.5 * hole_diameter, 0, 0])
                        circle(d=hole_diameter);
                    translate([+0.5 * hole_diameter, 0, 0])
                        circle(d=hole_diameter);
                }
            }
            
    }
}
