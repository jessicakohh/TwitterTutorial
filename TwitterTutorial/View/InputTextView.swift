//
//  CaptionTextView.swift
//  TwitterTutorial
//
//  Created by juyeong koh on 2023/01/18.
//

import UIKit

class InputTextView: UITextView {
    let placeholderLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .darkGray
        label.text = "무슨일이 일어나고 있나요?"
        return label
    }()
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        
        backgroundColor = .white
        font = UIFont.systemFont(ofSize: 16)
        isScrollEnabled = false
        heightAnchor.constraint(equalToConstant: 100).isActive = true
        addSubview(placeholderLabel)
        placeholderLabel.anchor(top: topAnchor,
                                left: leftAnchor,
                                paddingTop: 8,
                                paddingLeft: 4)
        NotificationCenter.default.addObserver(self, selector: #selector(handleTextInputChange),
                                               name: UITextView.textDidChangeNotification,
                                               object: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Selectors
    @objc func handleTextInputChange() {
//        print("DEBUG : Hide and show placeholder / 플레이스홀더 숨기기 및 표시")
        placeholderLabel.isHidden = !text.isEmpty
    }
}
