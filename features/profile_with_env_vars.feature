Feature: Profile with environment variables

  Background:
    Given a file named "spec/a_spec.rb" with:
      """ruby
      require 'spec_helper'

      describe 'a gerbil' do
        it 'has feet' do
        end

        it 'has a nose' do
          RubyProf.pause if RubyProf.running?
          RubyProf.resume if RubyProf.running?
        end
      end
      """

  Scenario: when set to 'each' and running only a specific scenario
    Given the environment variable "RSPEC_PROFILE" is set to "each"
    When I run `rspec spec/a_spec.rb:7`
    Then it should pass
    And the following files should exist:
      | profiles/a-gerbil/has-a-nose:7.html |
    And the following files should not exist:
      | profiles/all.html                   |
      | profiles/a-gerbil/has-feet:4.html   |

  Scenario: when set to 'each'
    Given the environment variable "RSPEC_PROFILE" is set to "each"
    When I run `rspec`
    Then it should pass
    And the following files should exist:
      | profiles/a-gerbil/has-feet:4.html   |
      | profiles/a-gerbil/has-a-nose:7.html |
    And the following files should not exist:
      | profiles/all.html                   |

  Scenario: when set to 'all'
    Given the environment variable "RSPEC_PROFILE" is set to "all"
    When I run `rspec`
    Then it should pass
    And the following files should exist:
      | profiles/all.html                   |
    And the following files should not exist:
      | profiles/a-gerbil/has-feet:4.html   |
      | profiles/a-gerbil/has-a-nose:7.html |

  Scenario: when set to some invalid value
    Given the environment variable "RSPEC_PROFILE" is set to "invalid value"
    When I run `rspec`
    Then it should fail
    And the output should contain:
      """
      ENV['RSPEC_PROFILE'] should be blank, 'all' or 'each', but was 'invalid value'
      """

  Scenario: when not set at all
    When I run `rspec`
    Then it should pass
    And the following files should not exist:
      | profiles/all.html                   |
      | profiles/a-gerbil/has-feet:4.html   |
      | profiles/a-gerbil/has-a-nose:7.html |
