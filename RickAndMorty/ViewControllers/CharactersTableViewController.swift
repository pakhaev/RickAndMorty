//
//  CharactersTableViewController.swift
//  RickAndMorty
//
//  Created by Khusain on 13.05.2023.
//

import UIKit

final class CharactersTableViewController: UITableViewController {

    // MARK: - Private properties
    private let networkManager = NetworkManager.shared
    private var rickAndMorty: RickAndMorty?
    private var nextPage: String?
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Rick and Morty"
        fetchData(from: Link.rickAndMortyApi.rawValue)
    }

    // MARK: - Prepare
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let indexPath = tableView.indexPathForSelectedRow else { return }
        let character = rickAndMorty?.results[indexPath.row]
        
        guard let detailsVC = segue.destination as? CharacterDetailViewController else { return }
        detailsVC.character = character
    }
}

// MARK: - Fetch funcs
extension CharactersTableViewController {
    private func fetchData(from url: String?) {
        
        networkManager.fetch(RickAndMorty.self, from: url) {[weak self] result in
            switch result {
            case .success(let rickAndMorty):
                self?.rickAndMorty = rickAndMorty
                self?.nextPage = rickAndMorty.info.next
                self?.tableView.reloadData()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func getNextPage(from url: String?) {
        networkManager.fetch(RickAndMorty.self, from: url) { [weak self] result in
            guard let self = self else {return}
            switch result {
            case .success(let rickAndMorty):
                self.rickAndMorty?.results.append(contentsOf: rickAndMorty.results)
                self.nextPage = rickAndMorty.info.next
                self.tableView.reloadData()
            case .failure(let error):
                print(error)
            }
        }
    }
}

// MARK: - Table view data source
extension CharactersTableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rickAndMorty?.results.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "characterCell", for: indexPath)
        
        guard let cell = cell as? CharacterTableViewCell else { return UITableViewCell() }
        
        let character = rickAndMorty?.results[indexPath.row]
        cell.configure(with: character)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let results = rickAndMorty?.results else { return }
        
        if results.count - indexPath.row <= 3 {
            getNextPage(from: nextPage)
        }
    }
}
