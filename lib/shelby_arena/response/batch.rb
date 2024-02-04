module ShelbyArena
  module Response
    class Batch < Base
      MAP = {
        name: 'BatchName',
        id: 'BatchId',
        start_date: 'BatchDate',
        end_date: 'BatchDateEnd',
        verify_amount: 'VerifyAmount',
        finalized: 'Finalized'
      }.freeze

      def format_single(data)
        response = to_h(MAP, data)
        response[:start_date]    = date_parse(response[:start_date])
        response[:end_date]      = date_parse(response[:end_date])
        response[:verify_amount] = response[:verify_amount].to_f
        response[:finalized]     = to_boolean(response[:finalized])
        response
      end
    end
  end
end
