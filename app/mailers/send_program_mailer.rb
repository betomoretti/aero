class SendProgramMailer < ActionMailer::Base
  default from: "aerolaplata.web@gmail.com.ar"

  def send_program(email, program)
    @program = program
    mail(to: email, subject: "Informacion de #{@program.name} ")
  end
end
