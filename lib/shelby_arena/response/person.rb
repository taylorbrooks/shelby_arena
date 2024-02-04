module ShelbyArena
  module Response
    class Person < Base
      MAP = {
        age: 'Age',
        first_name: 'FirstName',
        last_name: 'LastName',
        person_id: 'PersonID',
        person_link: 'PersonLink',
        gender: 'Gender'
      }.freeze

      def format_single(data)
        response = to_h(MAP, data)
        response[:email] = set_email(data)
        response[:emails] = set_emails(data)
        response
      end

      private

      def set_email(raw_response)
        # find_person returns an array of `Emails`
        # list_person return `FirstActiveEmail`
        raw_response.dig('FirstActiveEmail') || raw_response.dig('Emails', 'Email', 0, 'Address')
      end

      def set_emails(raw_response)
        # find_person returns an array of `Emails`
        # list_person return `FirstActiveEmail`
        raw_response.dig('Emails', 'Email')&.map { |email| email.dig('Address') } || []
      end
    end
  end
end
