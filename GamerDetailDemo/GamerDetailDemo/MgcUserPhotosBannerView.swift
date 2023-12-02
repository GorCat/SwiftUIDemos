//
//  MgcUserPhotosBannerView.swift
//  GamerDetailDemo
//
//  Created by GorCat on 2023/12/3.
//

import UIKit
import Kingfisher

class MgcUserPhotosBannerView: UIView {
    
    var videoURLs: [URL] = []
    var pictureURLs: [URL] = []
    
    let bgScrollowView = UIScrollView(frame: .zero)
    var bgButtons: [UIButton] = []
    
    let miniScrollowView = UIScrollView(frame: .zero)
    var miniButtons: [UIButton] = []
    
    let miniPageLabel = UILabel()
    
    var currentIndex = 0
    
    private var urlsCount: Int {
        let count = videoURLs.count + pictureURLs.count
        if count == 1 {
            // 不滚动
            return 1
        } else {
            // 要自动滚动，需要添加假动画
            return count + 2
        }
    }
    
    private var urls: [URL] {
        let allURLs = videoURLs + pictureURLs
        if urlsCount == 1 {
            return allURLs
        } else {
            return [allURLs.last!] + allURLs + [allURLs.first!]
        }
    }

    // MARK: Life
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        bgScrollowView.delegate = self
        addSubview(bgScrollowView)
        
        miniScrollowView.delegate = self
        addSubview(miniScrollowView)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: UI
    func reloadDatas() {
        clearSubviews()
        setBgScrollow()
        setMiniScrollow()
    }
    
    func clearSubviews() {
        for button in bgButtons {
            button.removeFromSuperview()
        }
        bgButtons = []
        for button in miniButtons {
            button.removeFromSuperview()
        }
        miniButtons = []
    }
    
    func setBgScrollow() {
        bgScrollowView.frame = bounds
        bgScrollowView.contentSize = CGSize(width: screenWidth * CGFloat(urlsCount), height: bounds.height)
        bgScrollowView.isPagingEnabled = true
        
        for (i, url) in urls.enumerated() {
            let index = CGFloat(i)
            let button = UIButton(type: .custom)
            button.frame = CGRect(x: index * screenWidth, y: 0, width: bounds.width, height: bounds.height)
            button.tag = 300 + i
            button.addTarget(self, action: #selector(bgButtonTaped(_:)), for: .touchUpInside)
            button.kf.setImage(with: url, for: .normal, placeholder: UIImage(named: ""))
            button.imageView?.contentMode = .scaleAspectFill
            button.clipsToBounds = true
            button.layer.cornerRadius = 10
            button.layer.borderWidth = 1
            bgScrollowView.addSubview(button)
            bgButtons.append(button)
        }
    }
    
    func setMiniScrollow() {
        // 只有一张图片不显示小地图
        if urlsCount == 1 {
            miniScrollowView.isHidden = true
            return
        }
        
        miniScrollowView.isHidden = false
        
        let contentWidth = CGFloat(urlsCount) * 50 + CGFloat(urlsCount - 1) * 5
       
        var miniWidth: CGFloat = 0
        if urlsCount < 3 {
            miniWidth = contentWidth
        } else {
            miniWidth = 160
        }
        
        miniScrollowView.frame = CGRect(x: 15, y: bounds.height - 94, width: miniWidth, height: 50)
        miniScrollowView.contentSize = CGSize(width: contentWidth, height: 50)
        
        for (i, url) in urls.enumerated() {
            let index = CGFloat(i)
            let button = UIButton(type: .custom)
            button.frame = CGRect(x: i * 55, y: 0, width: 50, height: 50)
            button.tag = 200 + i
            button.addTarget(self, action: #selector(miniButtonTaped(_:)), for: .touchUpInside)
            button.kf.setImage(with: url, for: .normal, placeholder: UIImage(named: ""))
            button.imageView?.contentMode = .scaleAspectFill
            button.clipsToBounds = true
            button.layer.cornerRadius = 10
            button.layer.borderWidth = 1
            miniScrollowView.addSubview(button)
            miniButtons.append(button)
        }
        
    }
    
    func updateMiniButtons() {
        for button in miniButtons {
            let index = button.tag - 200
            
//            button.layer.borderColor = UIColor.white.cgColor
            
        }
    }
    
    @objc func miniButtonTaped(_ sender: UIButton) {
        
    }
    
    @objc func bgButtonTaped(_ sender: UIButton) {
        
    }
}

extension MgcUserPhotosBannerView: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
    }
}
