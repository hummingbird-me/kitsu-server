require 'objspace'

class DebugController < ApplicationController
  #before_action :verify_admin
  skip_after_action :enforce_policy_use

  def verify_admin
    unless current_user && current_user.resource_owner.has_role?(:admin)
      head 404
    end
  end

  def dump_all
    file = File.open('/tmp/head.dump', 'w')
    ObjectSpace.dump_all(output: file)
    file.close
    send_file file.path
  end

  def trace_on
    ObjectSpace.trace_object_allocations_start
    render json: { trace: 'on' }
  end

  def gc_info
    render json: GC.latest_gc_info.as_json
  end
end
