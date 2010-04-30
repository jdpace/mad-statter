MadStatter: Simple stats plugin for *Rails 3* apps
==================================================

**NOTE:** This project is only partially complete. It still lacks a means to pull
the statistics and also the charting capability for displaying those statistics.

MadStatter allows you do easily define a number of statistics for your Rails app.
Stats are essentially classes that define a metric you wish to run against your application
at a given interval or rate. Anything that can be represented as a numeric value given a 
time can be defined as a Statistic with MadStatter.

Examples
--------

A Statistic to record the number of new users on a hourly basis:

    # Stored at RAILS_ROOT/app/statistics/signups.rb
    class Signups < MadStatter::Statistic
      desc "Total number of new user signups per hour"
      rate :hour
      
      def poll
        beginning_of_hour = DateTime.civil(time.year,time.month,time.day,time.hour,00,00).utc
        end_of_hour       = DateTime.civil(time.year,time.month,time.day,time.hour,59,59).utc
        User.count(:conditions => ["created_at BETWEEN ? AND ?", beginning_of_hour, end_of_hour])
      end
    end
    
A Statistic that would record the gross amount of money made per day:

    class DailyRevenue < MadStatter::Statistic
      desc "Daily Revenue"
      rate :day
      
      def poll
        # Stats with a rate of :day or :month will be polled
        # at the beginning of that interval
        # ie. 12AM or the 1st of the month
        #
        # Since we want revenue for a full day we need to look
        # at yesterday. By setting time it will also be recorded
        # to the database correctly.
        time = Date.yesterday
        Payment.sum(:amount, :conditions => [
          "approved_at BETWEEN ? AND ?",
          time.beginning_of_day, 
          time.end_of_day
        ])
      end
    end

Installation
------------
# TODO - Gem Install, Rails setup, Route for Stats controller

== Note on Patches/Pull Requests
 
* Fork the project.
* Make your feature addition or bug fix.
* Add tests for it. This is important so I don't break it in a
  future version unintentionally.
* Commit, do not mess with rakefile, version, or history.
  (if you want to have your own version, that is fine but bump version in a commit by itself I can ignore when I pull)
* Send me a pull request. Bonus points for topic branches.

== Copyright

Copyright (c) 2010 jdpace. See LICENSE for details.
