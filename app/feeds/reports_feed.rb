class ReportsFeed < Feed
  def write_target
    ['reports_aggr', id]
  end

  def read_target
    ['reports_aggr', id]
  end
end
