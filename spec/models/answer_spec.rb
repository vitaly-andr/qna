require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should belong_to(:question) }
  it { should belong_to(:author).class_name('User') }

  it { is_expected.to have_many_attached(:files) }
  it { should have_many(:links).dependent(:destroy) }


  it { should validate_presence_of(:body) }

  it_behaves_like 'votable'

end
