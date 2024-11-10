//
//  PolygonRegion.swift
//  ARMultiuser
//
//  Created by admin on 11/9/24.
//  Copyright © 2024 Apple. All rights reserved.
//

import Foundation
import CoreLocation

struct PolygonRegion {

    let verticies:[CLLocationCoordinate2D]
    private var maxLat: CLLocationDegrees!
    private var maxLon: CLLocationDegrees!
    private var minLat: CLLocationDegrees!
    private var minLon: CLLocationDegrees!
    private var epsilon: CLLocationDegrees

    var center: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: minLat+(maxLat-minLat)/2, longitude: minLon+(maxLon-minLon)/2)
    }

    var latSpan: CLLocationDegrees {
        return abs(maxLat-minLat)
    }

    var lonSpan: CLLocationDegrees {
        return abs(maxLon-minLon)
    }

    init(verticies: [CLLocationCoordinate2D], epsilon: CLLocationDegrees = 0.01) {
        self.verticies = verticies
        self.epsilon = epsilon

        for point in self.verticies {
            maxLat = maxLat != nil ? max(maxLat, point.latitude):point.latitude
            maxLon = maxLon != nil ? max(maxLon, point.longitude):point.longitude
            minLat = minLat != nil ? min(minLat, point.latitude):point.latitude
            minLon = minLon != nil ? min(minLon, point.longitude):point.longitude
        }
    }

    public func isPointInside(_ testPoint: CLLocationCoordinate2D) -> Bool {
        guard isInsideBoundingBox(testPoint) else {
            return false
        }

        var intersections = 0

        let outsidePoint = CLLocationCoordinate2D(latitude: self.minLat - epsilon, longitude: testPoint.longitude)

        let testRay = Ray(point1: outsidePoint, point2: testPoint)

        for index in 0..<verticies.count {
            let edge = Ray(point1: verticies[index], point2: verticies[(index+1)%verticies.count])
            if intersectionType(testRay,edge) == .intersecting {
                intersections += 1
            }

        }

        if intersections % 2 == 0 {
            return false
        }

        return true
    }


    private func isInsideBoundingBox(_ testPoint: CLLocationCoordinate2D) -> Bool {

        return !( testPoint.latitude < minLat || testPoint.latitude > maxLat || testPoint.longitude < minLon || testPoint.longitude > maxLon )
    }

    // See https://stackoverflow.com/questions/217578/how-can-i-determine-whether-a-2d-point-is-within-a-polygon/218081?s=1|193.4130#218081

    private func intersectionType(_ ray1: Ray, _ ray2: Ray) -> IntersectionType {

        var d1,d2: Double
        var a1,a2,b1,b2,c1,c2: Double

        let v1x1 = ray1.point1.latitude
        let v1y1 = ray1.point1.longitude
        let v1x2 = ray1.point2.latitude
        let v1y2 = ray1.point2.longitude

        let v2x1 = ray2.point1.latitude
        let v2y1 = ray2.point1.longitude
        let v2x2 = ray2.point2.latitude
        let v2y2 = ray2.point2.longitude

        // Convert vector 1 to a line (line 1) of infinite length.
        // We want the line in linear equation standard form: A*x + B*y + C = 0
        // See: http://en.wikipedia.org/wiki/Linear_equation
        a1 = v1y2 - v1y1
        b1 = v1x1 - v1x2
        c1 = (v1x2 * v1y1) - (v1x1 * v1y2)

        // Every point (x,y), that solves the equation above, is on the line,
        // every point that does not solve it, is not. The equation will have a
        // positive result if it is on one side of the line and a negative one
        // if is on the other side of it. We insert (x1,y1) and (x2,y2) of vector
        // 2 into the equation above.
        d1 = (a1 * v2x1) + (b1 * v2y1) + c1
        d2 = (a1 * v2x2) + (b1 * v2y2) + c1

        // If d1 and d2 both have the same sign, they are both on the same side
        // of our line 1 and in that case no intersection is possible. Careful,
        // 0 is a special case, that's why we don't test ">=" and "<=",
        // but "<" and ">".
        if (d1 > 0 && d2 > 0) || (d1 < 0 && d2 < 0) {
            return .nonIntersecting
        }

        // The fact that vector 2 intersected the infinite line 1 above doesn't
        // mean it also intersects the vector 1. Vector 1 is only a subset of that
        // infinite line 1, so it may have intersected that line before the vector
        // started or after it ended. To know for sure, we have to repeat the
        // the same test the other way round. We start by calculating the
        // infinite line 2 in linear equation standard form.
        a2 = v2y2 - v2y1
        b2 = v2x1 - v2x2
        c2 = (v2x2 * v2y1) - (v2x1 * v2y2)

        // Calculate d1 and d2 again, this time using points of vector 1.
        d1 = (a2 * v1x1) + (b2 * v1y1) + c2
        d2 = (a2 * v1x2) + (b2 * v1y2) + c2

        // Again, if both have the same sign (and neither one is 0),
        // no intersection is possible.
        if (d1 > 0 && d2 > 0) || (d1 < 0 && d2 < 0) {
            return .nonIntersecting
        }

        // If we get here, only two possibilities are left. Either the two
        // vectors intersect in exactly one point or they are collinear, which
        // means they intersect in any number of points from zero to infinite.
        if (a1 * b2) - (a2 * b1) == 0.0 {
            return .coLinear
        }

        // If they are not collinear, they must intersect in exactly one point.
        return .intersecting
    }

    private struct Ray {
        let point1: CLLocationCoordinate2D
        let point2: CLLocationCoordinate2D
    }

    private enum IntersectionType {
        case intersecting
        case nonIntersecting
        case coLinear
    }

}
