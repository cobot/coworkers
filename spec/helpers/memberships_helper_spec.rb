require 'spec_helper'

describe MembershipsHelper, '#format_messenger' do
  it 'turns a skype name into a skype url' do
    expect(remove_target(helper.format_messenger('Skype', 'test'))).to eql('<a href="skype:test?add">test</a>')
  end

  it 'links to twitter' do
    expect(remove_target(helper.format_messenger('Twitter', 'test'))).to eql('<a href="http://twitter.com/test">@test</a>')
  end

  it 'deals with a twitter name that already has an @' do
    expect(remove_target(helper.format_messenger('Twitter', '@test'))).to eql('<a href="http://twitter.com/test">@test</a>')
  end

  it 'returns a tel link' do
    expect(remove_target(helper.format_messenger('Phone', '123 456'))).to eql('<a href="tel:123456">123 456</a>')
  end

  it 'returns a mailto link' do
    expect(remove_target(helper.format_messenger('Email', 'joe@example.com'))).to eql('<a href="mailto:joe@example.com">joe@example.com</a>')
  end

  it 'leaves others untouched' do
    expect(helper.format_messenger('Jabber', 'test')).to eql('test')
  end

  def remove_target(link)
    link.sub(/ target="\S+"/, '')
  end
end
