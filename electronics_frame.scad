use<frame.scad>
include<arduino.scad>
//Creates a bumper style enclosure that fits tightly around the edge of the PCB
//derived from Arduino connectors library by Kelly Egan.

// Designed from a sketch of i3 Omega frame. Generates an enclosed frame,
// uncomment lines at the bottom to create STLs for top and bottom.  

// Designed by Joseph Lenox

module boardShape_wide( boardType = MEGA, offset = 0, height = pcbHeight ) {
	dimensions = boardDimensions(boardType);

	xScale = (dimensions[0] + offset * 8) / dimensions[0];
	yScale = (dimensions[1] + offset * 8) / dimensions[1];

	translate([-offset-5, -offset-4, 0])
		scale([xScale, yScale, 1.0])
			linear_extrude(height = height) 
				polygon(points = boardShapes[boardType]);
}
module bumper_solid(boardType = MEGA, mountingHoles = false, thick=0.2) {
	bumperBaseHeight = 2;
	bumperHeight = bumperBaseHeight + pcbHeight + 0.5;
	dimensions = boardDimensions(boardType);

	difference() {
		union() {
			//Outer rim of bumper
			difference() {
				boardShape(boardType = boardType, offset=1.4, height = bumperHeight);
				translate([0,0,-0.1])
					boardShape(boardType = boardType, height = bumperHeight + 0.2);
			}
			//Base of bumper	
			difference() {
				boardShape(boardType = boardType, offset=1, height = bumperBaseHeight);
				translate([0,0, -0.1])
					boardShape(boardType = boardType, offset=-2, height = bumperHeight + 0.2);
			}
			//Base of bumper	
			difference() {
				translate([0,0,-thick]) 
					boardShape_wide(boardType = boardType, offset=2, height = bumperBaseHeight+thick);
				color("Red") translate([4,18,-2]) cube([45.3,60,10]);
			}
			//Board mounting holes
			holePlacement(boardType=boardType) 
				cylinder(r = mountingHoleRadius + 1.5, h = bumperBaseHeight, $fn = 32);

			//Bumper mounting holes (exterior)
			if( mountingHoles ) {
				difference() {	
					hull() {
						translate([-6, (dimensions[1] - 6) / 2, 0])
							cylinder( r = 6, h = pcbHeight + 2, $fn = 32 );
						translate([ -0.5, dimensions[0] / 2 - 9, 0]) 
							cube([0.5, 12, bumperHeight+thick]);
					}
					translate([-6, (dimensions[0] - 6) / 2, 0])
						mountingHole(holeDepth = bumperHeight+thick);
				}
				difference() {	
					hull() {
						translate([dimensions[0] + 6, (dimensions[1] - 6) / 2,0])
							cylinder( r = 6, h = pcbHeight + 2, $fn = 32 );
						translate([ dimensions[0], dimensions[1] / 2 - 9, 0]) 
							cube([0.5, 12, bumperHeight]);
					}
					translate([dimensions[0] + 6, (dimensions[1] - 6) / 2,0])
						mountingHole(holeDepth = bumperHeight+thick);
				}
			}
		}
		translate([0,0,-0.5])
		holePlacement(boardType=boardType) translate([0,0,-2])
			cylinder(r = mountingHoleRadius, h = bumperHeight+thick+2, $fn = 32);	
		color("purple") holePlacement(boardType=boardType) translate([0,0,-2.1])
			cylinder(r = 4.5, h = 3, $fn = 32);	
		translate([0, 0, bumperBaseHeight]) {
			components(boardType = boardType, component = ALL, offset = 1);
		}
		translate([4,(dimensions[1] - dimensions[1] * 0.4)/2,-1])
			cube([dimensions[0] -8,dimensions[1] * 0.4,bumperBaseHeight + 2]);
	}
}
//translate([0,0,-3.1]) // Translation for top cutoff. Uncomment this and comment next line. 
translate([0,0,5]) // Translation for bottom cutoff. Uncomment this and comment previous line.
rotate([0,0,180]) {
difference() {
	union() {
		translate([-45,0,5.1]) rotate([0,0,270])  bumper_solid(boardType=MEGA, thick=10);
		translate([0,-4,0]) {
		color("blue")translate([15,-70,3.1]) cube([36,13,4]);
		difference() {
			color("blue")translate([15,-70,3.1]) cube([36,13,5]);
			color("blue")translate([15.25,-69.9,3.1]) cube([35.5,12.8,5]);
		}
		}
	}
	translate([50, 3, -10]) cylinder(r=1.5, h=30, $fn=30);
	translate([-45, 3, -10]) cylinder(r=1.5, h=30, $fn=30);
	translate([-45, -58, -10]) cylinder(r=1.5, h=30, $fn=30);
	translate([-2,0,0]) color("Blue") i3omegaframe(3.1);
	color("Green") translate([-60,-80,2.9]) cube([500,500,20]); // bottom cutoff, .1mm shorter to add some tension. uncomment this for slicing box for top
	//color("Green") translate([-60,-70,-6.9]) cube([500,500,10]); // top cutoff, uncomment this for bottom.
}
//color("Blue") i3omegaframe(3.1);
}
