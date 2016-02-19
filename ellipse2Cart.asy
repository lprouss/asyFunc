// -------------------------------------------------------------------------- //
// ellipse2Cart: Cartesian coordinates for a point on an ellipse
//
// Function that returns the Cartesian coordinates (x and y) of a point on an
// ellipse at the provided true anomaly angle. The ellipse is characterized
// using its eccentricity and semimajor axis.
//
// Author: Louis-Philippe Rousseau (ULaval)
// Created: February 2016

pair ellipse2Cart(
 real e, // eccentricity (0 <= e < 1)
 real a, // semimajor axis [m]
 real ta // true anomaly [deg]
)
{
    // make sure the true anomaly value is lower than +-360 degrees
    //if ( ta >= 360 ){ ta = ta - 360; }
    //if ( ta <= -360 ){ ta = ta + 360; }

    // distance of the point to the ellipse focus (radius) at the true anomaly
    real r = a * ( 1 - e^2 ) / ( 1 + e * Cos(ta) );

    // calculate and return the Cartesian coordinates of the point
    return r * (Cos(ta), Sin(ta));
}

