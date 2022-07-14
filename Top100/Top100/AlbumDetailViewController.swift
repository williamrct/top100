//
//  AlbumDetailViewController.swift
//  Top100
//
//  Created by William Rodriguez on 7/11/22.
//
//

import UIKit

class AlbumDetailViewController: UIViewController {
    
    var albumImageURL: String
    var albumURL: String
    var albumId: String
    var albumName: String
    var artistId: String
    var artistName: String
    var releaseDate: String
    var copyright: String
    var genres: [Genre]
    
    
    var estimatedHeight: CGFloat = 0
    
    init(albumImageURL: String, albumURL: String, albumId: String, albumName: String, artistId: String, artistName: String, releaseDate: String, copyright: String, genres: [Genre]) {
        self.albumImageURL = albumImageURL
        self.albumURL = albumURL
        self.albumId = albumId
        self.albumName = albumName
        self.artistId = artistId
        self.artistName = artistName
        self.releaseDate = releaseDate
        self.copyright = copyright
        self.genres = genres
        
        super.init(nibName: nil, bundle: nil)
        self.title = ""
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var albumImageView: UIImageView = UIImageView()
    var artistNameLBL: UILabel = UILabel()
    var albumNameLBL: UILabel = UILabel()
    
    lazy var releaseDateLBL: UILabel = {
        let label = UILabel(frame: CGRect(x: CGFloat(16), y: CGFloat(UIScreen.main.bounds.height - 144), width: CGFloat(UIScreen.main.bounds.width - 32), height: CGFloat(14)))
        label.font = UIFont.systemFont(ofSize: 12, weight: UIFont.Weight.regular)
        label.textColor = UIColor.gray
        label.text = "Release Date"
        label.textAlignment = .center
        return label
    }()
    
    lazy var copyrightLBL: UILabel = {
        let label = UILabel(frame: CGRect(x: CGFloat(16), y: CGFloat(UIScreen.main.bounds.height - 129), width: CGFloat(UIScreen.main.bounds.width - 32), height: CGFloat(14)))
        label.font = UIFont.systemFont(ofSize: 12, weight: UIFont.Weight.regular)
        label.textColor = UIColor.gray
        label.text = "Copyright"
        label.textAlignment = .center
        return label
    }()
    
    lazy var visitAlbumButton: UIButton = {
        let button = UIButton(frame: CGRect(x: (UIScreen.main.bounds.width / 2) - 72.5, y: self.view.bounds.maxY - 100, width: CGFloat(155), height: CGFloat(45)))
        button.alpha = 1
        button.layer.cornerRadius = 10
        button.backgroundColor = .systemBlue
        button.isUserInteractionEnabled = true
        //button.configuration?.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
         // var outgoing = incoming
         //   outgoing.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.bold)
         // return outgoing
         //}
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.semibold)
        button.setTitle("Visit The Album", for: .normal)
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
   /* let albumView: UIStackView = {
        let view = UIStackView()
        view.frame.size.width = UIScreen.main.bounds.width
        view.axis = .vertical
        view.alignment = .leading
        view.spacing = 10.0
        view.distribution = .fill
        view.translatesAutoresizingMaskIntoConstraints = true
        return view
    }() */
    
    let genresView: UIStackView = {
        let view = UIStackView()
        view.frame.size.width = UIScreen.main.bounds.width
        view.axis = .horizontal
        view.alignment = .leading
        view.spacing = 20.0
        //view.translatesAutoresizingMaskIntoConstraints = true
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let backButtonBackgroundImage = UIImage(named: "backButtonCircle.png") else { return }
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        
        appearance.backButtonAppearance.configureWithDefault(for: .plain)
        
        let hideBackButtonTitleAttributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.clear]

        let normalBackButton = appearance.backButtonAppearance.normal
        let highlightedBackButton = appearance.backButtonAppearance.highlighted
    
        normalBackButton.titleTextAttributes = hideBackButtonTitleAttributes
        highlightedBackButton.titleTextAttributes = hideBackButtonTitleAttributes
        normalBackButton.backgroundImage = backButtonBackgroundImage
        highlightedBackButton.backgroundImage = backButtonBackgroundImage
        
        navigationController?.navigationBar.backItem?.backBarButtonItem?.imageInsets = UIEdgeInsets(top: 0, left: 28, bottom: 0, right: 0)

        appearance.setBackIndicatorImage(nil, transitionMaskImage: nil)

        navigationController?.navigationBar.tintColor = UIColor.clear
        navigationController?.navigationBar.isOpaque = false
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.standardAppearance = appearance

        self.view.backgroundColor = .white
    
        if let url = NSURL(string: albumImageURL)  {
            ImageLoader.shared.loadImage(imageURL: url, completion: {image -> Void in
                self.albumImageView.image = image
            })
        }
        
        self.albumImageView = UIImageView(frame: CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(UIScreen.main.bounds.width), height: CGFloat(UIScreen.main.bounds.width)))
        self.albumImageView.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(self.albumImageView)
        
