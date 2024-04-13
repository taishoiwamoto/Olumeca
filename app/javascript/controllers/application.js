// "@hotwired/stimulus"からApplicationクラスをインポートします。
import { Application } from "@hotwired/stimulus"

// Stimulusアプリケーションのインスタンスを作成し、アプリケーションを開始します。
const application = Application.start()

// Configure Stimulus development experience
// アプリケーションのデバッグモードを設定します。
// debugプロパティをfalseに設定することで、開発中の詳細なログ出力を無効にします。
application.debug = false

// windowオブジェクトにStimulusアプリケーションを割り当てます。
// これにより、ブラウザのコンソールからアプリケーションを直接操作できるようになります。
window.Stimulus   = application

// application変数をエクスポートします。
// 他のファイルやモジュールからこのアプリケーションインスタンスにアクセスできるようにするためです。
export { application }

// ブラウザにアラートを表示し、'hi'というメッセージをユーザーに通知します。
alert('hi')