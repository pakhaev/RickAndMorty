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
    
    init(info: [String: Any], results: [Character]) {
        self.info = Info(from: info)
        self.results = results
    }
    
    init(info: Info, results: [Character]) {
        self.info = info
        self.results = results
    }
    
    static func getRickAndMorty(from value: Any) -> RickAndMorty {
        guard let charactersData = value as? [String: Any] else {
            return RickAndMorty(info: [:], results: [])
        }
        
        guard let info = charactersData["info"] as? [String: Any] else {            return RickAndMorty(info: [:], results: [])
        }
        guard let characters = charactersData["results"] as? [[String: Any]] else {
            return RickAndMorty(info: [:], results: [])
        }
        
        return RickAndMorty(info: info, results: characters.map{ Character(from: $0)})
    }
}

struct Info: Decodable {
    let next: String?
    
    init(next: String?) {
        self.next = next
    }
    
    init(from characterData: [String: Any]) {
        next = characterData["next"] as? String
    }
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
    
    init(
        id: Int,
        name: String,
        status: String,
        species: String,
        gender: String,
        origin: Origin,
        location: Origin,
        image: String,
        episode: [String]
    ) {
        self.id = id
        self.name = name
        self.status = status
        self.species = species
        self.gender = gender
        self.origin = origin
        self.location = location
        self.image = image
        self.episode = episode
    }
    
    init(from characterData: [String: Any]) {
        id = characterData["id"] as? Int ?? 0
        name = characterData["name"] as? String ?? ""
        status = characterData["status"] as? String ?? ""
        species = characterData["species"] as? String ?? ""
        gender = characterData["gender"] as? String ?? ""
        origin = Origin(from: characterData["origin"] as? [String: Any] ?? [:])
        location = Origin(from: characterData["location"] as? [String: Any] ?? [:])
        image = characterData["image"] as? String ?? ""
        episode = characterData["episode"] as? [String] ?? [""]
    }
    
    static func getCharacter(from value: Any) -> Character {
        guard let charactersData = value as? [String: Any] else {
            return Character(from: [:])
        }
        
        return Character(from: charactersData)
    }
    
}

struct Origin: Decodable {
    let name: String
    
    init(name: String) {
        self.name = name
    }
    
    init(from originData: [String: Any]) {
        name = originData["name"] as? String ?? ""
    }
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
    
    init(name: String, date: String, episode: String, characters: [String]) {
        self.name = name
        self.date = date
        self.episode = episode
        self.characters = characters
    }
    
    init(from episodesData: [String: Any]) {
        name = episodesData["name"] as? String ?? ""
        date = episodesData["air_date"] as? String ?? ""
        episode = episodesData["episode"] as? String ?? ""
        characters = episodesData["characters"] as? [String] ?? [""]
    }
    
    static func getEpisode(from value: Any) -> Episode {
        guard let episodeData = value as? [String: Any] else {
            return Episode(from: [:])
        }
        
        return Episode(from: episodeData)
    }
}

enum Link: String {
    case rickAndMortyApi = "https://rickandmortyapi.com/api/character"
}
