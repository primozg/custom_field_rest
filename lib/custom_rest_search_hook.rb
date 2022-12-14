class CustomRestSearchHookListener < Redmine::Hook::ViewListener

  def view_layouts_base_html_head(context={})
    html = "\n<!-- [custom field rest plugin] -->\n"
    html << stylesheet_link_tag("rest_search", plugin: "custom_field_rest")
    html << javascript_include_tag("rest_field.js", plugin: "custom_field_rest")
    return html
  end

  def  view_issues_form_details_bottom(context={})
    html = ""
      context[:issue].available_custom_fields.each do |field|
        if field.is_a?(IssueCustomField)
          if field.field_format == 'rest_search'
              options =Hash[];
              html << "<script>\n"
              html << "//<![CDATA[\n"
              html << "observeRestField(\'issue_custom_field_values_#{field.id}\', \'#{Redmine::Utils.relative_url_root}/custom_rest_search/search?project_id=#{context[:issue].project_id}&issue_id=#{context[:issue].id}&custom_field_id=#{field.id}\', JSON.parse(#{options.to_json.dump}))\n"
              html << "//]]>\n"
              html << "</script>\n"
          end
        end
      end
    return html
  end
end
