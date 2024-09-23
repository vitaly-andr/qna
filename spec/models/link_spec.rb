require 'rails_helper'

RSpec.describe Link, type: :model do

  it { should validate_presence_of :name }
  it { should validate_presence_of :url }
  it { should have_many(:links).dependent(:destroy) }
end
