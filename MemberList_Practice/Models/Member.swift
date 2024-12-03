//
//  Member.swift
//  MemberList_Practice
//
//  Created by t2023-m0033 on 12/3/24.
//

import UIKit
// 데이터 묶음은 보통 스트럭트로, 클래스는 느림

// 대리자(VC)가 할 수 있는 일을 정의해줌
// (커스텀) 델리게이트 패턴 구현을 위한 프로토콜 선언
// weak 선언시 -> 클래스에서만 채택가능한 프로토콜로 설정해줘야함 AnyObject
protocol MemberDelegate: AnyObject {
    func addNewMember(_ member: Member)
    func update(index: Int, _ member: Member)
}
   //   실제로 업데이트는 DC에서 일어남 -> 대리자VC한테 너도 무언갈 해야해, 나의 대리자 역할로
   //   어떠한 동작이 일어났을때 그 동작의 결과를 전달을 받을 수 있는 정확한 행동을 선언
   //   VC가 실제로 그 동작을 받아서 어떤 일을 해야할지를 정의해줌 - 델리게이트 패턴의 핵심


// 멤버 모델
struct Member {
    // 이미지가 없다면 메모리 낭비할 필요가 없으니 lazy var 로 선언
    lazy var memberImage: UIImage? = {
        // 이름이 없다면, 시스템 사람이미지 셋팅
        guard let name = name else {
            return UIImage(systemName: "person")
        }
        // 해당이름으로된 이미지가 없다면, 시스템 사람이미지 셋팅
        return UIImage(named: "\(name).png") ?? UIImage(systemName: "person")
    }()
    
    // 멤버의 (절대적) 순서를 위한 타입 저장 속성
    static var memberNumbers: Int = 0
    
    let memberId: Int
    var name: String?
    var age: Int?
    var phone: String?
    var address: String?
    
    // 생성자 구현 - 멤버 와이즈가 아닌 직접구현, 생성자 안에다 논리를 넣기 위해
    init(name: String?, age: Int?, phone: String?, address: String?) {
        
        // 타입 저장속성에 저장되어 있는 값으로 순번 메기기
        self.memberId = Member.memberNumbers
        
        // 나머지 저장속성은 외부에서 셋팅
        self.name = name
        self.age = age
        self.phone = phone
        self.address = address
        
        
        // 멤버를 생성한다면, 항상 타입 저장속성의 정수값 + 1
        Member.memberNumbers += 1
    }

}
