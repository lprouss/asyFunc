// -------------------------------------------------------------------------- //
// ellipsoid: ellipsoid with a symmetry of rotation in the XY-plane
//
// Function that returns an ellipsoid of revolution with a symmetry of
// rotation in the XY-plane. The ellipsoid is characterized using equatorial
// and polar radii provided as input.
//
// Author: Louis-Philippe Rousseau (ULaval)
// Created: February 2016

// import useful module
import solids;

// import function to calculate an arc of ellipse in a 3D frame
import ellipse3;

revolution ellipsoid(
    real re, // equatorial radius [m]
    real rp // polar radius [m]
)
{
    // calculate the polar eccentricity
    real ep = sqrt( (re^2 - rp^2) / re^2 );

    // calculate the true anomaly corresponding to a latitude of 90 degrees
    real tap = aCos( -ep );

    // calculate the ellipse arc that will be used to create the ellipsoid
    path3 ellArc = ellipse3( ep, re, 0, 90, 0, -tap, tap, (re*ep,0,0), 10 );

    // create the ellipsoid of revolution around the z axis
    return revolution( O, ellArc, Z );
}

