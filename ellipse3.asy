// -------------------------------------------------------------------------- //
// ellipse3: oriented ellipse or arc of an ellipse in 3D frame
//
// Function that returns the path in a 3D frame corresponding to an ellipse
// having the provided eccentricity and semimajor axis or an arc of that
// ellipse between the true anomalies provided as input. The ellipse (or arc)
// is oriented in the 3D frame according to the three proper Euler angles
// (https://en.wikipedia.org/wiki/Euler_angles) optionally provided as input.
//
// In celestial mechanics, the inputs of the function define the orbital
// elements for the desired orbit. Therefore, the three Euler angles correspond
// to the right ascension of the ascending node, the inclination and the
// argument of periapsis, in that order.
//
// Author: Louis-Philippe Rousseau (ULaval)
// Created: February 2016

// import useful modules
import graph3;

// import function to calculate the coordinates of a point on the ellipse
import ellipse2Cart;

path3 ellipse3(
 real e, // eccentricity (0 <= e < 1)
 real a, // semimajor axis [m]
 real eul1=0, // first Euler angle (right ascension of the ascending node) [deg]
 real eul2=0, // second Euler angle (inclination) [deg]
 real eul3=0, // third Euler angle (argument of periapsis) [deg]
 real ta1=0, // true anomaly at the beginning of the arc [deg]
 real ta2=360, // true anomaly at the end of the arc [deg]
 triple C=O, // coordinates of the main ellipse focus in the 3D frame
 int n=360 // number of true anomaly increments to use for calculations
)
{
    // calculate the 2D path of the ellipse or arc of ellipse
    pair ellPos( real ta ){ return ellipse2Cart( e, a, ta ); }
    path ell2 = graph( ellPos, ta1, ta2, n=n, join=Spline );

    // calculate the transformation from the 2D ellipse frame to the 3D frame
    transform3 T23 = rotate( eul1, Z ) * rotate( eul2, X ) * rotate( eul3, Z );

    // orient the 2D ellipse path into the 3D frame
    path3 ell3 = T23 * path3(ell2);

    // shift the focus position and return the 3D ellipse path
    return shift( C ) * ell3;
}

