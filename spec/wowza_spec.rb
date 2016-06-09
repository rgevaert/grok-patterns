require 'spec_helper'

describe "the wowza access/stats log grok pattern" do

  before do
    @grok = Grok.new
    @grok.add_patterns_from_file("grok.d/base")
    @grok.add_patterns_from_file("grok.d/wowza_patterns")
    @grok.compile("%{WOWZAACCESSLOG}")
  end

  describe "wowza access log line" do
    before do
      log_line = "2016-05-11\t08:41:16\tCEST\tconnect\tsession\tINFO\t200\t192.168.1.1\t-\t_defaultVHost_\tlive\t_definst_\t0.001\t[any]\t1935\trtmp://wowza1.com:1935/live/_definst_\t192.168.1.1\twowz\tWowzaProLiveRepeater\tWIN 10,0,12,36\t45049314\t3431\t3073\t-\t-\t-\t-\t-\t-\t-\t-\t-\t-\t-\t-\t-\trtmp://wowza1.com:1935/live/_definst_\t-"
      @match = @grok.match(log_line)
    end

    it "should have the correct date value" do
      @match.should have_logstash_field("date").with_value("2016-05-11")
    end

    it "should have the correct time value" do
      @match.should have_logstash_field("time").with_value("08:41:16")
    end

    it "should have the correct timezone value" do
      @match.should have_logstash_field("tz").with_value("CEST")
    end

    it "should have the correct xEvent value" do
      @match.should have_logstash_field("xEvent").with_value("connect")
    end

    it "should have the correct xCategory value" do
      @match.should have_logstash_field("xCategory").with_value("session")
    end

    it "should have the correct xSeverity value" do
      @match.should have_logstash_field("xSeverity").with_value("INFO")
    end

    it "should have the correct xStatus value" do
      @match.should have_logstash_field("xStatus:int").with_value("200")
    end

    it "should have the correct xCtx value" do
      @match.should have_logstash_field("xCtx").with_value("192.168.1.1")
    end

    it "should have the correct xComment value" do
      @match.should have_logstash_field("xComment").with_value("-")
    end

    it "should have the correct xVhost value" do
      @match.should have_logstash_field("xVhost").with_value("_defaultVHost_")
    end

    it "should have the correct xApp value" do
      @match.should have_logstash_field("xApp").with_value("live")
    end

    it "should have the correct xAppinst value" do
      @match.should have_logstash_field("xAppinst").with_value("_definst_")
    end

    it "should have the correct xDuration value" do
      @match.should have_logstash_field("xDuration:float").with_value("0.001")
    end

    it "should have the correct sIp value" do
      @match.should have_logstash_field("sIp").with_value("[any]")
    end

    it "should have the correct sPort value" do
      @match.should have_logstash_field("sPort:int").with_value("1935")
    end

    it "should have the correct sUri value" do
      @match.should have_logstash_field("sUri").with_value("rtmp://wowza1.com:1935/live/_definst_")
    end

    it "should have the correct cIp value" do
      @match.should have_logstash_field("cIp").with_value("192.168.1.1")
    end

    it "should have the correct cProto value" do
      @match.should have_logstash_field("cProto").with_value("wowz")
    end

    it "should have the correct cReferrer value" do
      @match.should have_logstash_field("cReferrer").with_value("WowzaProLiveRepeater")
    end

    it "should have the correct cUserAgent value" do
      @match.should have_logstash_field("cUserAgent").with_value("WIN 10,0,12,36")
    end

    it "should have the correct cClientId value" do
      @match.should have_logstash_field("cClientId").with_value("45049314")
    end

    it "should have the correct csBytes value" do
      @match.should have_logstash_field("csBytes:int").with_value("3431")
    end

    it "should have the correct scBytes value" do
      @match.should have_logstash_field("scBytes:int").with_value("3073")
    end

    it "should have the correct xStreamId value" do
      @match.should have_logstash_field("xStreamId").with_value("-")
    end

    it "should have the correct xSpos value" do
      @match.should have_logstash_field("xSpos:float").with_value("-")
    end

    it "should have the correct csStreamBytes value" do
      @match.should have_logstash_field("csStreamBytes:int").with_value("-")
    end

    it "should have the correct scStreamBytes value" do
      @match.should have_logstash_field("scStreamBytes:int").with_value("-")
    end

    it "should have the correct xSname value" do
      @match.should have_logstash_field("xSname").with_value("-")
    end

    it "should have the correct xSnameQuery value" do
      @match.should have_logstash_field("xSnameQuery").with_value("-")
    end

    it "should have the correct xFileName value" do
      @match.should have_logstash_field("xFileName").with_value("-")
    end

    it "should have the correct xFileExt value" do
      @match.should have_logstash_field("xFileExt").with_value("-")
    end

    it "should have the correct xFileSize value" do
      @match.should have_logstash_field("xFileSize:int").with_value("-")
    end

    it "should have the correct xFileLength value" do
      @match.should have_logstash_field("xFileLength:float").with_value("-")
    end

    it "should have the correct xSuri value" do
      @match.should have_logstash_field("xSuri").with_value("-")
    end

    it "should have the correct xSuriStem value" do
      @match.should have_logstash_field("xSuriStem").with_value("-")
    end

    it "should have the correct xSuriQuery value" do
      @match.should have_logstash_field("xSuriQuery").with_value("-")
    end

    it "should have the correct csUriStem value" do
      @match.should have_logstash_field("csUriStem").with_value("rtmp://wowza1.com:1935/live/_definst_")
    end

    it "should have the correct csUriQuery value" do
      @match.should have_logstash_field("csUriQuery").with_value("-")
    end
  end
end
