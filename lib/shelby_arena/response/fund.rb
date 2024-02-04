module ShelbyArena
  module Response
    class Fund < Base
      MAP = {
        id: 'FundId',
        active: 'Active',
        name: 'FundName',
        online_name: 'OnlineName',
        description: 'FundDescription',
        is_tax_deductible: 'TaxDeductible',
        start_date: 'StartDate',
        end_date: 'EndDate'
      }.freeze

      def format_single(data)
        to_h(MAP, data)
      end
    end
  end
end
