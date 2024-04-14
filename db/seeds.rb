# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

# 初期データとしてデータベースに登録するカテゴリーのリスト
categories = [
  'Ilustración・Cómic',
  'Diseño',
  'Creación de sitios web・Diseño web',
  'Video・Animación・Filmación',
  'Marketing・Captación de clientes web',
  'Música・Narración',
  'Redacción・Traducción',
  'Negocios・Consultoría・Profesiones jurídicas',
  'IT・Programación・Desarrollo',
  'Adivinación',
  'Consulta de preocupaciones・Asesoramiento amoroso・Compañía para conversar',
  'Aprendizaje・Empleo・Certificación・Coaching',
  'Vivienda・Belleza・Vida・Hobbies',
  'Lecciones en línea・Asesoramiento',
  'Dinero・Trabajo secundario・Afiliados',
  'Otros'
]

# 既存のカテゴリーを全て削除する
Category.delete_all

# 上記で定義したカテゴリーをデータベースに追加する
# Category.create!(name: category) は、Category モデル（Railsのモデルで、データベースのテーブルに対応しています）を使って新しいレコードを作成します。ここで create! メソッドを使用しており、これは新しいカテゴリをデータベースに保存します。create! メソッドは、name: キーワード引数に category 変数を渡しており、これにより新しいカテゴリの名前が設定されます。
categories.each do |category|
  Category.create!(name: category)
end
