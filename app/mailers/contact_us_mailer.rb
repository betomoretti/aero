class ContactUsMailer < ActionMailer::Base
  default from: "aerolaplata.web@gmail.com.ar"

  def contact_us(nombre_apellido, empresa, email, consulta)
    @nombre_apellido = nombre_apellido
    @empresa = empresa
    @email = email
    @consulta = consulta
    mail(to: "unique@aerolaplata.com.ar", subject: "Consulta de unique de #{nombre_apellido}, #{empresa}")
  end
end
