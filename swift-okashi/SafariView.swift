//
//  SafariView.swift
//  swift-okashi
//
//  Created by 後藤遥 on 2022/02/15.
//

import SwiftUI
import SafariServices

// おそらくUIViewControllerRepresentableのクラスを継承するのに
// まずmakeUIView, updateUIViewは必須
// でmakeUIViewが勝手に実行されてSFSafariViewControllerっていうUIKit？の機能か知らんけどwebviewを表示できるインスタンスを返す
// それらのラッパーがこのrepresentableって感じか。あとはこれに適切にプロパティを入れたら簡単にある程度は表示できるって感じですね。
struct SafariView: UIViewControllerRepresentable {
    var url: URL
    func makeUIViewController(context: Context) -> SFSafariViewController {
        return SFSafariViewController(url: url)
    }
    
    func updateUIViewController(_ uiViewController: SFSafariViewController, context: Context) {}
}
