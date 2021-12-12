//
//  GBFeedPostGeneralCellTableViewCell.swift
//  GuestBook
//
//  Created by Emily Crowl on 12/8/21.
//

import UIKit

class GBFeedPostGeneralCellTableViewCell: UITableViewCell {

    static let identifier = "GBFeedPostGeneralTableViewCell"

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = UIColor(named: "guestBookBG")
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func configure() {
        // configure the cell
    }

    override func layoutSubviews() {
        super.layoutSubviews()
    }
}
