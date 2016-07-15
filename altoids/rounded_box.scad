module rounded_box(dims, radii, epsilon = 0.01){
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
                    cylinder(r = r1-r2, h = 2*epsilon, center = true, $fn = 100);
                }
            }
            sphere(r = r2, $fn = 50);
        }
    }  
}
