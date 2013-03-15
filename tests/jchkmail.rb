#!/usr/bin/ruby 
require 'rubygems'
require 'grok-pure'
 
grok = Grok.new

print grok.add_patterns_from_file("../grok.d/base")
print grok.add_patterns_from_file("../grok.d/postfix_patterns")
print grok.add_patterns_from_file("../grok.d/jchkmail_patterns")

connect = "NOQUEUE: milter-reject: CONNECT from 8.Red-79-146-86.dynamicIP.rima-tde.net[79.146.86.8]: 421 4.5.1 Connection Rate - See http://helpdesk.ugent.be/email/faq.php; proto=SMTP"
unknown	= "NOQUEUE: milter-reject: UNKNOWN from 78-21-199-246.access.telenet.be[78.21.199.246]: 421 4.5.1 Too many errors - See http://helpdesk.ugent.be/email/faq.php; proto=SMTP"
ehlo 	= "NOQUEUE: milter-reject: EHLO from 225.pool85-60-40.dynamic.orange.es[85.60.40.225]: 451 4.3.2 Too many errors ! Come back later. - See http://helpdesk.ugent.be/email/faq.php; proto=SMTP helo=<[1.2.3.4]>"
#ehlo 	= "NOQUEUE: milter-reject: EHLO from 225.pool85-60-40.dynamic.orange.es[85.60.40.225]: 451 4.3.2 Too many errors ! Come back later. - See http://helpdesk.ugent.be/email/faq.php; proto=SMTP helo=<225.pool85-60-40.dynamic.orange.es>"
mail 	= "NOQUEUE: milter-reject: MAIL from unknown[178.131.239.144]: 550 5.7.1 Invalid HELO/EHLO parameter - See http://helpdesk.ugent.be/email/faq.php; from=<sucga@yahoo.com> proto=ESMTP helo=<dnsnruipxu>"
helo 	= "NOQUEUE: milter-reject: HELO from mx.jfpr.jus.br[200.193.141.30]: 451 4.3.2 Too many errors ! Come back later. - See http://helpdesk.ugent.be/email/faq.php; proto=SMTP helo=<mx.jfpr.jus.br>"
rcpt 	= "5A9BA7FE6E: milter-reject: RCPT from webmail.bnet.at[92.62.30.5]: 451 4.3.2 Too many errors ! Come back later. - See http://helpdesk.ugent.be/email/faq.php; from=<arno.bundschuh@bnet.at> to=<xyz.abc@ugent.be> proto=ESMTP helo=<webmail.bnet.at>"
endofmes="78A977FE20: milter-reject: END-OF-MESSAGE from webmail.bnet.at[92.62.30.5]: 4.3.2 Too many errors ! Come back later. - See http://helpdesk.ugent.be/email/faq.php; from=<arno.bundschuh@bnet.at> to=<leni.deneve@ugent.be> proto=ESMTP helo=<webmail.bnet.at>"


print "\n"
pattern = '%{MILTERCONNECT}'
grok.compile(pattern)
print grok.match(connect).captures()
print "\n"
print "\n"
pattern = '%{MILTERUNKNOWN}'
grok.compile(pattern)
print grok.match(unknown).captures()
print "\n"
print "\n"
print "\n"
pattern = '%{MILTEREHLO}'
grok.compile(pattern)
print grok.match(ehlo).captures()
print "\n"
print "\n"
pattern = '%{MILTERENDOFMESSAGE}'
grok.compile(pattern)
print grok.match(endofmes).captures()
print "\n"
print "\n"
pattern = '%{MILTERMAIL}'
grok.compile(pattern)
print grok.match(mail).captures()
print "\n"
print "\n"
pattern = '%{MILTERHELO}'
grok.compile(pattern)
print grok.match(helo).captures()
print "\n"
print "\n"
pattern = '%{MILTERRCPT}'
grok.compile(pattern)
print grok.match(rcpt).captures()
print "\n"
