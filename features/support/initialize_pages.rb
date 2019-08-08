class InitializePages
    def login
        @login_name ||= LoginPage.new
    end

    def purchases
        @purchases ||= PurchasesPage.new
    end

    def purchases_new
        @purchases_new ||= PurchasesNewPage.new
    end

    def vendors_new
        @vendors_new ||= VendorsNewPage.new
    end

    def vendors_index
        @vendors_index ||= VendorsIndexPage.new
    end

    def vendors_detail
        @vendors_detail ||= VendorsDetailPage.new
    end

    def vendors_edit
        @vendors_edit ||= VendorsEditPage.new
    end
    
    def sign_up
        @sign_up ||= SignUpPage.new
    end

    def dashboard
        @dashboard ||= DashboardPage.new
    end

    def password_new
        @password_new ||= PasswordNewPage.new
    end

    def registers_index
        @registers_index ||= RegistersIndexPage.new
    end

    def registers_new
        @registers_new ||= RegistersNewPage.new
    end

    def registers_detail
        @registers_detail ||= RegistersDetailPage.new
    end

    def registers_edit
        @registers_edit ||= RegistersEditPage.new
    end

    def bank_transfers_new
        @bank_transfers_new ||= BankTransfersNewPage.new
    end

    def bank_transfers
        @bank_transfers ||= BankTransfersPage.new
    end

    def bank_transfers_edit
        @bank_transfers_edit ||= BankTransfersEditPage.new
    end

    def bank_deposits_new
        @bank_deposits_new ||= BankDepositsNewPage.new
    end

    def bank_deposits
        @bank_deposits ||= BankDepositsPage.new
    end

    def bank_deposits_edit
        @bank_deposits_edit ||= BankDepositsEditPage.new
    end
end