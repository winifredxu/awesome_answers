class Question < ActiveRecord::Base
	validates :title, presence: true, uniqueness: {scope: :body, case_sensitive: false}
	validates :body, presence: { message: "must be provided!"}

	validates :view_count, numericality: {greater_than_or_equal_to: 0}

	validate :stop_words

	# Initialize -> Validate -> Save -> Commit  ===  4 stages where callbacks can be inserted
	after_initialize :set_defaults 
	before_save :cap_title


	scope :recent, lambda { |x| order("updated_at DESC").limit(x) }
	# this is the same as below -- returns the x most recent DB entries
	#def self.recent(number)
	#  order("updated_at DESC").limit(number)
	#end

	scope :last_x_days, lambda { |x| where(created_at: x.days.ago..Time.now) }
#scope :last_y_days, lambda { |y| order("updated_at  < CURRENT_DATE - INTEVAL '#{}'")}
#scope :last_z_days, lambda { |z| where("created_at > ?", num.days.ago) }

	private

	def stop_words
		if title.present? && title.include?("monkey")
			errors.add(:title, "PLease don't use monkey!")
		end
	end

	def set_defaults  #set the default view_count to "1"
		self.view_count ||= 1
	end

	def cap_title
		self.title.capitalize!	
	end

end