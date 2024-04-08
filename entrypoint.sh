# 初回起動時のみに処理したい内容を記述するヘルパースクリプト

#!/bin/bash
set -e

# Railsのserver.pidファイルを削除します（前回の起動時に異常終了した場合などに備えて）
rm -f /Olumeca/tmp/pids/server.pid

# コンテナのメインプロセス（DockerfileでCMDで指定されたもの）を実行します
exec "$@"
