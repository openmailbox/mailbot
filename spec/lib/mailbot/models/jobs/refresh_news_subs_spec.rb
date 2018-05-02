require 'spec_helper'

RSpec.describe Mailbot::Models::RefreshNewsSubs do
  it_behaves_like 'a scheduled job', { frequency: 42 }
end
