//
//  ProfileModel.swift
//  roome
//
//  Created by minsong kim on 5/23/24.
//

import Foundation

struct ProfileModel {
    static let genre = ["액션", "범죄", "SF", "코미디", "로맨스", "스릴러", "공포", "판타지", "추리", "드라마", "미스터리", "감성", "어드벤처", "역사", "동화", "탈옥", "잠입", "야외", "문제방"]
    static let strength = ["관찰력", "집중력", "분석력", "순발력", "추리력", "실행력", "창의력", "침착함", "협업 능력"]
    static let themeSelect = ["탄탄한 스토리", "다양한 연출", "명확한 개연성", "퀄리티 높은 인테리어", "큰 스케일", "신선한 문제", "논리적인 문제"]
    static let deviceAndLock = ["장치", "자물쇠", "장치 & 자물쇠 모두"]
    static let dislike = ["이과형 문제", "높은 난이도", "노가다 문제", "문제방", "긴 지문", "억지 감동", "삑딱쿵", "억지 활동성", "낮은 조도"]
    static let mbti: [(type: String, description: String)] = [("E","외향형"),("I","내향형"),("N","직관형"),("S","현실주의형"),("T","사고형"),("F","감정형"),("J","계획형"),("P","탐색형")]
    static let horrorPosition: [(type: String, description: String)] = [
        ("극쫄", "사소한거에도 놀랄 정도로 겁이 많아요"),
        ("쫄", "겁이 많은 편이에요"),
        ("반쫄", "무서워하지만, 공포 테마는 좋아요"),
        ("마지모탱", "무서워하지만, 쫄들 사이에서 탱 포지션이에요"),
        ("탱", "무서워하지 않아요"),
        ("극탱", "공포를 오히려 즐겨요"),
        ("잘 모르겠어요", "혹은 공포 테마 경험이 없어요")]
    static let hintPrefer: [(type: String, description: String)] = [
        ("힌트 안써요", "막히더라도 사용하지 않아요"),
        ("최소한의 힌트만", "시간이 오래 걸릴 때만 써요"),
        ("힌트 사용 괜찮아요", "조금만 막혀도 바로 사용해요")]
    static let activity: [(type: String, description: String)] = [
        ("높은 활동성", "걷고, 뛰고, 계단 이동하는 게 좋아요"),
        ("중간 활동성", "땀나지 않을 정도로 적당히 움직이는 게 좋아요"),
        ("낮은 활동성", "걷는 정도가 좋아요"),
        ("활동성 최소", "최소한의 이동만 있는 게 좋아요")]
}
