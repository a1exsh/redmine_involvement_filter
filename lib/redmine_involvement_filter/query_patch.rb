module RedmineInvolvementFilter
  module QueryPatch
    unloadable

    def self.included(base)
      base.class_eval do
        alias_method_chain :available_filters, :involvement
      end
    end

    def available_filters_with_involvement
      return @available_filters if @available_filters

      available_filters_without_involvement

      if User.current.logged?
        @available_filters["involvement"] = {
          :type => :list,
          :values => [[l(:text_involved), "1"]],
          :order => 4  # places it next to the Assignee filter
        }
      end

      @available_filters
    end

    def sql_for_involvement_field(field, operator, value)
      uid = User.current.id
      if operator == '='
        op = '='
        inop = 'IN'
        whereop = 'OR'
      else
        op = '<>'
        inop = 'NOT IN'
        whereop = 'AND'
      end

      ids_sql = %(
SELECT DISTINCT journalized_id
  FROM #{Journal.table_name}
 WHERE journalized_type='Issue'
   AND user_id #{op} #{uid}
)
      sql = ["#{Issue.table_name}.assigned_to_id #{op} #{uid}",
             "#{Issue.table_name}.author_id #{op} #{uid}",
             "#{Issue.table_name}.id #{inop} (#{ids_sql})"].join(" #{whereop} ")

      "(#{sql})"
    end
  end
end
