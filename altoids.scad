//made with OpenSCAD version 2015.03-1 

//all lengths in centimeters
epsilon = 0.01;

bottom();

//translate(-dims/2) 
module bottom(){
    dims = [9.3,5.8,2.0];
    radii = [1,0.1];
    wall_thickness = 0.05;
    difference(){
        rounded_box(dims, radii);
        translate(wall_thickness * [1,1,1]){
            rounded_box(dims - [2*wall_thickness, 2*wall_thickness, 0], radii);
        }
        // holes for the hinges
        //0.6 high
        //0.2 from the top
        translate([2.0, -2*epsilon, dims[2] - 0.8])
            cube([1.0, wall_thickness + 4*epsilon, 0.6]);
        translate([dims[0] - 3.0, -2*epsilon, dims[2] - 0.8])
            cube([1.0, wall_thickness + 4*epsilon, 0.6]);
    }
    
    translate([2.0, -wall_thickness, dims[2] - 0.8])
        hinge();
    translate([dims[0] - 3.0, -wall_thickness, dims[2] - 0.8])
        hinge();

    // 1.6 is the height off the ground
    // 2.0 is the distance from the bump to the edge
    translate([2.0, dims[1]-2*epsilon, 1.6])
        rotate([-90,0,0])
            bump();
    // 0.5 is the length of a bump
    translate([dims[0]-2.0 - 0.5,dims[1]-2*epsilon, 1.6])
        rotate([-90,0,0])
            bump();
    
}

module rounded_box(dims, radii){
    length = dims[0];
    width = dims[1];
    height = dims[2];
    r1 = radii[0];
    r2 = radii[1];
    translate([r2,r2,r2]){
        minkowski(){
            translate([r1-r2,r1-r2,0]){
                minkowski(){
                    cube(dims - [2*r1, 2*r1, 2*epsilon+2*r2]);
                    translate([0,0,epsilon]) 
                    cylinder(r = r1-r2, h = 2*epsilon, center = true, $fn = 50);
                }
            }
            sphere(r = r2, $fn = 50);
        }
    }  
}


module bump(){
    $fn = 50;
    width = 0.2;
    length = 0.5;
    height = 0.05;
    dims = [width, length, height];
    r = width / 2 - epsilon;
    hull(){
        translate([r,-epsilon,0]) minkowski(){
            cube([length - 2*r, 2*epsilon, epsilon]);
            cylinder(r = r, h = epsilon);
        }
        translate([r,0,height]) rotate([0,90,0]) cylinder(h = length - 2*r, r = epsilon);
    }
}

module hinge(){
    $fn = 50;
    epsilon = 0.01;
    wall_thickness = 0.1;

    curved_hinge_segment();
    translate([0,0,0.15])
        rotate([180,0,0]) 
            curved_hinge_segment();

    theta = acos(0.075/0.1);

    intersection(){
        translate([0,0,0.15]){
            difference(){
                rotate([90,0,0]) 
                    curved_hinge_segment();
                translate([-epsilon,0,0])
                    rotate([theta,0,0])
                        cube([1.0+2*epsilon, 0.1 + epsilon, 0.1 + epsilon]);
            }
        }
    }
    translate([0,-0.1*cos(theta),0.15 + 0.1*sin(theta)])
        rotate([-atan(1),0,0])
            cube([1.0, 0.05, 0.2]);
}

module curved_hinge_segment(){
    translate([0,-0.05,0])
        intersection(){
            difference(){
                base();
                translate([-epsilon,0.05,0]) 
                    rotate([0,90,0]) 
                        cylinder(r = 0.05, h = 1.0+2*epsilon);
                translate([-epsilon,-epsilon,0])
                    cube([1.0 + 2*epsilon, 0.05+epsilon, 0.1]);
            }
            translate([-epsilon,0.05,0]) 
                rotate([0,90,0]) 
                    cylinder(r = 0.1, h = 1.0+2*epsilon);    
        }
}

module base(){
    cube([1.0, wall_thickness + 0.1 , 0.6]);
}