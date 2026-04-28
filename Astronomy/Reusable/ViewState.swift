//
//  ViewState.swift
//  Astronomy
//
//  Created by Ajay Odedara on 27/04/2026.
//

enum ViewState<T> {
    case idle
    case loading
    case loaded(T)
    case error(Error)
}
