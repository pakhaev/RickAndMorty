//
//  CharacterDetailViewController.swift
//  RickAndMorty
//
//  Created by Khusain on 14.05.2023.
//

import UIKit

final class CharacterDetailViewController: UIViewController {

    // MARK: - IB Outlets
    @IBOutlet var characterImageView: UIImageView! {
        didSet {
            characterImageView.layer.cornerRadius = characterImageView.frame.height / 2
        }
    }
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var imageActivityIndicator: UIActivityIndicatorView!
    
    // MARK: - Public properties
    var character: Character!
    
    // MARK: - Private properties
    private let networkManager = NetworkManager.shared
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageActivityIndicator.startAnimating()
        imageActivityIndicator.hidesWhenStopped = true
        imageActivityIndicator.color = .gray
        
        setupViewControllers()
    }
    
    // MARK: - Prepare
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let navigationVC = segue.destination as? UINavigationController else { return }
        guard let episodesVC = navigationVC.topViewController as? EpisodesTableViewController else { return }
        episodesVC.character = character
    }
}

// MARK: - Setup UI
extension CharacterDetailViewController {
    private func setupViewControllers() {
        title = character.name
        
        descriptionLabel.text = character.description
        
        networkManager.fetchImage(from: character.image) { [weak self] result in
            switch result {
            case .success(let imageData):
                self?.characterImageView.image = UIImage(data: imageData)
                self?.imageActivityIndicator.stopAnimating()
            case .failure(let error):
                print(error)
            }
        }
    }
}
