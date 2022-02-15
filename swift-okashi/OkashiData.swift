//
//  OkashiData.swift
//  swift-okashi
//
//  Created by 後藤遥 on 2022/02/15.
//

import Foundation
import UIKit

// identifiableはidプロパティが必須
struct OkashiItem: Identifiable {
    let id = UUID()
    let name: String
    let link: URL
    let image: URL
}

class OkashiData: ObservableObject {
    // Codableだとjsonの変数名と揃えることで変換時、変数に勝手に格納してくれるらしい
    struct ResultJson: Codable {
        struct Item: Codable {
            let name: String?
            let url: URL?
            let image: URL?
        }
        let item: [Item]?
    }
    
    // publishedはプロパティを自動で監視通知してくれる
    // StateObjectを使ってるから使えるらしくこれをpublishにしておくと追加されたらcontentviewnのviewが再描画されるって感じ。
    @Published var okashiList: [OkashiItem] = []
    
    func searchOkashi(keyword: String) async {
        print(keyword)
        
        guard let keyword_encode = keyword.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            return
        }
        
        guard let req_url = URL(
            string:
                "https://sysbird.jp/toriko/api/?apikey=guest&format=json&keyword=\(keyword_encode)&max=30&order=r"
        ) else {
            return
        }
        print(req_url)
        
        do {
            // appleはデフォルトでhttpと通信できない、またhttpsであってもセキュリティ要件を満たしていないと接続できない
            let (date, _) = try await URLSession.shared.data(from: req_url)
            
            let decoder = JSONDecoder()
            let json = try decoder.decode(ResultJson.self, from: date)
            print(json)
            guard let items = json.item else {
                return
            }
            // 前のデータを初期化
            DispatchQueue.main.async {
                self.okashiList.removeAll()
            }
            
            for item in items {
                if let name = item.name,
                   let link = item.url,
                   let image = item.image {
                    let okashi = OkashiItem(name: name, link: link, image: image)
                    DispatchQueue.main.async {
                        self.okashiList.append(okashi)
                    }
                }
            }
            print(self.okashiList)
        } catch {
            print("エラー")
        }
    }
}
