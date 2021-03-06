module Spree
  module Admin
    module CalendarHelper

      def calendar(date = Date.today, &block)
        Calendar.new(self, date, block).table
      end

      def week_calendar(&block)
        WeekCalendar.new(self, block).table
      end

      class Calendar < Struct.new(:view, :date, :callback)

        # TODO: Add rtl support
        WEEK_DAYS = %w[sunday monday tuesday wednesday thursday friday saturday]
        HEADER = WEEK_DAYS.map{ |day| Spree.t(day) }
        START_DAY = :sunday

        delegate :content_tag, to: :view

        def table
          content_tag :table, class: "calendar" do
            header + week_rows
          end
        end

        def header
          content_tag :tr do
            HEADER.map { |day| content_tag :th, day }.join.html_safe
          end
        end

        def week_rows
          weeks.map do |week|
            content_tag :tr do
              week.map { |day| day_cell(day) }.join.html_safe
            end
          end.join.html_safe
        end

        def weeks
          first = date.beginning_of_month.beginning_of_week(START_DAY)
          last = date.end_of_month.end_of_week(START_DAY)
          (first..last).to_a.in_groups_of(7)
        end

        def day_cell(day)
          content_tag :td, view.capture(day, &callback), class: day_classes(day)
        end

        def day_classes(day)
          classes = []
          classes << "today" if day == Date.today
          classes << "notmonth" if day.month != date.month
          classes.empty? ? nil : classes.join(" ")
        end

      end

      class WeekCalendar < Struct.new(:view, :callback)

        WEEK_DAYS = %w[sunday monday tuesday wednesday thursday friday saturday]
        HEADER = WEEK_DAYS.map{ |day| Spree.t(day) }
        START_DAY = :sunday

        delegate :content_tag, to: :view

        def table
          content_tag :table, class: "calendar" do
            header + week_row
          end
        end

        def header
          content_tag :tr do
            HEADER.map { |day| content_tag :th, day }.join.html_safe
          end
        end

        def week_row
          content_tag :tr do
            (0..6).map { |day| day_cell(day) }.join.html_safe
          end
        end

        def day_cell(day)
          content_tag :td, view.capture(day, &callback)
        end

      end

    end
  end
end