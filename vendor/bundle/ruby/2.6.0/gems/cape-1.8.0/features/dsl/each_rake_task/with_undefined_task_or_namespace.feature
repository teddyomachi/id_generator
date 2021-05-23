Feature: The #each_rake_task DSL method with an undefined task or namespace

  In order to use the metadata of Rake tasks in my Capistrano recipes,
  As a developer using Cape,
  I want to use the Cape DSL.

  Scenario: do not enumerate any Rake tasks
    Given a full-featured Rakefile
    And a Capfile with:
      """
      Cape do
        each_rake_task 'lon' do |t|
          $stdout.puts '', "Name: #{t[:name].inspect}"
          if t[:parameters]
            $stdout.puts "Parameters: #{t[:parameters].inspect}"
          end
          if t[:description]
            $stdout.puts "Description: #{t[:description].inspect}"
          end
        end
      end
      """
    When I run `cap -vT`
    Then the output should not contain "lon"
