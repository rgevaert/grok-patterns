require 'spec_helper'

describe "the extended amavis grok pattern" do

  before do
    @grok = Grok.new
    @grok.add_patterns_from_file("grok.d/base")
    @grok.add_patterns_from_file("grok.d/amavisdnew_patterns")
    @grok.add_patterns_from_file("grok.d/postfix_patterns")
    @grok.compile('%{AMAVISDNEW}')
  end

  # this covers the following amavis log formatter
  #  $log_templ = <<'EOD';
  #  [?%#D|#|Passed #
  #  [? [:ccat|major] |OTHER|CLEAN|MTA-BLOCKED|OVERSIZED|BAD-HEADER|SPAMMY|SPAM|\
  #  UNCHECKED|BANNED (%F)|INFECTED (%V)]#
  #  , [? %p ||%p ][?%a||[?%l||LOCAL ]\[%a\] ][?%e||\[%e\] ]%s -> [%D|,]#
  #  [? %q ||, quarantine: %q]#
  #  [? %Q ||, Queue-ID: %Q]#
  #  [? %m ||, Message-ID: %m]#
  #  [? %r ||, Resent-Message-ID: %r]#
  #  , mail_id: %i#
  #  , Hits: [:SCORE]#
  #  , size: %z#
  #  [~[:remote_mta_smtp_response]|["^$"]||[", queued_as: "]]\
  #  [remote_mta_smtp_response|[~%x|["queued as ([0-9A-Z]+)$"]|["%1"]|["%0"]]|/]#
  #  [? [:header_field|Subject] ||, Subject: [:dquote|[:header_field|Subject]]]#
  #  [? [:header_field|From]    ||, From: [:uquote|[:header_field|From]]]#
  #  [? [:useragent|name]   ||, [:useragent|name]: [:uquote|[:useragent|body]]]#
  #  [? %#T ||, Tests: \[[%T|,]\]]#
  #  [:supplementary_info|SCTYPE|, shortcircuit=%%s]#
  #  [:supplementary_info|AUTOLEARN|, autolearn=%%s]#
  #  , %y ms#
  #  ]
  #  [?%#O|#|Blocked #
  #  [? [:ccat|major|blocking] |#
  #  OTHER|CLEAN|MTA-BLOCKED|OVERSIZED|BAD-HEADER|SPAMMY|SPAM|\
  #  UNCHECKED|BANNED (%F)|INFECTED (%V)]#
  #  , [? %p ||%p ][?%a||[?%l||LOCAL ]\[%a\] ][?%e||\[%e\] ]%s -> [%O|,]#
  #  [? %Q ||, Queue-ID: %Q]#
  #  [? %m ||, Message-ID: %m]#
  #  [? %r ||, Resent-Message-ID: %r]#
  #  , mail_id: %i#
  #  , Hits: [:SCORE]#
  #  , size: %z#
  #  #, smtp_resp: [:smtp_response]#
  #  [? [:header_field|Subject] ||, Subject: [:dquote|[:header_field|Subject]]]#
  #  [? [:header_field|From]    ||, From: [:uquote|[:header_field|From]]]#
  #  [? [:useragent|name]   ||, [:useragent|name]: [:uquote|[:useragent|body]]]#
  #  [? %#T ||, Tests: \[[%T|,]\]]#
  #  [:supplementary_info|SCTYPE|, shortcircuit=%%s]#
  #  [:supplementary_info|AUTOLEARN|, autolearn=%%s]#
  #  , %y ms#
  #  ]
  #  EOD

  describe "with a clean amavis log line" do
    before do
      log_line = 'Mar 15 10:25:28 mcheck2 amavis[26387]: (26387-87) Passed CLEAN, DEFAULT LOCAL [157.193.140.25] [157.193.140.25] <abc.deb@myhost.be> -> <pdaf@dfasykx.com>, Message-ID: <5142E910.6070802@dfa.ugent.be>, mail_id: DjyiQfdboMCr, Hits: 0.713, size: 263336, queued_as: D127CC5F5, Subject: "Re: xxxxxx", From: =?windows-1252?Q?xxxxxPll=E9e?=_<xxxx@xxxx.xxt.be>, User-Agent: Mozilla/5.0_(Windows_NT_6.1;_WOW64;_rv:17.0)_Gecko/20130307_Thunderbird/17.0.4, Tests: [HTML_MESSAGE=0.001,HTML_TAG_BALANCE_BODY=0.712], shortcircuit=no, autolearn=disabled, 1958 ms'
      @match = @grok.match(log_line)
    end

    it "should have the correct action value" do
      @match.should have_logstash_field("action").with_value("Passed")
    end

    it "should have the correct ccat value" do
      @match.should have_logstash_field("ccat").with_value("CLEAN")
    end

    it "should have the correct policy bank value" do
      @match.should have_logstash_field("policybank").with_value("DEFAULT LOCAL")
    end

    it "should have the correct relayip value" do
      @match.should have_logstash_field("relayip").with_value("157.193.140.25")
    end

    it "should have the correct originip value" do
      @match.should have_logstash_field("originip").with_value("157.193.140.25")
    end

    it "should have the correct from value" do
      @match.should have_logstash_field("from").with_value("abc.deb@myhost.be")
    end

    it "should have the correct recipients value" do
      @match.should have_logstash_field("recipients").with_value("<pdaf@dfasykx.com>")
    end

    it "should have the correct messageid value" do
      @match.should have_logstash_field("messageid").with_value("5142E910.6070802@dfa.ugent.be")
    end

    it "should have the correct mail_id value" do
      @match.should have_logstash_field("mail_id").with_value("DjyiQfdboMCr")
    end

    it "should have the correct hits value" do
      @match.should have_logstash_field("hits:float").with_value("0.713")
    end

    it "should have the correct size value" do
      @match.should have_logstash_field("size:int").with_value("263336")
    end

    it "should have the correct qid value" do
      @match.should have_logstash_field("qid").with_value("D127CC5F5")
    end

    it "should have the correct subject value" do
      @match.should have_logstash_field("subject").with_value("Re: xxxxxx")
    end

    it "should have the correct user_agent value" do
      @match.should have_logstash_field("user_agent").with_value("Mozilla/5.0_(Windows_NT_6.1;_WOW64;_rv:17.0)_Gecko/20130307_Thunderbird/17.0.4")
    end

    it "should have the correct tests value" do
      @match.should have_logstash_field("TESTS").with_value("HTML_MESSAGE=0.001,HTML_TAG_BALANCE_BODY=0.712")
    end

    it "should have the correct shortcircuit value" do
      @match.should have_logstash_field("shortcircuit").with_value("no")
    end

    it "should have the correct autolearn value" do
      @match.should have_logstash_field("autolearn").with_value("disabled")
    end

    it "should have the correct elapsedtime" do
      @match.should have_logstash_field("elapsedtime").with_value("1958")
    end



#    it "should have the correct agent" do
#      @match.should have_logstash_field("agent").with_value("\"Mozilla/5.0 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)\"")
#    end
#
#    it "should have the correct status code" do
#      @match.should have_logstash_field("response").with_value("200")
#    end
#
#    it "should have the performance data collected" do
#      @match.should have_logstash_field("request_time").with_value("0.421")
#      @match.should have_logstash_field("upstream_response_time").with_value("0.418")
#      @match.should have_logstash_field("gzip_ratio").with_value("3.28")
#    end
  end

end
