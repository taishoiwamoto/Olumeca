# このファイルは、Rubyのプロジェクトにおける環境設定を扱うための初期化スクリプトの一部です。
# 主にRuby on Railsのアプリケーションで見られる構成ですが、他のRubyプロジェクトでも使用されることがあります。

ENV["BUNDLE_GEMFILE"] ||= File.expand_path("../Gemfile", __dir__)

require "bundler/setup" # Set up gems listed in the Gemfile.
require "bootsnap/setup" # Speed up boot time by caching expensive operations.
