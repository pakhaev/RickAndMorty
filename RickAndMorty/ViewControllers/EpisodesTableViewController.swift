//
//  EpisodesTableViewController.swift
//  RickAndMorty
//
//  Created by Khusain on 14.05.2023.
//

import UIKit

final class EpisodesTableViewController: UITableViewController {

    // MARK: - Public properties
    var character: Character!
    var episodes: [Episode] = []
    
    // MARK: - Private properties
    private let networkManager = NetworkManager.shared
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Episodes"
    }

    // MARK: - Prepare
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let episodeVC = segue.destination as? EpisodeDetailsViewController else { return }
        
        episodeVC.episode = sender as? Episode
    }

}

// MARK: - Table view data source
extension EpisodesTableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return character.episode.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "episode", for: indexPath)
        var content = cell.defaultContentConfiguration()
        let episodeURL = character.episode[indexPath.row]
        
        networkManager.fetch(Episode.self, from: episodeURL) { [weak self] result in
            switch result {
            case .success(let episode):
                self?.episodes.append(episode)
                content.text = episode.name
                cell.contentConfiguration = content
            case .failure(let error):
                print(error)
            }
        }
        
        return cell
    }
}

// MARK: - Table view delegate

extension EpisodesTableViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let episode = episodes[indexPath.row]
        performSegue(withIdentifier: "showEpisode", sender: episode)
    }
}
