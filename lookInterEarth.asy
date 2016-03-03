// -------------------------------------------------------------------------- //
// lookInterEarth: intersection point of a satellite look vector with the
//                  surface of the Earth
//
// Function that calculates and returns the intersection point on the Earth's
// surface of the look vector for a satellite on orbit.
//
// The surface of the reference ellipsoid for the Earth can be provided.
// Otherwise, it is generated using the provided equatorial and polar radii.
// The calculations are based on the local coordinate system with an origin at
// the satellite's center of gravity. The local z axis is calculated from the
// satellite's position relative to the center of the Earth. The local x axis
// is the tangent to the orbit track at the satellite's position, i.e. it is
// the normalized satellite velocity. The local y axis completes the
// right-angled system. The look vector is oriented using 1) a off-nadir angle,
// measured from the local z axis and positive if pointing towards +y, and
// 2) a azimuth angle, measured from the local y axis and positive if pointing
// towards +x.
//
// Author: Louis-Philippe Rousseau (ULaval)
// Created: February 2016

// import useful modules
import three;

triple lookInterEarth(
    path3 orbit, // orbit track
    real obsFrac, // observation time as a fraction of the orbit length
    real lookOff, // off-nadir angle for the look direction (degrees)
    real lookAz, // azimuth angle for the look direction (degrees)
    pair radE = (1,0.99665), // Earth ellipsoid radii [equatorial polar]
    surface surfE = null, // surface of the Earth ellipsoid
    real prec = -1 // absolute error, -1: machine precision
)
{
    // if necessary, generate the surface of the Earth ellipsoid
    surface earthSurf;
    if ( surfE == null )
    {
        // make sure the provided raddi are valid (positive)
        assert( (radE.x > 0) && (radE.y > 0),
            "invalid radii for Earth ellipsoid." );

        // import function to generate an ellipsoid of revolution
        import ellipsoid;

        // generate the Earth ellipsoid and the Earth surface grid
        revolution earth = ellipsoid( radE.x, radE.y );
        earthSurf = surface( earth );
    }
    else { earthSurf = surfE; }

    // calculate the observation point on the orbit
    real obsTime = reltime( orbit, obsFrac );
    triple obsPt = relpoint( orbit, obsFrac );

    // calculate the unit vectors for the satellite position and velocity
    triple rn = unit( obsPt );
    triple vn = dir( orbit, obsTime );

    // calculate the local axes
    triple zl = -rn;
    triple yl = cross( zl, vn );
    triple xl = cross( yl, zl );
    //path3 xlVec = shift( obsPt ) * (O--xl);
    //path3 ylVec = shift( obsPt ) * (O--yl);
    //path3 zlVec = shift( obsPt ) * (O--zl);

    // calculate the look direction
    triple lookDir = rotate( lookAz, -zl ) * rotate( lookOff, -xl ) * (-obsPt);
    //triple lookDir = rotate( lookAz, endpoint(zlVec), obsPt ) *
        //rotate( lookOff, endpoint(xlVec), obsPt ) * O;

    //triple lookDir = rotate( lookAz, yl ) * rotate( lookOff, -xl ) * (-obsPt);
    //triple lookDir = rotate( lookAz, obsPt, endpoint(ylVec) ) *
        //rotate( lookOff, endpoint(xlVec), obsPt ) * O;

    // define the look vector
    path3 lookVec = shift( obsPt ) * (O--lookDir);
    //path3 lookVec = (obsPt--lookDir);

    // find and return the first intersection point between the look vector
    // and the surface of the Earth
    triple[] interPt = intersectionpoints( lookVec, earthSurf, prec );
    return interPt[0];
}

