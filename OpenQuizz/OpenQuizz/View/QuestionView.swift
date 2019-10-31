//
//  QuestionView.swift
//  OpenQuizz
//
//  Created by Steve Bernard on 20/05/2019.
//  Copyright © 2019 Steve Bernard. All rights reserved.
//

import UIKit

class QuestionView: UIView {

    @IBOutlet private var label: UILabel!
    @IBOutlet private var icon:  UIImageView!
    
    enum Style {
        case correct, incorrect, standard
    }
    
    var style : Style = .standard {
        didSet {
            setStyle(style)
        }
    }
    
    private func setStyle(_ style: Style) {
        switch style {
        case .correct:
            backgroundColor = UIColor(red: 200/255.0, green: 236/255.0, blue: 160/255.0, alpha: 1)
            icon.image = #imageLiteral(resourceName: "Icon Correct")
            icon.isHidden = false
        case .incorrect:
            backgroundColor = #colorLiteral(red: 0.8980392157, green: 0.5490196078, blue: 0.5843137255, alpha: 1)
            icon.image = #imageLiteral(resourceName: "Icon Error")
            icon.isHidden = false
        case .standard:
            backgroundColor = #colorLiteral(red: 0.7529411765, green: 0.768627451, blue: 0.7882352941, alpha: 1)
            icon.isHidden = true
        }
    }
    
    var title = "" {
        didSet {
            label.text = title
        }
    }
}

