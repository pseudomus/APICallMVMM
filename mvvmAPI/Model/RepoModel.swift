//
//  RepoModel.swift
//  mvvmAPI
//
//  Created by Luca Lacerda on 16/08/23.
//

import Foundation

struct Repos: Codable, Identifiable{
    let id:Int
    let name:String
    let description:String?
    let stargazersCount:Int?
}
