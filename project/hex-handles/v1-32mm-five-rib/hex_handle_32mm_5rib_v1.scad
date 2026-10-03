/*
 HEX HANDLE V1 — 32 mm / FIVE HARD-EDGED RIBS
 Units: millimetres. Standalone OpenSCAD source; no external libraries.

 Published V1. Rebuilt from scratch after two discarded concept-matching prototypes.
 - Exactly five ribs, at 72 degree intervals, on the main grip and neck.
 - Flat rib crests, explicit edge chamfers, planar recessed panels.
 - Piecewise-linear shoulders and polygonal double collar: no body fillets.
 - Only the last 1.4 mm of the tail has an axial comfort roundover.
 - 6.4 mm A/F hex; 26.3 mm full-size depth; two outward epoxy reservoirs.
 - A tapered roof connects the socket to a continuous 2.4 mm tail vent.

 PRINT COORDINATES: hex mouth on Z=0 / bed. Tail at Z=32.
 Export output="handle" for the complete printable part.
 output="section" is a HALF-MODEL for inspection, NOT for printing as a handle.
 The mouth-down roof taper avoids an unsupported abrupt socket floor.

 Width is a design choice: default 28 mm circumscribed envelope, not a promise
 of a 28 x 28 bounding box (a five-fold outline has unequal axis extents).
 Geometry is not physically torque-tested or calibrated to a particular printer.
*/

/* [Output] */
output = "handle"; // [handle,section,socket_coupon]

/* [Exterior] */
handle_length = 32;         // Never above 32 mm for this design.
envelope_diameter = 28;     // Circumscribed XY envelope; default is intentionally stubby.
rib_count = 5;              // Fixed by the design brief; do not increase to eight.
body_rotation = 0;          // Rotation of five-rib pattern, degrees.
rib_crest_width = 3.6;      // Flat land width at the default 28 mm envelope.
tail_roundover = 1.4;       // Axial/radial roundover at the exposed tail ONLY.
tail_roundover_steps = 16;

/* [Socket] */
socket_af = 6.4;            // Exact nominal CAD flat-to-flat opening.
shaft_length = 26;
seating_allowance = 0.3;
socket_depth = shaft_length + seating_allowance;
socket_rotation = 30;      // Hex has flats parallel to Y at default.
entry_chamfer_depth = 0.8;
entry_chamfer_af = 7.8;
epoxy_pocket_af = 8.8;
epoxy_pocket_land = 1.6;
epoxy_pocket_chamfer = 1.4; // Each end; 4.4 mm total height per pocket.

/* [Vent and mouth-down roof] */
vent_diameter = 2.4;
roof_taper_depth = 2.0;    // Begins AFTER the 26.3 mm full-size socket.
roof_tip_af = 2.0;         // Ends wholly inside the circular vent.
vent_exit_diameter = 3.6;
vent_exit_chamfer_depth = 0.65;
vent_segments = 96;

/* [Fit coupon] */
coupon_diameter = 15;

/* [Hidden] */
eps = 0.02;
sx = envelope_diameter / 28;
sz = handle_length / 32;

assert(rib_count == 5, "This revision requires exactly five ribs.");
assert(handle_length <= 32, "Overall length must not exceed 32 mm.");
assert(handle_length > socket_depth + roof_taper_depth + vent_exit_chamfer_depth,
       "Not enough tail beyond the socket and vent transition.");
assert(envelope_diameter >= 24 && envelope_diameter <= 36,
       "Envelope parameter is intended for 24..36 mm; recheck overhangs if changed.");
assert(tail_roundover > 0 && tail_roundover <= 2.0);
assert(tail_roundover_steps >= 8);
assert(socket_af > vent_diameter && entry_chamfer_af >= socket_af);
assert(entry_chamfer_depth > 0);
assert(epoxy_pocket_af > socket_af && epoxy_pocket_chamfer > 0 && epoxy_pocket_land > 0);
assert(socket_depth/3 > 2*epoxy_pocket_chamfer + epoxy_pocket_land,
       "Epoxy pockets overlap.");
