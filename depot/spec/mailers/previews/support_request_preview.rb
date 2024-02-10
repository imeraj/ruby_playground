# Preview all emails at http://localhost:3000/rails/mailers/support_request
class SupportRequestPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/support_request/respond
  def respond
    support_request = SupportRequest.first
    SupportRequestMailer.respond(support_request)
  end

end
