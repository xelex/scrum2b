class S2bIssuesController < ProjectController

  #before_filter :check_before, :only => [:index]
  before_filter :get_members, :only => [:index, :get_data, :load_data]
  before_filter lambda { check_permission(:edit) }, :only => [:index, :update]
  before_filter lambda { check_permission(:view) }, :only => [:index]
  
  def index
    # issues = Issue.all
    # issues.each do |is|
      # is.destroy
    # end
    # issues = Issue.last
    # issues.update_attributes(:status_id => 3)
  end
  
  def get_data
    load_data
    @issues = opened_versions_list.first.fixed_issues
    @issues_backlog = Issue.where(:fixed_version_id => nil).where("project_id IN (?)",@hierarchy_project_id)
    render :json => {:versions => @versions, :issues => @issues, :issues_backlog => @issues_backlog, :tracker => @tracker, :priority => @priority, :status => @status, :members => @members, :status_ids => DEFAULT_STATUS_IDS}
  end
  
  def get_issues_version
    logger.info "Params version id  #{params[:version_id]}"
    version = Version.find(params[:version_id])
    @issues = version.fixed_issues # <- not too useful
    render :json => {:issues => @issues}
  end

  def get_issues_backlog
    logger.info ""
    @issues = version.fixed_issues # <- not too useful
    render :json => {:issues => @issues}
  end
  
  def create
    #Creat new issue
    logger.info "params issue #{params[:issue]}"
    @issue = Issue.new(params[:issue])
    if @issue.save
      render :json => {:result => "create_success", :issue => @issue}
    else
      render :json => {:result => @issue.errors.full_messages}
    end
  end

  def destroy
    @issue = Issue.find(params[:id])
    if @issue.destroy
      render :json => {:result => "success"}
    else
      render :json => {:result => @issue.errors.full_messages}
    end
  end

  def update
    logger.info "TRACKer id #{params[:issue][:tracker_id]}"
    @issue = Issue.find(params[:issue][:id])
    if @issue.update_attributes(:subject => params[:issue][:subject], :description => params[:issue][:description], :estimated_hours => params[:issue][:estimated_hours],
                                :priority_id => params[:issue][:priority_id], :assigned_to_id => params[:issue][:assigned_to_id],
                                :start_date => params[:issue][:start_date], :due_date => params[:issue][:due_date],:tracker_id => params[:issue][:tracker_id])
      render :json => {:result => "eidt_success",:issue => @issue}
    else
      render :json => {:result => @issue.errors.full_messages}
    end
 end
  
  def load_data
    @versions =  opened_versions_list
    @priority = IssuePriority.all
    @tracker = Tracker.all
    @status = IssueStatus.where("id IN (?)" , DEFAULT_STATUS_IDS['status_no_start'])
  end
end
