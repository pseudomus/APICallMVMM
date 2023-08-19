//
//  DataController.swift
//  mvvmAPI
//
//  Created by Luca Lacerda on 16/08/23.
//

import Foundation
import CoreData

class DataController:ObservableObject{
    let container = NSPersistentContainer(name: "History")
    @Published var searchHistory:[Searched] = []
    
    init(){
        container.loadPersistentStores{ description, error in
            if let error = error{
                print("Core data failed to load, \(error.localizedDescription)")
            }
        }
        fetchHistory()
    }
    
    func fetchHistory(){
        let request = NSFetchRequest<Searched>(entityName: "Searched")
        
        do{
            searchHistory = try container.viewContext.fetch(request)
        }catch let error{
            print("error: \(error)")
        }
    }
    
    func addUser(user: GitHubUser){
        let newSearch = Searched(context: container.viewContext)
        newSearch.id = String(user.id)
        newSearch.login = user.login
        if let bio = user.bio{
            newSearch.bio = bio
        }
        newSearch.favorite = false
        saveData()
    }
    
    func saveData(){
        do{
            try container.viewContext.save()
            fetchHistory()
        }catch let error{
            print("error: \(error)")
        }
    }
    
    func removeItem(at Offset: IndexSet){
        for index in Offset{
            let toRemove = self.searchHistory[index]
            self.container.viewContext.delete(toRemove)
            self.saveData()
        }
    }
}

