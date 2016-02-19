// -------------------------------------------------------------------------- //
// markAngle3: mark an angle in 3D
//
// Function that generates and draws a marker (an arc) for an angle in 3D. It
// is inspired from the "markangle3D" Asymptote function available on the web.
//
// Author: Louis-Philippe Rousseau (ULaval)
// Created: February 2016

// TODO: detect and handle right angles?

// import useful modules
import three;

void markAngle3(
    Label L = "", // label
    align al = NoAlign, // label alignment
    triple C, // vertex of the angle
    triple A, // first side of the angle
    triple B, // second side of the angle
    real rad = 0.1, // radius as a relative length of the shortest side
    bool cc = true, // draw the angle in the counterclockwise direction?
    pen p = currentpen, // pen for the angle arc
    pen fillpen = nullpen, // pen for the angle area (filling)
    arrowbar3 arrow = None // arrow for the angle arc
)
{
    // calculate the length of each side
    real lenCA = abs( A - C );
    real lenCB = abs( B - C );

    // choose the reference length (minimum)
    real lenRef = min( lenCA, lenCB );

    // define the points on each side used to draw the angle arc
    triple Arel = relpoint( C--A, rad * lenRef / lenCA );
    triple Brel = relpoint( C--B, rad * lenRef / lenCB );

    // define the normal to the angle arc
    triple norm = normal(C--Arel--Brel);
    if (!cc) { norm = -norm; }

    // generate the angle arc
    path3 ang = arc( C, Arel, Brel, norm );

    // draw the angle area and arc
    if (fillpen != nullpen)
    {
        draw( surface( C--ang--cycle ), fillpen, nolight );
    }
    draw( L, ang, al, p, arrow );
}

