# frozen_string_literal: true

require 'spec_helper'

describe 'Bounded taggable' do
  let(:model) { BoundedTaggableModel.create!(name: 'Bob') }

  it 'only returns tags bound to its own class' do
    model.language_list = 'ruby, python'
    model.save!

    expect(model.reload.languages.map(&:name)).to contain_exactly('ruby', 'python')
  end

  it 'creates a tag_bound for the taggable class' do
    model.language_list = 'ruby'
    model.save!

    tag = ActsAsTaggableOn::Tag.find_by(name: 'ruby')
    expect(tag.tag_bounds.pluck(:class_name)).to include('BoundedTaggableModel')
  end

  # Regression: a global Tag can be bound to more than one class (the same tag
  # name reused across taggable models). The per-context association must not
  # return that tag once per bound class.
  context 'when a tag is also bound to another class' do
    before do
      model.language_list = 'ruby'
      model.save!

      tag = ActsAsTaggableOn::Tag.find_by!(name: 'ruby')
      tag.tag_bounds.create!(class_name: 'SomeOtherModel')
    end

    it 'returns the tag exactly once' do
      expect(model.reload.languages.map(&:name)).to eq(['ruby'])
    end

    it 'does not multiply the tagging count' do
      expect(model.reload.languages.size).to eq(1)
    end
  end
end