        self.albumImageView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0).isActive = true
        self.albumImageView.widthAnchor.constraint(equalToConstant: self.view.bounds.width).isActive = true
        self.albumImageView.heightAnchor.constraint(equalToConstant: self.view.bounds.width).isActive = true
        self.albumImageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        
        self.artistNameLBL = UILabel(frame: CGRect(x: CGFloat(16), y: CGFloat(UIScreen.main.bounds.width + 16), width: CGFloat(UIScreen.main.bounds.width - 32), height: CGFloat(21)))
        self.artistNameLBL.translatesAutoresizingMaskIntoConstraints = false
        self.artistNameLBL.font = UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.regular)
        self.artistNameLBL.textColor = UIColor.gray
        self.artistNameLBL.text = artistName
        
        self.view.addSubview(artistNameLBL)
        self.artistNameLBL.topAnchor.constraint(equalTo: self.albumImageView.bottomAnchor, constant: 12).isActive = true
        self.artistNameLBL.leadingAnchor.constraint(equalTo: self.albumImageView.leadingAnchor, constant: 16 ).isActive = true
        self.artistNameLBL.trailingAnchor.constraint(equalTo: self.albumImageView.trailingAnchor, constant: -16 ).isActive = true
        self.artistNameLBL.heightAnchor.constraint(equalToConstant: 21).isActive = true
        
        estimatedHeight = estimatedLabelHeight(albumName, fontsize: 34, width: self.view.bounds.width - 32)
        
        self.albumNameLBL = UILabel(frame: CGRect(x: CGFloat(16), y: CGFloat(self.view.bounds.width + artistNameLBL.bounds.height), width: CGFloat(self.view.bounds.width - 32), height: CGFloat(estimatedHeight)))
        self.albumNameLBL.translatesAutoresizingMaskIntoConstraints = false
        self.albumNameLBL.font = UIFont.systemFont(ofSize: 34, weight: UIFont.Weight.bold)
        self.albumNameLBL.lineBreakMode = .byWordWrapping
        self.albumNameLBL.numberOfLines = 0
        self.albumNameLBL.textColor = UIColor.black
        self.albumNameLBL.text = albumName
        self.albumNameLBL.textAlignment = .left

        self.view.addSubview(albumNameLBL)
        
        self.albumNameLBL.topAnchor.constraint(equalTo: artistNameLBL.bottomAnchor, constant: 0).isActive = true
        self.albumNameLBL.leadingAnchor.constraint(equalTo: self.albumImageView.leadingAnchor, constant: 16 ).isActive = true
        self.albumNameLBL.trailingAnchor.constraint(equalTo: self.albumImageView.trailingAnchor, constant: -16 ).isActive = true
        self.albumNameLBL.heightAnchor.constraint(equalToConstant: estimatedHeight).isActive = true

        var genreXOffset = 16
        
        for genre in genres {
            let y = albumImageView.bounds.height + artistNameLBL.bounds.height + estimatedHeight + 20
            let estimateWidth = estimatedLabelWidth(genre.name, fontsize: 12) + 18
            let label = UILabel(frame: CGRect(x: CGFloat(genreXOffset), y: CGFloat(y), width: CGFloat(estimateWidth), height: CGFloat(18)))
            label.font = UIFont.systemFont(ofSize: 12, weight: UIFont.Weight.medium)
            label.textColor = UIColor.blue
            label.text = genre.name
            label.textAlignment = .center
            label.layer.borderColor = UIColor.blue.cgColor
            label.layer.borderWidth = 1
            label.layer.cornerRadius = 8
            genresView.addSubview(label)
            genreXOffset += Int(estimateWidth + 10)
        }
        
        self.view.addSubview(genresView)
        
        self.releaseDateLBL.text = "Released \(releaseDate)"
        self.view.addSubview(releaseDateLBL)
        
        self.copyrightLBL.text = copyright
        self.view.addSubview(copyrightLBL)
        
        self.view.addSubview(visitAlbumButton)
        self.view.bringSubviewToFront(visitAlbumButton)
        self.visitAlbumButton.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)

    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    func estimatedLabelWidth(_ string: String, fontsize: CGFloat) -> CGFloat {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: fontsize)
        label.text = string

        let width = (label.systemLayoutSizeFitting(CGSize(width: UIView.layoutFittingExpandedSize.width, height: UIView.layoutFittingExpandedSize.height), withHorizontalFittingPriority: .defaultLow, verticalFittingPriority: .required).width)
        return width
    }
    
    func estimatedLabelHeight(_ string: String, fontsize: CGFloat, width: CGFloat) -> CGFloat {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: fontsize)
        label.text = string
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping

        let height = (label.systemLayoutSizeFitting(CGSize(width: width, height: UIView.layoutFittingExpandedSize.height), withHorizontalFittingPriority: .required, verticalFittingPriority: .fittingSizeLevel).height)
        return height
    }
    
    
    @objc func buttonTapped(_ sender : UIButton) {
        guard let url = URL(string: self.albumURL) else { return }
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }
    
}
