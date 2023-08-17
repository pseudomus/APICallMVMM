//
//  UserModel.swift
//  mvvmAPI
//
//  Created by Luca Lacerda on 16/08/23.
//

import Foundation

struct GitHubUser: Codable, Identifiable{
    let id:Int
    let login: String
    let avatarUrl: String?
    let bio: String?
}
