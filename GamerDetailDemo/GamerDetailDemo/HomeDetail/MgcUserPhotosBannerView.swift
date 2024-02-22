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
    var bgIndex = 0
    private var bgURLs: [URL] {
        let allURLs = videoURLs + pictureURLs
        if allURLs.count == 1 {
            return allURLs
        } else {
            return [allURLs.last!] + allURLs + [allURLs.first!]
        }
    }
    
    let miniScrollowView = UIScrollView(frame: .zero)
    var miniButtons: [UIButton] = []
    var miniIndex: Int {
        if bgIndex == 0 {
            return miniURLs.count - 1
        } else if bgIndex == bgURLs.count - 1 {
            return 0
        } else {
            return bgIndex - 1
        }
    }
    private var miniURLs: [URL] {
        let allURLs = videoURLs + pictureURLs
        return allURLs
    }
    
    let miniPageLabel = UILabel()
    
    var timer: Timer?
    
    // MARK: Life
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        bgScrollowView.delegate = self
        addSubview(bgScrollowView)
        
//        miniScrollowView.delegate = self
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
        let urlsCount = bgURLs.count
        bgScrollowView.frame = bounds
        bgScrollowView.contentSize = CGSize(width: screenWidth * CGFloat(urlsCount), height: bounds.height)
        bgScrollowView.isPagingEnabled = true
        
        for (i, url) in bgURLs.enumerated() {
            let index = CGFloat(i)
            let button = UIButton(type: .custom)
            button.frame = CGRect(x: index * screenWidth, y: 0, width: bounds.width, height: bounds.height)
            button.tag = 300 + i
            button.addTarget(self, action: #selector(bgButtonTaped(_:)), for: .touchUpInside)
            button.kf.setImage(with: url, for: .normal, placeholder: UIImage(named: ""))
            button.imageView?.contentMode = .scaleAspectFill
            bgScrollowView.addSubview(button)
            bgButtons.append(button)
        }
        
        if bgURLs.count > 1 {
            bgIndex = 1
            bgScrollowView.setContentOffset(CGPoint(x: screenWidth, y: 0), animated: false)
        }
    }
    
    func setMiniScrollow() {
        let urlsCount = miniURLs.count
        // 只有一张图片不显示小地图
        if urlsCount == 1 {
            miniScrollowView.isHidden = true
            miniPageLabel.isHidden = true
            return
        }
        
        miniScrollowView.isHidden = false
        miniPageLabel.isHidden = false
        
        let contentWidth = CGFloat(urlsCount) * 50 + CGFloat(urlsCount - 1) * 5
       
        var miniWidth: CGFloat = 0
        if urlsCount < 3 {
            miniWidth = contentWidth
        } else {
            miniWidth = 160
        }
        
        miniScrollowView.frame = CGRect(x: 15, y: bounds.height - 94, width: miniWidth, height: 50)
        miniScrollowView.contentSize = CGSize(width: contentWidth, height: 50)
        
        for (i, url) in miniURLs.enumerated() {
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
            button.layer.borderColor = UIColor.clear.cgColor
            miniScrollowView.addSubview(button)
            miniButtons.append(button)
        }
        
    }
    
    func updateMiniScrollow() {
        let urlsCount = miniURLs.count
        // 1 张图无需显示小地图
        if urlsCount == 1 {
            return
        }
        
        miniPageLabel.text = "\(miniIndex + 1)/\(urlsCount)"
        
        for button in miniButtons {
            let index = button.tag - 200
            if index == miniIndex {
                button.layer.borderColor = UIColor.white.cgColor
            } else {
                button.layer.borderColor = UIColor.clear.cgColor
            }
        }
    
        var scrollIndex = max(miniIndex - 1, 0)
        if urlsCount > 3 {
            scrollIndex = min(scrollIndex, urlsCount - 2)
        }
        miniScrollowView.setContentOffset(CGPoint(x: 55 * scrollIndex, y: 0), animated: true)
    }
    
    @objc func miniButtonTaped(_ sender: UIButton) {
        let index = sender.tag - 200
        bgScrollowView.setContentOffset(CGPoint(x: CGFloat(index) * screenWidth, y: 0), animated: true)
        bgIndex = index + 1
        
    }
    
    @objc func bgButtonTaped(_ sender: UIButton) {
        // TODO: 跳转详情
        debugPrint("点击了\(miniIndex)张图片")
    }
    
    func mgc_startAnimiation() {
        timer = Timer.scheduledTimer(timeInterval: 3.5, target: self, selector: #selector(timerFired), userInfo: nil, repeats: true)
    }
    
    func mgc_stopAnimation() {
        timer?.invalidate()
        timer = nil
    }
    
    @objc func timerFired() {
        if bgURLs.count == 0 {
            return
        }
        let nextBgIndex = bgIndex + 1
        if nextBgIndex >= bgURLs.count {
            bgIndex = 1
            bgScrollowView.setContentOffset(CGPoint(x: screenWidth, y: 0), animated: false)
            return
        }
        bgScrollowView.setContentOffset(CGPoint(x: screenWidth * CGFloat(nextBgIndex), y: 0), animated: true)
        
    }
}

extension MgcUserPhotosBannerView: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetX = scrollView.contentOffset.x
        let i = Int(round(offsetX / screenWidth))
        let lastOffset = screenWidth * CGFloat(bgURLs.count - 1)
        bgIndex = i
        
        if offsetX < screenWidth {
            scrollView.setContentOffset(CGPoint(x: lastOffset, y: 0), animated: false)
        } else if offsetX > lastOffset {
            scrollView.setContentOffset(CGPoint(x: screenWidth, y: 0), animated: false)
        }
        
        updateMiniScrollow()
        
    }
}
