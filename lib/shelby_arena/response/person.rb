module ShelbyArena
  module Response
    class Person < Base
      MAP = {
        age: 'Age',
        first_name: 'FirstName',
        last_name: 'LastName',
        person_id: 'PersonID',
        person_link: 'PersonLink',
        gender: 'Gender',
        campus_id: 'CampusID',
        campus: 'CampusName'
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
        emails_key = parse_emails_key(raw_response.dig('Emails', 'Email'))

        raw_response.dig('FirstActiveEmail') || emails_key.first
      end

      def set_emails(raw_response)
        # find_person returns an array of `Emails`
        # list_person return `FirstActiveEmail`
        parse_emails_key(raw_response.dig('Emails', 'Email'))
      end

      def parse_emails_key(emails_key)
        if emails_key.is_a?(Array)
          emails_key&.map { |email| email.dig('Address') } || []
        else
          [emails_key&.dig('Address')] || []
        end
      end
    end
  end
end
