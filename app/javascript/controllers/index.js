// Import and register all your controllers from the importmap under controllers/*
// 以下の行で、importmap内のcontrollers/*にあるすべてのコントローラーをインポートし、アプリケーションに登録します。
import { application } from "controllers/application"

// Eager load all controllers defined in the import map under controllers/**/*_controller
// controllers/**/*_controllerの下に定義されたすべてのコントローラーをイーガーロード（事前にロード）します。
// イーガーロードは、ページの読み込み時に全てのコントローラーを一度にロードする方法です。
import { eagerLoadControllersFrom } from "@hotwired/stimulus-loading"
eagerLoadControllersFrom("controllers", application)

// Lazy load controllers as they appear in the DOM (remember not to preload controllers in import map!)
// DOMに表示されるにつれて、コントローラーを遅延ロードします。（import mapでコントローラーをプリロードしないように注意してください！）
// 遅延ロードは、必要になるまでコントローラーのロードを遅らせることで、ページの初期読み込み時間を短縮する技術です。
// import { lazyLoadControllersFrom } from "@hotwired/stimulus-loading"
// lazyLoadControllersFrom("controllers", application)
