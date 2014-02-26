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
    @name = user[:cn]
    @extension = user.extension
    @did = user[:pager]
    @did = nil if @did.empty?
    @title = "Choose Route"
    add_to_head = [css("datatables-bs3"), 
                   js('jquery.dataTables.min'),
                   js('datatables-bs3')]
    @head = add_to_head.join("\n")
    @available_numbers = DCID::AreaCode.filter(Sequel.~(numbers: nil)).sort { |a,b| a.state <=> b.state }
    if current_route
      @selected = current_route.number
    else
      @selected = 'Dynamic'
    end
  end

  def set(extension)
    @ext = user.extension
    unless extension == @ext
      flash[:error] = "You cannot change the caller id for someone else!"
      redirect_referer
    end
    unless cid = request.params["routeSelect"]
      flash[:error] = "You must supply a Caller ID! #{request.params}"
      redirect_referer
    end
    if current_route
      if cid == 'Dynamic'
        current_route.delete
      else
        current_route.update(number: cid)
      end
    else
      DCID::Route.create(cid: extension, number: cid) unless cid == 'Dynamic'
    end
    redirect :routing
  end

  private
  def current_route(extension = nil)
    extension ||= user.extension
    @route ||= DCID::Route.first(cid: extension)
  end

end
