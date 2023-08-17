//
//  RepoView.swift
//  mvvmAPI
//
//  Created by Luca Lacerda on 16/08/23.
//

import SwiftUI

struct RepoView: View {
    var repos:[Repos]
    
    var body: some View {
        VStack{
            List{
                ForEach(repos) { rep in
                    Text(rep.name)
                }
            }
        }
    }
}

struct RepoView_Previews: PreviewProvider {
    static var previews: some View {
        RepoView(repos: [])
    }
}
