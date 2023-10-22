class HomeController < ApplicationController
  def top
    #未対応 [重要度: 低] Serviceの量が増えてきたときに動作が遅くなる可能性があります。DBに適切なインデックスを張ることをお勧めします。
    # activeで絞ってから並び替えをしているため、deleted_at, created_atの複合インデックスが必要な認識です。
    # explainを用いるとindexが利用されているかどうかの調査ができるので確認してみてください。
    # https://qiita.com/buntafujikawa/items/c6e7bfa99c1814811863
    @services = Service.active.order(created_at: :desc).limit(4)
  end
end
