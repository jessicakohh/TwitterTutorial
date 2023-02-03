//
//  EditProfileCell.swift
//  TwitterTutorial
//
//  Created by juyeong koh on 2023/02/03.
//

import Foundation

import UIKit

class EditProfileCell: UITableViewCell {
    
    // MARK: - properties
    
    // MARK: - LifeCycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .systemPink
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Selectors
    
    // MARK: - API
    
    // MARK: - Helpers

}