assert(socket_depth/3 - epoxy_pocket_land/2 - epoxy_pocket_chamfer > entry_chamfer_depth,
       "First epoxy pocket overlaps entry chamfer.");
assert(roof_tip_af/sqrt(3) < vent_diameter/2,
       "Roof tip must terminate INSIDE the round vent.");
assert(vent_exit_diameter >= vent_diameter && vent_exit_diameter < socket_af);
assert(coupon_diameter > 2*epoxy_pocket_af/sqrt(3) + 3);

// Thirty perimeter vertices, not a rounded polar surface. Each sector uses
// Cartesian rib coordinates. Its flank top and foot share the same local Y,
// so the tapered rib walls remain single PLANES, not twisted loft surfaces.
// There are six real corners per rib: foot, bevel, crest, crest, bevel, foot.

// [height at L=32, crest circumradius, recess radius, crest chamfer radial depth]
// The long grip is a true constant polygonal prism from Z=16.1 to Z=25.7.
// Collar ramps deliberately use slopes steeper than 45 degrees from vertical.
function hard_sections() = [
 [ 0.00,12.15,11.70,0.25], // Flat mouth-down footprint, no elephant-foot lip.
 [ 0.85,13.70,12.70,0.35], // Hard, steep head chamfer.
 [ 2.60,13.70,11.45,0.45], // Five clearly cut head flutes.
 [ 3.10,13.20,10.65,0.45],
 [ 6.50,10.60, 9.35,0.40], // Angular neck taper, not a fillet.
 [ 9.10,10.60, 9.35,0.40],
 [10.55,12.70,12.25,0.30], // First five-sided collar.
 [11.15,12.70,12.25,0.30],
 [11.50,11.50,11.15,0.25], // Recess between collars.
 [12.00,11.50,11.15,0.25],
 [12.65,12.70,12.25,0.30], // Second collar.
 [13.25,12.70,12.25,0.30],
 [13.65,11.10,10.60,0.30],
 [14.40,11.10,10.45,0.35],
 [16.10,14.00,10.95,0.45], // Five broad-ended, raised grip ribs.
 [25.70,14.00,10.95,0.45],
 [26.50,12.00,10.60,0.40], // Straight chamfered rib termination.
 [26.90,11.85,10.45,0.30],
 [28.00,13.70,11.45,0.40], // Five-lobed tail pads.
 [28.60,13.70,11.45,0.40],
 [28.90,13.10,11.45,0.35], // Shallow belt across tail pads.
 [29.40,13.10,11.45,0.35],
 [29.75,13.70,11.45,0.40]
];

function exterior_sections() = concat(
 [for(s=hard_sections()) [s[0]*sz,s[1]*sx,s[2]*sx,s[3]*sx]],
 [for(i=[0:tail_roundover_steps])
   let(a=90*i/tail_roundover_steps,
       dr=tail_roundover*(1-cos(a)))
   [handle_length-tail_roundover+tail_roundover*sin(a),
    13.7*sx-dr, 11.45*sx-dr, 0.4*sx]]
);

function rib_xy(s,k) =
 let(w=rib_crest_width*sx/2, b=s[3], wf=w+b,
     crest=sqrt(s[1]*s[1]-w*w), foot=sqrt(s[2]*s[2]-wf*wf))
 k==0 ? [foot,-wf] :
 k==1 ? [crest-b,-wf] :
 k==2 ? [crest,-w] :
 k==3 ? [crest,w] :
 k==4 ? [crest-b,wf] : [foot,wf];

