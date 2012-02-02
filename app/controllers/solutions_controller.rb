class SolutionsController < ApplicationController
  before_filter :admins_only
  before_filter :load_solution, :only => [:show, :edit, :update, :destroy]

  def index
    @solutions = Solution.all
  end

  def new
    @solution = Solution.new
  end
  
  def update
    @solution.update_attributes(params[:solution])
    respond_with(@solution, :location => :solutions)
  end
  
  def create
    @solution = Solution.create(params[:solution])
    respond_with(@solution, :location => :solutions)
  end
end
