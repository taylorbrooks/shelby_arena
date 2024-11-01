module ShelbyArena
  class Client
    module Contribution

      def list_contributions(options = {})
        options[:api_sig] = generate_api_sig(contribution_path, options)
        res = get(contribution_path, options.sort)
        Response::Contribution.format(res.dig('ContributionListResult', 'Contributions', 'Contribution'))
      end

      def find_contributions_by_batch_id(batch_id, options = {})
        path = "batch/#{batch_id}/contribution/list"
        options[:api_sig] = generate_api_sig(path, options)

        res = get(path, options.sort)
        Response::Contribution.format(res.dig('ContributionListResult', 'Contributions', 'Contribution'))
      end

      def find_contribution(id, options = {})
        options[:api_sig] = generate_api_sig(contribution_path(id), options)
        res = get(contribution_path(id), options.sort)
        Response::Contribution.format(res.dig('Contribution'))
      end

      def create_contribution(
        batch_id,
        person_id:,
        date:,
        currency_type_id:,
        transaction_number:,
        contribution_funds:
      )
        path = "batch/#{batch_id}/contribution/add"

        body = {
          'BatchId' => batch_id,
          'CurrencyAmount' => sum_of_funds(contribution_funds),
          'TransactionNumber' => transaction_number,
          'ContributionDate' => date,
          'CurrencyTypeId' => currency_type_id,
          'PersonId' => person_id,
          'ContributionFunds' => translate_funds(contribution_funds)
        }

        options = {}
        options[:api_sig] = generate_api_sig(path, options)

        res = json_post("#{path}?api_session=#{options[:api_session]}&api_sig=#{options[:api_sig]}", body.to_json)

        if res.dig('ModifyResult', 'Successful').downcase == 'false'
          raise ShelbyArena::Error, res.dig('ModifyResult')
        else
          res.dig('ModifyResult', 'ObjectID')
        end
      end

      private

      def sum_of_funds(contribution_funds)
        contribution_funds.map { |fund| fund[:amount] }.sum.round(2)
      end

      def translate_funds(contribution_funds)
        contribution_funds.map do |fund|
          {
            'FundId' => fund[:fund_id],
            'Amount' => fund[:amount]
          }
        end
      end

      def contribution_path(id = nil)
        id ? "contribution/#{id}" : 'contribution/list'
      end
    end
  end
end
