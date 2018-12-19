//
//  QuoteMessageView.swift
//  ChattoAdditions
//
//  Created by bigstep_macbook_air on 03/10/18.
//  Copyright © 2018 Badoo. All rights reserved.
//

import Foundation
import UIKit

open class QuoteMessageView: UIView {
    private let imageHeight:CGFloat = 35
    private let idicatorWidth:CGFloat = 2
    private let maxWidth:CGFloat = 210
    
    private var containerView: UIStackView = {
        let view = UIStackView()
        return view
    }()
    
    open var stackView : UIStackView = {
        let stackView  = UIStackView()
        return stackView
    }()
    
    open var nameView:  UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.textAlignment = .left
        return label
    }()
    
    open var messageView: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        label.textAlignment = .left
        return label
    }()
    
    open var imageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    private var indicatorView: UIView = {
        let view = UIView()
        return view
    }()
    
    init(){
        super.init(frame: .zero)
        setupContainerView()
        setupStackView()
        createConstraints()
        self.stackView.frame = self.frame
    }
    
    private func setupContainerView(){
        containerView.axis = .vertical
        containerView.distribution = .equalSpacing
        containerView.isBaselineRelativeArrangement = true
        containerView.spacing = 5.0
        containerView.addArrangedSubview(nameView)
        containerView.addArrangedSubview(messageView)
    }
    
    private func setupStackView(){
        stackView.axis = .horizontal
        stackView.spacing = 7.0
        [indicatorView,containerView,imageView].forEach{
            stackView.addArrangedSubview($0)
        }
        stackView.isBaselineRelativeArrangement = true
        self.addSubview(stackView)
    }
    
    private func createConstraints() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: stackView.topAnchor),
            bottomAnchor.constraint(equalTo: stackView.bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.widthAnchor.constraint(equalToConstant: maxWidth),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            indicatorView.widthAnchor.constraint(equalToConstant: idicatorWidth),
            imageView.widthAnchor.constraint(equalToConstant: imageHeight),
            imageView.heightAnchor.constraint(equalToConstant: imageHeight)
        ])
    }
    
    func setIndicatorColor(_ color:UIColor){
        self.indicatorView.backgroundColor = color
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
