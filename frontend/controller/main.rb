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
class MainController < Controller
  map :/
  # the index action is called automatically when no other action is specified
  def index
    login_first
    @title = 'Welcome to DCID!'
    redirect :routing
  end

  def login
    @title = "Login"
    redirect_referer if logged_in?
    return unless request.post?
    creds = request.subset(:login, :password)
    user = DCID::LdapUser.authenticate(creds)
    Ramaze::Log.info "Auth Result: #{user} #{user.username} #{user.extension}"
    user_login(creds)
    answer :/
  end

  def logout
    @title = "Logged Out"
    user_logout 
    @flash = 'You are now logged out. <a href="/login">Log Back In</a>'
  end

  def numbers(where = nil)
    if where.nil?
      nums = DCID::AreaCode.all
    else
      if where == "owned"
        nums = DCID::AreaCode.owned.all
      elsif where =~ /\d\d\d+/
        nums = DCID::AreaCode.filter(:code => /#{where[0,3]}/)
      else
        nums = DCID::AreaCode.filter(:city => /#{where}/i)
      end
    end
    @title = "Number Listing"
    add_to_head = [css("datatables-bs3"), 
                   js('jquery.dataTables.min'),
                   js('datatables-bs3')]
    @head = add_to_head.join("\n")
    @numbers = nums.map do |num|
      '["%s", "%s", "%s", "%s", "%s"]' % [
        num.code,
        num.city,
        num.state,
        num.postal_code,
        num.numbers.nil? ? "none" : num.numbers.join(", ")
      ]
    end
  end

end
