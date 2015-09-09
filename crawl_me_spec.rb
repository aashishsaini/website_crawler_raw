require_relative 'crawl_me'

describe 'CrawlMe' do
  let(:base_url) { 'http://facebook.com' }
  let(:login_url) { 'http://signin.com' }
  let(:signup_url) { 'http://signup.com' }
  let(:help_url) { 'http://help.com' }
  let(:career_url) { 'http://careers.com' }
  let(:input_tag) { '<input></input>' }

  let(:help_url_content) { input_tag }
  let(:base_url_content) { "#{ input_tag }<a href='#{ login_url }'>Log In</a><a href='#{ signup_url }'>Sign up</a><a href='#{ help_url }'>Help</a><a href='#{ career_url }'>Careers</a>"}
  let(:login_url_content) {"#{ input_tag }#{ input_tag }#{ input_tag }<a href='#{ signup_url }'>Sign up</a>"}
  let(:signup_url_content) {"#{ input_tag }<a href='#{ help_url }'>Help</a>#{ input_tag }<a href='#{ career_url }'>Careers</a>"}
  let(:career_url_content) {"#{ input_tag }<a href='applyme'>Apply for this position</a>"}

  describe '#count_input' do
    before do
      # stubbing response
      @crawl_me = CrawlMe.new(base_url)
      allow(@crawl_me).to receive(:content).with(base_url).and_return(base_url_content)
      allow(@crawl_me).to receive(:content).with(login_url).and_return(login_url_content)
      allow(@crawl_me).to receive(:content).with(signup_url).and_return(signup_url_content)
      allow(@crawl_me).to receive(:content).with(help_url).and_return(help_url_content)
      allow(@crawl_me).to receive(:content).with(career_url).and_return(career_url_content)
    end

    context 'counting inputs' do
      it { expect(@crawl_me.count_input[base_url]).to eq 14 }
      it { expect(@crawl_me.count_input[help_url]).to eq 1 }
      it { expect(@crawl_me.count_input[career_url]).to eq 1 }
      it { expect(@crawl_me.count_input[login_url]).to eq 7 }
      it { expect(@crawl_me.count_input[signup_url]).to eq 4 }
    end
  end
end