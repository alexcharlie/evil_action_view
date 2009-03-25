class EvilActionPart
  include EvilActionView
  
  attr_accessor :kind, :params
  
  def initialize(kind, params)
    self.kind = kind
    self.params = params
    
    self.process_story(self.kind)
  end
  
  def process_story(action_name)
    if self.respond_to?(action_name)
      execute_before_filter_chain && self.send(action_name)
      execute_after_filter_chain
    end
  end
  
  def render_part
    raise ImplementationError, "Must be implemented by descendants, I don't know what API Call you want to make!"
  end
  
  class << self
    attr_writer :before_filter_chain
    attr_writer :after_filter_chain
    
    def before_filter_chain
      @before_filter_chain ||= []
    end
    
    def after_filter_chain
      @after_filter_chain ||= []
    end

  end
  
  def execute_before_filter_chain
    self.class.before_filter_chain.inject(true) do |boolean, filter|
      boolean && self.send(filter)
    end
  end
  
  def execute_after_filter_chain
    self.class.after_filter_chain.inject(true) do |boolean, filter|
      boolean && self.send(filter)
    end
  end
  
  def self.before_filter(message_name)
    self.before_filter_chain ||= []
    self.before_filter_chain << message_name
  end
  
  def self.after_filter(message_name)
    self.after_filter_chain ||= []
    self.after_filter_chain << message_name
  end
end