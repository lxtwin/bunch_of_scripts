cp /etc/pam.d/system-auth .
cp /etc/pam.d/password-auth .

# The auth string to use.
_auth="\
### START CIS Update ###\n\
auth        required      pam_faillock.so preauth silent audit deny=5 even_deny_root unlock_time=180 root_unlock_time=180\n\
auth        [default=die] pam_faillock.so authfail audit deny=5 unlock_time=180\n\
### END CIS Update ###"

# The account string to use.
_account="\
### START CIS Update ###\n\
account     required      pam_faillock.so\n\
### END CIS Update ###"


sed -i.sys_bkp  -e '/^\s*auth\s*required\s*pam_deny/ a'"${_auth}"'' -e '/^\s*account\s*required\s*pam_permit/ a'"${_account}"'' ./system-auth
sed -i.pass_bkp -e '/^\s*auth\s*required\s*pam_deny/ a'"${_auth}"'' -e '/^\s*account\s*required\s*pam_permit/ a'"${_account}"'' ./password-auth

exit
