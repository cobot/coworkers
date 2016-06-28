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

  it 'leaves jabber untouched' do
    expect(helper.format_messenger('Jabber', 'test')).to eql('test')
  end

  def remove_target(link)
    link.sub(/ target="\S+"/, '')
  end
end