module exterior() {
 sections=exterior_sections();
 n=rib_count*6;
 assert(sections[len(hard_sections())][0] > sections[len(hard_sections())-1][0],
        "Tail roundover overlaps preceding pad detail.");
 points=[for(s=sections, j=[0:rib_count-1], k=[0:5])
   let(a=body_rotation+360*j/rib_count,p=rib_xy(s,k))
   [p[0]*cos(a)-p[1]*sin(a),p[0]*sin(a)+p[1]*cos(a),s[0]]];
 faces=concat(
   [[for(i=[n-1:-1:0]) i]],
   [for(j=[0:len(sections)-2],i=[0:n-1])
     [j*n+i,j*n+(i+1)%n,(j+1)*n+(i+1)%n]],
   [for(j=[0:len(sections)-2],i=[0:n-1])
     [j*n+i,(j+1)*n+(i+1)%n,(j+1)*n+i]],
   [[for(i=[0:n-1]) (len(sections)-1)*n+i]]
 );
 polyhedron(points=points,faces=faces,convexity=20);
}

// One hexagonal loft: reliefs expand OUTWARD, never into the bit's path.
// The final taper builds a printable mouth-down roof, with no horizontal
// socket-floor bridge. The 2.4 mm vent cuts right through the tapered tip.
module hex_socket_and_roof() {
 h=epoxy_pocket_land/2;
 t=h+epoxy_pocket_chamfer;
 c1=socket_depth/3;
 c2=2*socket_depth/3;
 rows=[
  [-eps,entry_chamfer_af],
  [0,entry_chamfer_af],
  [entry_chamfer_depth,socket_af],
  [c1-t,socket_af],
  [c1-h,epoxy_pocket_af],
  [c1+h,epoxy_pocket_af],
  [c1+t,socket_af],
  [c2-t,socket_af],
  [c2-h,epoxy_pocket_af],
  [c2+h,epoxy_pocket_af],
  [c2+t,socket_af],
  [socket_depth,socket_af],
  [socket_depth+roof_taper_depth,roof_tip_af]
 ];
 points=[for(s=rows,i=[0:5])
   let(a=socket_rotation+60*i,r=s[1]/sqrt(3))
   [r*cos(a),r*sin(a),s[0]]];
 faces=concat(
   [[5,4,3,2,1,0]],
   [for(j=[0:len(rows)-2],i=[0:5])
     [6*j+i,6*j+(i+1)%6,6*(j+1)+(i+1)%6]],
   [for(j=[0:len(rows)-2],i=[0:5])
     [6*j+i,6*(j+1)+(i+1)%6,6*(j+1)+i]],
   [[for(i=[0:5]) 6*(len(rows)-1)+i]]
 );
 polyhedron(points=points,faces=faces,convexity=12);
}

module cavities() {
 hex_socket_and_roof();
 translate([0,0,socket_depth-eps])
   cylinder(d=vent_diameter,h=handle_length-socket_depth+2*eps,$fn=vent_segments);
 translate([0,0,handle_length-vent_exit_chamfer_depth])
   cylinder(d1=vent_diameter,d2=vent_exit_diameter,
            h=vent_exit_chamfer_depth,$fn=vent_segments);
 translate([0,0,handle_length-eps])
   cylinder(d=vent_exit_diameter,h=2*eps,$fn=vent_segments);
}

module handle() {
 difference() { exterior(); cavities(); }
}

module section() {
 // Keep the +Y half; socket, both reservoirs, roof and vent are exposed.
 intersection() {
  handle();
  translate([-envelope_diameter,0,-1])
   cube([2*envelope_diameter,envelope_diameter,handle_length+2]);
 }
}

module socket_coupon() {
 // Smaller body, full-depth cavity. Print with its hex opening on the bed too.
 difference() {
  union() {
   cylinder(d=coupon_diameter,h=handle_length-0.7,$fn=80);
   translate([0,0,handle_length-0.7])
    cylinder(d1=coupon_diameter,d2=coupon_diameter-1.4,h=0.7,$fn=80);
  }
  cavities();
 }
}

if(output=="handle") handle();
else if(output=="section") section();
else if(output=="socket_coupon") socket_coupon();
else assert(false,"Unknown output; use handle, section or socket_coupon.");