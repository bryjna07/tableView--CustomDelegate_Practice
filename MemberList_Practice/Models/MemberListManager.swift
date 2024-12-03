//
//  MemberListManager.swift
//  MemberList_Practice
//
//  Created by t2023-m0033 on 12/3/24.
//

import Foundation
// 관리자 역할, 데이터 배열, 뷰컨한테 전달, 모든 비즈니스 로직을 담을 수 있는 매니저
final class MemberListManager {
    // 빈 배열로 선언 후 데이터를 만드는 함수 호출 후 담으려고
    // 멤버리스트를 저장하기 위한 배열
    private var membersList: [Member] = []
    
    // 뷰컨에서 이 함수를 호출해줘야 데이터 생성 후 위 빈배열에 담는
    // 서버와 통신한 후 데이터를 받아오고 받아온 데이터를 통해 배열을 담게 해주려고
    // 전체 멤버 리스트 만들기 (꼭 필요하지 않고, 원래 배열에 멤버 생성해도 됨)
    func makeMembersListDatas() {
        membersList = [
            Member(name: "홍길동", age: 20, phone: "010-1111-2222", address: "서울"),
            Member(name: "임꺽정", age: 23, phone: "010-2222-3333", address: "서울"),
            Member(name: "스티브", age: 50, phone: "010-1234-1234", address: "미국"),
            Member(name: "쿡", age: 30, phone: "010-7777-7777", address: "캘리포니아"),
            Member(name: "베조스", age: 50, phone: "010-2222-7777", address: "하와이"),
            Member(name: "배트맨", age: 40, phone: "010-3333-1234", address: "고담씨티"),
            Member(name: "조커", age: 40, phone: "010-4321-1234", address: "고담씨티")
        ]
    }
    
    // 전체 멤버 리스트 얻기, 배열로 리턴
    func getMembersList() -> [Member] {
        return membersList
    }
    
    // 새로운 멤버 만들기, 멤버 구조체 타입, 배열에 추가
    func makeNewMember(_ member: Member) {
        membersList.append(member)
    }
    
    // 기존 멤버의 정보 업데이트, 어떤 멤버인지 알기위해 인덱스를 받음
    func updateMemberInfo(index: Int, _ member: Member) {
        membersList[index] = member
    }
    
    // 특정 멤버 얻기 (굳이 필요 없지만, 서브스크립트 구현해보기)
    subscript(index: Int) -> Member {
        get {
            return membersList[index]
        }
    }
}
