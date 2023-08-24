//
//  ViewModelType.swift
//


import Foundation

protocol ViewModelType {
    associatedtype Input
    associatedtype Output

    func binding(input: Input) -> Output
}
