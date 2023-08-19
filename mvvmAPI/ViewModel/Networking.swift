//
//  DataController.swift
//  mvvmAPI
//
//  Created by Luca Lacerda on 16/08/23.
//

import Foundation

@MainActor
final class Networking: ObservableObject{
    
    @Published var user:GitHubUser?
    @Published var followers:[GitHubUser]?
    @Published var repos:[Repos]?
    
    func fetchUsers(user:String) async throws {
        
        let endpoint = "https://api.github.com/users/\(user)"
        guard let url = URL(string: endpoint) else { throw GHError.invalidURl }
        let (data,response) = try await URLSession.shared.data(from: url)
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else{
            print("\(response)")
            throw GHError.invalidREsponse
        }
        do{
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            self.user = try decoder.decode(GitHubUser.self, from: data)
        } catch {
            throw GHError.invalidData
        }
    }
    
    func fetchFollowers(user:String) async throws {
        
        let endpoint = "https://api.github.com/users/\(user)/followers"
        guard let url = URL(string: endpoint) else { throw GHError.invalidURl }
        let (data,response) = try await URLSession.shared.data(from: url)
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else{
            throw GHError.invalidREsponse
        }
        do{
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            self.followers = try decoder.decode([GitHubUser].self, from: data)
        } catch {
            throw GHError.invalidData
        }
    }
    
    func fetchRepos(user:String) async throws{
        
        let endpoint = "https://api.github.com/users/\(user)/repos"
        guard let url = URL(string: endpoint) else { throw GHError.invalidURl}
        let (data,response) = try await URLSession.shared.data(from: url)
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else{
            throw GHError.invalidREsponse
        }
        do{
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            self.repos = try decoder.decode([Repos].self, from: data)
        }catch{
            throw GHError.invalidREsponse
        }
    }
    
    func clearSearch(){
        self.user = nil
        self.followers = nil
        self.repos = nil
    }
}

