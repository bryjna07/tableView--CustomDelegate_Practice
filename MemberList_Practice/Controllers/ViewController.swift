//
//  ViewController.swift
//  MemberList_Practice
//
//  Created by t2023-m0033 on 12/3/24.
//

import UIKit

final class ViewController: UIViewController {
    
    // 테이블 뷰, 굳이 뷰를 따로 나누지 않음
    private let tableView = UITableView()
    // 뷰컨에서 비즈니스로직에 접근할 수 있는 매니저 만들기
    var memberListManager = MemberListManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        // 배열의 데이터 생성하도록⭐️
        setupDatas()
        seupTableView()
        setupNaviBar()
        setupTableViewConstraints()
    }

    func setupNaviBar() {
        title = "회원 목록"
        
        // 네비게이션바 설정관련
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()  // 불투명으로
        appearance.backgroundColor = .white
        navigationController?.navigationBar.tintColor = .systemBlue
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        
        // 네비게이션바 오른쪽 상단 버튼 설정
       // self.navigationItem.rightBarButtonItem = self.plusButton
    }
    
    func seupTableView() {
        tableView.dataSource = self
        tableView.delegate = self    //⭐️ 꼭 해줘야함
        // 테이블 뷰 셀의 높이설정
        tableView.rowHeight = 60
        
        // 셀의 등록⭐️ (타입인스턴스 - 메타타입)
        tableView.register(MyTableViewCell.self, forCellReuseIdentifier: "MemberCell")
    }
    
    func setupDatas() {
        memberListManager.makeMembersListDatas() // 일반적으로는 서버에 요청
    }
    
    // 테이블뷰의 오토레이아웃 설정
    func setupTableViewConstraints() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0)
        ])
    }

}


extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // 배열을 달라고 요청, 테이블뷰에 리턴 -> 표시
        return memberListManager.getMembersList().count
    }
    
    
    // 셀을 구현했으니 이 메서드를 구현해주면됨
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 위에서 등록을 해줘서 사용가능
        let cell = tableView.dequeueReusableCell(withIdentifier: "MemberCell", for: indexPath) as! MyTableViewCell
        
        // 셀을 그리는 방식, 서브스크립트 구현한 것을 활용
        // 셀에 접근해서 직접적으로 세팅해주는 방법이 아닌 다른 방법
        // 셀에서 멤버를 저장속성으로 구현, 속성감시자, 멤버만 전달하는 방식으로 구현
        cell.member = memberListManager[indexPath.row]
        // 멤버라는 속성에 배열에서 멤버를 하나 꺼내서 전달
        // 저장속성에 멤버를 전달을 하면 셀에서 알아서 꺼내서 이미지,레이블 등을 표시해주는 방식
        // 알아서 실행해주기 때문에 훨씬 편함
        cell.selectionStyle = .none
        
        return cell
        
    }
    
}

extension ViewController: UITableViewDelegate {
    
    //선택적인 메서드, 셀이 선택되었을때 동작이 전달
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 다음화면으로 넘어가는 코드
        let detailVC = DetailViewController()
        
        
        
        navigationController?.pushViewController(detailVC, animated: true)
        
        
        
    }
    
    
    
    
}
