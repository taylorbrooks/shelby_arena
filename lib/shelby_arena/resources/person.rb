module ShelbyArena
  class Client
    module Person
      def list_people(options = {})
        options[:api_sig] = generate_api_sig(people_path, options)
        res = get(people_path, options.sort)
        Response::Person.format_list(res.dig('PersonListResult', 'Persons', 'Person'))
      end

      def find_people_by_name_and_email(first_name, last_name, email)
        list_people(firstName: first_name, lastName: last_name, email: email)
      end

      def find_people_by_email(email)
        list_people(email: email)
      end

      def find_person(id, options = {})
        path = people_path(id)
        options[:api_sig] = generate_api_sig(path, options)
        res = get(path, options.sort)
        Response::Person.format(res.dig('Person'))
      end

      def create_person(
        first_name:,
        last_name:,
        email:,
        record_status_id: 2
      )
        path = 'person/add'

        body = {
          'FirstName' => first_name,
          'LastName' => last_name,
          'Emails' => ['Address' => email],
          'RecordStatusID' => record_status_id,
        }

        options = {}
        options[:api_sig] = generate_api_sig(path, options)
        res = json_post("#{path}?api_session=#{options[:api_session]}&api_sig=#{options[:api_sig]}", body.to_json)
        res.dig('ModifyResult', 'ObjectID')
      end

      def update_person(
        id,
        first_name: nil,
        last_name: nil,
        email: nil,
        record_status_id: nil
      )
        path = "#{people_path(id)}/update"

        body = {}

        body['FirstName'] = first_name if first_name
        body['LastName'] = last_name if last_name
        body['Emails'] = ['Address' => email] if email
        body['RecordStatusID'] = record_status_id if record_status_id

        options = {}
        options[:api_sig] = generate_api_sig(path, options)

        res = json_post("#{path}?api_session=#{options[:api_session]}&api_sig=#{options[:api_sig]}", body.to_json)
        res.dig('ModifyResult', 'ObjectID')
      end

      private

      def people_path(id = nil)
        id ? "person/#{id}" : 'person/list'
      end
    end
  end
end
