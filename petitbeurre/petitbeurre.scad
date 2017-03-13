/*
 *
 * Petit Beurre
 *
 * This is a naive attempt at reproducing a vintage Petit Beurre cutter.
 *
 * Inspired from https://en.wikipedia.org/wiki/Petit-Beurre
 *
 * (c) 2017 AUTONOMOUS INDUSTRIAL TOOLS INCORPORATED
 *
 * Licensed under CERN OHL v.1.2 or later
 *
 * You may redistribute and modify this documentation under the terms of the
 * CERN OHL v.1.2. (http://ohwr.org/cernohl). This documentation is distributed
 * WITHOUT ANY EXPRESS OR IMPLIED WARRANTY, INCLUDING OF
 * MERCHANTABILITY, SATISFACTORY QUALITY AND FITNESS FOR A
 * PARTICULAR PURPOSE. Please see the CERN OHL v.1.2 for applicable
 * conditions
 *
 * author: william@accret.io
 *
 */

MoldHeight=10;
MoldBaseHeight=2;

CookieLength=72.4;
CookieWidth=54;

EarRadius=5;

TeethWidth=4.6;
TeethLength=20;
TeethOffset=4;

DotDiameter=1;
FontSize=7;

res=20; /* this is the $fn value - the higher, the longer the rendering time is */

/* 2D shape of the Petit Beurre */

module teeth(Spacing) {
     translate([Spacing/2, 0, 0]) {
     square([TeethWidth - Spacing, TeethLength - Spacing/2]);
     translate([(TeethWidth - Spacing)/2, TeethLength ]) circle((TeethWidth - Spacing)/2, $fn=res, center=true);
     }
}

module ear(Spacing) {
     resize([12-2*Spacing,8-2*Spacing])circle(5, $fn=res);
}

module quadrant(Spacing) {
     translate([CookieLength/2, CookieWidth/2, 0 ]) {
          rotate([0, 0, 45])
               ear(Spacing);
     }
     for (i=[0:4]) {
          translate([CookieLength/2 - TeethLength + 3 , CookieWidth/2 - i*(TeethWidth ) - TeethOffset, 0 ]) {
               rotate([0, 0, -90]) teeth(Spacing);
          }
     }
     for (i=[1:7]) {
          translate([CookieLength/2 - i*(TeethWidth) - TeethOffset , CookieWidth/2 - TeethLength + 3, 0 ]) {
               rotate([0, 0, 0]) teeth(Spacing);
          }
     }
     square([CookieLength/2 - 5, CookieWidth/2 - 4]);
}

module shape(Spacing=0) {
     quadrant(Spacing);
     mirror([1, 0, 0]) {
          quadrant(Spacing);
     }
     mirror([0, 1, 0]) {
          quadrant(Spacing);
     }
     rotate([0, 0 , 180]) {
          quadrant(Spacing);
     }
}

/* the 24 dots. later they will be the pushers of the ejection mechanism */

module dot() {
     cylinder(MoldHeight, DotDiameter, 3*DotDiameter, $fn = res);
}

module dot_row() {
     for (i=[0:2]) {
          translate([-10 * i - 5, 0, 0]) {
               dot();
          }
          translate([10 * i + 5, 0, 0]) {
               dot();
          }
     }
}
   
   
module dots() {

     for (i=[0:1]) {
          translate([0, 6 + i * 12 ]) {
               dot_row();
          }
           translate([0, - 6 - i * 12 ]) {
               dot_row();
          }
     }

}




/* the text. you need to install the Rebel bones font on your system, or to use another font */
module label(position, t) {
     linear_extrude(height = MoldHeight, center = false, convexity = 10, twist = 0, scale=[1, 1]) {
          translate([0, position, 0])
               text(t, size= FontSize, font = "Rebel bones", halign="center");
     }
}


/* assembling everything */
module cutter() {
     
     dots();
     
     difference() {
          linear_extrude(height = MoldHeight, center = false, convexity = 10, twist = 0) {
               shape(0);
          }
          
          linear_extrude(height = MoldHeight, center = false, convexity = 10, twist = 0) {
               shape(1);
          }
          
          translate([CookieLength/2-5, CookieWidth/2-5, 0 ]) 
               cylinder(MoldHeight, 3, 3, $fn=res);
          
          translate([CookieLength/2-5, -(CookieWidth/2-5), 0 ]) 
               cylinder(MoldHeight, 3, 3, $fn=res);
          
          translate([-(CookieLength/2-5), CookieWidth/2-5, 0 ]) 
               cylinder(MoldHeight, 3, 3, $fn=res);
          
          translate([-(CookieLength/2-5), -(CookieWidth/2-5), 0 ]) 
               cylinder(MoldHeight, 3, 3, $fn=res);
     }
     
     label(8.5, "COLETTE");
     label(-3.5, "EDITH");
     label(-15.5, "MARGUERITE");
          
     translate([0, 0, MoldHeight])
          cube([CookieLength+15, CookieWidth+15, MoldBaseHeight], center=true);
}

rotate([180, 0, 0])
cutter();


     
     
