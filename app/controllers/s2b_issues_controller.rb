class S2bIssuesController < ProjectController

  #before_filter :check_before, :only => [:index]
  before_filter :get_members, :only => [:index, :get_data]
  before_filter lambda { check_permission(:edit) }, :only => [:index]
  before_filter lambda { check_permission(:view) }, :only => [:index]
  
  def index
    # issues = Issue.all
    # issues.each do |is|
      # is.destroy
    # end
  end
  
  def get_data
    @versions =  opened_versions_list
    @issues = opened_versions_list.first.fixed_issues # <- not too useful
    @priority = IssuePriority.all
    @tracker = Tracker.all
    @status = IssueStatus.where("id IN (?)" , DEFAULT_STATUS_IDS['status_no_start'])
    render :json => {:versions => @versions, :issues => @issues, :tracker => @tracker, :priority => @priority, :status => @status, :members => @members}
  end
  
  def get_issues_version
    version = Version.find(params[:version_id])
    @issues = version.fixed_issues # <- not too useful
    logger.info "LIST ISSUES  #{@issues}"
    render :json => {:issues => @issues}
  end
  
  def create
    #Creat new issue
    logger.info "params issue #{params[:issue]}"
    @issue = Issue.new(params[:issue].merge(:status_id => DEFAULT_STATUS_IDS['status_no_start']))
    if @issue.save
      render :json => {:result => "create_success", :issue => @issue}
    else
      render :json => {:result => @issue.errors.full_messages}
    end
  end
end
