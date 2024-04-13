// Import and register all your controllers from the importmap under controllers/*

// 'controllers/application'からapplicationオブジェクトをインポートします。
// これはStimulusアプリケーションのインスタンスです。
import { application } from "controllers/application"

// Eager load all controllers defined in the import map under controllers/**/*_controller
// import mapに定義されたすべてのコントローラーを事前にロードします。
// 'controllers'ディレクトリ下のすべてのコントローラーファイルを、Stimulusアプリケーションに登録します。
import { eagerLoadControllersFrom } from "@hotwired/stimulus-loading"
eagerLoadControllersFrom("controllers", application)

// Lazy load controllers as they appear in the DOM (remember not to preload controllers in import map!)
// import { lazyLoadControllersFrom } from "@hotwired/stimulus-loading"
// lazyLoadControllersFrom("controllers", application)
