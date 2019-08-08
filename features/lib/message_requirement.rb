class MessageRequirement
  include DataMagic
  DataMagic.load 'message.yml'

  def load_notification(message)
    data_for "message/#{message}"
  end
end