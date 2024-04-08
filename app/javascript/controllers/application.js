// "@hotwired/stimulus"パッケージからApplicationクラスをインポートします。
// Applicationクラスは、Stimulusアプリケーションのルートとなり、
// コントローラの登録や設定などを管理します。
import { Application } from "@hotwired/stimulus"

// Stimulus Applicationインスタンスを作成し、
// そのインスタンスを変数applicationに割り当てます。
// Application.start()メソッドによって、Stimulusアプリケーションが初期化されます。
const application = Application.start()

// 開発者向けの設定を行います。
// application.debugをfalseに設定することで、
// 開発中のデバッグ出力を無効化します。
application.debug = false

// Stimulusアプリケーションのインスタンスをグローバル変数window.Stimulusに割り当てます。
// これにより、ブラウザのコンソールからアクセス可能になり、
// デバッグや実験が容易になります（ただし、ここではデバッグは無効化されています）。
window.Stimulus   = application

// application変数をexportして、他のJavaScriptモジュールから
// このStimulusアプリケーションのインスタンスにアクセスできるようにします。
export { application }

// 'hi'というテキストを持つアラートダイアログを表示します。
// この行は、ページがロードされた際にユーザーに対して直接的なフィードバックを提供するために使用されます。
// ただし、実際のアプリケーションでは、このようなアラートを本番環境で使用することは推奨されません。
alert('hi')