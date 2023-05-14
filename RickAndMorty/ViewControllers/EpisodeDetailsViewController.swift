//
//  EpisodeDetailsViewController.swift
//  RickAndMorty
//
//  Created by Khusain on 14.05.2023.
//

import UIKit

final class EpisodeDetailsViewController: UIViewController {

    // MARK: - IB Outlets
    @IBOutlet var infoEpisodeLabel: UILabel!
    @IBOutlet var tableView: UITableView!
    
    // MARK: - Public properties
    var episode: Episode!
    
    // MARK: - Private properties
    private var characters: [Character] = [] {
        didSet {
            if characters.count == episode.characters.count {
                characters = characters.sorted { $0.id < $1.id }
            }
        }
    }
    private let networkManager = NetworkManager.shared
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setCharacters()
        title = episode.name
        infoEpisodeLabel.text = episode.description

    }
    
    // MARK: - Prepare
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let characterDetailVC = segue.destination as? CharacterDetailViewController else { return }
        characterDetailVC.character = sender as? Character
    }
}

// MARK: - Fetch func
extension EpisodeDetailsViewController {
    private func setCharacters() {
        episode.characters.forEach { characterURL in
            networkManager.fetch(Character.self, from: characterURL) { [weak self] result in
                switch result {
                case .success(let character):
                    self?.characters.append(character)
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
}

// MARK: - UITableViewDataSource
extension EpisodeDetailsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "characterCell", for: indexPath) as? CharacterTableViewCell else { return UITableViewCell() }
        
        let characterURL = episode.characters[indexPath.row]
        
        networkManager.fetch(Character.self, from: characterURL) { result in
            switch result {
            case .success(let character):
                cell.configure(with: character)
            case .failure(let error):
                print(error)
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        episode.characters.count
    }
}

// MARK: - UITableViewDelegate
extension EpisodeDetailsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let character = characters[indexPath.row]
        performSegue(withIdentifier: "showCharacter", sender: character)
    }
}
