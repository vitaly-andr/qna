require 'rails_helper'

RSpec.describe Question, type: :model do
  it { should have_many(:answers).dependent(:destroy) }
  it { should belong_to(:author).class_name('User') }

  it { is_expected.to have_many_attached(:files) }
  it { should accept_nested_attributes_for :links}
  it { should have_many(:links).dependent(:destroy) }


  it { should validate_presence_of :title }
  it { should validate_presence_of :body }
end
