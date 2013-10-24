require 'redmine'
require 'open-uri'
require 'issue'

Redmine::Plugin.register :redmine_wiki_sql do
  name 'Redmine Wiki SQL'
  author 'NewGyu(Rodrigo Ramalho)'
  author_url 'https://github.com/NewGyu/redmine_wiki_sql'
  description 'Allows you to run SQL queries and have them shown on your wiki in table format'
  version '0.0.1'

  Redmine::WikiFormatting::Macros.register do
    desc "Run SQL query"
    macro :sql do |obj, args, text|

        _sentence = text
        _sentence = _sentence.gsub("\\(", "(")
        _sentence = _sentence.gsub("\\)", ")")
        _sentence = _sentence.gsub("\\*", "*")

        result = ActiveRecord::Base.connection.execute(_sentence)
        unless result.nil?
          unless result.size == 0
            column_names = []
            for f in result.fields.each do
              column_names << f
            end

            _thead = '<tr>'
            column_names.each do |column_name|
              _thead << '<th>' + column_name.to_s + '</th>'
            end
            _thead << '</tr>'

            _tbody = ''
            result.each do |r|
              _tbody << '<tr>'
              r.each do |c|
                _tbody << "<td>#{c}</td>"
              end
              _tbody << '</tr>'
            end

            text = '<table class="list">' << _thead << _tbody << '</table>' 

            text.html_safe
          else
            ''.html_safe
          end
        else
          ''.html_safe
        end
    end 
  end
	
end
