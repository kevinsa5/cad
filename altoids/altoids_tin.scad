//made with OpenSCAD version 2015.03-1 
//all lengths in centimeters
use <altoids_top.scad>;
use <altoids_bottom.scad>;

color("fuchsia")
bottom();
//angle = $t < 0.10 ? 0 : ($t - 0.10) * 90;
angle = 40;
color("yellow")
translate([-0.05, -0.03, 1.39]) 
    rotate([angle,0,0]) 
        top();


//$vpr = [60, 0, 225 - $t*720 ];
 