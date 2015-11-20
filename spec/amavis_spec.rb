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
  end

  describe "with a spammy amavis log line" do
    before do
      log_line = 'Mar 15 15:16:24 mcheck4 amavis[18588]: (18588-47) Passed SPAMMY, DEFAULT [93.174.66.65] [93.174.66.65] <a6g6h@a6g6h.r39.it> -> <bart.vanderstraeten@ugent.be>, Message-ID: <201303151516230534@311470.623.2153.16768>, mail_id: 9I671lxS3H2g, Hits: 10.632, size: 23466, queued_as: D1BDE9E332, Subject: "=?UTF-8?Q?profiteer_nu_van_de_daling_van_onze_tarieven?=", From: "=?UTF-8?Q?Auxifina_Kredieten_door_webvoordelen?="_<jan.veyt@webvoordelen.com>, Tests: [CMAE_1=10,DKIM_SIGNED=0.1,DKIM_VALID=-0.1,HS_INDEX_PARAM=0.023,HTML_IMAGE_RATIO_04=0.61,HTML_MESSAGE=0.001,RCVD_IN_DNSWL_NONE=-0.0001,SPF_HELO_PASS=-0.001,SPF_PASS=-0.001], shortcircuit=no, autolearn=disabled, 681 ms'
      @match = @grok.match(log_line)
    end

    it "should have the correct action value" do
      @match.should have_logstash_field("action").with_value("Passed")
    end

    it "should have the correct ccat value" do
      @match.should have_logstash_field("ccat").with_value("SPAMMY")
    end

  end

  describe "with a blocked amavis log line" do
    before do
      log_line = 'Mar 15 15:55:12 mcheck4 amavis[20996]: (20996-19) Blocked SPAM, DEFAULT [82.57.200.97] [172.129.36.105] <info@yahoo.com.tw> -> <e.e@ugent.be>,<m.m@ugent.be>, Message-ID: <5123901C01A43BDE@smtp201.alice.it>, mail_id: eA4yT5RIEyFP, Hits: 27.617, size: 1487, Subject: "Re:Youve won", From: "Yahoo_Asia"<info@yahoo.com.tw>, X-Mailer: Microsoft_Outlook_Express_6.00.2800.1081, Tests: [CMAE_1=10,DKIM_ADSP_CUSTOM_MED=0.001,FAKE_REPLY_C=0.001,FILL_THIS_FORM_LONG=3.476,FORGED_MUA_OUTLOOK=2.785,FROM_MISSP_MSFT=1,MISSING_HEADERS=1.207,MONEY_FROM_MISSP=1,NML_ADSP_CUSTOM_MED=1.2,RCVD_IN_DNSWL_NONE=-0.0001,REPLYTO_WITHOUT_TO_CC=1.946,T_FILL_THIS_FORM=0.01,T_FROM_MISSPACED=0.01,T_LOTS_OF_MONEY=0.01,US_DOLLARS_3=2.523,XMAILER_MIMEOLE_OL_1ECD5=2.448], shortcircuit=no, autolearn=disabled, 204 ms'
      @match = @grok.match(log_line)
    end

    it "should have the correct action value" do
      @match.should have_logstash_field("action").with_value("Blocked")
    end

    it "should have the correct ccat value" do
      @match.should have_logstash_field("ccat").with_value("SPAM")
    end

  end

  describe "with a bad header amavis log line" do
    before do
      log_line = 'Mar 10 12:54:59 mcheck4 amavis[19543]: (19543-59) Passed BAD-HEADER, DEFAULT [128.178.224.219] [128.178.131.141] <www-data@stisrvm11.epfl.ch> -> <e.e@ugent.be>, Message-ID: <1ac98b88dbb9a38a11f83e8446e9b897@lepfl.ch>, mail_id: RMRzRAG1iLLS, Hits: -1.194, size: 5859, queued_as: 1CA3B7FDC9, Subject: "subject"", From: "www-data"_<www-data@stisrvm11.epfl.ch>, X-Mailer: PHPMailer_5.1_(phpmailer.sourceforge.net), Tests: [HTML_MESSAGE=0.001,MIME_HTML_ONLY=1.105,RCVD_IN_DNSWL_MED=-2.3], shortcircuit=no, autolearn=disabled, 348 ms'
      @match = @grok.match(log_line)
    end

    it "should have the correct action value" do
      @match.should have_logstash_field("action").with_value("Passed")
    end

    it "should have the correct ccat value" do
      @match.should have_logstash_field("ccat").with_value("BAD-HEADER")
    end


  end

end
