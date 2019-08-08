class LoginRequirement
  include DataMagic
  DataMagic.load 'credential.yml'

  def load_crendential_details(user_details)
    data_for "credential/#{user_details}"
  end
end