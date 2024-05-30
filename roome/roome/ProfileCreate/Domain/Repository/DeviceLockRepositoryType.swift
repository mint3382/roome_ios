//
//  DeviceLockRepositoryType.swift
//  roome
//
//  Created by minsong kim on 5/30/24.
//

import Foundation

protocol DeviceLockRepositoryType {
    func registerDeviceLock(id: Int) async throws
}
