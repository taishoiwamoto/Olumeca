# このファイルは、Ruby on Railsのアプリケーションでデータベースに初期データを追加するためのシードデータを定義しています。
# db/seeds.rbとして位置づけられるこのファイルは、アプリケーションの初期セットアップ時や、データベースをリセットした後に、
# 必要なデフォルトデータを簡単にデータベースに挿入するために使われます。

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

# カテゴリーのデフォルト値を定義
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

# カテゴリーを全て削除
Category.delete_all

# カテゴリーを作成
categories.each do |category|
  Category.create!(name: category)
end
