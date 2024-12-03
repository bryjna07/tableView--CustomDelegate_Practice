//
//  ViewController.swift
//  MemberList_Practice
//
//  Created by t2023-m0033 on 12/3/24.
//  viewWillAppear를 통해 업데이트 하도록 했었음
//  비효율적임, 계속 업데이트함 , 업데이트 하지 않고 돌아갔을때도 리로드함
//  델리게이트패턴으로 버튼을 눌러서 실제로 업데이트 됐을 때만 리로드 되도록 하려고함
//  정보가 업데이트가 되었으니 너가 구현을 해 ( 다른 객체에게 ) - 커스텀 델리게이트

import UIKit

final class ViewController: UIViewController {
    
    // 테이블 뷰, 굳이 뷰를 따로 나누지 않음
    private let tableView = UITableView()
    
    //MARK: - 관리 모델 선언
    // 뷰컨에서 비즈니스로직에 접근할 수 있는 매니저 만들기
    // MVC패턴을 위한 데이터 매니저 (배열 관리 - 데이터)
    var memberListManager = MemberListManager()
    
    // 네비게이션바에 넣기 위한 버튼
    lazy var plusButton: UIBarButtonItem = {
        let button = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(plusButtonTapped))
        return button
    }()

    //MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        // 배열의 데이터 생성하도록⭐️
        setupDatas()
        seupTableView()
        setupNaviBar()
        setupTableViewConstraints()
    }

    // 커스텀 델리게이트로 구현시 없어도됨
    // 델리게이트가 아닌 방식으로 구현할때는 화면 리프레시⭐️
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        // 뷰가 다시 나타날때, 테이블뷰를 리로드
//        tableView.reloadData()
//    }
        
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
        self.navigationItem.rightBarButtonItem = self.plusButton
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
    
    //MARK: - 오토레이아웃 셋팅
    
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

    // 멤버를 추가하기 위한 다음 화면으로 이동
    @objc func plusButtonTapped() {
        // 다음화면으로 이동 (멤버는 전달하지 않음)
        let detailVC = DetailViewController()
        
        // 다음 화면의 대리자 설정 (다음 화면의 대리자는 지금 현재의 뷰컨트롤러)
        detailVC.delegate = self
        
        // 화면이동
        navigationController?.pushViewController(detailVC, animated: true)
        //show(detailVC, sender: nil)
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

//MARK: - 테이블뷰 델리게이트 구현 (셀이 선택되었을때)
extension ViewController: UITableViewDelegate {
    
    // 셀이 선택이 되었을때 어떤 동작을 할 것인지 뷰컨트롤러에게 물어봄
    //선택적인 메서드, 셀이 선택되었을때 동작이 전달
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 다음화면으로 넘어가는 코드
        let detailVC = DetailViewController()
        
        // 다음 화면의 대리자 설정 (다음 화면의 대리자는 지금 현재의 뷰컨트롤러)
        // DVC에 접근할 수 있는 부분이 이 부분이기 때문에 여기서 델리게이트 설정
        // self -> VC, DVC의 대리자 는 내가 될거야
        detailVC.delegate = self
        
        // 다음 화면에 멤버를 전달
        let array = memberListManager.getMembersList()
        detailVC.member = array[indexPath.row]
        
        
        // 화면이동
        navigationController?.pushViewController(detailVC, animated: true)
        
         
    }
    
}


//MARK: - 멤버 추가하거나, 업데이트에 대한 델리게이트 구현
// 프로토콜을 채택함으로써 대리자 역할이 가능해짐
extension ViewController: MemberDelegate {
    // 멤버가 추가되면 실행할 메서드 구현
    func addNewMember(_ member: Member) {
        // 모델에 멤버 추가
        memberListManager.makeNewMember(member)
        // 테이블뷰를 다시 로드 (다시 그리기)
        tableView.reloadData()
    }
    
    // 멤버의 정보가 업데이트 되면 실행할 메서드 구현
    func update(index: Int, _ member: Member) {
        print("업데이트")
        // 모델에 멤버 정보 업데이트
        memberListManager.updateMemberInfo(index: index, member)
        // 테이블뷰를 다시 로드 (다시 그리기)
        tableView.reloadData()
    }
}
