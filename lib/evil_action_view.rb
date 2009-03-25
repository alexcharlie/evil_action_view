require 'ostruct'

module EvilActionView
  module ClassMethods
    def view_template
      if @view_template
        @view_template.send :assign_variables_from_controller
        return @view_template
      end

      controller = ApplicationController.new
      controller.request = OpenStruct.new(:parameters => {}, :symbolized_path_parameters => {}, :protocol => 'http', :accepts => [])
      controller.instance_variable_set("@_params", {})

      controller.send(:initialize_current_url)

      controller.instance_variable_set("@assigns", {})
      controller.send :add_instance_variables_to_assigns

      @view_template = ActionView::Base.new([RAILS_ROOT + '/app/views'], controller.instance_variable_get("@assigns"), controller)

      (class << @view_template; self end).send(:include, controller.master_helper_module)
      
      @view_template
    end
    alias_method :evil, :view_template
    
    # We overwrite some helpers in our model's view_template and call it 
    # "canvas_view_template". Want to fake out the view_template to believe
    # it is rendering in the canvas context so our URL helpers work.
    def canvas_view_template
      if @view_template
        view_template
      else
        class << view_template
          def in_facebook_canvas?
            true
          end
        end
        view_template
      end
    end
  end
  
  def self.included(base)
    base.extend(EvilActionView::ClassMethods)
    
    def view_template
      self.class.view_template
    end
    
    def canvas_view_template
      self.class.canvas_view_template
    end
    alias_method :evil, :view_template
  end
end


    
