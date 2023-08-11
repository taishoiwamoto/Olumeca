class Contact < ApplicationRecord
  validates :name, presence: { message: ':El nombre no puede estar vacío.' }
  validates :email,presence: { message: ':El correo electrónico no puede estar vacío.' },
            format: { with: URI::MailTo::EMAIL_REGEXP, message: ":Formato de correo electrónico inválido." }
  validates :phone, presence: { message: ':El número de teléfono no puede estar vacío.' }
  validates :message, presence: { message: ':El mensaje no puede estar vacío.' }
end
