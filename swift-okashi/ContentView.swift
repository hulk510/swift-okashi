//
//  ContentView.swift
//  swift-okashi
//
//  Created by 後藤遥 on 2022/02/15.
//

import SwiftUI

struct ContentView: View {
    @StateObject var okashiDataList = OkashiData()
    @State var inputText = ""
    @State var showSafari = false
    
    var body: some View {
        VStack {
            TextField("キーワード", text: $inputText, prompt: Text("キーワードを入力してください"))
                .onSubmit {
                    Task { // TaskはPromiseみたいな感じかな？
                        await okashiDataList.searchOkashi(keyword: inputText)
                    }
                }
            // これで改行から検索にボタンの名前変えれるらしい。
                .submitLabel(.search)
                .padding()
            // こいつ入れたら勝手に綺麗にしてくれるからいいな
            // okashiListはpublishedやから更新されたタイミングで勝手に描画される。
            // そしてそれをやるために @StateObject var okashiDataList = OkashiData()って定義してる感じかな。
            // データを取得して変換みたいなロジックとそれをviewに表示するってロジックを分けることで再利用しやすくするって感じ。
            // viewまで入ってると再利用がしにくいから基本的には処理と最終的にviewに表示は分けるべきらしい。
            // OkashiDataがclassなのはこの場合apiで常に状態が変化するからstructではアタイコピーになるため参照で渡したいからクラスになってる
            // bindingとpublisedの違いがいまいちわからん。
            List(okashiDataList.okashiList) {
                okashi in // これの書き方謎すぎ
                
                Button(action: {
                    showSafari.toggle()
                }) {
                    HStack {
                        AsyncImage(url: okashi.image) {
                            image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(height:40)
                        } placeholder: {
                            // 読み込み中のインジゲーターを表示するインスタンスらしい
                            ProgressView()
                        }
                        Text(okashi.name)
                    }
                }.sheet(isPresented: self.$showSafari, content: {
                    SafariView(url: okashi.link)
                    // これがあるおかげでしたに黒い部分が出来ずに画面いっぱいに表示してくれるみたい。
                        .edgesIgnoringSafeArea(.bottom)
                })
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
