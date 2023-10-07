# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

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

delivery_methods = ['Videollamada', 'Chat']

Category.delete_all
DeliveryMethod.delete_all

categories.each do |category|
  Category.create!(name: category)
end

delivery_methods.each do |method|
  DeliveryMethod.create!(name: method)
end
