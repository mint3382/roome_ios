//
//  TermsAgreeRepositoryType.swift
//  roome
//
//  Created by minsong kim on 5/21/24.
//

import Foundation

protocol TermsAgreeRepositoryType {
    func requestTerms(states: TermsButtonStates) async throws
}
