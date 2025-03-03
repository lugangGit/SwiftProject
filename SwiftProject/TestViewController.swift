//
//  ViewController.swift
//  SwiftProject
//
//  Created by 梓源 on 2024/12/23.
//

import UIKit
import Moya
import SnapKit
import SwiftyJSON
import SVProgressHUD

class TestViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = kColorRandom()
        navigationBar?.setRightButton(image: UIImage(named: ImageName.navibar_more_grey))
        navigationBar?.rightButtonClick = {
            print("右按钮")
            Application.shared.navigator.show(segue: .test, sender: self)
        }
    }
    
    override func makeUI() {
        let englishButton = UIButton(type: .system)
        englishButton.setTitle("English", for: .normal)
        englishButton.addTarget(self, action: #selector(selectEnglish), for: .touchUpInside)
        
        englishButton.frame = CGRect(x: 0, y: 4*kNavBarHeight, width: kScreenWidth, height: 20)
        self.view.addSubview(englishButton)
        
        let chineseButton = UIButton(type: .system)
        chineseButton.setTitle("中文", for: .normal)
        chineseButton.addTarget(self, action: #selector(selectChinese), for: .touchUpInside)
        chineseButton.frame = CGRect(x: 0, y: 6*kNavBarHeight, width: kScreenWidth, height: 20)
        self.view.addSubview(chineseButton)
    }
    
    @objc func selectEnglish() {
        LanguageManager.shared.currentLanguage = AppLanguage.english
    }
    
    @objc func selectChinese() {
        LanguageManager.shared.currentLanguage = AppLanguage.chinese
    }

}

