require 'spec_helper'

describe "the extended amavis grok pattern" do

  before do
    @grok = Grok.new
    @grok.add_patterns_from_file("grok.d/base")
    @grok.add_patterns_from_file("grok.d/apache_patterns")
    @grok.compile('%{APACHEERRORLOG}')
  end

  describe "apache default error log" do
    before do
      log_line = '[Fri May 27 09:26:02 2016] [error] [client 192.168.1.1] File does not exist: /var/www/myapp/myfile.html'
      @match = @grok.match(log_line)
    end

    it "should have the correct timestamp value" do
      @match.should have_logstash_field("timestamp").with_value("Fri May 27 09:26:02 2016")
    end

    it "should have the correct severity value" do
      @match.should have_logstash_field("severity").with_value("error")
    end

    it "should have the correct policy clientip value" do
      @match.should have_logstash_field("clientip").with_value("192.168.1.1")
    end

    it "should have the correct message_remainder value" do
      @match.should have_logstash_field("message_remainder").with_value("File does not exist: /var/www/myapp/myfile.html")
    end
  end
end
