class Journal2issueController < ApplicationController
  unloadable



  def index
  end

  def create
    @journal = Journal.find_by_id(params[:id])
    @issue = Issue.new(
                 :author => @journal.user,
                 :subject => @journal.notes[0,50],
                 :description => @journal.notes,
                 :created_on => @journal.created_on,
                 :is_private => @journal.private_notes,
                 :tracker => @journal.issue.tracker,
                 :priority => @journal.issue.priority,
                 :project => @journal.issue.project)

    if @issue.save
      @relation = IssueRelation.new(
                                   :issue_from => @issue,
                                   :issue_to => @journal.issue,
                                   :relation_type => "relates")
      @relation.save

      @journal.notes = l(:j2i_issue_created_at, @issue.id)
      @journal.save

      flash[:notice] = l(:j2i_issue_created_success);
      redirect_to issue_path(@issue)
    else
      flash[:error] = l(:j2i_issue_created_error)  + " (" + @issue.errors.full_messages.join(', ') + ")"
      redirect_to issue_path(@journal.issue)
    end
  end

end
