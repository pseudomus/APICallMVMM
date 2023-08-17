//
//  ContentView.swift
//  mvvmAPI
//
//  Created by Luca Lacerda on 16/08/23.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject private var data = Networking()
    @StateObject private var controller = DataController()
    @State private var search:String = ""
    @State private var isOpen:Bool = false
    
    var body: some View {
        NavigationStack{
            VStack {
                Button{
                    isOpen.toggle()
                }label: {
                    Text("History")
                }
                HStack{
                    TextField("Pesquisar usuário", text: $search)
                        .frame(width: 190)
                        .padding()
                        .textFieldStyle(.roundedBorder)
                        .multilineTextAlignment(.center)
                    Button{
                        Task{
                            do{
                                try await data.fetchUsers(user: search)
                                try await data.fetchFollowers(user: search)
                                try await data.fetchRepos(user: search)
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
                    }label: {
                        Text("Search")
                    }
                    .padding()
                    .buttonStyle(.borderedProminent)
                }
                .padding(.bottom,10)
                
                AsyncImage(url: URL(string: data.user?.avatarUrl ?? "")) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit
                        )
                        .clipShape(Circle())
                        .shadow(color: .black, radius: 10)
                } placeholder: {
                    Circle()
                        .foregroundColor(.secondary)
                        .shadow(color: .black, radius: 10)
                }
                .frame(width: 120, height: 120)
                Text(data.user?.login ?? "Login")
                    .bold()
                    .font(.system(size: 25))
                
                Text(data.user?.bio ?? "Bio")
                    .padding(.bottom,20)
                
                NavigationLink{
                    if let repos = data.repos{
                        RepoView(repos: repos)
                    }
                }label: {
                    Text("Repos")
                }
                if let follow = data.followers{
                    Text("Followers")
                        .bold()
                        .padding(.top,20)
                    List{
                        ForEach(0..<follow.count, id:\.self){ i in
                            Text(follow[i].login)
                        }
                    }
                }
                Spacer()
            }
            .sheet(isPresented: $isOpen){
                History(data: data, controller: controller, isOpen: $isOpen)
            }
            .padding()
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
