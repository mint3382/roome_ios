//
//  BackButton.swift
//  roome
//
//  Created by minsong kim on 5/22/24.
//

import UIKit

class BackButton: UIButton {
    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        customBackButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func customBackButton() {
        var buttonConfiguration = UIButton.Configuration.plain()
        buttonConfiguration.image = UIImage(systemName: "chevron.backward")?.resize(newWidth: 20).changeImageColor(.label)
        
        self.configuration = buttonConfiguration
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func updateButton(image: UIImage?) {
        self.configuration?.image = image
    }
}
