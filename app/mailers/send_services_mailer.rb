class SendServicesMailer < ActionMailer::Base
  default from: "aerolaplata.web@gmail.com.ar"
  add_template_helper(UniqueHelper)

  def send_services(email, services)
  	p services
    @services = services
    mail(to: email, subject: "Informacion de servicios unique")
  end
end
