//
//  GBFeedPostActionTableViewCell.swift
//  GuestBook
//
//  Created by Emily Crowl on 12/8/21.
//

import UIKit

protocol GBFeedPostActionsTableViewCellDelegate: AnyObject {
    func didTapLikeButton()
    func didTapCommentButton()
    //func didTapSendButton()
}

class GBFeedPostActionsTableViewCell: UITableViewCell {

    weak var delegate: GBFeedPostActionsTableViewCellDelegate?

    static let identifier = "GBFeedPostActionsTableViewCell"

    private let likeButton: UIButton = {
        let button = UIButton()
        let config = UIImage.SymbolConfiguration(pointSize: 30, weight: .thin)
        let image = UIImage(systemName: "heart", withConfiguration: config)
        button.setImage(image, for: .normal)
        button.tintColor = .label
        return button
    }()

    private let commentButton: UIButton = {
        let button = UIButton()
        let config = UIImage.SymbolConfiguration(pointSize: 30, weight: .thin)
        let image = UIImage(systemName: "message", withConfiguration: config)
        button.setImage(image, for: .normal)
        button.tintColor = .label
        return button
    }()

    /*private let sendButton: UIButton = {
        let button = UIButton()
        let config = UIImage.SymbolConfiguration(pointSize: 30, weight: .thin)
        let image = UIImage(systemName: "paperplane", withConfiguration: config)
        button.setImage(image, for: .normal)
        button.tintColor = .label
        return button
    }()*/

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(likeButton)
        contentView.addSubview(commentButton)
       // contentView.addSubview(sendButton)
        
        contentView.backgroundColor = UIColor(named: "guestBookBG")

        likeButton.addTarget(self, action: #selector(didTapLikeButton), for: .touchUpInside)
        commentButton.addTarget(self, action: #selector(didTapCommentButton), for: .touchUpInside)
       // sendButton.addTarget(self, action: #selector(didTapSendButton), for: .touchUpInside)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc private func didTapLikeButton() {
        delegate?.didTapLikeButton()
    }

    @objc private func didTapCommentButton() {
        delegate?.didTapCommentButton()
    }

    //@objc private func didTapSendButton() {
    //     delegate?.didTapSendButton()
    //}

    public func configure(with post: UserPost) {
        // configure the cell
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        // like, comment, send
        let buttonSize = contentView.height-10

        let buttons = [likeButton, commentButton]
        for x in 0..<buttons.count {
            let button = buttons[x]
            button.frame = CGRect(x: (CGFloat(x)*buttonSize) + (10*CGFloat(x+1)), y: 5, width: buttonSize, height: buttonSize)
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()

    }

}
