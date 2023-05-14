//
//  CharacterTableViewCell.swift
//  RickAndMorty
//
//  Created by Khusain on 13.05.2023.
//

import UIKit

class CharacterTableViewCell: UITableViewCell {

    // MARK: - IB Outlets
    @IBOutlet var characterImageView: UIImageView! {
        didSet {
            characterImageView.contentMode = .scaleAspectFit
            characterImageView.clipsToBounds = true
            characterImageView.layer.cornerRadius = characterImageView.frame.height / 2
            characterImageView.backgroundColor = .white
        }
    }
    @IBOutlet var characterNameLabel: UILabel!
    
    // MARK: - Private properties
    private let networkManager = NetworkManager.shared
    
    // MARK: - Setup UI
    func configure(with character: Character?) {
        characterNameLabel.text = character?.name
        
        networkManager.fetchImage(from: character?.image) { [weak self] result in
            switch result {
            case .success(let imageData):
                self?.characterImageView.image = UIImage(data: imageData)
            case .failure(let error):
                print(error)
            }
        }
    }
}
