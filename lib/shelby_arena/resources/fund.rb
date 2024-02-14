module ShelbyArena
  class Client
    module Fund
      def list_funds
        options = {}
        options[:api_sig] = generate_api_sig(fund_path, options)
        res = get(fund_path, options.sort)
        Response::Fund.format(res.dig('FundListResult', 'Funds', 'Fund'))
      end

      def find_fund(id, options = {})
        options[:api_sig] = generate_api_sig(fund_path(id), options)
        res = get(fund_path(id), options.sort)
        Response::Fund.format(res.dig('Fund'))
      end

      private

      def fund_path(id = nil)
        id ? "fund/#{id}" : 'fund/list'
      end
    end
  end
end
