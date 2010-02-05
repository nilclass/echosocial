$stderr.puts "Loading crabgrass..."
require File.join(File.dirname(__FILE__), '..', 'config', 'environment')

ApiConf = YAML.load_file(File.join(RAILS_ROOT, 'config', 'api.yml')).symbolize_keys.freeze

$config = {
  :host => ApiConf[:host],
  :port => ApiConf[:port],
  :auth_info => {
    :method => 'key',
    :key => ApiConf[:key]
  },
  :log_level => 'DEBUG'
}

module CGApiHelper
  def unpack(params)
    model = params[:type].to_s.constantize
    raise ArgumentError.new("Given type is not a model!") unless model.kind_of?(ActiveRecord::Base)
    model.find(params[:id])
  end

  def pack(object, attributes=[])
    if object.kind_of?(Array)
      object.map { |obj| pack(obj, attributes) }
    else
      { :type => object.class.name,
        :id => object.id,
        :attributes => attributes.inject({}) { |attrs, attr|
          object.read_attribute(attr)
        }
      }
    end
  end
end

ApiSwitch::API.define(ApiConf[:namespace], CGApiHelper) do |api|

  ## TESTS

  api.may("return true or false, based on whether the given subject may perform action (:view, :edit, :admin) on object.") do |params|
    subject = api.unpack(params[:subject])
    object = api.unpack(params[:object])
    action = params[:action].to_sym
    raise ArgumentError.new("Action '#{action}' invalid!") unless ACCESS.keys.include?(action)
    subject.may?(action, object)
  end

  api.member_of("is the given user member of that group?") do |params|
    user = api.unpack(params[:user])
    group = api.unpack(params[:group])
    user.member_of?(group)
  end

  ## LISTINGS

  api.users("list all users (in the given site)") do |params|
    attrs = params[:attributes] || []
    site = api.unpack(params[:site]) if params[:site]
    api.pack(site ? User.on(site) : User.all, attrs)
  end

  api.groups("list all groups (in the given network or site)") do |params|
    attrs = params[:attributes] || []
    network = api.unpack(params[:network]) if params[:network]
    site = api.unpack(params[:site]) if params[:site]
    network ||= site.network
    api.pack(network ? network.groups : Group.all, attrs)
  end

  api.networks("list all networks (in the given site)") do |params|
    attrs = params[:attributes] || []
    site = api.unpack(params[:site]) if params[:site]
    api.pack(site ? site.networks : Network.all, attrs)
  end

  api.committees("list all committees in the given group or network") do |params|
    attrs = params[:attributes] || []
    group = api.unpack(params[:group]) if params[:group]
    network = api.unpack(params[:network]) if params[:network]
    group ||= network
    api.pack(group.committees, attrs)
  end

  api.members("list all members of given group") do |params|
    attrs = params[:attributes] || []
    group = api.unpack(params[:group]) if params[:group]
    network = api.unpack(params[:network]) if params[:network]
    committee = api.unpack(params[:committee]) if params[:committee]
    group ||= network || committee
    api.pack(group.members, attrs)
  end
end
