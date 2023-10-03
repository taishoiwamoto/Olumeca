# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

categories = [
  'Ilustración & Cómics',
  'Diseño',
  'Creación de sitios web & Diseño web',
  'Video, Animación & Filmación',
  'Marketing & Atracción web',
  'Música & Narración',
  'Escritura & Traducción',
  'Representación de negocios, Consultoría & Servicios profesionales',
  'IT, Programación & Desarrollo',
  'Adivinación',
  'Consejería, Consejos de amor & Compañía',
  'Aprendizaje, Idioma, Búsqueda de empleo, Certificación & Coaching',
  'Vivienda, Belleza, Estilo de vida & Pasatiempos',
  'Lecciones en línea & Consejos',
  'Dinero, Trabajos secundarios & Marketing de afiliados'
]

categories.each do |category|
  Category.create!(name: category)
end

delivery_methods = ['Videollamada', 'Chat']

delivery_methods.each do |method|
  DeliveryMethod.create!(name: method)
end
