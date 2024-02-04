module ShelbyArena
  module Response
    class Contribution < Base
      MAP = {
        id: 'ContributionId',
        batch_id: 'BatchId',
        amount: 'CurrencyAmount',
        date: 'ContributionDate',
        memo: 'Memo',
        person_id: 'PersonId',
        person: 'PersonInformation',
        transaction_number: 'TransactionNumber',
        currency_type_id: 'CurrencyTypeId',
        currency_type_value: 'CurrencyTypeValue',
        contribution_funds: 'ContributionFunds'
      }.freeze


      def format_single(data)
        response = to_h(MAP, data)
        response[:contribution_funds] = ContributionFund.format(response[:contribution_funds].dig('ContributionFund')) if response[:contribution_funds]
        response[:person] = Person.format(response[:person])
        response[:amount] = response[:amount].to_f
        response
      end
    end
  end
end
