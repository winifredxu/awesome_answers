class QuestionsController < ApplicationController
	before_action:find_question, only: [:show, :edit, :update, :destroy] #:new, :create, :index does not need individual element IDs

	
	# used to show the form to create the resource, "new" action leads to "create" submit in form
	def new
		@question = Question.new
	end
	
	#used to create the resources, expect to receive params submitted from the form shown in the new page
	def create
		#use explicit field permission in submission, "strong parameter" started in Rails v4
		# refractored into def question_params method

		@question = Question.new question_params
		if @question.save
			#render text: "thank you!"
			# shortcut for this is below:  redirect_to question_path(@question)

			redirect_to @question, notice: "Question created successfully"
		else
			#show the form again with error
			
			#render the new.html.erb again here. 	
			render :new  # layout: new_layout

		end
	end


	def show
		#render text:params

		#find is set in before_action

		if @question != nil
			# @question.view_count +=1
			# @question.save
			@question.increment!(:view_count)
		end
	end	

	def index
		@entire_questions = Question.all.order('title ASC')

		@questions_recent = Question.recent(3)
	end


	# "edit" action leads to "update" submit in form
	def edit
		#find is set in before_action
	end

	def update
		#find is set in before_action	
		#question_params was a variable before, now set as a method below

		if @question.update question_params
			redirect_to @question, notice: "Question updated successfully"
		else
			render :edit
		end
	end

	def destroy
		#find is set in before_action
		@question.destroy
		redirect_to questions_path, notice: "Question deleted successfully"
	end

	def find_question
		@question = Question.find params[:id]
	end

	def question_params
		# use strong params to ensure only the fields explicitly stated are allowed
		params.require(:question).permit([:title, :body])
	end

end
