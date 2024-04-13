// "@hotwired/stimulus"からControllerクラスをインポートします。
// Stimulusの基本的なコントローラー機能を継承することで、独自のコントローラーを作成できます。
import { Controller } from "@hotwired/stimulus"

// 新しいクラスを定義し、StimulusのControllerクラスを継承します。
// export defaultを使用して、このクラスを他のファイルからインポート可能にします。
export default class extends Controller {
  // connectメソッドは、コントローラーがDOMに接続されたときに自動的に呼ばれます。
  connect() {
    // this.elementは、このコントローラーが適用されるDOM要素を参照します。
    // textContentプロパティを使用して、要素のテキストを"Hello World!"に設定します。
    this.element.textContent = "Hello World!"
  }
}
