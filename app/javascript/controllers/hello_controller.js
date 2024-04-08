// "@hotwired/stimulus"からControllerクラスをインポートします。
// Controllerクラスは、Stimulusにおける全てのコントローラーの基底クラスです。
import { Controller } from "@hotwired/stimulus"

// Controllerクラスを継承して匿名クラスをエクスポートします。
// このクラスは、特定のHTML要素に関連付けられた動作を定義します。
export default class extends Controller {
  // connectメソッドは、このコントローラーがHTML要素に接続された際に自動的に呼び出されます。
  // Stimulusのライフサイクルコールバックの一つであり、DOM要素の初期化やイベントリスナーの設定に使用されます。
  connect() {
    // this.elementは、このコントローラーが関連付けられたDOM要素を参照します。
    // ここでは、その要素のtextContentプロパティを"Hello World!"という文字列に設定しています。
    // これにより、コントローラーが接続されているHTML要素の内容が"Hello World!"に置き換わります。
    this.element.textContent = "Hello World!"
  }
}
