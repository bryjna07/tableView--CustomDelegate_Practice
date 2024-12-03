//
//  DetailViewController.swift
//  MemberList_Practice
//
//  Created by t2023-m0033 on 12/3/24.
//

import UIKit
// 더이상 상속하지 않음
final class DetailViewController: UIViewController {
    
    //뷰컨에서 직접적으로 디테일뷰에 전달해줘도됨
    private let detailView = DetailView()
    
    // 멤버를 전 화면에서 전달받아야함
    // 어차피 여기있는 멤버가 디테일뷰까지 전달이 되어야 표시됨 -> 저장속성으로 구현
    var member: Member?
    
    override func loadView() {
        // 뷰를 교체해줌
        view = detailView
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        setupData()
        setupButtonAction()
      
      
    }
    
    // 멤버를 뷰에 전달⭐️ (뷰에서 알아서 화면 셋팅)
    private func setupData() {
        detailView.member = member
    }
    
    // 디테일뷰에 있는 save버튼의 타겟 설정⭐️
    func setupButtonAction() {
        detailView.saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
    }
    
    //MARK: - SAVE버튼 또는 UPDATE버튼이 눌렸을때의 동작
    
    // 버튼액션은 일반적으로 뷰컨에서 해줘야함 present메서드는 뷰컨에만 구현되어있기 때문
    @objc func saveButtonTapped() {
        print("버튼 눌림")
    }

}
