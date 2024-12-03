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
        
        // [1] 멤버가 없다면 (새로운 멤버를 추가하는 화면)
        if member == nil {
            // 입력이 안되어 있다면.. (일반적으로) 빈문자열로 저장
            let name = detailView.nameTextField.text ?? ""
            let age = Int(detailView.ageTextField.text ?? "")
            let phoneNumber = detailView.phoneNumberTextField.text ?? ""
            let address = detailView.addressTextField.text ?? ""
            
            // 새로운 멤버 (구조체) 생성
            var newMember =
            Member(name: name, age: age, phone: phoneNumber, address: address)
            newMember.memberImage = detailView.mainImageView.image
            
            // 1) 델리게이트 방식이 아닌 구현⭐️
            let index = navigationController!.viewControllers.count - 2
            // 전 화면에 접근하기 위함
            let vc = navigationController?.viewControllers[index] as! ViewController
            // 전 화면의 모델에 접근해서 멤버를 추가
            vc.memberListManager.makeNewMember(newMember)
            
            
            // 2) 델리게이트 방식으로 구현⭐️
            //delegate?.addNewMember(newMember)
            
            
        // [2] 멤버가 있다면 (멤버의 내용을 업데이트 하기 위한 설정)
        } else {
            // 이미지뷰에 있는 것을 그대로 다시 멤버에 저장
            member!.memberImage = detailView.mainImageView.image
            
            let memberId = Int(detailView.memberIdTextField.text!) ?? 0
            member!.name = detailView.nameTextField.text ?? ""
            member!.age = Int(detailView.ageTextField.text ?? "") ?? 0
            member!.phone = detailView.phoneNumberTextField.text ?? ""
            member!.address = detailView.addressTextField.text ?? ""
            
            // 뷰에도 바뀐 멤버를 전달 (뷰컨트롤러 ==> 뷰)
            detailView.member = member
            
            // 1) 델리게이트 방식이 아닌 구현⭐️
            let index = navigationController!.viewControllers.count - 2
            
            // 네비게이션 컨트롤러가 화면을 넘겨주었으니, 정보를 가지고 잇을거야
            // navigationController?.viewControllers[0] -> 뷰컨, 1 -> 디테일뷰컨
            // 바로 전 화면 == count - 1
            
            // 전 화면에 접근하기 위함
            let vc = navigationController?.viewControllers[index] as! ViewController
            // 전 화면의 모델에 접근해서 멤버를 업데이트
            vc.memberListManager.updateMemberInfo(index: memberId, member!)
            
            // 위의 과정이 복잡하기 때문에
            // 델리게이트 방식으로 구현⭐️
            //delegate?.update(index: memberId, member!)
        }
        
        // (일처리를 다한 후에) 전화면으로 돌아가기
        self.navigationController?.popViewController(animated: true)
        

        
    }

}
