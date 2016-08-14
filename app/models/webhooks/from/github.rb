class Webhooks::From::Github < Webhooks::From::Base
  PATTERNS = %w(comment pull_request issue)
  ACCEPT_ACTIONS = %w(created opened assigned)

  def comment
    assigned? ? 'assigned' : search_content('body')
  end

  def url
    search_content('html_url')
  end

  def mentions
    if assigned?
      [@payload.dig('assignee', 'login')].compact
    else
      super
    end
  end

  def assigned?
    @payload.dig('action') == 'assigned'
  end

  def additional_message
    msg = assigned? ? "you've been assigned" : super
    msg += "plus"
    msg
  end

  def accept?
    ACCEPT_ACTIONS.include?(@payload['action'])
  end
end
