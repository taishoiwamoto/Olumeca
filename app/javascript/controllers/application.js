// "@hotwired/stimulus"からApplicationクラスをインポートします。
// Stimulusは、Basecamp社によって開発されたJavaScriptフレームワークです。このフレームワークは、既存のHTMLに対して行動を追加することに焦点を当てており、特にRailsアプリケーションと組み合わせて使われることが多いですが、任意のWebプロジェクトで使用することが可能です。
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