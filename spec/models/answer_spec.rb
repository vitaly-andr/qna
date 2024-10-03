require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should belong_to(:question) }
  it { should belong_to(:author).class_name('User') }

  it { is_expected.to have_many_attached(:files) }
  it { should have_many(:links).dependent(:destroy) }


  it { should validate_presence_of(:body) }

  it_behaves_like 'votable'
  describe 'accepts_nested_attributes_for :links' do
    let(:answer) { create(:answer) }
    let!(:link) { create(:link, linkable: answer) }

    it 'deletes link if _destroy is set to true' do
      expect {
        answer.update(links_attributes: [{ id: link.id, _destroy: '1' }])
      }.to change(answer.links, :count).by(-1)
    end

    it 'does not delete link if _destroy is not set' do
      expect {
        answer.update(links_attributes: [{ id: link.id, _destroy: '0' }])
      }.to_not change(answer.links, :count)
    end
  end
end
