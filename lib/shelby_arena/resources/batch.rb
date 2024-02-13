module ShelbyArena
  class Client
    module Batch
      def list_batches(name: nil, start_date: nil, end_date: nil)
        path = 'batch/list'
        options = {}

        options[:batchName] = name if name
        options[:startDate] = start_date if start_date
        options[:endDate] = end_date if end_date

        options[:api_sig] = generate_api_sig(path, options)

        res = get(path, options.sort)
        Response::Batch.format_list(res.dig('BatchListResult', 'Batches', 'Batch'))
      end

      def find_batch(id, options = {})
        path = "batch/#{id}"
        options[:api_sig] = generate_api_sig(path, options)

        res = get(path, options.sort)
        Response::Batch.format(res.dig('Batch'))
      end

      def create_batch(name:, start_date:, end_date:)
        path = 'batch/add'
        body = {
          BatchName: name,
          BatchDate: start_date,
          BatchDateEnd: end_date
        }

        options = {}
        options[:api_sig] = generate_api_sig(path, options)
        json_body = body.to_json

        res = json_post("#{path}?api_session=#{options[:api_session]}&api_sig=#{options[:api_sig]}", json_body)

        res.dig('ModifyResult', 'Link').split('/').last
      end

      def delete_batch(id, options = {})
        path = "batch/#{id}"
        options[:api_sig] = generate_api_sig(path, options)
        delete(path, options.sort)
      end
    end
  end
end
