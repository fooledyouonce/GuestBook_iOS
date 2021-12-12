//  PhotoCollectionViewCell.swift
//  GuestBook
//
//  Created by Emily Crowl on 12/9/21.

import SDWebImage
import UIKit

class PhotoCollectionViewCell: UICollectionViewCell {
    static let identifier = "PhotoCollectionViewCell"
    
    private let photoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        photoImageView.frame = contentView.bounds
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        photoImageView.image = nil
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = UIColor(named: "guestBookBG")
        contentView.addSubview(photoImageView)
        contentView.clipsToBounds = true
        accessibilityLabel = "user post image"
        accessibilityHint = "double tap to open post"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configure(with model: UserPost) {
        let url = model.thumbnailImage
        photoImageView.sd_setImage(with: url, completed: nil)
        /*let task = URLSession.shared.dataTask(with: URL, completionHandler: { data, _, _ in
            photoImageView.image = UIImage(data: data!)
        })*/
    }
    
    public func configure(debug imageName: String) {
        photoImageView.image = UIImage(named: imageName)
    }
}
