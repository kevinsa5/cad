//made with OpenSCAD version 2015.03-1 
//all lengths in centimeters
use <rounded_box.scad>;

epsilon = 0.01;
dims = [9.4, 5.9, 0.7];
radii = [1, 0.1];
wall_thickness = 0.05;

color([224/255, 248/255, 148/255]) 
top();

module top(){
    translate([0,0,0.62])
        mirror([0,0,1])
            top_main();

    translate([dims[0]-0.3, 0.4, dims[2]-0.08])
        rotate([0,0,180])
            mirror([0, 1, 0]) 
                scale([1/50, 1/50, 1 / 10000])
                    surface(file = "altoids_logo.dat", convexity = 5);
}

module top_main(){
    difference(){
        rounded_box(dims, radii, epsilon);
        translate(wall_thickness * [1,1,1]){
            rounded_box(dims - [2*wall_thickness, 2*wall_thickness, wall_thickness-epsilon], radii, epsilon);
        }
        //holes for hinges:
        //height = 0.2, width = 1.2, 0.1 and 2.0 from the edge
        translate([2.0, -2*epsilon, dims[2]-0.3])
            cube([1.2, wall_thickness + 4*epsilon, 0.2]);
        translate([dims[0] - 3.2, -2*epsilon, dims[2]-0.3])
            cube([1.2, wall_thickness + 4*epsilon, 0.2]);
        
        //chop off the top, it's rounded the wrong way
        translate([-epsilon,-epsilon,dims[2]-0.08]) cube(dims + 5*epsilon*[1,1,1]);
    }
    // rim around the edge
    translate([1,0.002,dims[2]- 0.08]) 
        rotate([0,90,0])
            cylinder(r = 0.05, h = dims[0] - 2, $fn=50);
    translate([1,dims[1],dims[2]- 0.08]) 
        rotate([0,90,0])
            cylinder(r = 0.05, h = dims[0] - 2, $fn=50);
    translate([0,1,dims[2]- 0.08]) 
        rotate([0,90,90])
            cylinder(r = 0.05, h = dims[1] - 2, $fn=50);
    translate([dims[0],1,dims[2]- 0.08]) 
        rotate([0,90,90])
            cylinder(r = 0.05, h = dims[1] - 2, $fn=50);
    translate([1,1,dims[2]-0.08])
        rotate([0,0,180])
            arc90();
    translate([dims[0]-1,1,dims[2]-0.08])
        rotate([0,0,-90])
            arc90();
    translate([dims[0]-1,dims[1]-1,dims[2]-0.08])
        rotate([0,0,0])
            arc90();
    translate([1,dims[1]-1,dims[2]-0.08])
        rotate([0,0,90])
            arc90();
}
module arc90(){
    intersection(){
        rotate_extrude(angle = 360, concavity = 10, $fn = 100){
            translate([1,0,0]) circle(r = 0.05, $fn = 50);
        }
        translate([0,0,-0.5]) cube([2,2,2]);
    }
}