//
//  Credentials.swift
//  Spochify
//
//  Created by Alberto on 10/05/2019.
//  Copyright © 2019 com.github.albertopeam. All rights reserved.
//

import Foundation

struct Credential {
    let clientId: String
    let redirectUri: String
}

class Credentials {
    
    private let fileName: String
    
    init(fileName: String = "SpotifyCredentials") {
        self.fileName = fileName
    }
    
    func get() -> Credential {
        guard let path = Bundle.main.path(forResource: fileName, ofType: "plist"),
            let xml = FileManager.default.contents(atPath: path),
            let credential = try? PropertyListDecoder().decode(CredentialCodable.self, from: xml) else {
                fatalError("Couldn't decode \(fileName)")
        }
        return Credential(clientId: credential.clientId, redirectUri: credential.redirectUri)
    }
    
    struct CredentialCodable: Codable {
        let clientId: String
        let redirectUri: String
    }
    
}
