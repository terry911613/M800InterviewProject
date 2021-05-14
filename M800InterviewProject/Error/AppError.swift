//
//  AppError.swift
//  M800InterviewProject
//
//  Created by 李泰儀 on 2021/5/14.
//

import Foundation

public enum AppError {
    case urlNotFound
    case dataNil
}

extension AppError: Error {
    var localizedDescription: String {
        return errorDescription ?? String(describing: self)
    }
}

extension AppError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .urlNotFound:
            return "url not found"
        case .dataNil:
            return "data nil"
        }
    }
}
