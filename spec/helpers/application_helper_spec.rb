require 'spec_helper'

describe ApplicationHelper, '#markdown' do
  it 'turns text into markdown' do
    expect(helper.markdown('hello *world*').strip).to eql('<p>hello <em>world</em></p>')
  end

  it 'adds targte=top to links' do
    expect(helper.markdown('[hello](http://cobot.me) http://google.de').strip)
      .to eql('<p><a href="http://cobot.me" target="_top">hello</a> <a href="http://google.de" target="_top">http://google.de</a></p>')
  end
end
