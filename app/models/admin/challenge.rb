class Admin::Challenge
  include ActiveModel::Model

  STATUSES = ['Created', 'Completed', 'Hidden', 'Review', 'Submission', 'Winner Selected', 'No Winner Selected', 'On Hold - Pending Reviews']
  PRIZE_TYPES = ['Currency', 'Other']

  # Overrides the attr_accesssor class method so we are able to capture and
  # then save the defined fields as column_names
  def self.attr_accessor(*vars)
    @column_names ||= []
    @column_names.concat( vars )
    super
  end

  # Returns the previously defined attr_accessor fields
  def self.column_names
    @column_names
  end

  attr_accessor :winner_announced, :terms_of_service, :scorecard_type, :submission_details,
                :status, :start_date, :requirements, :name, :status, :end_date, :description,
                :reviewers, :categories, :prizes, :commentNotifiers, :reviewers_to_delete,
                :categories_to_delete, :prizes_to_delete, :commentNotifiers_to_delete, :assets,
                :challenge_type, :terms_of_service, :comments, :challenge_id,

                # these are fields from the challenge api that need to be there so we can
                # just "eat" the json and avoid the model from complaining that these
                # fields don't exist

                # IDEA FOR REFACTORING:
                # We should instead have a slave ::Challenge object to consume the original
                # challenge params and extract out whatever data we need. The way this is
                # being implemented right now smells of feature envy.
                :attributes, :total_prize_money, :submissions, :usage_details, :is_open,
                :release_to_open_source, :post_reg_info, :prize_type, :discussion_board,
                :registered_members, :challenge_comments, :additional_info,
                :participating_members, :challenge_prizes,
                :top_prize, :id, :participants

  # Add validators as you like :)
  validates :name, presence: true
  validates :start_date, presence: true
  validates :end_date, presence: true
  validates_inclusion_of :status, in: STATUSES

  validate  do
    if start_date && end_date && winner_announced
      errors.add(:end_date, 'must be after start date') unless end_date > start_date
      errors.add(:winner_announced, 'must be after end date') unless winner_announced >= end_date.to_date
    end
  end

  def initialize(params={})
    # the api names some fields as challenge_xxx where as the payload needs to be xxx
    params['reviewers'] = params.delete('challenge_reviewers') if params.include? 'challenge_reviewers'
    params['commentNotifiers'] = params.delete('challenge_comment_notifiers') if params.include? 'challenge_comment_notifiers'
    params['prizes'] = params.delete('challenge_prizes') if params.include? 'challenge_prizes'
    super(params)
  end

  # Return an object instead of a string
  def start_date
    (Time.parse(@start_date) if @start_date) || Date.today
  end

  # Return an object instead of a string
  def end_date
    (Time.parse(@end_date) if @end_date) || Date.today + 7.days
  end

  # Return an object instead of a string
  def winner_announced
    (Time.parse(@winner_announced) if @winner_announced) || Date.today + 14.days
  end

  def categories
    (@categories.delete_if {|n| n.blank?} if @categories) || []
  end

  def assets
    @assets || []
  end

  def statuses
    Admin::Challenge::STATUSES
  end

  def reviewers
    @reviewers || []
  end

  def commentNotifiers
    @commentNotifiers || []
  end

  def prizes
    @prizes || []
  end

  # formats the object to conform to the api format
  # maybe we should use RABL for this one instead?
  def payload
    # Get the original challenge to figure out the stuff to be deleted.
    # We are re-requesting the original challenge instead of tracking which
    # entries are to be deleted client-side to minimize race conditions. Race
    # conditions aren't totally eliminated, but the window is largely smaller
    # in this case. Plus the logic is much simpler too :)

    result = {
      challenge: {
        detail: {
          winner_announced: winner_announced,
          terms_of_service: terms_of_service,
          scorecard_type:"Sandbox Scorecard",
          submission_details: submission_details,
          status: status,
          start_date: start_date.to_time.iso8601,
          requirements: requirements,
          name: name,
          end_date: end_date.to_time.iso8601,
          description: description,
          comments: comments,
          challenge_type: challenge_type,
        },
        challenge_id: challenge_id,
        reviewers: reviewers.map {|name| {name: name}},
        categories: categories.map {|name| {name: name}},
        prizes: prizes,
        commentNotifiers: commentNotifiers.map {|name| {name: name}},
        assets: assets.map {|filename| {filename: filename}},
      }
    }
    if self.challenge_id && !self.challenge_id.blank?
      original_challenge = Admin::Challenge.new ::Challenge.find([self.challenge_id, 'admin'].join('/')).raw_data
      original_challenge_categories = original_challenge.categories.records.map(&:display_name)
      stuff_to_delete = {
        categories_to_delete: (original_challenge_categories - categories).map {|name| {name: name}},
        reviewes_to_delete: (original_challenge.reviewers - reviewers).map {|name| {name: name}},
        commentNotifiers_to_delete: (original_challenge.commentNotifiers - commentNotifiers).map {|name| {name: name}},
        prizes_to_delete: original_challenge.prizes.map {|c| c.to_hash } - prizes,
        assets_to_delete: (original_challenge.assets - assets).map {|filename| {filename: filename}},
      }
      result[:challenge].update(stuff_to_delete)
    end
    result
  end

end

# {
#   "challenge" : {
#     "detail" : {
#       "winner_announced":"2015-05-17",
#       "terms_of_service":"Standard Terms & Conditions",
#       "scorecard_type":"Sandbox Scorecard",
#       "submission_details":"<em>&#39;Some submission details&#39;<br><br>Another double quoted stuff &quot;fdfdfd&quot;</em>",
#       "status":"Hidden",
#       "start_date":"2012-03-17T18:02:00.000+0000",
#       "requirements":"Hello this is a sample requirement with some interesting stuff like<br><br>Bullets<br><ul><li>Bull1</li><li>Bull2</li></ul>\n<div style=\"text-align: center; \">Links <br><br><a href=\"http://developer.force.com\" target=\"_blank\">http://developer.force.com<br></a><br><strong>Bold Text</strong></div>\n<br><strike><em>Crossed - Italics<br></em></strike><br><br>",
#       "name":"RSpec Challenge",
#       "status":"Planned",
#       "end_date":"2014-04-17T18:02:00.000+0000",
#       "description":"sample Description",
#       "comments":"My challenge comments",
#       "challenge_type":"Design"
#       },
#     "reviewers" : [{"name" : "mess"}, {"name" : "jeffdonthemic"}],
#     "categories" : [{"name" : "java"}, {"name": "heroku"}],
#     "prizes" : [{"place":2,"points":222,"prize":"122","value":1212}, {"place":1,"points":2120,"prize":"1000","value":21212}],
#     "commentNotifiers" : [{"email" : "jdouglas@appirio.com"}, {"name" : "mess"}],
#     "assets" : [{"filename" : "img.png"}, {"filename": "logo.jpg"}],
#     "reviewers_to_delete" : [{"name" : "mess"}, {"name" : "jeffdonthemic"}],
#     "categories_to_delete" : [{"name" : "java"}, {"name": "heroku"}],
#     "prizes_to_delete" : [{"place":2,"points":222,"prize":"122","value":1212}, {"place":1,"points":2120,"prize":"1000","value":21212}],
#     "commentNotifiers_to_delete" : [{"email" : "jdouglas@appirio.com"}, {"name" : "mess"}],
#     "assets_to_delete" : [{"filename" : "img.png"}, {"filename": "logo.jpg"}]
#   }
# }