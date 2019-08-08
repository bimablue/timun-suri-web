module GeneratorFaker
	def faker_vendor_page_new
	  return{ display_name: Faker::Name.unique.first_name + Faker::Name.unique.last_name,
      vendor_email: Faker::Internet.free_email(),
      vendor_tax_no: Faker::Number.number(10),
      vendor_title: 'Mr.',
      vendor_first_name: Faker::Name.unique.first_name,
      vendor_middle_name: Faker::Name.unique.middle_name,
      vendor_last_name: Faker::Name.unique.last_name,
      vendor_mobile: '0856' + Faker::Number.number(7),
      vendor_phone: '021' + Faker::Number.number(7),
      vendor_fax: '021' + Faker::Number.number(7),
      vendor_other: Faker::Lorem.characters(20),
      vendor_billing_address: Faker::Address.full_address
    }
	end

	def faker_cash_and_bank_page_new
	  return{ account_name: Faker::Name.unique.first_name + Faker::Name.unique.last_name,
			account_description: Faker::Lorem.characters(20),
			account_category: ['Cash & Bank', 'Credit Card'].sample,
			account_details: ['None', 'Header Account of :', 'Sub Account of :'].sample,
			account_sub_details: '',
      account_tax: ['PPN', ''].sample,
      account_tags: 'Internal',
			account_bank_name: ['Mandiri', 'BCA', 'BRI'].sample
    }
  end
  
  def faker_contact_new
    first_name = Faker::Name.unique.first_name
    last_name = Faker::Name.unique.last_name
	  return{ contact_name: first_name + last_name,
			contact_type: 'customer',
			contact_bill_address: ['None', 'Header Account of :', 'Sub Account of :'].sample,
			contact_email: Faker::Internet.free_email(),
      contact_tax_no: Faker::Number.number(10),
      contact_title: 'Mr.',
      contact_first_name: first_name,
      contact_middle_name: Faker::Name.unique.middle_name,
      contact_last_name: last_name,
      contact_mobile: '0856' + Faker::Number.number(7),
      contact_phone: '021' + Faker::Number.number(7),
      contact_fax: '021' + Faker::Number.number(7),
      contact_other: Faker::Lorem.characters(20),
    }
  end
end
World(GeneratorFaker)