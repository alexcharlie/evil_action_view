dir = File.expand_path(File.dirname(__FILE__))
$:.unshift dir + '/../lib'

require 'rubygems'
require 'active_record'
require 'action_view'
require 'action_controller'
require 'test/unit'
require 'mocha'
require 'ostruct'
require 'evil_action_view'

RAILS_ROOT = dir

class ApplicationController < ActionController::Base
  helper_method :some_string

  def some_string
    'some string'
  end
end

class Story < ActiveRecord::Base
  include EvilActionView
end

class TestEvilActionView < Test::Unit::TestCase
  def setup 
    Story.stubs(:connection).returns(stub_everything(:columns => []))
    @story = Story.new
  end

  def test_views_can_render_in_a_model
    story = @story.evil.render(:partial => 'news/story')
    assert_match %(href), story
  end

  def test_works_with_helpers
    assert_equal 'some string', @story.evil.some_string
  end
end
