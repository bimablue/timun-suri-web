class InitializeRequirement
  def login
	  @login ||= LoginRequirement.new
  end

  def message
	  @message ||= MessageRequirement.new
  end

  def account
    @account ||= CashAndBankRequirement.new
  end
end