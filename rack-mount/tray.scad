include <./common.scad>
use <./rackEars.scad>

// Rack mount tray that supports screws on the bottom of the rack-mount item
bottomScrewTray(u=1);


// Config variables
//trayAlignment = "middle"; // middle, right, left
trayWidth = 140;
trayDepth = 85;
trayThickness = 3;

mountPoints = [];
mountScrewType = "m3";


module bottomScrewTray(u, trayWidth, trayDepth, trayThickness, mountPoints, mountScrewType) {

  frontLipHeight = 2;
  backLipHeight = 1; // also applies to sides
  lipThickness = 3;

  rackEarSideThickness = 3;
  rackEarFrontThickness = 3;

  screwDx = rackMountScrewWidth; // x dist between the mount holes
  screwDz = uDiff * u;

  plateLength = screwDx + 2*rackMountScrewXDist;
  plateHeight = screwDz + 2*rackMountScrewZDist;

  minScrewToTraySpacing = 8;

  // TODO: toggle this based on left/right/middle alignment
  leftScrewDistToTray = minScrewToTraySpacing + 2 + 10;

  leftScrewGlobalX = -leftScrewDistToTray;
  rightScrewGlobalX = screwDx + leftScrewGlobalX;

  pointHoleRadius = screwRadiusSlacked("m3");
  pointHoleThickness = 2;
  pointMountElevation = 1;

  points = [ // [x,y,elevation,holeRadius,holeThickness]
      [(27.5),34, pointMountElevation, pointHoleRadius, pointHoleThickness],
      [(27.5)+79.5,34, pointMountElevation, pointHoleRadius, pointHoleThickness]
    ];


  difference() {
    applyMountHoles(points)
    translate(v = [-rackEarSideThickness, -rackEarFrontThickness, -trayThickness])
    body();

    // hack
    *union() {
      translate(v = [-20, 18, 15])
      rotate(a = [0, 90, 0])
      cylinder(r = 10, h = inf);

      translate(v = [-20, 40, 13])
      rotate(a = [0, 90, 0])
      cylinder(r = 7, h = inf);
    }
  }

  module body() {

    cube(size = [trayWidth, trayDepth, trayThickness]);

    translate(v = [0, 0, trayThickness])
    cube(size = [trayWidth, lipThickness, frontLipHeight]);

    translate(v = [0, trayDepth-lipThickness, trayThickness])
    cube(size = [trayWidth, lipThickness, backLipHeight]);

    translate(v = [0, 0, trayThickness])
    cube(size = [lipThickness, trayDepth, backLipHeight]);

    translate(v = [trayWidth-lipThickness, 0, trayThickness])
    cube(size = [lipThickness, trayDepth, backLipHeight]);

    translate(v = [leftScrewGlobalX, 0, rackMountScrewZDist])
    rackEarModule(frontThickness = rackEarFrontThickness, sideThickness = rackEarSideThickness, frontWidth =
        leftScrewDistToTray+rackMountScrewXDist+rackEarSideThickness, sideDepth = trayDepth-lipThickness, u = u);

    translate(v = [rightScrewGlobalX, 0, rackMountScrewZDist])
    mirror(v = [1, 0, 0])
    rackEarModule(frontThickness = rackEarFrontThickness, sideThickness = rackEarSideThickness, frontWidth =
       rightScrewGlobalX-trayWidth+rackMountScrewXDist+rackEarSideThickness, sideDepth = trayDepth-lipThickness, u = u);
    }


  module applyMountHoles(points) {


    apply_pn() {
      for (i = [0:len(points)-1]) {
        p = points[i];
        x = p[0];
        y = p[1];
        elevation = p[2];
        hR = p[3];
        hT = p[4];
        translate(v=[x, y, 0])
        cylinder(r=hR+hT, h=elevation);
      }
      for (i = [0:len(points)-1]) {
        p = points[i];
        x = p[0];
        y = p[1];
        hR = p[3];
        hT = p[4];
        translate(v=[x, y, 0])
        cylinder(r=hR, h=inf50, center=true);
      }
      children(0);
    }

  }

}