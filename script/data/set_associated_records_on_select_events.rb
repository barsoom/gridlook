# These are Auctionet mailers. Adapt this script to your needs.
events_to_update = {
  "AskBuyerToCheckBankAccountMailer#build" => { param: [ "claim_id" ], model: "ReturnClaim" },
  "AskCustomerToProvideInsuranceClaimDetailsMailer#build" => { param: [ "insurance_claim_id", "claim_id" ], model: "InsuranceClaim" },
  "Seller::InformAboutUsedRightOfWithdrawalMailer#build" => { param: [ "claim_id" ], model: "ReturnClaim" },
  "InformBuyerOfApprovedReturnClaimMailer#build" => { param: [ "claim_id", "return_claim_id" ], model: "ReturnClaim" },
}

events_to_update.each do |mail, options|
  scope = Event.where(mailer_action: mail).where("associated_records = '{}' OR associated_records IS NULL")
  scope.find_each.each do |event|
    id = options[:param].map { |param| JSON::parse(event.unique_args[:arguments])[param] }.compact.first

    event.associated_records = [] if event.associated_records.nil? # atm this is not a not-null-column
    puts event.inspect if id.blank? # debug

    event.associated_records << "#{options[:model]}:#{id}"
    event.save!
    print "."
  end
end
