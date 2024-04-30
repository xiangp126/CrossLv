FGVM01TM23003837 (Interim)# config global
FGVM01TM23003837 (global) (Interim)# config system console
FGVM01TM23003837 (console) (Interim)# set output standard
FGVM01TM23003837 (console) (Interim)# end
FGVM01TM23003837 (global) (Interim)# end
FGVM01TM23003837 (Interim)# config global
FGVM01TM23003837 (global) (Interim)# diagnose debug enable
FGVM01TM23003837 (global) (Interim)# diagnose debug cli 7
FGVM01TM23003837 (global) (Interim)# end
//FGVM01TM23003837 (Interim)# config global
//FGVM01TM23003837 (haha) (Interim)# diagnose debug cmdb-trace 2
//end

0: config vdom
0: edit haha
0: config firewall ssl-ssh-profile
0: delete "ssl2"
0: end
0: end

0: config vdom
0: edit haha
0: config firewall ssl-ssh-profile
0: edit "ssl2"
//config ssl2
//set inspect-all certificate-inspection
0: config https
0: set status certificate-inspection
0: set unsupported-ssl-version allow
0: set quic bypass
0: show
0: end
0: show
0: end
0: end

//FGVM01TM23003837 (Interim)# config vdom
//FGVM01TM23003837 (vdom) (Interim)# edit haha
//FGVM01TM23003837 (haha) (Interim)# config firewall ssl-ssh-profile
//FGVM01TM23003837 (ssl-ssh-profile) (Interim)# edit ssl
//FGVM01TM23003837 (ssl3) (Interim)# show https
//
//FGVM01TM23003837 (ssl3) (Interim)# show
//FGVM01TM23003837 (ssl3) (Interim)# end
//
//FGVM01TM23003837 (haha) (Interim)# end
