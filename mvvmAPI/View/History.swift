//
//  History.swift
//  mvvmAPI
//
//  Created by Luca Lacerda on 17/08/23.
//

import SwiftUI

struct History: View {
    @StateObject var data:Networking
    @StateObject var controller:DataController
    @Binding  var isOpen:Bool
    
    var body: some View {
        VStack{
            List{
                ForEach(controller.searchHistory,id: \.self){ i in
                    Button{
                        Task{
                            do{
                                try await data.fetchUsers(user: i.login ?? "")
                                try await data.fetchFollowers(user: i.login ?? "")
                                try await data.fetchRepos(user: i.login ?? "")
                            }catch GHError.invalidREsponse{
                                print("resposta invalida")
                            }catch GHError.invalidURl{
                                print("URl invalida")
                            }catch GHError.invalidData{
                                print("dados invalidos")
                            }catch{
                                print("erro")
                            }
                            
                            if let user = data.user{
                                controller.addUser(user: user)
                            }
                        }
                        
                        isOpen.toggle()
                        
                    }label: {
                        Text(i.login ?? "")
                    }
                }
            }
        }
    }
}


