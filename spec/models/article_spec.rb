require 'rails_helper'

RSpec.describe Article do
  describe 'associations' do
    def association
      described_class.reflect_on_association(:comments)
    end

    it 'has many comments' do
      expect(association).not_to be_nil
      expect(association.options[:inverse_of]).not_to be_nil
    end

    it 'deletes associated comments when destroyed' do
      expect(association.options[:dependent]).to eq(:destroy)
    end
  end
end
