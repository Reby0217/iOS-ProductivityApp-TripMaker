//
//  LocationManagement.swift
//  TripMaker
//
//  Created by Kejia Liu on 2024-03-20.
//

import Foundation
import SQLite

extension DBManager {
    
    /**
    - Description: Adds a new location to an existing route identified by routeID.
    - Returns: A UUID that uniquely identifies the newly added location.
    */
    func addLocationToRoute(routeID: UUID, name: String, realPicture: String, description: String, isLocked: Bool) throws -> UUID {
        let locationID = UUID()
        let insert = locationTable.table.insert(
            locationTable.locationID <- locationID,
            locationTable.routeID <- routeID,
            locationTable.name <- name,
            locationTable.realPicture <- realPicture,
            locationTable.description <- description,
            locationTable.isLocked <- isLocked
        )
        try db?.run(insert)
        return locationID
    }
    
    
    /**
    - Description: Retrieves all locations associated with a given route ID, including their tags.
    - Returns: An array of Location objects, each representing a location on the route with its associated tags.
    */
    func fetchLocationsForRoute(routeID: UUID) throws -> [Location] {
        let query = locationTable.table.join(tagTable.table, on: locationTable.locationID == tagTable.locationID)
            .filter(locationTable.routeID == routeID)
            .select(locationTable.table[*], tagTable.tag)

        var locations: [UUID: Location] = [:]

        for row in try db!.prepare(query) {
            let locationID = row[locationTable.locationID]
            let tag = row[tagTable.tag]
            
            if var location = locations[locationID] {
                location.tagsArray.append(tag)
                locations[locationID] = location
            } else {
                let location = Location(
                    name: row[locationTable.name],
                    locationID: locationID,
                    realPicture: row[locationTable.realPicture],
                    tagsArray: [tag],
                    description: row[locationTable.description],
                    isLocked: row[locationTable.isLocked]
                )
                locations[locationID] = location
            }
        }
        
        return Array(locations.values)
    }
    
    /**
    - Description: Updates the details of an existing location identified by locationID.
    - Returns: void
    */
    func updateLocation(locationID: UUID, newName: String, newRealPicture: String, newDescription: String, newIsLocked: Bool) throws {
        let locationToUpdate = locationTable.table.filter(locationTable.locationID == locationID)
        try db?.run(locationToUpdate.update(
            locationTable.name <- newName,
            locationTable.realPicture <- newRealPicture,
            locationTable.description <- newDescription,
            locationTable.isLocked <- newIsLocked
        ))
    }
    
    
    /**
    - Description: Removes an existing location from the database.
    - Returns: void
    */
    func deleteLocation(locationID: UUID) throws {
        let locationToDelete = locationTable.table.filter(locationTable.locationID == locationID)
        try db?.run(locationToDelete.delete())
    }
    
    
    /**
    - Description: Fetches all tags associated with a specific location.
    - Returns: An array of strings representing the tags associated with the location. Returns an empty array if no tags are found or in case of an error.
    */
    func fetchTagsForLocation(locationID: UUID) throws -> [String] {
        let tagsQuery = tagTable.table.filter(tagTable.locationID == locationID).select(tagTable.tag)
        let tagsRecords = try db?.prepare(tagsQuery)
        return tagsRecords?.map { $0[tagTable.tag] } ?? []
    }
    
    
    /**
    - Description: Fetches a single location's details by locationID.
    - Returns: A Location object containing the details of the location.
    */
    func fetchLocationDetails(locationID: UUID) throws -> Location {
        let query = locationTable.table.filter(locationTable.locationID == locationID)
        
        guard let location = try db?.pluck(query) else {
            throw NSError(domain: "Location Not Found!", code: 404, userInfo: nil)
        }
        
        let tags = try fetchTagsForLocation(locationID: locationID)

        return Location(
            name: location[locationTable.name],
            locationID: locationID,
            realPicture: location[locationTable.realPicture],
            tagsArray: tags,
            description: location[locationTable.description],
            isLocked: location[locationTable.isLocked]
        )
    }
    
    
    /**
    - Description: Updates the lock status of a specific location identified by locationID.
    - Returns: void
    */
    func updateLocationLockStatus(locationID: UUID, isLocked: Bool) throws {
        let location = locationTable.table.filter(locationTable.locationID == locationID)
        try db?.run(location.update(locationTable.isLocked <- isLocked))
    }
    
    
    /**
    - Description: Adds a new tag to a location. The tag is associated with the location identified by locationID.
    - Returns: void
    */
    func addTagToLocation(locationID: UUID, tag: String) throws {
        let insert = tagTable.table.insert(
            tagTable.tagID <- UUID(),
            tagTable.locationID <- locationID,
            tagTable.tag <- tag
        )
        try db?.run(insert)
    }
    
    
}
