require 'redmine'
require 'dispatcher'

Dispatcher.to_prepare do
  require_dependency 'query'

  Query.send(:include, RedmineInvolvementFilter::QueryPatch)
end

Redmine::Plugin.register :redmine_involvement_filter do
  name 'Redmine Issue Involvement Filter plugin'
  author 'Alex Shulgin <ash@commandprompt.com>'
  description 'A plugin to filter out issues in which the current user is involved.'
  version '0.0.1'
#  url 'http://example.com/path/to/plugin'
#  author_url 'http://example.com/about'
end
