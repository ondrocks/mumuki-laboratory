class RootConstraint
  def matches?(request)
    Mumukit::Platform.organization_mapping == Mumukit::Platform::OrganizationMapping::Path || Mumukit::Platform.implicit_organization?(request)
  end
end
