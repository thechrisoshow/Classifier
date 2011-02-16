class HomeController < ApplicationController
  def index
    @categories = Category.except_neutral.all
    @category_choices = Category.all
  end
end