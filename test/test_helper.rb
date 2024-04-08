# テストを実行する環境として「test」を指定します。すでに環境変数が設定されている場合はその値を使用し、
# そうでない場合は「test」を使用します。これにより、テスト実行時に本番環境や開発環境に影響を与えることなく、
# テスト環境でのみ実行されることが保証されます。
ENV["RAILS_ENV"] ||= "test"
# Railsアプリケーションの環境設定ファイルを読み込みます。これによりテスト実行に必要な
# アプリケーションの設定や依存関係がロードされます。
require_relative "../config/environment"

# Railsの標準的なテストヘルパーを読み込みます。これによりテストケースの定義や
# テスト実行のための各種メソッドが利用可能になります。
require "rails/test_help"

class ActiveSupport::TestCase
  # テストを複数のプロセッサで並列実行する設定を行います。これによりテストの実行時間が短縮され、
  # より効率的にテストを行うことができます。
  parallelize(workers: :number_of_processors)

  # テスト用のフィクスチャデータをセットアップします。フィクスチャは、テスト実行前に
  # データベースにロードされるテストデータのことで、test/fixturesディレクトリ下に
  # YAMLフォーマットで定義されています。`:all`を指定することで全てのフィクスチャが利用可能になります。
  fixtures :all

  # 他のテストケースでも共通して使用するヘルパーメソッドをここで定義することができます。
  # これにより、テストコードの重複を避け、メンテナンス性を向上させることができます。
end
