Language.class_eval do
  def test_only_fake_response
    {status: Status::Failed, result: 'noop result'}
  end

  def run_tests!(*)
    test_only_fake_response
  end

  def run_query!(*)
    test_only_fake_response
  end
end

Assignment.class_eval do
  def failed!
    update_attributes!(status: Status::Failed)
  end
end
