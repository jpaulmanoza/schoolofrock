//
//  SORModel.swift
//  SchoolOfRock
//
//  Created by John Paul Manoza on 06/11/2018.
//  Copyright © 2018 topsi. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import ObjectMapper
import RxSwift

class SORModel {
    static var sharedInstance = SORModel()
    
    private let kClientId: String = "4f099d12ffc6417da6a6df1a9f06201f";
    private let kSecretId: String = "7c1ed75222df47c390f963faf8df3adb";
    private let kB64Key: String = "NGYwOTlkMTJmZmM2NDE3ZGE2YTZkZjFhOWYwNjIwMWY6N2MxZWQ3NTIyMmRmNDdjMzkwZjk2M2ZhZjhkZjNhZGI=";
    private let kClientCallback: String = "SOR://loginCallback";
    
    let token$: Variable<String?> = Variable(nil);
    let albums$: Variable<[SORAlbum]> = Variable([]);
    
    init() {
        // persist user
        if let existingToken = self.getToken() {
            token$.value = existingToken;
        }
    }
    
    func getAuthenticateUrl() -> String {
        var kApiUrl = "https://accounts.spotify.com/en/authorize?client_id=";
        kApiUrl += self.kClientId + "&response_type=code&redirect_uri=SOR:%2F%2FloginCallback";
        return kApiUrl;
    }
    
    func generateAuthToken(item: String) {
        let trim: String = "sor://logincallback/?code=";
        let code: String = item.replacingOccurrences(of: trim, with: "");
        
        let endpoint: String = "https://accounts.spotify.com/api/token";
        let params: [String: Any] = [
            "grant_type": "authorization_code",
            "code": code, "redirect_uri": kClientCallback,
            "client_id": kClientId, "client_secret": kSecretId
        ]
        
        Alamofire.request(endpoint, method: .post, parameters: params).responseJSON { response in
            if let data = response.result.value {
                let json = JSON(data); let token = json["access_token"].stringValue;
                
                // notify change
                self.token$.value = token;
                
                /// save for later use
                UserDefaults.standard.set(token, forKey: "token");
                
            }
        }
    }
    
    func getAlbums(qTerm: String = "School Of Rock", page: Int = 0) {
        // url encode query
        let query = qTerm.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!;

        let endpoint = "https://api.spotify.com/v1/search?type=album&q=" + query + "&limit=5";
        let header: HTTPHeaders = self.requestHeader();
        
        Alamofire.request(endpoint, headers: header).responseJSON { response in
            if let data = response.result.value {
                let json = JSON(data);
                // TODO: Addd Mapper to catch album -> items (e.g. SORAlbumPage)
                let albumItems = String(describing: json["albums"]);
                guard let albumPages = Mapper<SORAlbumPage>().mapArray(JSONString: albumItems) else {
                    return
                }
                
                var albums: [SORAlbum] = [];
                for page in albumPages {
                    for album in page.pageItems { albums.append(album) }
                }
                
                // notify change
                self.albums$.value.append(contentsOf: albums);
            }
        }
    }
    
    private func getToken() -> String? {
        return UserDefaults.standard.string(forKey: "token");
    }
    
    private func requestHeader() -> [String: String] {
        var header: [String: String] = [:];
        if let token = self.getToken() {
            header["Authorization"] = "Bearer " + token;
        }
        return header;
    }
}
