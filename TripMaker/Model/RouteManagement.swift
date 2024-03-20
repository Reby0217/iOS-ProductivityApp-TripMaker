//
//  RouteManagement.swift
//  TripMaker
//
//  Created by Kejia Liu on 2024-03-20.
//

import Foundation
import SQLite

extension DBManager {
    
    /**
    - Description: Adds a new route to the database with a specified map picture.
    - Returns: The UUID of the newly created route.
    */
    func addRoute(name: String, mapPicture: String) throws -> UUID {
        let routeID = UUID()
        let insert = routeTable.table.insert(
            routeTable.routeID <- routeID,
            routeTable.name <- name,
            routeTable.mapPicture <- mapPicture
        )
        try db?.run(insert)
        return routeID
    }


    /**
        - Description: Retrieves the UUID of a specific route by name.
        - Returns: UUID
        */
        func fetchRouteIDbyName(name: String) throws -> UUID {
            let query = routeTable.table.filter(routeTable.name == name)
            guard let routeRecord = try db?.pluck(query) else {
                throw NSError(domain: "Route Not Found!", code: 404, userInfo: nil)
            }
            return routeRecord[routeTable.routeID]
        }


    /**
    - Description: Retrieves the details of a specific route by routeID, including all the location IDs that belong to the route.
    - Returns: A Route object containing the route ID, array of location IDs, and the map picture
    */
    func fetchRouteDetails(routeID: UUID) throws -> Route {
        let query = routeTable.table.filter(routeTable.routeID == routeID)
        guard let routeRecord = try db?.pluck(query) else {
            throw NSError(domain: "Route Not Found!", code: 404, userInfo: nil)
        }
        
        let name = routeRecord[routeTable.name]
        let mapPicture = routeRecord[routeTable.mapPicture]
        let locationsQuery = locationTable.table.filter(locationTable.routeID == routeID)
        let locationRecords = try db?.prepare(locationsQuery)
        let locationIDs = locationRecords?.map { $0[locationTable.locationID] } ?? []
        
        return Route(routeID: routeID, name: name, locationArray: locationIDs, mapPicture: mapPicture)
    }



    /**
    - Description: Deletes a route with given UUID from the database.
    - Returns: void
    */
    func deleteRoute(routeID: UUID) throws {
        let route = routeTable.table.filter(routeTable.routeID == routeID)
        try db?.run(route.delete())
    }

}
