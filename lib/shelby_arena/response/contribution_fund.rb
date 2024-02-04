module ShelbyArena
  module Response
    class ContributionFund < Base
      MAP = {
        id: 'ContributionFundId',
        contribution_id: 'ContributionId',
        amount: 'Amount',
        fund: 'Fund',
        fund_id: 'FundId'
      }.freeze

      def format_single(data)
        response = to_h(MAP, data)
        response[:fund] = Fund.format(response[:fund])
        response[:amount] = response[:amount].to_f
        response
      end
    end
  end
end
