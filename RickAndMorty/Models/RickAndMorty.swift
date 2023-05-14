//
//  RickAndMorty.swift
//  RickAndMorty
//
//  Created by Khusain on 13.05.2023.
//

import Foundation

struct RickAndMorty: Decodable {
    let info: Info
    var results: [Character]
}

struct Info: Decodable {
    let next: String?
    let prev: String?
}

struct Character: Decodable {
    let id: Int
    let name: String
    let status: String
    let species: String
    let gender: String
    let origin: Origin
    let location: Origin
    let image: String
    let episode: [String]
    
    var description: String {
        """
        Name: \(name)
        Status: \(status)
        Species: \(species)
        Gender: \(gender)
        Location: \(location.name)
        Origin: \(origin.name)
        """
    }
}

struct Origin: Decodable {
    let name: String
}

struct Episode: Decodable {
    let name: String
    let date: String
    let episode: String
    let characters: [String]
    
    var description: String {
        """
        Episode name: \(name)
        Date: \(date)
        """
    }
    
    enum CodingKeys: String, CodingKey {
        case name = "name"
        case date = "air_date"
        case episode = "episode"
        case characters = "characters"
    }
}

enum Link: String {
    case rickAndMortyApi = "https://rickandmortyapi.com/api/character"
}
