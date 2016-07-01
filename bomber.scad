//steps: 1000
//fps: 50

$fn=50;

time = $t * 1000;
v = [0,1,0];

g = 0.001;
t_drop = 100;
t_hit = 530;
// hit position = bomb_pos at t_hit
// = [0,5,0] + plane_pos(t_hit) + [0,0,-0.5 * g * pow(t_hit-t_drop,2)]
hit_pos = [0,5,0] + [50, -500, 100] + v * t_hit + [0,0,-0.5 * g * pow(t_hit-t_drop,2)];

plane_pos = [50, -500, 100] + v * time;
plane_tilt = [0,0,0];
bomb_pos = [0,5,0] + (time < t_drop ? plane_pos : plane_pos + [0,0,-0.5 * g * pow(time-t_drop,2)]);

// where the camera target is
$vpt = time < t_hit ? bomb_pos : hit_pos;
// camera distance
$vpd = time < (t_hit-100) ? (35 - 25 * time/(t_hit-100)) : 
       10 + (time-t_hit+100)*1.7;
// what angle the camera is at, relative to the target
$vpr = [80, 0, 135 - time/3 ];

if(time > t_hit){
    color("red"){
        translate(hit_pos){
            sphere((time - t_hit)*0.5);
        }
    }
}

color("lightblue"){
    translate(plane_pos){
        rotate(plane_tilt){
            bomber();
        }
    }
}

color("red"){
    translate(bomb_pos){
        // x(t) = v * t
        // y(t) = -0.5 * g * t^2
        // > dy/dx = dy/dt * dt/dx
        // > dy/dx = (-g * t) * (1/v)
        // > dy/dx = - g * t / v
        rotate(a = atan(-g*time/v[1]), v = [1,0,0]){
            rotate(a = 90, v = [1,0,0]){
                rotate(a = -time*3, v = [0,0,1])
                bomb();
            }
        }
    }
}

rotate(a = 30, v = [0,0,1]){
    color("green"){
        square([1000,1000], center=true);
    }
    spacing = 250;
    spacing = 50;
    color("purple"){
        for(i = [-500:spacing:500]){
            for(j = [-500:spacing:500]){
                translate([j,i ,0]){
                    cube([20,20,40*(1-0.7*sin(i*j))]);
                }
            }
        }
    }
}

module bomb(){
    cylinder(h = 1, r = 0.2);
    sphere(0.2);
    translate([0,0,0.95]){
        cylinder(h=0.5, r = 0.1);
    }
    translate([0,0,1.1]){
        for(i = [90:90:360]){
            translate([0.2*cos(i), 0.2*sin(i), 0]){
                difference(){
                    cylinder(h = 0.3, r=0.11);
                    translate([0,0,-0.05]){
                        cylinder(h = 0.4, r=0.09);
                    }
                }
            }
        }
    }
}


module swept_fin(sweep, size){
    rotate(a=sweep, v=[0,0,1]){
        scale(size){
            // cut off half the ellipse:
            intersection(){
                sphere(1);
                translate([1,0,0]){
                    cube(2,center=true);
                }
            }
        }
    }
}

module wing(){
    sweep = -35;
    swept_fin(sweep, [10,1.15,0.2]);
    translate([5*cos(sweep),5*sin(sweep)-1,0]){
        // engine:
        translate([0,0,-0.75]){
            rotate(a = 90, v = [-1,0,0]){
                cylinder(h = 2.5, r = 0.4);
            }
        }
        // engine strut:
        translate([-0.2,1,-0.4]){
            cube([0.4,1,0.5]);
        }
    }
}

module bomber(){
    length = 15;
    radius = 1;
    //body:
    translate([0,5,0]){
        rotate(a = 90, v = [-1,0,0]){
            cylinder(h = length-5, r = radius);
        }
    }
    //cockpit:
    translate([0,length,0]){
        scale([1,2,1]){
            sphere(radius);
        }
    }
    //butt:
    M = [ [ 1, 0, 0, 0 ],
          [ 0, 1, 0, 0 ],
          [ 0, -0.5, 1, 0 ],
          [ 0, 0, 0, 1 ] ] ;
    translate([0,5,0]){
        intersection(){
            scale([1,6,1]){
                multmatrix(M) {
                    sphere(radius);
                }
            }
            rotate(a = 90, v = [-1,0,0]){
                cylinder(h = 20, r = radius, center=true);
            }
        }
    }
    //wings:
    translate([0,0.70*length,0]){
        wing();
        mirror(v = [1,0,0]){
            wing();
        }
    }
    //tail:
    translate([0,1,0]){
        rotate(a = 20, v = [1,0,0]){
            scale([0.2,0.5,1]){
                cylinder(h = 3, r1 = radius, r2 = radius/2);
            }
        }
        fin_size = [2,0.3,0.1];
        translate([-0.05,-0.5,1.5]){
            swept_fin(-15, fin_size);
        }
        translate([0.05,-0.5,1.5]){
            mirror(v = [1,0,0]){
                swept_fin(-15,fin_size);
            }
        }
    }

}
