# Default url mappings are:
# 
# * a controller called Main is mapped on the root of the site: /
# * a controller called Something is mapped on: /something
# 
# If you want to override this, add a line like this inside the class:
#
#  map '/otherurl'
#
# this will force the controller to be mounted on: /otherurl.
class Routing < Controller
  map "/routing"
  # the index action is called automatically when no other action is specified
  def index(where = nil)
    login_first
    Ramaze::Log.info "Hey!"
    extension = user.extension
    @title = "Choose Route"
    add_to_head = [css("datatables-bs3"), 
                   js('jquery.dataTables.min'),
                   js('datatables-bs3')]
    @head = add_to_head.join("\n")
    extension
  end

  # the string returned at the end of the function is used as the html body
  # if there is no template for the action. if there is a template, the string
  # is silently ignored
  def notemplate
    @title = 'Welcome to Ramaze!'
    
    return 'There is no \'notemplate.xhtml\' associated with this action.'
  end

  def logged_in?
    false
  end
end
