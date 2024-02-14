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
        response = to_h(MAP, data)
        response[:active] = to_boolean(response[:active])
        response[:is_tax_deductible] = to_boolean(response[:is_tax_deductible])
        response[:start_date] = date_parse(response[:start_date])
        response[:end_date] = date_parse(response[:end_date])
        response
      end
    end
  end
end
