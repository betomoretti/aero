class ContactUsMailer < ActionMailer::Base
  default from: "aerolaplata.web@gmail.com.ar"

  def contact_us(nombre_apellido, empresa, email, consulta)
    @nombre_apellido = nombre_apellido
    @empresa = empresa
    @email = email
    @consulta = consulta
    mail(to: "marianomoretti.87@gmail.com", subject: "Consulta de unique")
  end
end
