class MatchesController < ApplicationController

  def index
    if request.xhr?
      @filters = params['filter']
      respond_to do |format|
        format.json { render json: @filters } #used for testing purposes to show what filters are provided
      end
    end
  end

  def new
    @match = Match.new
  end

  def show
    @surv = Survey.find(params["survey"]) #not affected by match_type

    #depending on match type you either need the resident or the volunteer as the subject and the opposite as the participants
    if params["match_type"] == "Resident -> Volunteer"
      subject = Resident.where(user_id: params["user"]).take
      @participants = Match.participating_volunteers(@surv)
    elsif params["match_type"] == "Volunteer -> Resident"
      subject = Volunteer.where(user_id: params["user"]).take
      @participants = Match.participating_residents(@surv)
    end
    @scores = Match.scores(@participants, @surv, subject)
    @match_rankings = Match.match(@participants, @scores, @surv)
    @filters = Match.filters(@surv, subject)
  end

end
