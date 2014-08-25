require 'redmine'

#require 'application_helper_patch'

#Rails.configuration.to_prepare do
#  ApplicationHelper.send(:include, PluginName::Patches::ApplicationtHelperPatch) unless ApplicationHelper.included_modules.include? PluginName::Patches::ApplicationtHelperPatch
#end

Redmine::Plugin.register :scrum2b do
  name 'Scrum2B Plugin'
  author 'ScrumTobe Team'
  description %Q{A scrum tool for team to work:
                  - Scrum board
                  - Customize views
                }
  version '2.0'
  url 'https://github.com/scrum2b/scrum2b'
  author_url 'http://www.scrumtobe.com'

  settings :default => {'status_no_start'=> {}, 'status_inprogress' => {}, 'status_completed' => {}, 'status_closed' => {} }, :partial => 'settings/scrum2b'
  
  project_module :scrum2b do
    permission :s2b_view_issue, {'s2b_api/issues' => [:index] }, :public => true
    permission :s2b_edit_issue, {'s2b_api/issues' => [:index] }  , :public => true    
  end
  menu :project_menu, :scrum2b, { :controller => "s2b_api/issues", :action => :index }, :caption => :label_scrum2b, :after => :activity, :param => :project_id
end
