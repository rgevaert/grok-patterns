#!/usr/bin/ruby 
require 'rubygems'
require 'grok-pure'
 
grok = Grok.new

print grok.add_patterns_from_file("../grok.d/base")
print grok.add_patterns_from_file("../grok.d/amavisdnew_patterns")

clean = 'Mar 15 10:25:28 mcheck2 amavis[26387]: (26387-87) Passed CLEAN, DEFAULT LOCAL [157.193.140.25] [157.193.140.25] <abc.deb@myhost.be> -> <pdaf@dfasykx.com>, Message-ID: <5142E910.6070802@dfa.ugent.be>, mail_id: DjyiQfdboMCr, Hits: 0.713, size: 263336, queued_as: D127CC5F5, Subject: "Re: xxxxxx", From: =?windows-1252?Q?xxxxxPll=E9e?=_<xxxx@xxxx.xxt.be>, User-Agent: Mozilla/5.0_(Windows_NT_6.1;_WOW64;_rv:17.0)_Gecko/20130307_Thunderbird/17.0.4, Tests: [HTML_MESSAGE=0.001,HTML_TAG_BALANCE_BODY=0.712], shortcircuit=no, autolearn=disabled, 1958 ms'

spammy = 'Mar 15 15:16:24 mcheck4 amavis[18588]: (18588-47) Passed SPAMMY, DEFAULT [93.174.66.65] [93.174.66.65] <a6g6h@a6g6h.r39.it> -> <bart.vanderstraeten@ugent.be>, Message-ID: <201303151516230534@311470.623.2153.16768>, mail_id: 9I671lxS3H2g, Hits: 10.632, size: 23466, queued_as: D1BDE9E332, Subject: "=?UTF-8?Q?profiteer_nu_van_de_daling_van_onze_tarieven?=", From: "=?UTF-8?Q?Auxifina_Kredieten_door_webvoordelen?="_<jan.veyt@webvoordelen.com>, Tests: [CMAE_1=10,DKIM_SIGNED=0.1,DKIM_VALID=-0.1,HS_INDEX_PARAM=0.023,HTML_IMAGE_RATIO_04=0.61,HTML_MESSAGE=0.001,RCVD_IN_DNSWL_NONE=-0.0001,SPF_HELO_PASS=-0.001,SPF_PASS=-0.001], shortcircuit=no, autolearn=disabled, 681 ms'

blocked = 'Mar 15 15:55:12 mcheck4 amavis[20996]: (20996-19) Blocked SPAM, DEFAULT [82.57.200.97] [172.129.36.105] <info@yahoo.com.tw> -> <e.e@ugent.be>,<m.m@ugent.be>, Message-ID: <5123901C01A43BDE@smtp201.alice.it>, mail_id: eA4yT5RIEyFP, Hits: 27.617, size: 1487, Subject: "Re:Youve won", From: "Yahoo_Asia"<info@yahoo.com.tw>, X-Mailer: Microsoft_Outlook_Express_6.00.2800.1081, Tests: [CMAE_1=10,DKIM_ADSP_CUSTOM_MED=0.001,FAKE_REPLY_C=0.001,FILL_THIS_FORM_LONG=3.476,FORGED_MUA_OUTLOOK=2.785,FROM_MISSP_MSFT=1,MISSING_HEADERS=1.207,MONEY_FROM_MISSP=1,NML_ADSP_CUSTOM_MED=1.2,RCVD_IN_DNSWL_NONE=-0.0001,REPLYTO_WITHOUT_TO_CC=1.946,T_FILL_THIS_FORM=0.01,T_FROM_MISSPACED=0.01,T_LOTS_OF_MONEY=0.01,US_DOLLARS_3=2.523,XMAILER_MIMEOLE_OL_1ECD5=2.448], shortcircuit=no, autolearn=disabled, 204 ms'

badheader = 'Mar 10 12:54:59 mcheck4 amavis[19543]: (19543-59) Passed BAD-HEADER, DEFAULT [128.178.224.219] [128.178.131.141] <www-data@stisrvm11.epfl.ch> -> <e.e@ugent.be>, Message-ID: <1ac98b88dbb9a38a11f83e8446e9b897@lepfl.ch>, mail_id: RMRzRAG1iLLS, Hits: -1.194, size: 5859, queued_as: 1CA3B7FDC9, Subject: "subject"", From: "www-data"_<www-data@stisrvm11.epfl.ch>, X-Mailer: PHPMailer_5.1_(phpmailer.sourceforge.net), Tests: [HTML_MESSAGE=0.001,MIME_HTML_ONLY=1.105,RCVD_IN_DNSWL_MED=-2.3], shortcircuit=no, autolearn=disabled, 348 ms'

pattern = '%{AMAVISDNEW}'
grok.compile(pattern)
print grok.match(clean).captures()
print "\n"
print "\n"
print "\n"
print grok.match(spammy).captures()
print "\n"
print "\n"
print "\n"
print grok.match(blocked).captures()
print "\n"
print "\n"
print "\n"
print grok.match(badheader).captures()
