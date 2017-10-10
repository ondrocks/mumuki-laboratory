class Interactive < Challenge
  include Triable

  markdown_on :corollary
  validate :ensure_triable_language
  validate :ensure_stateful_console

  name_model_as Exercise

  def reset!
    super
    self.query_results = []
  end

  def console?
    true
  end

  def stateful_console?
    true
  end

  def queriable?
    false
  end

  def hidden?
    false
  end

  def upload?
    false
  end

  private

  def ensure_triable_language
    errors.add(:base, :language_not_triable) unless language.triable?
  end

  def ensure_stateful_console
    errors.add(:base, :console_not_stateful) unless language.stateful_console?
  end

end
