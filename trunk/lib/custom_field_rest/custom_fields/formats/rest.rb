module CustomFieldRest
  module CustomFields
    module Formats

      class RestSearch < Redmine::FieldFormat::List
        add 'rest_search'
        field_attributes :rest, :svn, :svnusr, :svnpwd, :svnca
        self.form_partial = 'custom_fields/formats/rest'

      end

    end
  end
end
