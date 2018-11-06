//
//  SORModel.swift
//  SchoolOfRock
//
//  Created by John Paul Manoza on 06/11/2018.
//  Copyright © 2018 topsi. All rights reserved.
//

import Foundation
import Alamofire

class SORModel {
    private let kClientId: String = "4f099d12ffc6417da6a6df1a9f06201f";
    private let kSecretId: String = "7c1ed75222df47c390f963faf8df3adb";
    private let kB64Key: String = "NGYwOTlkMTJmZmM2NDE3ZGE2YTZkZjFhOWYwNjIwMWY6N2MxZWQ3NTIyMmRmNDdjMzkwZjk2M2ZhZjhkZjNhZGI=";
    private let kClientCallback: String = "SOR://loginCallback"
    
    init() {
        
    }
    
    func getAuthenticateUrl() -> String {
        var kApiUrl = "https://accounts.spotify.com/en/authorize?client_id=";
        kApiUrl += self.kClientId + "&response_type=code&redirect_uri=SOR:%2F%2FloginCallback";
        return kApiUrl;
    }
    
    func generateAuthToken(item: String) {
        let trim: String = "sor://logincallback/?code=";
        let trimmed: String = item.replacingOccurrences(of: trim, with: "");
        
        let redirect: String = "&redirect_uri=" + kClientCallback;
        let code: String = "&code=" + trimmed;
        let client: String = "&client_id=" + kClientId;
        let secret: String = "&client_secret=" + kSecretId;
        
        var endpoint: String = "https://accounts.spotify.com/api/token?grant_type=authorization_code";
        endpoint = endpoint + redirect + code + client + secret;
        
        print("using endpoint", endpoint);
        
        Alamofire.request(endpoint, method: .post).response { response in
            print("using response", response);
        }
        
        UserDefaults.standard.set(code, forKey: "token");
    }
    
    func getToken() -> String? {
        return UserDefaults.standard.value(forKey: "token") as? String;
    }
}
