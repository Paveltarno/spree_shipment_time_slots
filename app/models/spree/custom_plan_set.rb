module Spree

  class CustomPlanSet

    include ActiveRecord::Validations

    attr_reader :date

    def initialize(date = Date.today)
      @date = date
    end

    def custom_plans
      Spree::CustomPlan.where(date: @date.beginning_of_month..@date.end_of_month).all
    end

    def to_param
      @date.strftime
    end

  end

end
