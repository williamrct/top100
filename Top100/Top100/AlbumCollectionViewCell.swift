//
//  AlbumCollectionViewCell.swift
//  Top100
//
//  Created by William Rodriguez on 7/8/22.
//
//

import UIKit

class AlbumCollectionViewCell: UICollectionViewCell {
    static let identifier = "AlbumCell"
    
    var albumId: String
    var albumName: String
    var artistId: String
    var artistName: String
    
    lazy var topSpacerView: UIView = {
        let view = UIView(frame: CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(UIScreen.main.bounds.width), height: CGFloat(14)))
        return view
    }()
    
    lazy var albumImageView: UIImageView = {
        let imageView = UIImageView(frame: CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(self.frame.width - 12), height: CGFloat(self.frame.width - 12)))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 30
        imageView.clipsToBounds = true
        return imageView
    }()
    
    lazy var albumNameLBL: UILabel = {
        let label = UILabel(frame: CGRect(x: CGFloat(12), y: CGFloat(self.frame.height - 40), width: CGFloat(self.frame.width - 24), height: CGFloat(40)))
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.semibold)
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.textColor = UIColor.white
        label.text = "Album Name"
        return label
    }()
    
    lazy var artistNameLBL: UILabel = {
        let label = UILabel(frame: CGRect(x: CGFloat(22), y: CGFloat(self.frame.height - 26), width: CGFloat(self.frame.width - 24), height: CGFloat(14)))
        label.font = UIFont.systemFont(ofSize: 12, weight: UIFont.Weight.medium)
        label.textColor = UIColor.gray
        label.text = "Artist Name"
        return label
    }()
    
    override init(frame: CGRect) {
        self.albumId = ""
        self.albumName = ""
        self.artistId = ""
        self.artistName = ""
        
        super.init(frame: frame)
        
        contentView.backgroundColor = .white
        self.clipsToBounds = true
        //self.autoresizesSubviews = true
        
        //MARK: Album Image View
        albumImageView.frame = CGRect(x: 6, y: 6, width: self.bounds.width - 12, height: self.bounds.height - 6)
        albumImageView.contentMode = .scaleAspectFit
        albumImageView.clipsToBounds = true
        //albumImageView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(albumImageView)
        //albumImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
        albumImageView.heightAnchor.constraint(equalToConstant: self.frame.height - 12).isActive = true
        albumImageView.widthAnchor.constraint(equalToConstant: self.frame.width - 12).isActive = true
        albumImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0 ).isActive = true
        albumImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0 ).isActive = true
        
        self.addSubview(artistNameLBL)
        artistNameLBL.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -26).isActive = true
        artistNameLBL.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 22 ).isActive = true
        artistNameLBL.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -22 ).isActive = true
        artistNameLBL.heightAnchor.constraint(equalToConstant: 14).isActive = true
        
        self.addSubview(albumNameLBL)
        albumNameLBL.bottomAnchor.constraint(equalTo: artistNameLBL.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        albumNameLBL.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 22 ).isActive = true
        albumNameLBL.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -22 ).isActive = true
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        albumImageView.image = nil
        albumId = ""
        albumName = ""
        artistId = ""
        artistName = ""
    }
    
}
