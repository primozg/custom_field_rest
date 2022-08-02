Redmine::Plugin.register :custom_field_rest do
  require 'custom_field_rest/custom_fields/formats/rest'
  require 'custom_rest_search_hook'
  name 'Redmine SVN TAGS Custom Field Label plugin'
  author 'Primož Gorkič'
  description 'This is a plugin for Redmine which adds tags from subvesrion webdav to Custom Fields'
  version '3.2'
  url 'https://github.com/primozg/custom_field_rest'

end

CustomField.safe_attributes(
  'rest',
  'svn',
  'svnusr',
  'svnpwd'
)

