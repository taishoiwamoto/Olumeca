# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

categories = [
  'Ilustración',
  'Diseño',
  'Creación de sitios web・Diseño web',
  'Vídeo・Animación・Grabación',
  'Marketing',
  'Música・Narración',
  'Redacción・Traducción',
  'Negocios・Consultoría・Profesiones',
  'IT・Programación・Desarrollo',
  'Adivinación',
  'Asesoramiento・Consejería de amor・Compañía para hablar',
  'Escuela・Educación・Aprendizaje・Empleo・Certificación',
  'Idioma・Linguística',
  'Vivienda・Belleza・Vida・Pasatiempos',
  'Dinero・Trabajo secundario',
  'Otros'
]

delivery_methods = ['Videollamada', 'Chat']

Category.delete_all
DeliveryMethod.delete_all

categories.each do |category|
  Category.create!(name: category)
end

delivery_methods.each do |method|
  DeliveryMethod.create!(name: method)
end
