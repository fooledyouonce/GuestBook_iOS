//  ProfileInfoHeaderCollectionReusableView.swift
//  GuestBook
//
//  Created by Emily Crowl on 12/9/21.

import UIKit

protocol ProfileInfoHeaderCollectionReusableViewDelegate: AnyObject {
    func profileHeaderDidTapPostsButton(_ header: ProfileInfoHeaderCollectionReusableView)
    func profileHeaderDidTapFollowersButton(_ header: ProfileInfoHeaderCollectionReusableView)
    func profileHeaderDidTapFollowingButton(_ header: ProfileInfoHeaderCollectionReusableView)
    func profileHeaderDidTapEditProfileButton(_ header: ProfileInfoHeaderCollectionReusableView)
}

final class ProfileInfoHeaderCollectionReusableView: UICollectionReusableView {
    static let identifier = "ProfileInfoHeaderCollectionReusableView"
    
    public weak var delegate: ProfileInfoHeaderCollectionReusableViewDelegate?
    
    private let profilePhotoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .gray
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    private let postsButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.label, for: .normal)
        button.setTitle("bio", for: .normal)
        return button
    }()
    
    /*private let followersButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.label, for: .normal)
        button.setTitle("followers", for: .normal)
        return button
    }()*/
    
    /*private let followingButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.label, for: .normal)
        button.setTitle("following", for: .normal)
        return button
    }()*/
    
    private let editProfileButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.label, for: .normal)
        button.setTitle("edit profile", for: .normal)
        return button
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "alan turing"
        label.textColor = .label
        label.numberOfLines = 1
        return label
    }()
    
    private let bioLabel: UILabel = {
        let label = UILabel()
        label.text = "prototype guestbook app!"
        label.textColor = .label
        label.numberOfLines = 0 //line wrap
        return label
    }()
    
    //MARK: init
    
    override init(frame: CGRect){
        super.init(frame: frame)
        addSubviews() //addSubview(view: view) adds a subview to the View. This function is adding multiple
        addButtonActions()
        backgroundColor = UIColor(named: "guestBookBG") //changed
        clipsToBounds = true
    }
    
    private func addSubviews() {
        addSubview(profilePhotoImageView)
        addSubview(postsButton)
        //addSubview(followingButton)
        //addSubview(followersButton)
        addSubview(editProfileButton)
        addSubview(nameLabel)
        addSubview(bioLabel)
    }
    
    private func addButtonActions() {
        postsButton.addTarget(self, action: #selector(didTapPostsButton), for: .touchUpInside)
        //followersButton.addTarget(self, action: #selector(didTapFollowersButton), for: .touchUpInside)
        //followingButton.addTarget(self, action: #selector(didTapFollowingButton), for: .touchUpInside)
        editProfileButton.addTarget(self, action: #selector(didTapEditProfileButton), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() { //stylizes the subviews
        super.layoutSubviews()
        
        let profilePhotoSize = width/4 //1/4 of view
        profilePhotoImageView.frame = CGRect(x: 5, y: 5, width: profilePhotoSize, height: profilePhotoSize).integral
    
        profilePhotoImageView.layer.cornerRadius = profilePhotoSize/2
        
        let buttonHeight = profilePhotoSize/2
        let countButtonWidth = (width-10-profilePhotoSize)/3
        
        postsButton.frame = CGRect(x: profilePhotoImageView.right, y: 5, width: countButtonWidth, height: buttonHeight).integral
        
        //followersButton.frame = CGRect(x: postsButton.right, y: 5, width: countButtonWidth, height: buttonHeight).integral
        
        //followingButton.frame = CGRect(x: followersButton.right, y: 5, width: countButtonWidth, height: buttonHeight).integral
        
        editProfileButton.frame = CGRect(x: profilePhotoImageView.right, y: 5 + buttonHeight, width: countButtonWidth * 3, height: buttonHeight).integral
        
        nameLabel.frame = CGRect(x: 5, y: 5 + profilePhotoImageView.bottom, width: width - 10, height: 50).integral
        
        let bioLabelSize = bioLabel.sizeThatFits(frame.size)
        bioLabel.frame = CGRect(x: 5, y: 5 + nameLabel.bottom, width: width - 10, height: bioLabelSize.height).integral
    }
    
    //MARK: actions
    @objc private func didTapPostsButton() {
        delegate?.profileHeaderDidTapPostsButton(self) //reference to current view
    }
    
    //@objc private func didTapFollowersButton() {
    //    delegate?.profileHeaderDidTapFollowersButton(self)
    //}
    
   // @objc private func didTapFollowingButton() {
   //     delegate?.profileHeaderDidTapFollowingButton(self)
  //}
    
    @objc private func didTapEditProfileButton() {
        delegate?.profileHeaderDidTapEditProfileButton(self)
    }
}
